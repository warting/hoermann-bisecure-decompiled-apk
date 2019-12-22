package com.adobe.air;

import air.de.hoermann.A201131.C0003R;
import android.app.Activity;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.adobe.air.AndroidLocale.STRING_ID;

public final class ListenErrorDialog {
    private final int ICON_ERROR = C0003R.drawable.banner;
    private final int PADDING_LENGTH = 20;
    private final Activity mActivity;
    private final String mDebuggerPort;

    /* renamed from: com.adobe.air.ListenErrorDialog$1 */
    class C00481 implements OnClickListener {
        C00481() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
            ListenErrorDialog.this.gotResultFromDialog(false);
        }
    }

    /* renamed from: com.adobe.air.ListenErrorDialog$2 */
    class C00492 implements OnClickListener {
        C00492() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
            ListenErrorDialog.this.gotResultFromDialog(true);
        }
    }

    /* renamed from: com.adobe.air.ListenErrorDialog$3 */
    class C00503 implements OnCancelListener {
        C00503() {
        }

        public void onCancel(DialogInterface dialog) {
            ListenErrorDialog.this.gotResultFromDialog(false);
        }
    }

    ListenErrorDialog(Activity act, int debuggerPort) {
        this.mActivity = act;
        this.mDebuggerPort = Integer.toString(debuggerPort);
    }

    public void createAndShowDialog() {
        LinearLayout pLayout = new LinearLayout(this.mActivity);
        pLayout.setLayoutParams(new LayoutParams(-1, -1));
        TextView pText = new TextView(this.mActivity);
        pText.setText(AndroidLocale.GetLocalizedString(STRING_ID.IDA_DEBUGGER_LISTEN_ERROR_MESSAGE).replaceFirst("%1", this.mDebuggerPort));
        pText.setLayoutParams(new LayoutParams(-2, -1));
        pText.setPadding(20, 20, 20, 20);
        pLayout.addView(pText);
        Builder mInputDialog = new Builder(this.mActivity);
        mInputDialog.setIcon(C0003R.drawable.banner);
        mInputDialog.setView(pLayout);
        mInputDialog.setTitle(AndroidLocale.GetLocalizedString(STRING_ID.IDA_DEBUGGER_LISTEN_ERROR_TITLE));
        mInputDialog.setPositiveButton(AndroidLocale.GetLocalizedString(STRING_ID.IDA_CANCEL), new C00481());
        mInputDialog.setNegativeButton(AndroidLocale.GetLocalizedString(STRING_ID.IDA_CONTINUE), new C00492());
        mInputDialog.setOnCancelListener(new C00503());
        mInputDialog.show();
    }

    public void gotResultFromDialog(boolean ok) {
        AndroidActivityWrapper actWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        if (ok) {
            actWrapper.gotResultFromDialog(false, "");
        } else {
            exitGracefully();
        }
    }

    private void exitGracefully() {
        System.exit(0);
    }
}
