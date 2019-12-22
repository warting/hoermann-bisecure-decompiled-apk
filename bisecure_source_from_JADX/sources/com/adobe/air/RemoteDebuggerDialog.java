package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.adobe.air.AndroidLocale.STRING_ID;

public final class RemoteDebuggerDialog {
    private final Activity mActivity;

    /* renamed from: com.adobe.air.RemoteDebuggerDialog$2 */
    class C00532 implements OnClickListener {
        C00532() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
            RemoteDebuggerDialog.this.gotResultFromDialog(false, null);
        }
    }

    /* renamed from: com.adobe.air.RemoteDebuggerDialog$3 */
    class C00543 implements OnCancelListener {
        C00543() {
        }

        public void onCancel(DialogInterface dialog) {
            RemoteDebuggerDialog.this.gotResultFromDialog(false, null);
        }
    }

    RemoteDebuggerDialog(Activity act) {
        this.mActivity = act;
    }

    public void createAndShowDialog(String hostOrIPaddress) {
        LinearLayout pLayout = new LinearLayout(this.mActivity);
        pLayout.setLayoutParams(new LayoutParams(-1, -1));
        pLayout.setOrientation(1);
        TextView pText = new TextView(this.mActivity);
        String helpString = "";
        if (hostOrIPaddress.length() > 0) {
            helpString = AndroidLocale.GetLocalizedString(STRING_ID.IDA_DEBUGGER_ERROR_MESSAGE).replaceFirst("%1", hostOrIPaddress) + "\n";
        }
        pText.setText(helpString + AndroidLocale.GetLocalizedString(STRING_ID.IDA_DEBUGGER_ENTERIP_MESSAGE));
        pText.setLayoutParams(new LayoutParams(-1, -1));
        pText.setPadding(20, 20, 20, 20);
        final EditText pTextinput = new EditText(this.mActivity);
        pTextinput.setLayoutParams(new LayoutParams(-1, -1));
        pTextinput.setHeight(30);
        pTextinput.setWidth(25);
        pLayout.addView(pText);
        pLayout.addView(pTextinput);
        Builder mInputDialog = new Builder(this.mActivity);
        mInputDialog.setView(pLayout);
        mInputDialog.setTitle(AndroidConstants.ADOBE_AIR);
        mInputDialog.setPositiveButton(AndroidLocale.GetLocalizedString(STRING_ID.IDA_OK), new OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                RemoteDebuggerDialog.this.gotResultFromDialog(true, pTextinput.getText().toString());
            }
        });
        mInputDialog.setNegativeButton(AndroidLocale.GetLocalizedString(STRING_ID.IDA_CANCEL), new C00532());
        mInputDialog.setOnCancelListener(new C00543());
        mInputDialog.show();
    }

    public void gotResultFromDialog(boolean button, String ipOrHost) {
        AndroidActivityWrapper.GetAndroidActivityWrapper().gotResultFromDialog(button, ipOrHost);
    }
}
