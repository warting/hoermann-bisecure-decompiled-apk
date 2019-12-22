package com.adobe.air;

import android.graphics.Bitmap;

/* compiled from: AIRWindowThreadedSurfaceView */
class DrawRequest {
    public static final int messageID = 1009;
    public int bgColor;
    public Bitmap bm;
    public int dstHt;
    public int dstWd;
    public int dstX;
    public int dstY;
    public boolean fullsc = false;
    public int ht;
    public boolean scale = false;
    public int wd;
    /* renamed from: x */
    public int f0x;
    /* renamed from: y */
    public int f1y;

    public DrawRequest(int _x, int _y, int _wd, int _ht, Bitmap _bm) {
        this.f0x = _x;
        this.f1y = _y;
        this.wd = _wd;
        this.ht = _ht;
        this.bm = _bm;
        this.scale = false;
    }

    public DrawRequest(int _x, int _y, int _wd, int _ht, Bitmap _bm, int _dstX, int _dstY, int _dstWd, int _dstHt, boolean _fullsc, int _bgColor) {
        this.f0x = _x;
        this.f1y = _y;
        this.wd = _wd;
        this.ht = _ht;
        this.bm = _bm;
        this.dstX = _dstX;
        this.dstY = _dstY;
        this.dstWd = _dstWd;
        this.dstHt = _dstHt;
        this.scale = true;
        this.fullsc = _fullsc;
        this.bgColor = _bgColor;
    }
}
