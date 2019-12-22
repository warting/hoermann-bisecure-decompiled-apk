package com.adobe.air;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.view.Window;
import android.view.WindowManager.LayoutParams;

public class AndroidAlertDialog {
    private static final String LOG_TAG = "AndroidAlertDialog";
    private AlertDialog mAlertDialog = null;
    private Builder mDialogBuilder = null;

    public AndroidAlertDialog(Context context) {
        this.mDialogBuilder = new Builder(context);
    }

    public Builder GetAlertDialogBuilder() {
        return this.mDialogBuilder;
    }

    public void show() {
        this.mAlertDialog = this.mDialogBuilder.create();
        this.mAlertDialog.setCanceledOnTouchOutside(false);
        this.mAlertDialog.show();
    }

    public void dismiss() {
        if (this.mAlertDialog != null) {
            this.mAlertDialog.dismiss();
        }
    }

    public Window getWindow() {
        if (this.mAlertDialog != null) {
            return this.mAlertDialog.getWindow();
        }
        return null;
    }

    public void setFullScreen() {
        if (this.mAlertDialog != null) {
            LayoutParams lp = new LayoutParams();
            Window window = getWindow();
            if (window != null) {
                lp.copyFrom(window.getAttributes());
                lp.width = -1;
                lp.height = -2;
                window.setAttributes(lp);
            }
        }
    }
}
