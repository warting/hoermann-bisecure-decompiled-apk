package com.adobe.air;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.SystemClock;
import com.adobe.air.AndroidActivityWrapper.ActivityState;

class ConfigDownloadListener {
    private static String LOG_TAG = "ConfigDownloadListener";
    private static ConfigDownloadListener sListener = null;
    private long lastPauseTime = SystemClock.uptimeMillis();
    private StateChangeCallback mActivityStateCB = new C00392();
    private BroadcastReceiver mDownloadConfigRecv = new C00381();

    /* renamed from: com.adobe.air.ConfigDownloadListener$1 */
    class C00381 extends BroadcastReceiver {
        private String LOG_TAG = "ConfigDownloadListenerBR";

        C00381() {
        }

        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(AIRService.INTENT_CONFIG_DOWNLOADED)) {
                boolean applyConfig = false;
                if (isInitialStickyBroadcast()) {
                    Bundle extras = intent.getExtras();
                    if (extras != null) {
                        if (ConfigDownloadListener.this.lastPauseTime < extras.getLong(AIRService.EXTRA_DOWNLOAD_TIME)) {
                            applyConfig = true;
                        }
                    }
                } else {
                    applyConfig = true;
                }
                if (applyConfig) {
                    AndroidActivityWrapper actWrap = AndroidActivityWrapper.GetAndroidActivityWrapper();
                    if (actWrap != null) {
                        actWrap.applyDownloadedConfig();
                    }
                }
            }
        }
    }

    /* renamed from: com.adobe.air.ConfigDownloadListener$2 */
    class C00392 implements StateChangeCallback {
        C00392() {
        }

        public void onActivityStateChanged(ActivityState state) {
            Activity act = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
            if (state == ActivityState.PAUSED) {
                act.unregisterReceiver(ConfigDownloadListener.this.mDownloadConfigRecv);
                ConfigDownloadListener.this.lastPauseTime = SystemClock.uptimeMillis();
            } else if (state == ActivityState.RESUMED) {
                act.registerReceiver(ConfigDownloadListener.this.mDownloadConfigRecv, new IntentFilter(AIRService.INTENT_CONFIG_DOWNLOADED));
            }
        }

        public void onConfigurationChanged(Configuration config) {
        }
    }

    private ConfigDownloadListener() {
        AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityStateChangeListner(this.mActivityStateCB);
    }

    public static ConfigDownloadListener GetConfigDownloadListener() {
        if (sListener == null) {
            sListener = new ConfigDownloadListener();
        }
        return sListener;
    }
}
