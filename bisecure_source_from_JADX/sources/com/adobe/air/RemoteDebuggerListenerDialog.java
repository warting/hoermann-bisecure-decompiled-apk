package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.DialogInterface.OnKeyListener;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import java.net.InetAddress;
import java.net.Socket;

public class RemoteDebuggerListenerDialog extends Activity {
    private final String LOG_TAG = getClass().getName();
    private int count = 0;
    private int debuggerPort = -1;
    private Activity mActivity = null;
    private Runnable mCheckAgain = null;
    private Handler mHandler = new Handler();
    private BroadcastReceiver mReceiver;
    private AlertDialog mWaitDialog = null;

    /* renamed from: com.adobe.air.RemoteDebuggerListenerDialog$1 */
    class C00551 extends BroadcastReceiver {
        C00551() {
        }

        public void onReceive(Context context, Intent intent) {
            if (!isInitialStickyBroadcast()) {
                Bundle extras = RemoteDebuggerListenerDialog.this.getIntent().getExtras();
                if ((extras != null ? extras.getInt("debuggerPort") : 7936) == RemoteDebuggerListenerDialog.this.debuggerPort) {
                    RemoteDebuggerListenerDialog.this.dismissDialog();
                }
            }
        }
    }

    /* renamed from: com.adobe.air.RemoteDebuggerListenerDialog$2 */
    class C00562 implements OnClickListener {
        C00562() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
            RemoteDebuggerListenerDialog.this.mHandler.removeCallbacks(RemoteDebuggerListenerDialog.this.mCheckAgain);
            RemoteDebuggerListenerDialog.this.closeListeningDebuggerSocket();
            RemoteDebuggerListenerDialog.this.unregisterReceiver(RemoteDebuggerListenerDialog.this.mReceiver);
            RemoteDebuggerListenerDialog.this.mReceiver = null;
            dialog.cancel();
            RemoteDebuggerListenerDialog.this.finish();
        }
    }

    /* renamed from: com.adobe.air.RemoteDebuggerListenerDialog$3 */
    class C00573 implements OnKeyListener {
        C00573() {
        }

        public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
            if (keyCode == 4) {
                RemoteDebuggerListenerDialog.this.mHandler.removeCallbacks(RemoteDebuggerListenerDialog.this.mCheckAgain);
                RemoteDebuggerListenerDialog.this.closeListeningDebuggerSocket();
                RemoteDebuggerListenerDialog.this.unregisterReceiver(RemoteDebuggerListenerDialog.this.mReceiver);
                RemoteDebuggerListenerDialog.this.mReceiver = null;
                dialog.cancel();
                RemoteDebuggerListenerDialog.this.finish();
            }
            return false;
        }
    }

    /* renamed from: com.adobe.air.RemoteDebuggerListenerDialog$5 */
    class C00615 extends AsyncTask<Integer, Integer, Integer> {
        C00615() {
        }

        protected Integer doInBackground(Integer... ports) {
            try {
                new Socket(InetAddress.getLocalHost(), ports[0].intValue()).close();
            } catch (Exception e) {
            }
            return Integer.valueOf(0);
        }
    }

    private enum DialogState {
        StateRuntimeNotReady,
        StateRuntimeWaitingForDebugger,
        StateRuntimeTimedOut
    }

    public void onCreate(Bundle savedInstanceState) {
        final String dialogMessage = getString(R.string.IDA_APP_WAITING_DEBUGGER_WARNING);
        final String timeOutMessage = getString(R.string.IDA_APP_DEBUGGER_TIMEOUT_INFO);
        this.mActivity = this;
        super.onCreate(savedInstanceState);
        Bundle extras = getIntent().getExtras();
        this.debuggerPort = extras != null ? extras.getInt("debuggerPort") : 7936;
        this.mWaitDialog = new Builder(this).create();
        String message = String.format(dialogMessage, new Object[]{Integer.valueOf(60)});
        this.mReceiver = new C00551();
        IntentFilter filter = new IntentFilter("android.intent.action.MAIN");
        filter.addCategory("RemoteDebuggerListenerDialogClose");
        registerReceiver(this.mReceiver, filter);
        this.mWaitDialog = createDialog(getString(R.string.IDA_APP_WAITING_DEBUGGER_TITLE), message, getString(R.string.button_cancel), new C00562(), new C00573());
        this.count = 0;
        this.mCheckAgain = new Runnable() {

            /* renamed from: com.adobe.air.RemoteDebuggerListenerDialog$4$1 */
            class C00581 implements OnClickListener {
                C00581() {
                }

                public void onClick(DialogInterface dialog, int whichButton) {
                    RemoteDebuggerListenerDialog.this.closeListeningDebuggerSocket();
                    dialog.cancel();
                    RemoteDebuggerListenerDialog.this.finish();
                }
            }

            public void run() {
                if (RemoteDebuggerListenerDialog.this.count < 60) {
                    String message = String.format(dialogMessage, new Object[]{Integer.valueOf(60 - RemoteDebuggerListenerDialog.this.count)});
                    RemoteDebuggerListenerDialog.this.count = RemoteDebuggerListenerDialog.this.count + 1;
                    RemoteDebuggerListenerDialog.this.mWaitDialog.setMessage(message);
                    RemoteDebuggerListenerDialog.this.mHandler.postDelayed(this, 1000);
                    return;
                }
                RemoteDebuggerListenerDialog.this.mHandler.removeCallbacks(this);
                RemoteDebuggerListenerDialog.this.mWaitDialog.cancel();
                if (RemoteDebuggerListenerDialog.this.mReceiver != null) {
                    RemoteDebuggerListenerDialog.this.unregisterReceiver(RemoteDebuggerListenerDialog.this.mReceiver);
                    RemoteDebuggerListenerDialog.this.mReceiver = null;
                }
                final OnClickListener dialogButtonHandler = new C00581();
                RemoteDebuggerListenerDialog.this.mWaitDialog = RemoteDebuggerListenerDialog.this.createDialog(AndroidConstants.ADOBE_AIR, timeOutMessage, RemoteDebuggerListenerDialog.this.getString(R.string.button_continue), dialogButtonHandler, new OnKeyListener() {
                    public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                        if (keyCode == 4) {
                            dialogButtonHandler.onClick(dialog, -1);
                        }
                        return false;
                    }
                });
                RemoteDebuggerListenerDialog.this.mWaitDialog.show();
            }
        };
        this.mHandler.postDelayed(this.mCheckAgain, 1000);
        this.mWaitDialog.show();
    }

    private AlertDialog createDialog(CharSequence title, CharSequence message, CharSequence positiveButtonText, OnClickListener positiveClickListener, OnKeyListener keyListener) {
        AlertDialog dialog = new Builder(this.mActivity).create();
        dialog.setTitle(title);
        dialog.setMessage(message);
        dialog.setButton(-1, positiveButtonText, positiveClickListener);
        dialog.setOnKeyListener(keyListener);
        dialog.setCancelable(true);
        return dialog;
    }

    private void closeListeningDebuggerSocket() {
        new C00615().execute(new Integer[]{Integer.valueOf(this.debuggerPort)});
    }

    private void dismissDialog() {
        if (this.mWaitDialog != null) {
            this.mWaitDialog.cancel();
        }
        if (this.mReceiver != null) {
            unregisterReceiver(this.mReceiver);
        }
        this.mReceiver = null;
        this.mHandler.removeCallbacks(this.mCheckAgain);
        this.mActivity.finish();
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == 4) {
            closeListeningDebuggerSocket();
            dismissDialog();
        }
        return super.onKeyDown(keyCode, event);
    }

    public void onStop() {
        closeListeningDebuggerSocket();
        dismissDialog();
        super.onStop();
    }
}
