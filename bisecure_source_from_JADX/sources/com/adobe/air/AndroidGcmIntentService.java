package com.adobe.air;

import android.app.IntentService;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.NotificationCompat.Builder;
import com.adobe.air.wand.message.MessageManager;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

public class AndroidGcmIntentService extends IntentService {
    private static final String CLOUDFRONT = "cloudfront";
    private static final String GAMESPACE = "gamespace";
    private static final String GAME_URL = "gameUrl";
    private static final String MSG_ID = "msgId";
    private static final String PROPERTY_NOTIFICATION_TIMESTAMP = "notficationTimestamp";
    private static final String TAG = "AndroidGcmIntentService";
    private static int sUniqueId = 0;
    private String mGameDesc = null;
    private String mGameIconUrl = null;
    private String mGameTitle = null;
    private String mGameUrl = null;
    private String mGameUrlPrefix = null;
    private String mHost = null;
    private String mMsgId = null;

    public AndroidGcmIntentService() {
        super(TAG);
    }

    protected void onHandleIntent(Intent intent) {
        String message = "";
        Bundle extras = intent.getExtras();
        if (extras != null && extras.containsKey(MessageManager.NAME_ERROR_MESSAGE)) {
            message = extras.getString(MessageManager.NAME_ERROR_MESSAGE);
        }
        if (!message.isEmpty()) {
            if ("gcm".equals(GoogleCloudMessaging.getInstance(this).getMessageType(intent))) {
                handleNotification(message);
            }
        }
        AndroidGcmBroadcastReceiver.completeWakefulIntent(intent);
    }

    private void handleNotification(String message) {
        if (isNotificationValid()) {
            try {
                JSONObject obj = new JSONObject(message);
                this.mGameTitle = obj.getString("gameTitle");
                this.mGameDesc = obj.getString("gameDesc");
                this.mGameIconUrl = obj.getString("gameIconUrl");
                this.mGameUrl = obj.getString(GAME_URL);
                this.mGameUrlPrefix = obj.getString("gameUrlPrefix");
                this.mMsgId = obj.getString(MSG_ID);
                if (this.mGameTitle != null && this.mGameDesc != null && this.mGameIconUrl != null && this.mGameUrl != null && this.mGameUrlPrefix != null && this.mMsgId != null) {
                    if (this.mGameUrlPrefix.equals(GAMESPACE)) {
                        this.mHost = "http://gamespace.adobe.com";
                    } else if (this.mGameUrlPrefix.equals(CLOUDFRONT)) {
                        this.mHost = "https://dh8vjmvwgc27o.cloudfront.net";
                    }
                    this.mGameUrl = this.mHost + "/" + this.mGameUrl;
                    this.mGameIconUrl = this.mHost + "/" + this.mGameIconUrl;
                    sendNotification();
                }
            } catch (Exception e) {
            }
        }
    }

    private void sendNotification() {
        Intent notificationIntent = new Intent(this, AdobeAIRMainActivity.class);
        notificationIntent.putExtra(GAME_URL, this.mGameUrl);
        notificationIntent.putExtra(MSG_ID, this.mMsgId);
        notificationIntent.setFlags(603979776);
        int i = sUniqueId + 1;
        sUniqueId = i;
        PendingIntent intent = PendingIntent.getActivity(this, i, notificationIntent, 1073741824);
        Builder mBuilder = new Builder(this);
        mBuilder.setSmallIcon(R.drawable.icon);
        mBuilder.setContentTitle(this.mGameTitle);
        mBuilder.setContentText(this.mGameDesc);
        mBuilder.setContentIntent(intent);
        mBuilder.setAutoCancel(true);
        Bitmap bitmap = getBitmapFromURL(this.mGameIconUrl);
        if (bitmap != null) {
            mBuilder.setLargeIcon(bitmap);
        }
        ((NotificationManager) getSystemService("notification")).notify(sUniqueId, mBuilder.build());
    }

    private boolean isNotificationValid() {
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        long oldTime = prefs.getLong(PROPERTY_NOTIFICATION_TIMESTAMP, Long.MIN_VALUE);
        long currentTime = System.currentTimeMillis();
        if (oldTime != Long.MIN_VALUE && currentTime - oldTime <= AdobeAIRMainActivity.RATE_LIMIT) {
            return false;
        }
        Editor editor = prefs.edit();
        editor.putLong(PROPERTY_NOTIFICATION_TIMESTAMP, currentTime);
        editor.commit();
        return true;
    }

    private Bitmap getBitmapFromURL(String src) {
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(src).openConnection();
            connection.setDoInput(true);
            connection.connect();
            return BitmapFactory.decodeStream(connection.getInputStream());
        } catch (Exception e) {
            return null;
        }
    }
}
