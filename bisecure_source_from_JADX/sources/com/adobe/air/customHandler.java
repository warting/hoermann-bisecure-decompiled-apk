package com.adobe.air;

import android.os.Handler;
import android.os.Message;

public class customHandler extends Handler {
    public static final int KEY_MSG_ID = 1121;
    public static final int TIME_OUT_MSG_ID = 1119;
    public static final int TOUCH_MSG_ID = 1120;

    public native void callTimeoutFunction(int i, int i2);

    public native boolean nativeOnKeyCallback(int i, int i2, int i3, boolean z, boolean z2, boolean z3);

    public native boolean nativeOnTouchCallback(int i, float f, float f2, float f3, int i2, float f4, float f5, boolean z, float[] fArr, int i3);

    public void handleMessage(Message msg) {
        if (msg.what == TIME_OUT_MSG_ID) {
            callTimeoutFunction(msg.arg1, msg.arg2);
        } else if (msg.what == TOUCH_MSG_ID) {
            TouchEventData touchObj = msg.obj;
            nativeOnTouchCallback(touchObj.mTouchEventType, touchObj.mXCoord, touchObj.mYCoord, touchObj.mPressure, touchObj.mPointerID, touchObj.mContactX, touchObj.mContactY, touchObj.mIsPrimaryPoint, touchObj.mHistory, touchObj.mMetaState);
        } else if (msg.what == KEY_MSG_ID) {
            KeyEventData keyObj = msg.obj;
            nativeOnKeyCallback(keyObj.mKeyAction, keyObj.mKeyCode, keyObj.mUnicode, keyObj.mAlt, keyObj.mShift, keyObj.mSym);
        }
    }
}
