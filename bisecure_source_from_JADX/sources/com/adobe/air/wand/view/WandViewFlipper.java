package com.adobe.air.wand.view;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ViewFlipper;
import com.adobe.air.R;
import com.adobe.air.wand.view.WandView.Listener;
import com.adobe.air.wand.view.WandView.ScreenOrientation;

public class WandViewFlipper extends ViewFlipper implements WandView {
    private static final String ACTIVE_WIFI_ASSIST_MESSAGE = "Enter this PIN in the desktop game and press 'Connect'";
    private static final String DEFAULT_VIEW_FONT_ASSET = "AdobeClean-Light.ttf";
    private static final String INACTIVE_WIFI_ASSIST_MESSAGE = "Connect this device to WiFi to get the pairing PIN";
    private static final String LOG_TAG = "WandViewFlipper";
    private static final String PIN_TITLE = "PIN : ";
    private static final String TITLE_DESCRIPTION_STRING = "Use this device as a Wireless Gamepad";
    private CompanionView mCompanionView = null;
    private View mCompanionViewHolder = null;
    private int mCurrentViewIndex = 0;
    private View mDefaultView = null;
    private Listener mListener = null;
    private TouchSensor mTouchSensor = null;

    /* renamed from: com.adobe.air.wand.view.WandViewFlipper$2 */
    class C00792 implements Runnable {
        C00792() {
        }

        public void run() {
            boolean z = false;
            ((ImageView) WandViewFlipper.this.mCompanionViewHolder.findViewById(R.id.skin)).setImageResource(R.color.transparent);
            WandViewFlipper.this.mCurrentViewIndex = 0;
            String token = "";
            if (WandViewFlipper.this.mListener != null) {
                token = WandViewFlipper.this.mListener.getConnectionToken();
            }
            if (!token.equals("")) {
                token = WandViewFlipper.getTokenString(token);
            }
            ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_string)).setText(token);
            TextView tokenDesc = (TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_desc);
            if (!WandViewFlipper.this.mListener.getConnectionToken().equals("")) {
                z = true;
            }
            tokenDesc.setText(WandViewFlipper.getTokenDesc(z));
            WandViewFlipper.this.setDisplayedChild(WandViewFlipper.this.mCurrentViewIndex);
        }
    }

    /* renamed from: com.adobe.air.wand.view.WandViewFlipper$3 */
    class C00803 implements Runnable {
        C00803() {
        }

        public void run() {
            WandViewFlipper.this.setDisplayedChild(WandViewFlipper.this.mCurrentViewIndex);
            try {
                if (WandViewFlipper.this.mListener != null) {
                    WandViewFlipper.this.mListener.onLoadCompanion(((Activity) WandViewFlipper.this.getContext()).getResources().getConfiguration());
                }
            } catch (Exception e) {
            }
        }
    }

    public WandViewFlipper(Context context) {
        super(context);
        initView(context);
    }

    public WandViewFlipper(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView(context);
    }

    private void initView(Context context) {
        this.mListener = null;
        try {
            setKeepScreenOn(true);
            LayoutInflater inflater = LayoutInflater.from(context);
            this.mDefaultView = inflater.inflate(R.layout.wand_default, null);
            this.mCompanionViewHolder = inflater.inflate(R.layout.wand_companion, null);
            this.mDefaultView.getBackground().setDither(true);
            TextView title = (TextView) this.mDefaultView.findViewById(R.id.title_string);
            Typeface font = Typeface.createFromAsset(context.getAssets(), DEFAULT_VIEW_FONT_ASSET);
            title.setTypeface(font);
            ((TextView) this.mDefaultView.findViewById(R.id.token_string)).setTypeface(font);
            ((TextView) this.mDefaultView.findViewById(R.id.token_desc)).setTypeface(font);
            TextView titleDesc = (TextView) this.mDefaultView.findViewById(R.id.title_desc);
            titleDesc.setTypeface(font);
            titleDesc.setText(TITLE_DESCRIPTION_STRING);
            addView(this.mDefaultView, 0);
            addView(this.mCompanionViewHolder, 1);
            this.mCompanionView = (CompanionView) this.mCompanionViewHolder.findViewById(R.id.companion_view);
            this.mTouchSensor = this.mCompanionView.getTouchSensor();
            this.mCurrentViewIndex = 0;
        } catch (Exception e) {
        }
    }

    public void setScreenOrientation(ScreenOrientation companionOrientation) throws Exception {
        int screenOrientation;
        switch (companionOrientation) {
            case LANDSCAPE:
                screenOrientation = 0;
                break;
            case PORTRAIT:
                screenOrientation = 1;
                break;
            case REVERSE_PORTRAIT:
                screenOrientation = 9;
                break;
            case REVERSE_LANDSCAPE:
                screenOrientation = 8;
                break;
            default:
                screenOrientation = -1;
                break;
        }
        Activity wandActivity = (Activity) getContext();
        if (wandActivity == null) {
            throw new IllegalArgumentException("Wand cannot find activity while loading companion.");
        }
        wandActivity.setRequestedOrientation(screenOrientation);
    }

    public void drawImage(Bitmap image) throws Exception {
        if (this.mCurrentViewIndex == 0) {
            throw new Exception("Companion view is not yet loaded.");
        }
        final ImageView skinView = (ImageView) this.mCompanionViewHolder.findViewById(R.id.skin);
        Bitmap tImage = Bitmap.createScaledBitmap(image, skinView.getWidth(), (image.getHeight() * skinView.getWidth()) / image.getWidth(), true);
        if (tImage != image) {
            image.recycle();
        }
        image = tImage;
        int skinHeight = skinView.getHeight();
        int scaledHeight = image.getHeight();
        if (scaledHeight > skinHeight) {
            tImage = Bitmap.createBitmap(image, 0, scaledHeight - skinHeight, skinView.getWidth(), skinView.getHeight());
            if (tImage != image) {
                image.recycle();
            }
            image = tImage;
        }
        final Bitmap scaledImage = image;
        ((Activity) getContext()).runOnUiThread(new Runnable() {
            public void run() {
                skinView.setImageBitmap(scaledImage);
            }
        });
    }

    private static String getTokenString(String token) {
        return PIN_TITLE + token;
    }

    private static String getTokenDesc(boolean wifiAvailable) {
        if (wifiAvailable) {
            return ACTIVE_WIFI_ASSIST_MESSAGE;
        }
        return INACTIVE_WIFI_ASSIST_MESSAGE;
    }

    public void loadDefaultView() throws Exception {
        ((Activity) getContext()).runOnUiThread(new C00792());
    }

    public void loadCompanionView() throws Exception {
        if (this.mCurrentViewIndex != 1) {
            this.mCurrentViewIndex = 1;
            ((Activity) getContext()).runOnUiThread(new C00803());
        }
    }

    public void registerListener(Listener listener) throws Exception {
        if (this.mListener != null) {
            throw new Exception("View listener is already registered");
        } else if (listener == null) {
            throw new Exception("Invalid view listener");
        } else {
            this.mListener = listener;
        }
    }

    public void unregisterListener() {
        this.mListener = null;
    }

    public void updateConnectionToken(final String connectionToken) {
        if (this.mCurrentViewIndex != 1) {
            ((Activity) getContext()).runOnUiThread(new Runnable() {
                public void run() {
                    String token = "";
                    if (!connectionToken.equals("")) {
                        token = WandViewFlipper.getTokenString(connectionToken);
                    }
                    ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_string)).setText(token);
                    ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_desc)).setText(WandViewFlipper.getTokenDesc(!connectionToken.equals("")));
                }
            });
        }
    }

    public TouchSensor getTouchSensor() {
        return this.mTouchSensor;
    }
}
