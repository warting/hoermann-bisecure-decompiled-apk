package com.adobe.air.utils;

import android.util.TimingLogger;

public class PerfTimer {
    private static final String LOG_TAG = "AIRPerfTimer";
    private TimingLogger m_timer = null;

    public PerfTimer(String blockName) {
        this.m_timer = new TimingLogger(LOG_TAG, blockName);
    }

    public final void newBlock(String blockName) {
        if (AIRLogger.isEnabled()) {
            this.m_timer.addSplit(blockName);
        }
    }

    public final void stop() {
        if (AIRLogger.isEnabled()) {
            this.m_timer.dumpToLog();
        }
    }
}
