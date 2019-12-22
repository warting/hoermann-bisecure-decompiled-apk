package com.adobe.air;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Picture;
import android.graphics.Rect;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build.VERSION;
import android.util.AttributeSet;
import android.util.Base64;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.SslErrorHandler;
import android.webkit.URLUtil;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebChromeClient.CustomViewCallback;
import android.webkit.WebSettings;
import android.webkit.WebSettings.PluginState;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AutoCompleteTextView;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import com.adobe.air.wand.view.CompanionView;
import java.io.UnsupportedEncodingException;

public class AndroidWebView implements StateChangeCallback {
    private static final int ERROR_OTHER = 0;
    private static final int ERROR_PROTOCOL_UNSUPPORTED = 3229;
    private static final int FOCUS_DOWN = 3;
    private static final int FOCUS_NONE = 1;
    private static final int FOCUS_UP = 2;
    private static final String LOG_TAG = "AndroidWebView";
    private AIRWindowSurfaceView mAIRSurface;
    private Rect mBounds = null;
    private Context mContext = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
    private WebViewCustomView mCustomViewHolder;
    private Rect mGlobalBounds = null;
    private long mInternalReference = 0;
    private RelativeLayout mLayout;
    private String mUrl = null;
    private AndroidWebViewImpl mView = new AndroidWebViewImpl(this.mContext);

    /* renamed from: com.adobe.air.AndroidWebView$1 */
    class C00321 extends WebChromeClient {
        private ValueCallback<Uri> mUploadMessage;

        C00321() {
        }

        public void onShowCustomView(View view, CustomViewCallback callback) {
            if (AndroidWebView.this.mCustomViewHolder == null) {
                AndroidWebView.this.mCustomViewHolder = new WebViewCustomView();
            }
            AndroidWebView.this.mCustomViewHolder.onShowCustomView(view, callback);
        }

        public void onHideCustomView() {
            if (AndroidWebView.this.mCustomViewHolder != null) {
                AndroidWebView.this.mCustomViewHolder.onHideCustomView();
            }
        }

        public void openFileChooser(ValueCallback<Uri> uploadFile) {
            if (this.mUploadMessage == null) {
                this.mUploadMessage = uploadFile;
                final AndroidActivityWrapper wrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
                wrapper.addActivityResultListener(new ActivityResultCallback() {
                    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
                        if (requestCode == 5) {
                            if (C00321.this.mUploadMessage != null) {
                                Uri result;
                                if (intent == null || resultCode != -1) {
                                    result = null;
                                } else {
                                    result = intent.getData();
                                }
                                C00321.this.mUploadMessage.onReceiveValue(result);
                                C00321.this.mUploadMessage = null;
                            }
                            wrapper.removeActivityResultListener(this);
                        }
                    }
                });
                Intent i = new Intent("android.intent.action.GET_CONTENT");
                i.addCategory("android.intent.category.OPENABLE");
                i.setType("*/*");
                wrapper.getActivity().startActivityForResult(Intent.createChooser(i, ""), 5);
            }
        }
    }

    /* renamed from: com.adobe.air.AndroidWebView$3 */
    class C00353 implements Runnable {
        C00353() {
        }

        public void run() {
            if (AndroidWebView.this.mView != null) {
                LayoutParams params = new LayoutParams(AndroidWebView.this.mGlobalBounds.width(), AndroidWebView.this.mGlobalBounds.height());
                params.leftMargin = AndroidWebView.this.mGlobalBounds.left;
                params.topMargin = AndroidWebView.this.mGlobalBounds.top;
                AndroidWebView.this.mView.setLayoutParams(params);
                AndroidWebView.this.mView.requestLayout();
            }
        }
    }

    public class AndroidWebViewImpl extends WebView {
        private int mLastFocusDirection = 0;
        private View m_focusedChildView = null;
        private boolean m_hasFocus = false;
        private boolean m_inRequestChildFocus = false;

        public AndroidWebViewImpl(Context context) {
            super(context);
        }

        public AndroidWebViewImpl(Context context, AttributeSet attrs) {
            super(context, attrs);
        }

        public AndroidWebViewImpl(Context context, AttributeSet attrs, int defStyle) {
            super(context, attrs, defStyle);
        }

        public boolean dispatchTouchEvent(MotionEvent event) {
            if (!this.m_hasFocus) {
                requestFocus();
            }
            return super.dispatchTouchEvent(event);
        }

        public void requestChildFocus(View child, View focused) {
            this.m_inRequestChildFocus = true;
            if (!this.m_hasFocus) {
                setRealFocus(true);
            }
            try {
                this.m_focusedChildView = child;
                super.requestChildFocus(child, focused);
            } finally {
                this.m_inRequestChildFocus = false;
            }
        }

        public void clearChildFocus(View child) {
            this.m_inRequestChildFocus = true;
            try {
                super.clearChildFocus(child);
            } finally {
                this.m_inRequestChildFocus = false;
            }
        }

        public void clearFocus() {
            if (this.m_focusedChildView != null) {
                this.m_focusedChildView.clearFocus();
                if (AutoCompleteTextView.class.isInstance(this.m_focusedChildView)) {
                    AndroidWebView.this.mView.removeView(this.m_focusedChildView);
                }
                this.m_focusedChildView = null;
                setRealFocus(false);
                return;
            }
            super.clearFocus();
        }

        private void setRealFocus(boolean focused) {
            super.onFocusChanged(focused, 0, new Rect());
            invalidate();
            dispatchFocusEvent(focused, 0);
        }

        public boolean isInTextEditingMode() {
            return this.m_hasFocus && !(this.m_focusedChildView == null && getChildCount() == 0);
        }

        private void dispatchFocusEvent(boolean focused, int direction) {
            if (this.m_hasFocus != focused) {
                this.m_hasFocus = focused;
                AndroidWebView webView = AndroidWebView.this;
                if (webView.mInternalReference != 0) {
                    if (AndroidWebView.this.mAIRSurface != null) {
                        AndroidWebView.this.mAIRSurface.updateFocusedStageWebView(webView, this.m_hasFocus);
                    }
                    int flashDirection = 1;
                    if ((direction & 2) == 2) {
                        flashDirection = 3;
                    } else if ((direction & 1) == 1) {
                        flashDirection = 2;
                    }
                    if (focused) {
                        webView.dispatchFocusIn(AndroidWebView.this.mInternalReference, flashDirection);
                    } else {
                        webView.dispatchFocusOut(AndroidWebView.this.mInternalReference, flashDirection);
                    }
                }
            }
        }

        protected void onFocusChanged(boolean focused, int direction, Rect previouslyFocusedRect) {
            super.onFocusChanged(focused, direction, previouslyFocusedRect);
            if (!this.m_inRequestChildFocus || this.m_focusedChildView == null || !this.m_hasFocus) {
                if (direction == 0) {
                    direction = this.mLastFocusDirection;
                }
                this.mLastFocusDirection = 0;
                dispatchFocusEvent(focused, direction);
            }
        }

        public boolean dispatchKeyEvent(KeyEvent event) {
            boolean handled = super.dispatchKeyEvent(event);
            if (!handled && event.getAction() == 0) {
                int direction = 0;
                if (event.getKeyCode() == 19) {
                    direction = 33;
                } else if (event.getKeyCode() == 20) {
                    direction = 130;
                }
                if (direction != 0) {
                    AndroidWebView webView = AndroidWebView.this;
                    this.mLastFocusDirection = direction;
                    webView.setStageFocus(direction);
                    return true;
                }
            }
            if (!handled) {
                handled = AndroidWebView.this.mAIRSurface.dispatchKeyEvent(event);
            }
            return handled;
        }
    }

    public class WebViewCustomView {
        private CustomViewCallback mCallback;
        private FrameLayout mCustomViewHolder;

        public void onShowCustomView(View view, CustomViewCallback callback) {
            if (this.mCallback != null) {
                callback.onCustomViewHidden();
                return;
            }
            this.mCallback = callback;
            View mainView = AndroidActivityWrapper.GetAndroidActivityWrapper().getView();
            mainView.setVisibility(8);
            View overlaysView = AndroidActivityWrapper.GetAndroidActivityWrapper().getOverlaysLayout(false);
            if (overlaysView != null) {
                overlaysView.setVisibility(8);
            }
            this.mCustomViewHolder = new FrameLayout(AndroidWebView.this.mContext) {
                public boolean dispatchKeyEvent(KeyEvent event) {
                    if (super.dispatchKeyEvent(event)) {
                        return true;
                    }
                    if (event.getAction() != 0 || event.getKeyCode() != 4) {
                        return false;
                    }
                    WebViewCustomView.this.onHideCustomView();
                    return true;
                }
            };
            this.mCustomViewHolder.setBackgroundColor(-16777216);
            ((ViewGroup) mainView.getParent()).addView(this.mCustomViewHolder, new FrameLayout.LayoutParams(-1, -1));
            this.mCustomViewHolder.addView(view, new FrameLayout.LayoutParams(-1, -1, 17));
            this.mCustomViewHolder.bringToFront();
            this.mCustomViewHolder.requestFocus();
        }

        public void onHideCustomView() {
            if (this.mCallback != null && this.mCustomViewHolder != null) {
                AndroidActivityWrapper.GetAndroidActivityWrapper().getView().setVisibility(0);
                View overlaysView = AndroidActivityWrapper.GetAndroidActivityWrapper().getOverlaysLayout(false);
                if (overlaysView != null) {
                    overlaysView.setVisibility(0);
                }
                ((ViewGroup) this.mCustomViewHolder.getParent()).removeView(this.mCustomViewHolder);
                this.mCustomViewHolder = null;
                this.mCallback.onCustomViewHidden();
                this.mCallback = null;
            }
        }
    }

    private native void dispatchFocusIn(long j, int i);

    private native void dispatchFocusOut(long j, int i);

    private native void dispatchLoadComplete(long j);

    private native void dispatchLoadError(long j, String str, int i);

    private native boolean dispatchLocationChange(long j);

    private native boolean dispatchLocationChanging(long j, String str);

    public AndroidWebView() {
        WebSettings settings = this.mView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setBuiltInZoomControls(true);
        settings.setNeedInitialFocus(true);
        boolean debuggingEnabled = AndroidActivityWrapper.GetAndroidActivityWrapper().getWebContentsDebuggingEnabled();
        if (debuggingEnabled && VERSION.SDK_INT >= 19) {
            AndroidWebViewImpl androidWebViewImpl = this.mView;
            AndroidWebViewImpl.setWebContentsDebuggingEnabled(debuggingEnabled);
        }
        if (VERSION.SDK_INT < 18) {
            settings.setPluginState(PluginState.ON);
        }
        if (VERSION.SDK_INT > 15) {
            settings.setAllowUniversalAccessFromFileURLs(true);
        }
        this.mView.setScrollbarFadingEnabled(true);
        this.mView.setScrollBarStyle(CompanionView.kTouchMetaStateIsPen);
        final AndroidWebView webView = this;
        this.mView.setWebChromeClient(new C00321());
        this.mView.setWebViewClient(new WebViewClient() {
            private String mLastPageStartedUrl = null;
            private boolean mNoCompleteForUrl = false;
            private String mUrl = null;

            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                this.mUrl = url;
                this.mLastPageStartedUrl = url;
            }

            public boolean shouldOverrideUrlLoading(WebView view, String overrideUrl) {
                boolean eventPrevented = webView.onLocationChanging(overrideUrl);
                this.mNoCompleteForUrl = eventPrevented;
                return eventPrevented;
            }

            public void onPageFinished(WebView view, String url) {
                if (url == null || !this.mNoCompleteForUrl) {
                    this.mUrl = url;
                    this.mNoCompleteForUrl = false;
                    webView.onLoadComplete(url);
                    return;
                }
                this.mNoCompleteForUrl = false;
            }

            public void onReceivedSslError(WebView view, final SslErrorHandler handler, final SslError error) {
                if (this.mUrl != null && error.getCertificate() != null) {
                    final String url = this.mUrl;
                    new Thread() {
                        public void run() {
                            boolean proceed = false;
                            if (error.getCertificate() != null) {
                                SSLSecurityDialog securityDialog = new SSLSecurityDialog();
                                securityDialog.show(url, error.getCertificate());
                                if (securityDialog.getUserAction().equals("session")) {
                                    proceed = true;
                                }
                            }
                            if (proceed) {
                                handler.proceed();
                            } else {
                                handler.cancel();
                            }
                        }
                    }.start();
                }
            }

            public void doUpdateVisitedHistory(WebView view, String url, boolean isReload) {
                if (this.mLastPageStartedUrl != null && this.mLastPageStartedUrl.equals(url)) {
                    webView.onLocationChange(url);
                }
            }

            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                this.mNoCompleteForUrl = true;
                if (errorCode == -10) {
                    webView.onLoadError(failingUrl, "[" + errorCode + "] " + description + ": " + failingUrl, AndroidWebView.ERROR_PROTOCOL_UNSUPPORTED);
                } else {
                    webView.onLoadError(failingUrl, "[" + errorCode + "] " + description + ": " + failingUrl, 0);
                }
            }
        });
    }

    public void enableLocalDomStorage() {
        this.mView.getSettings().setDomStorageEnabled(true);
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onActivityStateChanged(com.adobe.air.AndroidActivityWrapper.ActivityState r8) {
        /*
        r7 = this;
        r4 = android.webkit.WebView.class;
        r5 = "isPaused";
        r6 = 0;
        r6 = new java.lang.Class[r6];	 Catch:{ Exception -> 0x0057 }
        r1 = r4.getMethod(r5, r6);	 Catch:{ Exception -> 0x0057 }
        r4 = android.webkit.WebView.class;
        r5 = "onResume";
        r6 = 0;
        r6 = new java.lang.Class[r6];	 Catch:{ Exception -> 0x0057 }
        r3 = r4.getMethod(r5, r6);	 Catch:{ Exception -> 0x0057 }
        r4 = android.webkit.WebView.class;
        r5 = "onPause";
        r6 = 0;
        r6 = new java.lang.Class[r6];	 Catch:{ Exception -> 0x0057 }
        r2 = r4.getMethod(r5, r6);	 Catch:{ Exception -> 0x0057 }
        r4 = r7.mView;	 Catch:{ Exception -> 0x0057 }
        r5 = 0;
        r5 = new java.lang.Object[r5];	 Catch:{ Exception -> 0x0057 }
        r4 = r1.invoke(r4, r5);	 Catch:{ Exception -> 0x0057 }
        r4 = (java.lang.Boolean) r4;	 Catch:{ Exception -> 0x0057 }
        r0 = r4.booleanValue();	 Catch:{ Exception -> 0x0057 }
        r4 = com.adobe.air.AndroidWebView.C00364.$SwitchMap$com$adobe$air$AndroidActivityWrapper$ActivityState;	 Catch:{ Exception -> 0x0057 }
        r5 = r8.ordinal();	 Catch:{ Exception -> 0x0057 }
        r4 = r4[r5];	 Catch:{ Exception -> 0x0057 }
        switch(r4) {
            case 1: goto L_0x0047;
            case 2: goto L_0x0059;
            default: goto L_0x003b;
        };
    L_0x003b:
        r4 = com.adobe.air.AndroidWebView.C00364.$SwitchMap$com$adobe$air$AndroidActivityWrapper$ActivityState;
        r5 = r8.ordinal();
        r4 = r4[r5];
        switch(r4) {
            case 3: goto L_0x0069;
            case 4: goto L_0x0075;
            default: goto L_0x0046;
        };
    L_0x0046:
        return;
    L_0x0047:
        if (r0 == 0) goto L_0x003b;
    L_0x0049:
        r4 = r7.mView;	 Catch:{ Exception -> 0x0057 }
        r5 = 0;
        r5 = new java.lang.Object[r5];	 Catch:{ Exception -> 0x0057 }
        r3.invoke(r4, r5);	 Catch:{ Exception -> 0x0057 }
        r4 = r7.mView;	 Catch:{ Exception -> 0x0057 }
        r4.resumeTimers();	 Catch:{ Exception -> 0x0057 }
        goto L_0x003b;
    L_0x0057:
        r4 = move-exception;
        goto L_0x003b;
    L_0x0059:
        if (r0 != 0) goto L_0x003b;
    L_0x005b:
        r4 = r7.mView;	 Catch:{ Exception -> 0x0057 }
        r4.pauseTimers();	 Catch:{ Exception -> 0x0057 }
        r4 = r7.mView;	 Catch:{ Exception -> 0x0057 }
        r5 = 0;
        r5 = new java.lang.Object[r5];	 Catch:{ Exception -> 0x0057 }
        r2.invoke(r4, r5);	 Catch:{ Exception -> 0x0057 }
        goto L_0x003b;
    L_0x0069:
        r4 = r7.mCustomViewHolder;
        if (r4 != 0) goto L_0x0046;
    L_0x006d:
        r4 = new com.adobe.air.AndroidWebView$WebViewCustomView;
        r4.<init>();
        r7.mCustomViewHolder = r4;
        goto L_0x0046;
    L_0x0075:
        r4 = r7.mCustomViewHolder;
        if (r4 == 0) goto L_0x0046;
    L_0x0079:
        r4 = r7.mCustomViewHolder;
        r4.onHideCustomView();
        r4 = 0;
        r7.mCustomViewHolder = r4;
        goto L_0x0046;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidWebView.onActivityStateChanged(com.adobe.air.AndroidActivityWrapper$ActivityState):void");
    }

    public void onConfigurationChanged(Configuration config) {
    }

    public void setInternalReference(long objRef) {
        this.mInternalReference = objRef;
    }

    public void destroyInternals() {
        removedFromStage();
        this.mInternalReference = 0;
        this.mView.destroy();
        this.mView = null;
    }

    public void stop() {
        this.mView.stopLoading();
    }

    public void reload() {
        this.mView.reload();
    }

    public void setMediaPlaybackRequiresUserAction(boolean val) {
        Log.d(LOG_TAG, "Java - setting val = " + val);
        this.mView.getSettings().setMediaPlaybackRequiresUserGesture(val);
    }

    public boolean getMediaPlaybackRequiresUserAction() {
        return this.mView.getSettings().getMediaPlaybackRequiresUserGesture();
    }

    public void goBack() {
        this.mView.goBack();
    }

    public void goForward() {
        this.mView.goForward();
    }

    public boolean canGoBack() {
        return this.mView.canGoBack();
    }

    public boolean canGoForward() {
        return this.mView.canGoForward();
    }

    public void addedToStage(AIRWindowSurfaceView view) {
        if (this.mLayout != null) {
            removedFromStage();
        }
        this.mAIRSurface = view;
        AndroidActivityWrapper activityWrapper = view.getActivityWrapper();
        activityWrapper.addActivityStateChangeListner(this);
        this.mLayout = activityWrapper.getOverlaysLayout(true);
        this.mLayout.addView(this.mView, new LayoutParams(0, 0));
    }

    public void removedFromStage() {
        if (this.mLayout != null) {
            this.mLayout.removeView(this.mView);
            this.mLayout = null;
            AndroidActivityWrapper activityWrapper = this.mAIRSurface.getActivityWrapper();
            activityWrapper.didRemoveOverlay();
            activityWrapper.removeActivityStateChangeListner(this);
            this.mAIRSurface.updateFocusedStageWebView(this, false);
        }
        this.mAIRSurface = null;
    }

    public void setVisibility(boolean visible) {
        int newVisibility = visible ? 0 : 4;
        if (this.mView.getVisibility() != newVisibility) {
            this.mView.setVisibility(newVisibility);
        }
    }

    public long updateViewBoundsWithKeyboard(int windowHeight) {
        int panning = 0;
        this.mGlobalBounds = this.mBounds;
        if (this.mAIRSurface != null && isInTextEditingMode()) {
            Rect visibleBounds = new Rect(0, 0, this.mAIRSurface.getVisibleBoundWidth(), this.mAIRSurface.getVisibleBoundHeight());
            if (!visibleBounds.contains(this.mBounds)) {
                int top = Math.min(Math.max(0, this.mBounds.top), windowHeight);
                int bottom = Math.min(Math.max(0, this.mBounds.bottom), windowHeight);
                if (top == bottom) {
                    return 0;
                }
                int hiddenHeight = bottom - visibleBounds.bottom;
                if (hiddenHeight <= 0) {
                    return 0;
                }
                if (hiddenHeight <= top) {
                    panning = hiddenHeight;
                } else {
                    panning = top;
                    this.mGlobalBounds = new Rect(this.mBounds);
                    this.mGlobalBounds.bottom = visibleBounds.bottom + panning;
                }
            }
        }
        refreshGlobalBounds();
        return (long) panning;
    }

    public void resetGlobalBounds() {
        this.mGlobalBounds = this.mBounds;
        refreshGlobalBounds();
    }

    private void refreshGlobalBounds() {
        if (this.mView != null) {
            this.mView.post(new C00353());
        }
    }

    public void adjustViewBounds(double x, double y, double width, double height) {
        this.mBounds = new Rect((int) x, (int) y, (int) (x + width), (int) (y + height));
        this.mGlobalBounds = this.mBounds;
        refreshGlobalBounds();
    }

    public void loadString(String data, String mimeType) {
        boolean hasBOM = true;
        try {
            byte[] bytes = data.getBytes("utf-8");
            if (!(bytes.length >= 3 && bytes[0] == (byte) -17 && bytes[1] == (byte) -69 && bytes[2] == (byte) -65)) {
                hasBOM = false;
            }
            if (!hasBOM) {
                byte[] newBytes = new byte[(bytes.length + 3)];
                System.arraycopy(bytes, 0, newBytes, 3, bytes.length);
                newBytes[0] = (byte) -17;
                newBytes[1] = (byte) -69;
                newBytes[2] = (byte) -65;
                bytes = newBytes;
            }
            this.mView.loadData(Base64.encodeToString(bytes, 0, bytes.length, 2), "text/html", "base64");
        } catch (UnsupportedEncodingException e) {
        }
    }

    public void loadURL(String url) {
        if (url != null) {
            this.mView.loadUrl(url);
        }
    }

    public boolean onLocationChange(String url) {
        if (this.mInternalReference == 0) {
            return true;
        }
        this.mUrl = url;
        return dispatchLocationChange(this.mInternalReference);
    }

    private String decodeURL(String url) {
        try {
            return new String(URLUtil.decode(url.getBytes()));
        } catch (IllegalArgumentException e) {
            return url;
        }
    }

    public boolean onLocationChanging(String url) {
        if (this.mInternalReference == 0) {
            return true;
        }
        return dispatchLocationChanging(this.mInternalReference, decodeURL(url));
    }

    public void onLoadComplete(String url) {
        if (this.mInternalReference != 0) {
            this.mUrl = url;
            dispatchLoadComplete(this.mInternalReference);
        }
    }

    public void onLoadError(String url, String error, int errorCode) {
        if (this.mInternalReference != 0) {
            this.mUrl = url;
            dispatchLoadError(this.mInternalReference, error, errorCode);
        }
    }

    public String getCurrentLocation() {
        String url = this.mUrl;
        if (url == null) {
            return "about:blank";
        }
        return decodeURL(url);
    }

    public String getPageTitle() {
        String title = this.mView.getTitle();
        if (title == null) {
            return "";
        }
        return title;
    }

    public void assignFocus(int focusDirection) {
        switch (focusDirection) {
            case 1:
                this.mView.requestFocus();
                return;
            case 2:
                this.mView.pageUp(true);
                this.mView.requestFocus(33);
                return;
            case 3:
                this.mView.pageDown(true);
                this.mView.requestFocus(130);
                return;
            default:
                return;
        }
    }

    public void clearFocus() {
        this.mView.clearFocus();
        this.mAIRSurface.requestFocus();
    }

    public void setStageFocus(int direction) {
        this.mView.clearFocus();
        this.mAIRSurface.requestFocus(direction);
    }

    public Bitmap captureSnapshot(int width, int height) {
        Bitmap bitmap = null;
        if (width >= 0 && height >= 0 && !(width == 0 && height == 0)) {
            bitmap = Bitmap.createBitmap(width, height, Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.translate((float) (-this.mView.getScrollX()), (float) (-this.mView.getScrollY()));
            boolean isHorizontalScrollBarEnabled = this.mView.isHorizontalScrollBarEnabled();
            boolean isVerticalScrollBarEnabled = this.mView.isVerticalScrollBarEnabled();
            this.mView.setHorizontalScrollBarEnabled(false);
            this.mView.setVerticalScrollBarEnabled(false);
            try {
                this.mView.draw(canvas);
            } catch (Exception e) {
                Picture picture = this.mView.capturePicture();
                float scale = this.mView.getScale();
                canvas.scale(scale, scale);
                picture.draw(canvas);
            }
            this.mView.setHorizontalScrollBarEnabled(isHorizontalScrollBarEnabled);
            this.mView.setVerticalScrollBarEnabled(isVerticalScrollBarEnabled);
        }
        return bitmap;
    }

    public boolean isInTextEditingMode() {
        return this.mView.isInTextEditingMode();
    }
}
