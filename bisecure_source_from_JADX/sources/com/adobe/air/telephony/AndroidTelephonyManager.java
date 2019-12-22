package com.adobe.air.telephony;

import android.content.Context;
import android.telephony.TelephonyManager;

public class AndroidTelephonyManager {
    private static AndroidTelephonyManager sAndroidTelephonyManager = null;
    private Context mContext = null;
    private boolean mListening = false;
    private AndroidPhoneStateListener mPhoneStateListener = null;
    private TelephonyManager mTelephonyMgr = null;

    public static AndroidTelephonyManager CreateAndroidTelephonyManager(Context c) {
        if (sAndroidTelephonyManager == null) {
            sAndroidTelephonyManager = new AndroidTelephonyManager(c);
        }
        return sAndroidTelephonyManager;
    }

    public static AndroidTelephonyManager GetAndroidTelephonyManager() {
        return sAndroidTelephonyManager;
    }

    private AndroidTelephonyManager(Context c) {
        this.mContext = c;
        if (this.mContext != null) {
            this.mTelephonyMgr = (TelephonyManager) this.mContext.getSystemService("phone");
        }
    }

    public void listen(boolean start) {
        if (this.mTelephonyMgr != null) {
            if (start) {
                try {
                    if (!this.mListening) {
                        if (this.mPhoneStateListener == null) {
                            this.mPhoneStateListener = new AndroidPhoneStateListener();
                        }
                        this.mTelephonyMgr.listen(this.mPhoneStateListener, 32);
                        this.mListening = true;
                        this.mPhoneStateListener.onCallStateChanged(this.mTelephonyMgr.getCallState(), "0");
                        return;
                    }
                } catch (Exception e) {
                    return;
                }
            }
            if (!start && this.mListening && this.mPhoneStateListener != null) {
                this.mTelephonyMgr.listen(this.mPhoneStateListener, 0);
                this.mPhoneStateListener = null;
                this.mListening = false;
            }
        }
    }
}
