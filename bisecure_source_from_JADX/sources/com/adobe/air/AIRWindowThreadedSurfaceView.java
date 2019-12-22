package com.adobe.air;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.SurfaceHolder;
import java.util.concurrent.Semaphore;

public class AIRWindowThreadedSurfaceView extends AIRWindowSurfaceView {
    public final Semaphore drawSemaphore = new Semaphore(0);
    private DrawThread thread = null;

    public AIRWindowThreadedSurfaceView(Context context, AndroidActivityWrapper aActivityWrapper) {
        super(context, aActivityWrapper);
        Init(context);
    }

    protected void Init(Context context) {
        this.thread = new DrawThread(this, this.mSurfaceHolder, context);
    }

    public void surfaceCreated(SurfaceHolder holder) {
        super.surfaceCreated(holder);
        this.thread.setRunning(true);
        if (!this.thread.isAlive()) {
            try {
                this.thread.start();
            } catch (Exception e) {
            }
        }
    }

    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        super.surfaceChanged(holder, format, width, height);
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
        super.surfaceDestroyed(holder);
        boolean retry = true;
        this.thread.setRunning(false);
        while (retry && this.thread.isAlive()) {
            try {
                this.thread.join();
                retry = false;
            } catch (InterruptedException e) {
            }
        }
    }

    public void drawBitmap(int srcX, int srcY, int srcWd, int srcHt, Bitmap bm) {
        this.thread.requestDraw(srcX, srcY, srcWd, srcHt, bm);
        try {
            this.drawSemaphore.acquire();
        } catch (Exception e) {
        }
    }

    public void drawBitmap(int srcX, int srcY, int srcWd, int srcHt, Bitmap bm, int dstX, int dstY, int dstWd, int dstHt, boolean fullsc, int bgColor) {
        this.thread.requestDraw(srcX, srcY, srcWd, srcHt, bm, dstX, dstY, dstWd, dstHt, fullsc, bgColor);
        try {
            this.drawSemaphore.acquire();
        } catch (Exception e) {
        }
    }
}
