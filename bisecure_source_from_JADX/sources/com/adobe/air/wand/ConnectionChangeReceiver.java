package com.adobe.air.wand;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.adobe.air.wand.connection.Connection;

public class ConnectionChangeReceiver extends BroadcastReceiver {
    private static Connection mWandConn = null;

    public static void resisterWandConnection(Connection conn) {
        mWandConn = conn;
    }

    public static void unresisterWandConnection() {
        mWandConn = null;
    }

    public void onReceive(Context context, Intent intent) {
        if (mWandConn != null) {
            mWandConn.onConnectionChanged();
        }
    }
}
