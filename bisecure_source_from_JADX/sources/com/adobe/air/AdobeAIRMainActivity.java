package com.adobe.air;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Build.VERSION;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.provider.Settings.Secure;
import com.adobe.air.AndroidGcmResultReceiver.Receiver;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders.AppViewBuilder;
import com.google.android.gms.analytics.Tracker;
import com.google.android.gms.common.GooglePlayServicesUtil;
import java.util.Date;
import java.util.Map.Entry;
import java.util.Random;

public class AdobeAIRMainActivity extends Activity implements Receiver {
    private static final String AIR_PROPERTIES_URL = "airPropertiesUrl";
    public static final String ENABLE_MY_GAMES = "EnableMyGames";
    private static final String MSG_ID = "msgId";
    private static final String NEW_UI_ANALYTICS_URL = "http://www.adobe.com/airgames/3/";
    private static final String NOTIFICATION_ANALYTICS_URL = "https://www.adobe.com/gamepreview/?game=notification/notificationClicked.html_";
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    public static final String PROPERTY_DEFAULT_ACTIVITY = "AIRDefaultActivity";
    private static final String PROPERTY_ENABLE_MY_GAMES_PERCENTAGE = "MyGamesPercentage";
    private static final String PROPERTY_FIRST_LAUNCH = "firstLaunch";
    private static final String PROPERTY_ID = "UA-54849355-1";
    private static final String PROPERTY_NEW_UI_PERCENTAGE = "NewUIPercentage";
    private static final String PROPERTY_RANDOM_NO = "AirRandomNumber";
    public static long RATE_LIMIT = 86400000;
    public static final String RESULT_RECEIVER = "resultReceiver";
    private static final String TAG = "AdobeAIRMainActivity";
    private String mAirPropsFileUrl = "http://s3-us-west-1.amazonaws.com/gamepreview/prod/airandroid/air.properties";
    private AdobeAIRWebView mAnalyticsWebView = null;
    private Context mCtx = null;
    private int mEnableMyGamesThreshold = 100;
    private boolean mIsGameListDefaultActivity = true;
    private boolean mIsNewUISupported = false;
    private int mNewUIThreshold = 100;
    private AdobeAIRWebView mNotificationWebView = null;
    private int mRandomNumber;
    private AndroidGcmResultReceiver mReceiver = null;
    private Tracker mTracker = null;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.mCtx = this;
        copyActivityLevelPrefsToApplicationLevel();
        verifyNewUISupport();
        Tracker t = getTracker();
        t.setScreenName(TAG);
        t.send(new AppViewBuilder().build());
        startService(new Intent(this, ShakeListenerService.class));
        startActivity(new Intent(this, StaticPageActivity.class));
    }

    private void copyActivityLevelPrefsToApplicationLevel() {
        Editor editor = PreferenceManager.getDefaultSharedPreferences(this.mCtx).edit();
        SharedPreferences sourcePrefs = getSharedPreferences(AdobeAIR.class.getSimpleName(), 0);
        for (Entry<String, ?> entry : sourcePrefs.getAll().entrySet()) {
            Object value = entry.getValue();
            if (value instanceof String) {
                editor.putString((String) entry.getKey(), value.toString());
            } else if (value instanceof Long) {
                editor.putLong((String) entry.getKey(), ((Long) value).longValue());
            } else if (value instanceof Integer) {
                editor.putInt((String) entry.getKey(), ((Integer) value).intValue());
            } else if (value instanceof Boolean) {
                editor.putBoolean((String) entry.getKey(), ((Boolean) value).booleanValue());
            }
        }
        editor.commit();
        editor = sourcePrefs.edit();
        editor.clear();
        editor.commit();
    }

    public void onNewIntent(Intent intent) {
    }

    public void onBackPressed() {
    }

    private void updateSharedPrefForDefaultActivity() {
    }

    private void verifyNewUISupport() {
        if (VERSION.SDK_INT >= 10) {
            this.mIsNewUISupported = true;
        }
    }

    private int generateRandomNumber() throws NumberFormatException {
        Random randomGen;
        String androidIdStr = Secure.getString(getApplicationContext().getContentResolver(), "android_id");
        if (androidIdStr == null) {
            randomGen = new Random();
        } else {
            randomGen = new Random(((long) androidIdStr.hashCode()) + new Date().getTime());
        }
        return randomGen.nextInt(100);
    }

    public void onReceiveResult(int resultCode, Bundle resultData) {
        GooglePlayServicesUtil.getErrorDialog(resultCode, (Activity) this.mCtx, PLAY_SERVICES_RESOLUTION_REQUEST).show();
    }

    private void configureTestEnv() {
        try {
            Bundle metadataBundle = getPackageManager().getActivityInfo(getComponentName(), 128).metaData;
            if (metadataBundle != null) {
                String fileUrl = metadataBundle.getString(AIR_PROPERTIES_URL);
                if (fileUrl != null && !fileUrl.isEmpty()) {
                    this.mAirPropsFileUrl = fileUrl;
                }
            }
        } catch (NameNotFoundException e) {
        } catch (NullPointerException e2) {
        }
    }

    private synchronized Tracker getTracker() {
        if (this.mTracker == null) {
            GoogleAnalytics analytics = GoogleAnalytics.getInstance(this);
            analytics.enableAutoActivityReports(getApplication());
            this.mTracker = analytics.newTracker(PROPERTY_ID);
        }
        return this.mTracker;
    }

    protected void onStart() {
        super.onStart();
        GoogleAnalytics.getInstance(this).reportActivityStart(this);
    }

    protected void onStop() {
        super.onStop();
        GoogleAnalytics.getInstance(this).reportActivityStop(this);
    }
}
