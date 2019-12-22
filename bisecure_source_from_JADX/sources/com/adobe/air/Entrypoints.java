package com.adobe.air;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import com.adobe.air.utils.Utils;
import java.io.File;

public class Entrypoints {
    static boolean mCallEntryMain;
    private static String mLibCorePath = null;
    private static customHandler mMainHandler = new customHandler();
    public static Context s_context;
    private static String s_packageName;

    public native void EntryDownloadConfigNative(Object obj, String str);

    public native void EntryMainWrapper(String str, String str2, String str3, String str4, Object obj, Object obj2, Object obj3, Object obj4, boolean z, boolean z2);

    public native void EntryStopRuntimeNative();

    public native void applyDownloadedConfig();

    public native void setMainViewOnCreate(AIRWindowSurfaceView aIRWindowSurfaceView);

    public static Handler getMainHandler() {
        return mMainHandler;
    }

    public static void registerCallback(int aTime, int low_id, int high_id, Handler handlerInstance) {
        if (handlerInstance == null) {
            handlerInstance = mMainHandler;
        }
        Message msg = Message.obtain();
        msg.what = customHandler.TIME_OUT_MSG_ID;
        msg.arg1 = low_id;
        msg.arg2 = high_id;
        if (aTime > 0) {
            handlerInstance.sendMessageDelayed(msg, (long) aTime);
        } else {
            handlerInstance.sendMessage(msg);
        }
    }

    public static boolean registerTouchCallback(int delay, TouchEventData touchObject, Handler handlerInstance) {
        if (handlerInstance == null) {
            handlerInstance = mMainHandler;
        }
        Message msg = Message.obtain();
        msg.what = customHandler.TOUCH_MSG_ID;
        msg.obj = touchObject;
        if (delay > 0) {
            handlerInstance.sendMessageDelayed(msg, (long) delay);
        } else {
            handlerInstance.sendMessage(msg);
        }
        return true;
    }

    public static boolean registerKeyCallback(int delay, KeyEventData keyObject, Handler handlerInstance) {
        if (handlerInstance == null) {
            handlerInstance = mMainHandler;
        }
        Message msg = Message.obtain();
        msg.what = customHandler.KEY_MSG_ID;
        msg.obj = keyObject;
        if (delay > 0) {
            handlerInstance.sendMessageDelayed(msg, (long) delay);
        } else {
            handlerInstance.sendMessage(msg);
        }
        return true;
    }

    public static void BroadcastIntent(String action, String data) {
        AndroidActivityWrapper.GetAndroidActivityWrapper().BroadcastIntent(action, data);
    }

    public void EntryMain(String appXmlPath, String appRootDir, String extraArgs, String runtimePackageName, Object mainView, Object app, Object appInfo, Object context, Object activityWrapper, boolean isADL, boolean isDebuggerMode) {
        s_context = (Context) context;
        s_packageName = ((ApplicationInfo) appInfo).packageName;
        if (!mCallEntryMain) {
            mCallEntryMain = true;
            if (appRootDir.length() > 0 && appXmlPath.length() > 0) {
                EntryMainWrapper(appXmlPath, appRootDir, extraArgs, runtimePackageName, mainView, app, context, activityWrapper, isADL, isDebuggerMode);
            }
        }
    }

    public String GetLibCorePath() {
        if (mLibCorePath == null) {
            mLibCorePath = Utils.GetLibCorePath(s_context);
        }
        return mLibCorePath;
    }

    public boolean EntryDownloadConfig(Object context, String runtimePackageName) {
        s_context = (Context) context;
        ApplicationInfo appInfo = s_context.getApplicationInfo();
        s_packageName = appInfo.packageName;
        ApplicationFileManager.setAndroidPackageName(s_packageName);
        ApplicationFileManager.setAndroidAPKPath(appInfo.sourceDir);
        File cacheDir = s_context.getCacheDir();
        if (cacheDir == null) {
            return false;
        }
        ApplicationFileManager.processAndroidDataPath(cacheDir.getAbsolutePath());
        System.load(Utils.GetLibSTLPath(s_context));
        System.load(GetLibCorePath());
        EntryDownloadConfigNative(context, runtimePackageName);
        return true;
    }

    public void EntryApplyDownloadedConfig() {
        applyDownloadedConfig();
    }

    public void EntryStopRuntime() {
        System.load(GetLibCorePath());
        EntryStopRuntimeNative();
    }

    public void setMainView(View mainView) {
        setMainViewOnCreate((AIRWindowSurfaceView) mainView);
    }

    public static String getPackageName() {
        return s_packageName;
    }

    public static String getAppCacheDirectory() {
        return s_context.getCacheDir().getAbsolutePath();
    }

    public static String getRuntimeDataDirectory() {
        return s_context.getApplicationInfo().dataDir + "/";
    }
}
