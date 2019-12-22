package com.adobe.air;

public class KeyEventData {
    boolean mAlt;
    int mKeyAction;
    int mKeyCode;
    boolean mShift;
    boolean mSym;
    int mUnicode;

    public KeyEventData(int inKeyAction, int inKeyCode, int unicode, boolean alt, boolean shift, boolean sym) {
        this.mKeyAction = inKeyAction;
        this.mKeyCode = inKeyCode;
        this.mUnicode = unicode;
        this.mAlt = alt;
        this.mShift = shift;
        this.mSym = sym;
    }
}
