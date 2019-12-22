package com.adobe.air;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class FileChooserBroadcastReceiver extends BroadcastReceiver {
    public static final String TAG = FileChooserBroadcastReceiver.class.toString();

    public static native void SetFilename(String str);

    public void onReceive(Context context, Intent intent) {
        if (intent.getExtras() == null) {
        }
    }
}
