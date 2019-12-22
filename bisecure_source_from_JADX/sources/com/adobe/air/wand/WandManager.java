package com.adobe.air.wand;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.os.Vibrator;
import android.view.Display;
import android.view.WindowManager;
import com.adobe.air.wand.connection.Connection;
import com.adobe.air.wand.connection.Connection.Listener;
import com.adobe.air.wand.message.MessageManager;
import com.adobe.air.wand.message.json.JSONMessageManager;
import com.adobe.air.wand.motionsensor.Accelerometer;
import com.adobe.air.wand.motionsensor.Gyroscope;
import com.adobe.air.wand.motionsensor.Magnetometer;
import com.adobe.air.wand.view.TouchSensor;
import com.adobe.air.wand.view.WandView;
import com.adobe.air.wand.view.WandView.ScreenOrientation;

public class WandManager {
    private static final String LOG_TAG = "WandManager";
    private Accelerometer mAccelerometer = null;
    private Display mDisplay = null;
    private Gyroscope mGyroscope = null;
    private boolean mHasFocus = false;
    private boolean mIsDisposed = false;
    private boolean mListenToConfigChange = false;
    private Magnetometer mMagnetometer = null;
    private MessageManager mMessageManager = null;
    private String mProtocolVersion = null;
    private TaskManager mTaskManager = null;
    private TouchSensor mTouchSensor = null;
    private Vibrator mVibrator = null;
    private Connection mWandConnection = null;
    private WandView mWandView = null;

    private class ConnectionListener implements Listener {
        private ConnectionListener() {
        }

        public void onConnectionOpen(String protocolVersion) {
            try {
                WandManager.this.mProtocolVersion = protocolVersion;
                WandManager.this.mWandView.setScreenOrientation(ScreenOrientation.LANDSCAPE);
                WandManager.this.mWandView.loadCompanionView();
            } catch (Throwable th) {
            }
        }

        public void onConnectionClose() {
            try {
                WandManager.this.mProtocolVersion = null;
                WandManager.this.loadDefaultView();
            } catch (Throwable th) {
            }
        }

        public void onConnectSuccess() {
        }

        public void onConnectError() {
        }

        public void onDisconnectSuccess() {
        }

        public void onDisconnectError() {
        }

        public void onReceive(String message) {
            WandManager.this.mTaskManager.handleRemoteMessage(message);
        }

        public void updateConnectionToken(String connectionToken) {
            WandManager.this.mWandView.updateConnectionToken(connectionToken);
        }
    }

    private class TaskListener implements TaskManager.Listener {
        private TaskListener() {
        }

        public void sendConnectionMessage(String message) throws Exception {
            WandManager.this.mWandConnection.send(message);
        }

        public void setScreenOrientation(ScreenOrientation orientation) throws Exception {
            WandManager.this.mWandView.setScreenOrientation(orientation);
        }

        public void drawImage(Bitmap image) throws Exception {
            WandManager.this.mWandView.drawImage(image);
        }

        public String getRequestedProtocolVerison() throws Exception {
            if (WandManager.this.mProtocolVersion != null) {
                return WandManager.this.mProtocolVersion;
            }
            throw new Exception("No active connection.");
        }
    }

    private class ViewListener implements WandView.Listener {
        private ViewListener() {
        }

        public String getConnectionToken() {
            try {
                return WandManager.this.mWandConnection.getConnectionToken();
            } catch (Exception e) {
                return "";
            }
        }

        public void onLoadCompanion(Configuration currentConfiguration) throws Exception {
            if (currentConfiguration.orientation == 2) {
                WandManager.this.mWandConnection.onReadyForConnection();
            } else {
                WandManager.this.mListenToConfigChange = true;
            }
        }
    }

    public WandManager(Activity activity, WandView wandView, Connection wandConnection) throws Exception {
        ConnectionChangeReceiver.resisterWandConnection(wandConnection);
        this.mWandConnection = wandConnection;
        this.mWandConnection.registerListener(new ConnectionListener());
        this.mWandView = wandView;
        this.mWandView.registerListener(new ViewListener());
        this.mMessageManager = new JSONMessageManager();
        this.mTouchSensor = wandView.getTouchSensor();
        this.mAccelerometer = new Accelerometer(activity);
        this.mMagnetometer = new Magnetometer(activity);
        this.mGyroscope = new Gyroscope(activity);
        Context wandContext = activity;
        if (activity == null) {
            throw new Exception("Cannot find application context while initializing.");
        }
        this.mVibrator = (Vibrator) wandContext.getSystemService("vibrator");
        this.mDisplay = ((WindowManager) wandContext.getSystemService("window")).getDefaultDisplay();
        this.mTaskManager = new TaskManager(this.mMessageManager, this.mDisplay, this.mTouchSensor, this.mAccelerometer, this.mMagnetometer, this.mGyroscope, this.mVibrator);
        this.mTaskManager.registerListener(new TaskListener());
    }

    public void focus(boolean hasFocus) throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("WandManager has been disposed");
        }
        if (hasFocus) {
            setDefaultOrientation();
            this.mWandConnection.connect();
        } else {
            loadDefaultView();
            this.mWandConnection.disconnect();
        }
        this.mHasFocus = hasFocus;
    }

    public boolean hasFocus() {
        return this.mHasFocus;
    }

    public void onConfigurationChanged(Configuration config) throws Exception {
        if (this.mListenToConfigChange && config.orientation == 2) {
            this.mListenToConfigChange = false;
            this.mWandConnection.onReadyForConnection();
        }
    }

    private void loadDefaultView() throws Exception {
        try {
            this.mAccelerometer.stop();
            this.mTaskManager.terminateRunningTasks();
            setDefaultOrientation();
            this.mWandView.loadDefaultView();
        } catch (Exception e) {
            throw e;
        }
    }

    private void setDefaultOrientation() throws Exception {
        this.mWandView.setScreenOrientation(ScreenOrientation.INHERIT);
    }

    public void dispose() {
        this.mIsDisposed = true;
        this.mTaskManager.terminateRunningTasks();
        this.mTaskManager.unregisterListener();
        this.mTaskManager = null;
        this.mWandView.unregisterListener();
        this.mWandView = null;
        this.mAccelerometer.dispose();
        this.mAccelerometer = null;
        this.mDisplay = null;
        this.mMessageManager = null;
        this.mTouchSensor = null;
        this.mVibrator = null;
        this.mWandConnection.unregisterListener();
        this.mWandConnection = null;
        ConnectionChangeReceiver.unresisterWandConnection();
    }
}
