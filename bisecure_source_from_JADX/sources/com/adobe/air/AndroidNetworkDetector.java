package com.adobe.air;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.NetworkInfo;

public class AndroidNetworkDetector {
    private static final String NET_DETECT_TAG = "AndroidNetworkDetector";
    private BroadcastReceiver mReceiver;
    private long objReference;
    private boolean registered = false;

    /* renamed from: com.adobe.air.AndroidNetworkDetector$1 */
    class C00281 extends BroadcastReceiver {
        C00281() {
        }

        public void onReceive(Context context, Intent intent) {
            if (!isInitialStickyBroadcast()) {
                NetworkInfo nwInfo = (NetworkInfo) intent.getParcelableExtra("networkInfo");
                if (nwInfo != null) {
                    nwInfo.getDetailedState();
                }
                AndroidNetworkDetector.this.callOnNetworkChange(AndroidNetworkDetector.this.objReference);
            }
        }
    }

    private native void callOnNetworkChange(long j);

    public void RegisterForNetworkChange(Context context, long objRef) {
        if (!this.registered) {
            try {
                this.mReceiver = new C00281();
                this.objReference = objRef;
                IntentFilter filter = new IntentFilter();
                filter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
                context.registerReceiver(this.mReceiver, filter);
                this.registered = true;
            } catch (Exception e) {
            }
        }
    }
}
