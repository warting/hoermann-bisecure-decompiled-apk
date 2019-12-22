package com.adobe.flashruntime.air;

import android.content.Context;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.FlashEGL;
import com.adobe.air.FlashEGLFactory;
import com.adobe.flashruntime.shared.VideoView;

public class VideoViewAIR extends VideoView {
    private static String kLogTag = "VideoViewAIR";
    protected AndroidActivityWrapper mActivityWrapper;
    private FlashEGL mVideoFlashEGL = null;

    /* renamed from: com.adobe.flashruntime.air.VideoViewAIR$1 */
    class C00831 implements Callback {
        C00831() {
        }

        public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            VideoViewAIR.this.nativeSetSurfaceSize(VideoViewAIR.this.getFPInstance(), width, height);
        }

        public void surfaceCreated(SurfaceHolder holder) {
            VideoViewAIR.this.mActivityWrapper.planeStepCascade();
        }

        public void surfaceDestroyed(SurfaceHolder holder) {
            VideoViewAIR.this.mActivityWrapper.planeBreakCascade();
        }
    }

    private native void nativeSetSurfaceSize(long j, int i, int i2);

    public VideoViewAIR(Context inContext, AndroidActivityWrapper inWrapper) {
        super(inContext);
        this.mActivityWrapper = inWrapper;
        this.mActivityWrapper.registerPlane(this, 7);
        this.mActivityWrapper.planeStepCascade();
        getHolder().addCallback(new C00831());
    }

    public FlashEGL getVideoEgl() {
        if (this.mVideoFlashEGL == null) {
            this.mVideoFlashEGL = FlashEGLFactory.CreateFlashEGL();
        }
        return this.mVideoFlashEGL;
    }
}
