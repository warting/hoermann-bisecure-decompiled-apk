package com.adobe.air.wand;

import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;
import com.adobe.air.R;
import com.adobe.air.wand.connection.WandWebSocket;
import com.adobe.air.wand.view.WandView;

public class WandActivity extends Activity {
    private static final String LOG_TAG = "WandActivity";
    private boolean mHasResumed = false;
    private WandManager mWandManager = null;
    private WandWebSocket mWandWebSocket = null;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFormat(1);
        setContentView(R.layout.wand_main);
        initialize();
    }

    private void initialize() {
        try {
            this.mWandWebSocket = new WandWebSocket(this);
            this.mWandManager = new WandManager(this, (WandView) findViewById(R.id.wandView), this.mWandWebSocket);
        } catch (Exception e) {
        }
    }

    public void onResume() {
        super.onResume();
        this.mHasResumed = true;
    }

    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (this.mHasResumed && hasFocus && this.mWandManager != null && !this.mWandManager.hasFocus()) {
            try {
                this.mWandManager.focus(true);
            } catch (Exception e) {
            }
        }
    }

    public void onPause() {
        super.onPause();
        try {
            this.mHasResumed = false;
            this.mWandManager.focus(false);
        } catch (Exception e) {
        }
    }

    public void onDestroy() {
        super.onDestroy();
        try {
            terminate();
        } catch (Exception e) {
        }
    }

    public void onConfigurationChanged(Configuration config) {
        super.onConfigurationChanged(config);
        if (this.mWandManager != null && this.mWandManager.hasFocus()) {
            try {
                this.mWandManager.onConfigurationChanged(config);
            } catch (Exception e) {
            }
        }
    }

    private void terminate() throws Exception {
        this.mWandManager.dispose();
        this.mWandManager = null;
        this.mWandWebSocket.dispose();
        this.mWandWebSocket = null;
    }
}
