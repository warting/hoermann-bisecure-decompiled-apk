package com.adobe.air;

import android.os.Build.VERSION;
import android.os.SystemClock;
import android.view.KeyEvent;
import android.view.MotionEvent;
import com.adobe.air.utils.AIRLogger;

public class Automation {
    public boolean dispatchTouchEvent(AIRWindowSurfaceView v, int touchType, float x, float y, float pressure, int pointerid, float contactX, float contactY, boolean primaryPoint, float[] history, int metaState) {
        if (VERSION.SDK_INT < 9) {
            return false;
        }
        try {
            v.onTouchEvent(MotionEvent.obtain(SystemClock.uptimeMillis(), SystemClock.uptimeMillis(), touchType, x, y, metaState));
        } catch (Exception e) {
            AIRLogger.m0d("Automation", "[JP] dispatchTouchEvent caught " + e);
        }
        return true;
    }

    public boolean dispatchKeyEvent(AIRWindowSurfaceView v, int inKeyAction, int inKeyCode, int unicode, boolean alt, boolean shift, boolean sym) {
        if (VERSION.SDK_INT < 9) {
            return false;
        }
        int metastate = 0;
        if (alt) {
            metastate = 0 | 2;
        }
        if (shift) {
            metastate |= 1;
        }
        if (sym) {
            metastate |= 4;
        }
        try {
            KeyEvent event = new KeyEvent(SystemClock.uptimeMillis(), SystemClock.uptimeMillis(), inKeyAction, inKeyCode, 0, metastate);
            if (inKeyAction == 0) {
                v.onKeyDown(inKeyCode, event);
            } else if (inKeyAction == 1) {
                v.onKeyUp(inKeyCode, event);
            }
        } catch (Exception e) {
            AIRLogger.m0d("Automation", "[JP] dispatchKeyEvent caught " + e);
        }
        return true;
    }
}
