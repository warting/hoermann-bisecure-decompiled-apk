package com.adobe.flashruntime.shared;

import android.content.Context;
import android.os.Build.VERSION;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.ViewGroup.LayoutParams;

public class VideoView extends SurfaceView {
    private static final String TAG = "VideoSurfaceView";
    private boolean mAmCreated = false;
    private long mCPPInstance;
    private Context mContext;
    private boolean mPlanePositionSet = false;
    private Surface mSurface = null;
    private int mXmax = 16;
    private int mXmin = 0;
    private int mYmax = 16;
    private int mYmin = 0;

    /* renamed from: com.adobe.flashruntime.shared.VideoView$1 */
    class C00841 implements Callback {
        C00841() {
        }

        public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            Log.v(VideoView.TAG, "surfaceChanged format=" + format + ", width=" + width + ", height=" + height);
            if (!VideoView.this.useOverlay() || !VideoView.this.mPlanePositionSet) {
                return;
            }
            if (width != VideoView.this.mXmax - VideoView.this.mXmin || height != VideoView.this.mYmax - VideoView.this.mYmin) {
                VideoView.this.setPlanePosition(VideoView.this.mXmin, VideoView.this.mYmin, VideoView.this.mXmax, VideoView.this.mYmax);
            }
        }

        public void surfaceCreated(SurfaceHolder holder) {
            Log.v(VideoView.TAG, "surfaceCreated");
            VideoView.this.mSurface = holder.getSurface();
            VideoView.this.mAmCreated = true;
            VideoView.this.notifyNativeReadyForVideo();
        }

        public void surfaceDestroyed(SurfaceHolder holder) {
            Log.v(VideoView.TAG, "surfaceDestroyed");
            VideoView.this.mSurface.release();
            VideoView.this.mAmCreated = false;
            VideoView.this.notifyNativeReadyForVideo();
        }
    }

    /* renamed from: com.adobe.flashruntime.shared.VideoView$2 */
    class C00852 implements Runnable {
        C00852() {
        }

        public void run() {
            VideoView.this.layout(VideoView.this.mXmin, VideoView.this.mYmin, VideoView.this.mXmax, VideoView.this.mYmax);
        }
    }

    private native void nativeSetJavaViewReady(long j, boolean z);

    public VideoView(Context context) {
        super(context);
        this.mContext = context;
        setLayoutParams(new LayoutParams(-2, -2));
        if (useOverlay()) {
            getHolder().setFormat(842094169);
        }
        getHolder().addCallback(new C00841());
    }

    public void VideoPlaybackRestarted() {
    }

    void setNativeInstance(long instance) {
    }

    public void setFPInstance(long inFPInstance) {
        Log.d(TAG, "Changing FP Instance from " + this.mCPPInstance + " to " + inFPInstance);
        this.mCPPInstance = inFPInstance;
        notifyNativeReadyForVideo();
    }

    public long getFPInstance() {
        return this.mCPPInstance;
    }

    public void setPlanePosition(int xmin, int ymin, int xmax, int ymax) {
        this.mXmin = xmin;
        this.mYmin = ymin;
        this.mXmax = xmax;
        this.mYmax = ymax;
        this.mPlanePositionSet = true;
        getHandler().post(new C00852());
    }

    protected boolean useOverlay() {
        if (VERSION.SDK_INT >= 14) {
            return true;
        }
        return false;
    }

    public Surface getSurface() {
        if (this.mAmCreated && useOverlay()) {
            return this.mSurface;
        }
        return null;
    }

    public void notifyNativeReadyForVideo() {
        if (this.mCPPInstance != 0) {
            nativeSetJavaViewReady(this.mCPPInstance, this.mAmCreated);
        }
    }
}
