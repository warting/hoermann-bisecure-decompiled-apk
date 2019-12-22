package com.adobe.air.microphone;

import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.audiofx.AcousticEchoCanceler;
import android.media.audiofx.NoiseSuppressor;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Process;
import android.util.Log;
import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.microphone.MobileAEC.AggressiveMode;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;
import java.util.List;

public class AIRMicrophoneRecorder implements Runnable {
    public static final String[] BLACKLIST = new String[]{"Nexus 9", "Nexus 10", "ONE A2005", "D6503"};
    private AcousticEchoCanceler echoCanceler = null;
    private boolean hardwareAEC = false;
    private ByteBuffer mBuffer_toWrite;
    public volatile boolean mKeepAlive = true;
    private byte[] mMicBuffer;
    private int m_audioFormat = 0;
    private int m_audioSource = 0;
    private int m_bufferSize = 0;
    private int m_channelConfiguration = 0;
    public short m_delay = (short) 0;
    public boolean m_isEnhancedMicrophone = false;
    private volatile boolean m_isPaused;
    private volatile boolean m_isRecording;
    private AudioRecord m_recorder;
    private int m_sampleRate = 0;
    private final Object mutex = new Object();
    private NoiseSuppressor noiseSuppressor = null;
    private long t_analyze = 0;
    private long t_capture = 0;
    private long t_process = 0;
    private long t_render = 0;

    public AIRMicrophoneRecorder(int audioSource, int sampleRate, int channelConfig, int audioFormat, int bufferSize) {
        this.m_audioSource = audioSource;
        this.m_sampleRate = sampleRate;
        this.m_channelConfiguration = channelConfig;
        this.m_audioFormat = audioFormat;
        this.m_bufferSize = bufferSize;
        this.mMicBuffer = new byte[this.m_bufferSize];
    }

    public void run() {
        synchronized (this.mutex) {
            while (!isRecording()) {
                try {
                    this.mutex.wait();
                } catch (InterruptedException e) {
                    throw new IllegalStateException("Wait interrupted", e);
                }
            }
        }
        Process.setThreadPriority(-19);
        if (this.m_recorder != null) {
            try {
                if (this.m_isEnhancedMicrophone) {
                    ((AudioManager) AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getSystemService("audio")).setMode(3);
                    if (VERSION.SDK_INT >= 16) {
                        int sessionId = this.m_recorder.getAudioSessionId();
                        if (AcousticEchoCanceler.isAvailable() && NoiseSuppressor.isAvailable()) {
                            this.hardwareAEC = true;
                        } else {
                            this.hardwareAEC = false;
                        }
                        if (this.hardwareAEC) {
                            this.echoCanceler = AcousticEchoCanceler.create(sessionId);
                            if (this.echoCanceler != null) {
                                this.echoCanceler.setEnabled(true);
                            }
                            Log.d("AJAudioRecord", "IS Hardware NoiseSuppressor enabled " + NoiseSuppressor.isAvailable());
                            this.noiseSuppressor = NoiseSuppressor.create(sessionId);
                            if (this.noiseSuppressor != null) {
                                this.noiseSuppressor.setEnabled(true);
                            }
                        }
                    }
                }
                this.m_recorder.startRecording();
            } catch (IllegalStateException e2) {
            }
        }
    }

    public Boolean Open() {
        int bufferSize = AudioRecord.getMinBufferSize(this.m_sampleRate, this.m_channelConfiguration, this.m_audioFormat);
        if (this.m_isEnhancedMicrophone) {
            if (this.m_bufferSize > bufferSize) {
                bufferSize = this.m_bufferSize;
            } else {
                bufferSize *= 2;
            }
            this.mBuffer_toWrite = ByteBuffer.allocateDirect(this.m_bufferSize);
        } else if (this.m_bufferSize > bufferSize) {
            bufferSize = this.m_bufferSize;
        } else {
            bufferSize *= 2;
        }
        try {
            if (this.m_isEnhancedMicrophone) {
                this.m_recorder = new AudioRecord(7, this.m_sampleRate, this.m_channelConfiguration, this.m_audioFormat, bufferSize);
            } else {
                this.m_recorder = new AudioRecord(this.m_audioSource, this.m_sampleRate, this.m_channelConfiguration, this.m_audioFormat, bufferSize);
            }
            if (this.m_recorder == null || this.m_recorder.getState() != 1) {
                return Boolean.valueOf(false);
            }
            return Boolean.valueOf(true);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return Boolean.valueOf(false);
        }
    }

    public byte[] getBuffer() {
        this.t_capture = System.currentTimeMillis();
        int result = this.m_recorder.read(this.mMicBuffer, 0, this.m_bufferSize);
        if (result != -3 && result == -2) {
        }
        if (this.m_isEnhancedMicrophone && (!this.hardwareAEC || deviceIsBlackListed())) {
            this.t_render = System.currentTimeMillis();
            doAECM();
            this.mMicBuffer = Arrays.copyOf(this.mBuffer_toWrite.array(), this.m_bufferSize);
        }
        return this.mMicBuffer;
    }

    public void setRecording(boolean recording) {
        synchronized (this.mutex) {
            this.m_isRecording = recording;
            if (this.m_isRecording) {
                this.mutex.notify();
            } else {
                if (this.m_recorder.getState() == 1) {
                    this.m_recorder.stop();
                }
                this.m_recorder.release();
            }
        }
    }

    private void doAECM() {
        try {
            MobileAEC aecm = new MobileAEC(null);
            aecm.setAecmMode(AggressiveMode.MOST_AGGRESSIVE).prepare();
            ByteArrayInputStream fin = new ByteArrayInputStream(this.mMicBuffer);
            ByteArrayOutputStream fout = new ByteArrayOutputStream(this.mBuffer_toWrite.capacity());
            byte[] pcmInputCache = new byte[320];
            while (fin.read(pcmInputCache, 0, pcmInputCache.length) != -1) {
                short[] aecTmpIn = new short[160];
                short[] aecTmpOut = new short[160];
                ByteBuffer.wrap(pcmInputCache).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(aecTmpIn);
                this.t_analyze = System.currentTimeMillis();
                aecm.farendBuffer(aecTmpIn, 160);
                this.t_process = System.currentTimeMillis();
                this.m_delay = (short) ((int) ((this.t_render - this.t_analyze) + (this.t_process - this.t_capture)));
                this.m_delay = (short) 200;
                aecm.echoCancellation(aecTmpIn, null, aecTmpOut, (short) 160, this.m_delay);
                byte[] aecBuf = new byte[320];
                ByteBuffer.wrap(aecBuf).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().put(aecTmpOut);
                fout.write(aecBuf, 0, aecBuf.length);
            }
            this.mBuffer_toWrite.clear();
            this.mBuffer_toWrite = ByteBuffer.allocateDirect(fout.size());
            this.mBuffer_toWrite.put(fout.toByteArray());
            fout.close();
            fin.close();
            aecm.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isRecording() {
        boolean z;
        synchronized (this.mutex) {
            z = this.m_isRecording;
        }
        return z;
    }

    public void setIsEnhanced(boolean val) {
        this.m_isEnhancedMicrophone = val;
    }

    public static List<String> getBlackListedModels() {
        return Arrays.asList(BLACKLIST);
    }

    public static boolean deviceIsBlackListed() {
        return Arrays.asList(BLACKLIST).contains(Build.MODEL);
    }
}
