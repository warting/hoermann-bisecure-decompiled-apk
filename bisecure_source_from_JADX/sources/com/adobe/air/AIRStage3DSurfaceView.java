package com.adobe.air;

import android.content.Context;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;

public class AIRStage3DSurfaceView extends SurfaceView implements Callback {
    private static final String TAG = "com.adobe.air";
    private AndroidActivityWrapper mActivityWrapper = null;
    private long mFPInstance = 0;
    private boolean mInit = false;
    private boolean mSurfaceValid = false;
    private int mXmax = 16;
    private int mXmin = 0;
    private int mYmax = 16;
    private int mYmin = 0;
    private OnGlobalLayoutListener m_layOutListener = null;

    /* renamed from: com.adobe.air.AIRStage3DSurfaceView$1 */
    class C00111 implements OnGlobalLayoutListener {
        C00111() {
        }

        public void onGlobalLayout() {
            if (AIRStage3DSurfaceView.this.mFPInstance != 0) {
                AIRStage3DSurfaceView.this.nativeSurfaceLayoutChanged(AIRStage3DSurfaceView.this.mFPInstance);
            }
        }
    }

    private native void nativeSurfaceChanged(long j, int i, int i2);

    private native void nativeSurfaceCreated(long j);

    private native void nativeSurfaceLayoutChanged(long j);

    private native void nativeSurfaceLost(long j);

    public AIRStage3DSurfaceView(Context context, AndroidActivityWrapper wrapper, long fpinstance) {
        super(context);
        setFPInstance(context, wrapper, fpinstance);
        setWillNotDraw(false);
        setEnabled(true);
        setClickable(false);
        setFocusable(false);
        setFocusableInTouchMode(false);
        setLayoutParams(new LayoutParams(-2, -2));
        if (AndroidActivityWrapper.isGingerbread()) {
            getHolder().setFormat(2);
        } else {
            getHolder().setFormat(1);
        }
        getHolder().addCallback(this);
        setZOrderOnTop(false);
        this.mActivityWrapper.registerPlane(this, 6);
    }

    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        setMeasuredDimension(this.mXmax - this.mXmin, this.mYmax - this.mYmin);
    }

    public void setPlanePosition(int xmin, int ymin, int xmax, int ymax) {
        this.mXmin = xmin;
        this.mYmin = ymin;
        this.mXmax = xmax;
        this.mYmax = ymax;
        layout(xmin, ymin, xmax, ymax);
    }

    public boolean setFPInstance(Context context, AndroidActivityWrapper wrapper, long fpinstance) {
        this.mActivityWrapper = wrapper;
        this.mFPInstance = fpinstance;
        if (this.mFPInstance != 0) {
            this.mActivityWrapper.registerPlane(this, 6);
        } else {
            this.mActivityWrapper.unregisterPlane(6);
        }
        return this.mSurfaceValid;
    }

    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        if (this.mFPInstance != 0) {
            nativeSurfaceChanged(this.mFPInstance, width, height);
        }
    }

    public void surfaceCreated(SurfaceHolder holder) {
        this.mSurfaceValid = true;
        if (this.mFPInstance != 0) {
            nativeSurfaceCreated(this.mFPInstance);
        }
        this.mActivityWrapper.planeStepCascade();
        ViewTreeObserver viewObserver = getViewTreeObserver();
        if (viewObserver.isAlive()) {
            if (this.m_layOutListener == null) {
                this.m_layOutListener = new C00111();
            }
            if (this.m_layOutListener != null) {
                viewObserver.addOnGlobalLayoutListener(this.m_layOutListener);
            }
        }
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
        this.mSurfaceValid = false;
        if (this.mFPInstance != 0) {
            nativeSurfaceLost(this.mFPInstance);
        }
        this.mActivityWrapper.planeBreakCascade();
        ViewTreeObserver viewObserver = getViewTreeObserver();
        if (viewObserver.isAlive() && this.m_layOutListener != null) {
            viewObserver.removeGlobalOnLayoutListener(this.m_layOutListener);
        }
    }
}
