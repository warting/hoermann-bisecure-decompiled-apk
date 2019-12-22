package com.adobe.air;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;

public class StaticPageActivity extends Activity {
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_static_page);
        WebView view = (WebView) findViewById(R.id.adview);
        view.getSettings().setSupportZoom(true);
        view.getSettings().setJavaScriptEnabled(true);
        view.getSettings().setLayoutAlgorithm(LayoutAlgorithm.NORMAL);
        view.getSettings().setLoadWithOverviewMode(true);
        view.getSettings().setUseWideViewPort(true);
        view.setVerticalScrollBarEnabled(false);
        view.loadUrl("file:///android_asset/index.html");
    }
}
