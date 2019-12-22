package com.adobe.air;

import android.os.Handler;
import android.os.Looper;

public class WorkerLooper {
    private Handler mHandler = new customHandler();
    private Looper mLooper = Looper.myLooper();

    public WorkerLooper() {
        Looper.prepare();
    }

    public void start() {
        Looper.loop();
    }

    public Handler getHandler() {
        return this.mHandler;
    }

    public void quit() {
        this.mLooper.quit();
    }
}
