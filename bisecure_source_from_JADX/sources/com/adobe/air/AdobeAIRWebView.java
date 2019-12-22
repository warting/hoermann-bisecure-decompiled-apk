package com.adobe.air;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.webkit.WebBackForwardList;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class AdobeAIRWebView {
    public static final String ADOBE_GAME_SHOWCASE = "gaming.adobe.com";
    public static final String ADOBE_HOST = "www.adobe.com";
    public static final String CLOUDFRONT_HOST = "dh8vjmvwgc27o.cloudfront.net";
    public static final String DYNAMIC_URL_CLOUDFRONT = "https://www.adobe.com/airgames/4/";
    public static final String GAMESPACE_HOST = "gamespace.adobe.com";
    public static final String GOOGLE_PLAY_HOST = "play.google.com";
    public static final String STATIC_URL = "file:///android_res/raw/startga.html";
    private WebView mAuxWebView = null;
    private Context mCurrentContext = null;
    private boolean mFirstLoad = true;
    private WebView mHiddenWebView = null;
    private boolean mOffline = false;
    private WebView mWebView = null;

    /* renamed from: com.adobe.air.AdobeAIRWebView$1 */
    class C00191 extends WebViewClient {
        C00191() {
        }

        public boolean shouldOverrideUrlLoading(WebView webView, String url) {
            if (url != null) {
                Uri uri = Uri.parse(url);
                if (!(uri == null || uri.getScheme() == null)) {
                    boolean openInBrowser = false;
                    try {
                        if (uri.getHost() == null || !(uri.getScheme().equalsIgnoreCase("http") || uri.getScheme().equalsIgnoreCase("https"))) {
                            openInBrowser = true;
                        } else if (url.equals(AdobeAIRWebView.DYNAMIC_URL_CLOUDFRONT) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.GAMESPACE_HOST) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.CLOUDFRONT_HOST)) {
                            return false;
                        } else {
                            if (uri.getHost().equalsIgnoreCase(AdobeAIRWebView.ADOBE_HOST) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.GOOGLE_PLAY_HOST) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.ADOBE_GAME_SHOWCASE)) {
                                openInBrowser = true;
                            }
                        }
                        if (openInBrowser) {
                            ((Activity) AdobeAIRWebView.this.mCurrentContext).startActivity(new Intent("android.intent.action.VIEW", uri));
                        } else {
                            AdobeAIRWebView.this.mAuxWebView.loadUrl(url);
                        }
                    } catch (Exception e) {
                    }
                }
            }
            return true;
        }

        public void onPageFinished(WebView view, String url) {
            if (AdobeAIRWebView.this.mFirstLoad && !url.equals(AdobeAIRWebView.DYNAMIC_URL_CLOUDFRONT)) {
                AdobeAIRWebView.this.mFirstLoad = false;
                ((Activity) AdobeAIRWebView.this.mCurrentContext).setRequestedOrientation(2);
                ((Activity) AdobeAIRWebView.this.mCurrentContext).setContentView(AdobeAIRWebView.this.mWebView);
            }
        }

        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            AdobeAIRWebView.this.mOffline = true;
            AdobeAIRWebView.this.mWebView.loadUrl(AdobeAIRWebView.STATIC_URL);
        }
    }

    /* renamed from: com.adobe.air.AdobeAIRWebView$2 */
    class C00202 extends WebViewClient {
        C00202() {
        }

        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            return false;
        }
    }

    public AdobeAIRWebView(Context ctx) {
        this.mCurrentContext = ctx;
    }

    public void create() {
        WebViewClient webViewClient = new C00191();
        this.mWebView = new WebView(this.mCurrentContext);
        this.mWebView.setScrollBarStyle(0);
        this.mWebView.setWebViewClient(webViewClient);
        this.mWebView.getSettings().setJavaScriptEnabled(true);
        this.mWebView.getSettings().setBuiltInZoomControls(true);
        this.mWebView.getSettings().setDomStorageEnabled(true);
        this.mWebView.getSettings().setDatabaseEnabled(true);
        this.mWebView.getSettings().setDatabasePath(this.mCurrentContext.getApplicationContext().getFilesDir().getPath() + "/databases/");
        this.mAuxWebView = new WebView(this.mCurrentContext);
        this.mAuxWebView.getSettings().setJavaScriptEnabled(true);
        this.mAuxWebView.getSettings().setDomStorageEnabled(true);
        this.mAuxWebView.getSettings().setDatabaseEnabled(true);
        this.mAuxWebView.getSettings().setDatabasePath(this.mCurrentContext.getApplicationContext().getFilesDir().getPath() + "/databases/");
        createAnalyticsWebView();
    }

    public void createAnalyticsWebView() {
        this.mHiddenWebView = new WebView(this.mCurrentContext);
        this.mHiddenWebView.getSettings().setJavaScriptEnabled(true);
        this.mHiddenWebView.getSettings().setDomStorageEnabled(true);
        this.mHiddenWebView.getSettings().setDatabaseEnabled(true);
        try {
            this.mHiddenWebView.getSettings().setDatabasePath(this.mCurrentContext.getApplicationContext().getFilesDir().getPath() + "/databases/");
        } catch (Exception e) {
        }
        this.mHiddenWebView.setWebViewClient(new C00202());
    }

    public void loadUrl(String url) {
        this.mWebView.loadUrl(url);
    }

    public void loadAnalyticsUrl(String url) {
        this.mHiddenWebView.loadUrl(url);
    }

    public boolean canGoBack() {
        return this.mWebView.canGoBack();
    }

    public void goBack() {
        this.mWebView.goBack();
    }

    public WebBackForwardList copyBackForwardList() {
        return this.mWebView.copyBackForwardList();
    }

    public String getUrl() {
        return this.mWebView.getUrl();
    }

    public boolean isOffline() {
        return this.mOffline;
    }

    public void setOffline(boolean value) {
        this.mOffline = value;
    }
}
