package com.adobe.air.telephony;

import android.telephony.PhoneStateListener;

/* compiled from: AndroidTelephonyManager */
class AndroidPhoneStateListener extends PhoneStateListener {
    private native void nativeOnCallStateChanged(int i);

    AndroidPhoneStateListener() {
    }

    public void onCallStateChanged(int state, String incomingNumber) {
        nativeOnCallStateChanged(toAIRCallState(state));
    }

    private int toAIRCallState(int state) {
        if ((state & 1) == 1) {
            return 1;
        }
        if ((state & 2) == 2) {
            return 2;
        }
        return 0;
    }
}
