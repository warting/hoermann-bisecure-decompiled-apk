package com.adobe.air;

import android.content.Context;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;

/* compiled from: AndroidCamera */
class AndroidCameraView extends SurfaceView implements Callback {
    private AndroidActivityWrapper mActivityWrapper = null;
    private boolean mRecreating = false;

    public AndroidCameraView(Context context, AndroidActivityWrapper wrapper) {
        super(context);
        this.mActivityWrapper = wrapper;
        getHolder().setType(3);
        setZOrderMediaOverlay(false);
        getHolder().addCallback(this);
    }

    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
    }

    public void surfaceCreated(SurfaceHolder holder) {
        this.mActivityWrapper.planeStepCascade();
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
        this.mActivityWrapper.planeBreakCascade();
    }
}
