package com.adobe.air;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.SurfaceHolder;

/* compiled from: AIRWindowThreadedSurfaceView */
class DrawThread extends Thread {
    private Handler mHandler = null;
    private Looper mLooper = null;
    private boolean mRun = false;
    private AIRWindowThreadedSurfaceView mView = null;

    /* compiled from: AIRWindowThreadedSurfaceView */
    /* renamed from: com.adobe.air.DrawThread$1 */
    class C00401 extends Handler {
        C00401() {
        }

        public void handleMessage(Message m) {
            if (m.what == DrawRequest.messageID) {
                DrawThread.this.draw((DrawRequest) m.obj);
                DrawThread.this.mView.drawSemaphore.release();
            }
        }
    }

    public DrawThread(AIRWindowThreadedSurfaceView view, SurfaceHolder surfaceHolder, Context context) {
        this.mView = view;
    }

    public void run() {
        Looper.prepare();
        this.mHandler = new C00401();
        this.mLooper = Looper.myLooper();
        Looper.loop();
    }

    public void requestDraw(int x, int y, int wd, int ht, Bitmap bm) {
        Message msg = new Message();
        msg.what = DrawRequest.messageID;
        msg.obj = new DrawRequest(x, y, wd, ht, bm);
        this.mHandler.sendMessage(msg);
    }

    public void requestDraw(int x, int y, int wd, int ht, Bitmap bm, int dstX, int dstY, int dstWd, int dstHt, boolean fullsc, int bgColor) {
        Message msg = new Message();
        msg.what = DrawRequest.messageID;
        msg.obj = new DrawRequest(x, y, wd, ht, bm, dstX, dstY, dstWd, dstHt, fullsc, bgColor);
        this.mHandler.sendMessage(msg);
    }

    public void setRunning(boolean run) {
        this.mRun = run;
        if (!this.mRun) {
            this.mLooper.quit();
        }
    }

    private void draw(DrawRequest req) {
        if (req.scale) {
            this.mView.drawScaled(req.f0x, req.f1y, req.wd, req.ht, req.bm, req.dstX, req.dstY, req.dstWd, req.dstHt, req.fullsc, req.bgColor);
        } else {
            this.mView.draw(req.f0x, req.f1y, req.wd, req.ht, req.bm);
        }
    }
}
