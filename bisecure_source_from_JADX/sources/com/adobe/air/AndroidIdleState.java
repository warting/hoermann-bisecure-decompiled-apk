package com.adobe.air;

import android.app.KeyguardManager;
import android.app.KeyguardManager.KeyguardLock;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;

public class AndroidIdleState {
    public static final int IDLE_STATE_NORMAL = 0;
    private static final String IDLE_STATE_TAG = "AndroidIdleState";
    public static final int IDLE_STATE_WAKEUP = 1;
    private static AndroidIdleState mIdleStateManager = null;
    private int mCurrentIdleState = 0;
    private boolean mIsWakeUpLockHeld = false;
    private KeyguardLock mKeyGuardLock = null;
    private WakeLock mScreenBrightLock = null;
    private BroadcastReceiver sReceiver = null;
    private boolean sScreenOn = true;

    /* renamed from: com.adobe.air.AndroidIdleState$1 */
    class C00261 extends BroadcastReceiver {
        C00261() {
        }

        public void onReceive(Context context, Intent intent) {
            boolean screenOn = true;
            if (intent.getAction().equals("android.intent.action.SCREEN_OFF")) {
                screenOn = false;
            } else if (intent.getAction().equals("android.intent.action.SCREEN_ON")) {
                screenOn = true;
            }
            if (AndroidIdleState.this.sScreenOn != screenOn) {
                AndroidIdleState.this.sScreenOn = screenOn;
                AndroidActivityWrapper.GetAndroidActivityWrapper().onScreenStateChanged(AndroidIdleState.this.sScreenOn);
            }
        }
    }

    public static AndroidIdleState GetIdleStateManager(Context c) {
        if (mIdleStateManager == null) {
            mIdleStateManager = new AndroidIdleState(c);
        }
        return mIdleStateManager;
    }

    private AndroidIdleState(Context c) {
        if (this.sReceiver == null) {
            try {
                this.sReceiver = new C00261();
                IntentFilter filter = new IntentFilter("android.intent.action.SCREEN_ON");
                filter.addAction("android.intent.action.SCREEN_OFF");
                c.registerReceiver(this.sReceiver, filter);
            } catch (Exception e) {
            }
        }
    }

    public void ChangeIdleState(Context c, int stateRequested) {
        if (stateRequested == 0) {
            try {
                releaseLock();
                this.mCurrentIdleState = 0;
                return;
            } catch (Exception e) {
                return;
            }
        }
        if (this.mScreenBrightLock == null) {
            try {
                this.mScreenBrightLock = ((PowerManager) c.getSystemService("power")).newWakeLock(268435466, "DoNotDimScreen");
                this.mKeyGuardLock = ((KeyguardManager) c.getSystemService("keyguard")).newKeyguardLock("DoNotLockKeys");
            } catch (Exception e2) {
                this.mScreenBrightLock = null;
                this.mKeyGuardLock = null;
                return;
            }
        }
        this.mCurrentIdleState = 1;
        acquireLock();
    }

    public void acquireLock() {
        try {
            if (this.mCurrentIdleState == 1 && !this.mIsWakeUpLockHeld) {
                this.mScreenBrightLock.acquire();
                this.mKeyGuardLock.disableKeyguard();
                this.mIsWakeUpLockHeld = true;
            }
        } catch (Exception e) {
        }
    }

    public void releaseLock() {
        try {
            if (this.mCurrentIdleState == 1 && this.mIsWakeUpLockHeld) {
                this.mScreenBrightLock.release();
                this.mKeyGuardLock.reenableKeyguard();
                this.mIsWakeUpLockHeld = false;
            }
        } catch (Exception e) {
        }
    }
}
