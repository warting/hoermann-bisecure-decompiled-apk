package com.adobe.air;

import android.content.Context;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageManager.NameNotFoundException;
import com.adobe.air.utils.Utils;

public final class AIRSharedPref {
    private static final String LOG_TAG = "AIRSharedPref";
    private static String SP_CONFIG_DATA = "AIRSharedPref.ConfigData";
    private static String SP_CONFIG_DATA_DEFAULT = "\n";
    private static String SP_CONFIG_REQUEST_TIME = "AIRSharedPref.ConfigRequestTime";
    private static String SP_CONFIG_REQUEST_TIME_DEFAULT = null;

    private static String getPreferencesKey() {
        return Utils.getRuntimePackageName() + ".AIRSharedPref";
    }

    public static String getConfigRequestTime(Context callerContext) {
        String time = SP_CONFIG_REQUEST_TIME_DEFAULT;
        try {
            time = callerContext.createPackageContext(Utils.getRuntimePackageName(), 4).getSharedPreferences(getPreferencesKey(), 1).getString(SP_CONFIG_REQUEST_TIME, SP_CONFIG_REQUEST_TIME_DEFAULT);
        } catch (ClassCastException e) {
        } catch (NameNotFoundException e2) {
        }
        return time != SP_CONFIG_REQUEST_TIME_DEFAULT ? time : time;
    }

    public static String getConfigData(Context callerContext) {
        String configData = SP_CONFIG_DATA_DEFAULT;
        try {
            configData = callerContext.createPackageContext(Utils.getRuntimePackageName(), 4).getSharedPreferences(getPreferencesKey(), 1).getString(SP_CONFIG_DATA, SP_CONFIG_DATA_DEFAULT);
        } catch (ClassCastException e) {
        } catch (NameNotFoundException e2) {
        }
        return configData != SP_CONFIG_DATA_DEFAULT ? configData : configData;
    }

    public static boolean setConfigRequestTime(Context callerContext, String time) {
        Editor editor = callerContext.getSharedPreferences(getPreferencesKey(), 1).edit();
        editor.putString(SP_CONFIG_REQUEST_TIME, time);
        return editor.commit();
    }

    public static boolean setConfigData(Context callerContext, String configData) {
        Editor editor = callerContext.getSharedPreferences(getPreferencesKey(), 1).edit();
        editor.putString(SP_CONFIG_DATA, configData);
        return editor.commit();
    }
}
