package com.adobe.air;

import android.app.Activity;
import android.app.UiModeManager;

public class InstallOfferPingUtils {
    private static final String LOG_TAG = "InstallOfferPingUtils";

    private static boolean isAndroidTV(Activity activity) {
        try {
            if (((UiModeManager) activity.getSystemService("uimode")).getCurrentModeType() == 4) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    public static void PingAndExit(Activity activity, String baseUrl, boolean installClicked, boolean update, boolean exit) {
    }
}
