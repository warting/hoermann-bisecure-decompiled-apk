package com.adobe.air;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences.Editor;
import android.os.Build.VERSION;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.webkit.WebBackForwardList;

public class AdobeAIR extends Activity {
    private static final String PROPERTY_INITIAL_LAUNCH = "initialLaunch";
    private static final String TAG = "Adobe AIR";
    public String DYNAMIC_URL = "https://www.adobe.com/airgames/5/";
    private Context mCtx = null;
    private AdobeAIRWebView mGameListingWebView = null;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.mCtx = this;
        if (isInitialLaunch()) {
            this.DYNAMIC_URL = AdobeAIRWebView.DYNAMIC_URL_CLOUDFRONT;
            updateSharedPrefForInitialLaunch();
        }
        this.mGameListingWebView = new AdobeAIRWebView(this.mCtx);
        this.mGameListingWebView.create();
        this.mGameListingWebView.loadUrl(this.DYNAMIC_URL);
        onNewIntent(getIntent());
    }

    private boolean isInitialLaunch() {
        return PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).getBoolean(PROPERTY_INITIAL_LAUNCH, true);
    }

    private void updateSharedPrefForInitialLaunch() {
        Editor editor = PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).edit();
        editor.putBoolean(PROPERTY_INITIAL_LAUNCH, false);
        editor.commit();
    }

    public void onResume() {
        super.onResume();
        if (this.mGameListingWebView.isOffline()) {
            this.mGameListingWebView.setOffline(false);
            this.mGameListingWebView.loadUrl(this.DYNAMIC_URL);
        }
    }

    public void onBackPressed() {
        if (VERSION.SDK_INT >= 12 && this.mGameListingWebView.canGoBack()) {
            boolean gotoPrevHistItem = true;
            WebBackForwardList history = this.mGameListingWebView.copyBackForwardList();
            int curIndex = history.getCurrentIndex();
            if (curIndex > 0) {
                if (this.DYNAMIC_URL.equals(history.getItemAtIndex(curIndex - 1).getUrl())) {
                    gotoPrevHistItem = false;
                }
            }
            if (gotoPrevHistItem) {
                this.mGameListingWebView.goBack();
                return;
            }
        }
        super.onBackPressed();
    }
}
