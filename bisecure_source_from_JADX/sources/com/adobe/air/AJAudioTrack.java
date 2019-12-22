package com.adobe.air;

import android.media.AudioTrack;
import com.adobe.air.microphone.AIRMicrophone;

public class AJAudioTrack extends AudioTrack {
    private static int sStreamType = 3;
    private byte[] mBuf;

    public static AJAudioTrack CreateTrack(int sampleRate, int sampleFormat, int channelCount, int bufferSize) {
        if (AIRMicrophone.m_isEnhanced) {
            sStreamType = 0;
        }
        try {
            int minSize = AudioTrack.getMinBufferSize(sampleRate, ToAndroidChannelCount(channelCount), ToAndroidFormat(sampleFormat));
            if (bufferSize < minSize) {
                bufferSize = minSize;
            }
            AJAudioTrack trk = new AJAudioTrack(sampleRate, ToAndroidFormat(sampleFormat), ToAndroidChannelCount(channelCount), bufferSize);
            try {
                if (trk.getState() == 1) {
                    return trk;
                }
                trk.release();
                return null;
            } catch (Exception e) {
                AJAudioTrack aJAudioTrack = trk;
                return null;
            }
        } catch (Exception e2) {
            return null;
        }
    }

    public AJAudioTrack(int sampleRate, int sampleFormat, int channelCount, int bufferSize) {
        super(sStreamType, sampleRate, channelCount, sampleFormat, bufferSize, 1);
        this.mBuf = new byte[bufferSize];
    }

    public static void SetStreamType(int streamType) {
        sStreamType = streamType;
    }

    public static int ToAndroidFormat(int sampleFormat) {
        if (sampleFormat == 1) {
            return 3;
        }
        return 2;
    }

    public static int ToAndroidChannelCount(int channelCount) {
        if (channelCount == 1) {
            return 4;
        }
        return 12;
    }

    public byte[] GetBuffer() {
        return this.mBuf;
    }

    public boolean playing() {
        return getPlayState() == 3;
    }

    public boolean stopped() {
        return getPlayState() == 1;
    }
}
