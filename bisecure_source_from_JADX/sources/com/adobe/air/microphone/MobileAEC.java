package com.adobe.air.microphone;

public class MobileAEC {
    public static final short AECM_ENABLE = (short) 1;
    public static final short AECM_UNABLE = (short) 0;
    private AecmConfig mAecmConfig = null;
    private int mAecmHandler = -1;
    private boolean mIsInit = false;
    private SamplingFrequency mSampFreq = null;

    public class AecmConfig {
        private short mAecmMode = ((short) AggressiveMode.AGGRESSIVE.getMode());
        private short mCngMode = (short) 1;
    }

    public static final class AggressiveMode {
        public static final AggressiveMode AGGRESSIVE = new AggressiveMode(3);
        public static final AggressiveMode HIGH = new AggressiveMode(2);
        public static final AggressiveMode MEDIUM = new AggressiveMode(1);
        public static final AggressiveMode MILD = new AggressiveMode(0);
        public static final AggressiveMode MOST_AGGRESSIVE = new AggressiveMode(4);
        private final int mMode;

        public int getMode() {
            return this.mMode;
        }

        private AggressiveMode(int mode) {
            this.mMode = mode;
        }
    }

    public static final class SamplingFrequency {
        public static final SamplingFrequency FS_16000Hz = new SamplingFrequency(16000);
        public static final SamplingFrequency FS_8000Hz = new SamplingFrequency(8000);
        private final long mSamplingFrequency;

        public long getFS() {
            return this.mSamplingFrequency;
        }

        private SamplingFrequency(long fs) {
            this.mSamplingFrequency = fs;
        }
    }

    private static native int nativeAecmProcess(int i, short[] sArr, short[] sArr2, short[] sArr3, short s, short s2);

    private static native int nativeBufferFarend(int i, short[] sArr, int i2);

    private static native int nativeCreateAecmInstance();

    private static native int nativeFreeAecmInstance(int i);

    private static native int nativeInitializeAecmInstance(int i, int i2);

    private static native int nativeSetConfig(int i, AecmConfig aecmConfig);

    public MobileAEC(SamplingFrequency sampFreqOfData) {
        setSampFreq(sampFreqOfData);
        this.mAecmConfig = new AecmConfig();
        this.mAecmHandler = nativeCreateAecmInstance();
    }

    public void setSampFreq(SamplingFrequency fs) {
        if (fs == null) {
            this.mSampFreq = SamplingFrequency.FS_16000Hz;
        } else {
            this.mSampFreq = fs;
        }
    }

    public MobileAEC farendBuffer(short[] farendBuf, int numOfSamples) throws Exception {
        if (!this.mIsInit) {
            throw new Exception("setFarendBuffer() called on an unprepared AECM instance.");
        } else if (nativeBufferFarend(this.mAecmHandler, farendBuf, numOfSamples) != -1) {
            return this;
        } else {
            throw new Exception("setFarendBuffer() failed due to invalid arguments.");
        }
    }

    public void echoCancellation(short[] nearendNoisy, short[] nearendClean, short[] out, short numOfSamples, short delay) throws Exception {
        if (!this.mIsInit) {
            throw new Exception("echoCancelling() called on an unprepared AECM instance.");
        } else if (nativeAecmProcess(this.mAecmHandler, nearendNoisy, nearendClean, out, numOfSamples, delay) == -1) {
            throw new Exception("echoCancellation() failed due to invalid arguments.");
        }
    }

    public MobileAEC setAecmMode(AggressiveMode mode) throws NullPointerException {
        if (mode == null) {
            throw new NullPointerException("setAecMode() failed due to null argument.");
        }
        this.mAecmConfig.mAecmMode = (short) mode.getMode();
        return this;
    }

    public MobileAEC prepare() {
        if (this.mIsInit) {
            close();
            this.mAecmHandler = nativeCreateAecmInstance();
        }
        mInitAecmInstance((int) this.mSampFreq.getFS());
        this.mIsInit = true;
        nativeSetConfig(this.mAecmHandler, this.mAecmConfig);
        return this;
    }

    public void close() {
        if (this.mIsInit) {
            nativeFreeAecmInstance(this.mAecmHandler);
            this.mAecmHandler = -1;
            this.mIsInit = false;
        }
    }

    protected void finalize() throws Throwable {
        super.finalize();
        if (this.mIsInit) {
            close();
        }
    }

    private void mInitAecmInstance(int SampFreq) {
        if (!this.mIsInit) {
            nativeInitializeAecmInstance(this.mAecmHandler, SampFreq);
            this.mAecmConfig = new AecmConfig();
            nativeSetConfig(this.mAecmHandler, this.mAecmConfig);
            this.mIsInit = true;
        }
    }
}
