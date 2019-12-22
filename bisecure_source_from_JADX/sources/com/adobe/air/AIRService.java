package com.adobe.air;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.os.Process;
import android.os.SystemClock;
import com.adobe.air.utils.Utils;

public class AIRService extends Service {
    public static final String EXTRA_DOWNLOAD_TIME = "com.adobe.air.DownloadConfigCompleteTime";
    public static final String INTENT_CONFIG_DOWNLOADED = "com.adobe.air.DownloadConfigComplete";
    public static final String INTENT_DOWNLOAD_CONFIG = "com.adobe.air.DownloadConfig";
    private static final String LOG_TAG = "AIRService";
    private static AIRService sServiceInstance = null;
    private final IBinder mBinder = new DummyBinder();
    private Entrypoints mEntrypoints = null;
    private boolean mPlayerInitialized = false;

    public class DummyBinder extends Binder {
        AIRService getService() {
            return AIRService.this;
        }
    }

    public void onCreate() {
        super.onCreate();
        this.mEntrypoints = new Entrypoints();
        sServiceInstance = this;
        Utils.setRuntimePackageName(getApplicationContext().getPackageName());
    }

    public void onDestroy() {
        super.onDestroy();
        sServiceInstance = null;
        if (this.mPlayerInitialized) {
            this.mEntrypoints.EntryStopRuntime();
            this.mPlayerInitialized = false;
        }
        if (!Utils.hasCaptiveRuntime()) {
            Process.killProcess(Process.myPid());
        }
    }

    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent.getAction().equals(INTENT_DOWNLOAD_CONFIG)) {
            downloadConfig();
        }
        return 2;
    }

    public IBinder onBind(Intent intent) {
        return this.mBinder;
    }

    public static AIRService getAIRService() {
        return sServiceInstance;
    }

    private Entrypoints getEntrypoints() {
        return this.mEntrypoints;
    }

    private void downloadConfig() {
        if (!this.mPlayerInitialized) {
            this.mPlayerInitialized = true;
            if (!this.mEntrypoints.EntryDownloadConfig(getApplicationContext(), Utils.getRuntimePackageName())) {
                downloadDone(false);
            }
        }
    }

    public void downloadDone(boolean success) {
        if (success) {
            Intent intent = new Intent(INTENT_CONFIG_DOWNLOADED);
            intent.putExtra(EXTRA_DOWNLOAD_TIME, SystemClock.uptimeMillis());
            sendStickyBroadcast(intent);
        }
        stopSelf();
    }

    public Context getContext() {
        getEntrypoints();
        return Entrypoints.s_context;
    }

    public static boolean IsRunningInServiceContext() {
        return getAIRService() != null;
    }
}
