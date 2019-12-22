package com.adobe.air.utils;

import android.util.Log;

public class AIRLogger {
    static boolean g_enableReleaseLogging = false;
    private static String mflag = (Utils.GetExternalStorageDirectory() + "/.AIR/enable_logging");

    public static void Enable(boolean enable) {
        g_enableReleaseLogging = enable;
        Log.v("Release Logging: ", "enabled = " + g_enableReleaseLogging);
    }

    public static boolean isEnabled() {
        return g_enableReleaseLogging;
    }

    /* renamed from: d */
    public static int m1d(String tag, String msg, Throwable tr) {
        return g_enableReleaseLogging ? Log.d(tag, msg, tr) : 0;
    }

    /* renamed from: d */
    public static int m0d(String tag, String msg) {
        return g_enableReleaseLogging ? Log.d(tag, msg) : 0;
    }

    /* renamed from: e */
    public static int m2e(String tag, String msg) {
        return g_enableReleaseLogging ? Log.e(tag, msg) : 0;
    }

    /* renamed from: e */
    public static int m3e(String tag, String msg, Throwable tr) {
        return g_enableReleaseLogging ? Log.e(tag, msg, tr) : 0;
    }

    /* renamed from: i */
    public static int m5i(String tag, String msg, Throwable tr) {
        return g_enableReleaseLogging ? Log.i(tag, msg, tr) : 0;
    }

    /* renamed from: i */
    public static int m4i(String tag, String msg) {
        return g_enableReleaseLogging ? Log.i(tag, msg) : 0;
    }

    /* renamed from: v */
    public static int m7v(String tag, String msg, Throwable tr) {
        return g_enableReleaseLogging ? Log.v(tag, msg, tr) : 0;
    }

    /* renamed from: v */
    public static int m6v(String tag, String msg) {
        return g_enableReleaseLogging ? Log.v(tag, msg) : 0;
    }

    /* renamed from: w */
    public static int m8w(String tag, String msg) {
        return g_enableReleaseLogging ? Log.w(tag, msg) : 0;
    }

    /* renamed from: w */
    public static int m10w(String tag, Throwable tr) {
        return g_enableReleaseLogging ? Log.w(tag, tr) : 0;
    }

    /* renamed from: w */
    public static int m9w(String tag, String msg, Throwable tr) {
        return g_enableReleaseLogging ? Log.w(tag, msg, tr) : 0;
    }

    public static int println(int priority, String tag, String msg) {
        return g_enableReleaseLogging ? Log.println(priority, tag, msg) : 0;
    }

    public static boolean isLoggable(String tag, int level) {
        return g_enableReleaseLogging ? Log.isLoggable(tag, level) : false;
    }
}
