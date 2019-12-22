package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.DialogInterface.OnKeyListener;
import android.os.Bundle;
import android.view.KeyEvent;
import com.adobe.air.AndroidLocale.STRING_ID;

public class AIRUpdateDialog extends Activity {
    private static String AIR_PING_URL = "https://airdownload2.adobe.com/air?";
    private static AIRUpdateDialog sThis = null;
    private final String LOG_TAG = "AIRUpdateDialog";
    private final String RUNTIME_PACKAGE_ID = BuildConfig.APPLICATION_ID;
    private AndroidActivityWrapper actWrapper;
    private AlertDialog alertDialog = null;

    /* renamed from: com.adobe.air.AIRUpdateDialog$1 */
    class C00121 implements OnClickListener {
        C00121() {
        }

        public void onClick(DialogInterface dialog, int which) {
            AIRUpdateDialog.this.actWrapper.LaunchMarketPlaceForAIR(AIRUpdateDialog.this.getIntent().getStringExtra("airDownloadURL"));
            InstallOfferPingUtils.PingAndExit(AIRUpdateDialog.sThis, AIRUpdateDialog.AIR_PING_URL, true, true, false);
        }
    }

    /* renamed from: com.adobe.air.AIRUpdateDialog$2 */
    class C00132 implements OnKeyListener {
        C00132() {
        }

        public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
            if (keyCode != 4 && keyCode != 84) {
                return false;
            }
            dialog.cancel();
            InstallOfferPingUtils.PingAndExit(AIRUpdateDialog.sThis, AIRUpdateDialog.AIR_PING_URL, false, true, false);
            return true;
        }
    }

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sThis = this;
        this.actWrapper = AndroidActivityWrapper.CreateAndroidActivityWrapper(this, Boolean.valueOf(false));
        this.alertDialog = new Builder(this).setTitle(AndroidConstants.ADOBE_AIR).setMessage(AndroidLocale.GetLocalizedString(STRING_ID.IDA_RUNTIME_UPDATE_MESSAGE)).create();
        this.alertDialog.setButton(-1, AndroidLocale.GetLocalizedString(STRING_ID.IDA_UPDATE), new C00121());
        this.alertDialog.setOnKeyListener(new C00132());
        this.alertDialog.setCancelable(true);
        this.alertDialog.show();
    }

    public void onPause() {
        if (this.alertDialog != null) {
            this.alertDialog.cancel();
            this.alertDialog = null;
            finish();
        }
        super.onPause();
    }

    public void onStop() {
        if (this.alertDialog != null) {
            this.alertDialog.cancel();
            this.alertDialog = null;
            finish();
        }
        super.onStop();
    }
}
