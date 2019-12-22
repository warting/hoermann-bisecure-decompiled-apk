package com.adobe.flashruntime.air;

import android.graphics.SurfaceTexture;
import android.graphics.SurfaceTexture.OnFrameAvailableListener;
import android.os.Build.VERSION;
import android.util.Log;
import android.view.Surface;

public class VideoTextureSurface implements OnFrameAvailableListener {
    private static final String TAG = "VideoSurfaceTexture";
    private boolean mAmCreated = false;
    private long mCPPInstance;
    private boolean mFrameAvailable = false;
    private boolean mPlanePositionSet = false;
    private Surface mSurface = null;
    private int mTextureId;
    private SurfaceTexture mVideoTexture;

    private native void nativeSetJavaTextureSurfaceReady(long j, boolean z);

    public VideoTextureSurface(int texName) {
        this.mTextureId = texName;
        this.mVideoTexture = new SurfaceTexture(this.mTextureId);
        this.mVideoTexture.setOnFrameAvailableListener(this);
        this.mSurface = new Surface(this.mVideoTexture);
        this.mAmCreated = true;
    }

    public boolean updateSurfaceTextureTexImage() {
        if (!this.mFrameAvailable) {
            return false;
        }
        this.mVideoTexture.updateTexImage();
        this.mFrameAvailable = false;
        return true;
    }

    public void onFrameAvailable(SurfaceTexture surfaceTexture) {
        this.mFrameAvailable = true;
        notifyNativeReadyForVideoTexture();
    }

    public void VideoPlaybackRestarted() {
    }

    public void setFPInstance(long inFPInstance) {
        Log.d(TAG, "Changing FP Instance from " + this.mCPPInstance + " to " + inFPInstance);
        this.mCPPInstance = inFPInstance;
    }

    public long getFPInstance() {
        return this.mCPPInstance;
    }

    public boolean useOverlay() {
        if (VERSION.SDK_INT >= 14) {
            return true;
        }
        return false;
    }

    void setNativeInstance(long instance) {
    }

    public Surface getSurface() {
        if (this.mAmCreated && useOverlay()) {
            return this.mSurface;
        }
        return null;
    }

    public void notifyNativeReadyForVideoTexture() {
        if (this.mCPPInstance != 0) {
            nativeSetJavaTextureSurfaceReady(this.mCPPInstance, this.mAmCreated);
        }
    }
}
