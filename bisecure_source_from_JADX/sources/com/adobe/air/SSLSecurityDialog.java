package com.adobe.air;

import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.net.http.SslCertificate;
import android.view.KeyEvent;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class SSLSecurityDialog {
    public static final String TAG = SSLSecurityDialog.class.toString();
    private static final String USER_ACTION_TRUST_ALWAYS = "always";
    private static final String USER_ACTION_TRUST_NONE = "none";
    private static final String USER_ACTION_TRUST_SESSION = "session";
    private Condition m_condition = this.m_lock.newCondition();
    private Lock m_lock = new ReentrantLock();
    private String m_useraction = null;

    /* renamed from: com.adobe.air.SSLSecurityDialog$4 */
    class C00654 implements OnKeyListener {
        C00654() {
        }

        public boolean onKey(DialogInterface arg0, int arg1, KeyEvent event) {
            if (event.getKeyCode() == 4) {
                SSLSecurityDialog.this.SetUserAction(SSLSecurityDialog.USER_ACTION_TRUST_NONE);
            }
            return false;
        }
    }

    public String show(String server, byte[] cert) {
        ShowSSLDialog(server, cert, null, false);
        if (this.m_useraction != null) {
        }
        return this.m_useraction;
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void ShowSSLDialog(java.lang.String r23, byte[] r24, android.net.http.SslCertificate r25, boolean r26) {
        /*
        r22 = this;
        r3 = com.adobe.air.AndroidActivityWrapper.GetAndroidActivityWrapper();
        r10 = r3.getActivity();
        if (r10 != 0) goto L_0x000e;
    L_0x000a:
        r10 = r3.WaitForNewActivity();
    L_0x000e:
        r7 = new com.adobe.air.AndroidAlertDialog;
        r7.<init>(r10);
        r16 = r7.GetAlertDialogBuilder();
        r9 = r10.getLayoutInflater();
        r14 = r10.getResources();
        r19 = "ssl_certificate_warning";
        r0 = r19;
        r17 = com.adobe.air.utils.Utils.GetLayoutView(r0, r14, r9);
        if (r17 == 0) goto L_0x0178;
    L_0x0029:
        r18 = r17.getResources();
        r19 = "ServerName";
        r0 = r19;
        r1 = r18;
        r2 = r17;
        r15 = com.adobe.air.utils.Utils.GetWidgetInViewByNameFromPackage(r0, r1, r2);
        r15 = (android.widget.TextView) r15;
        r19 = new java.lang.StringBuilder;
        r19.<init>();
        r20 = r15.getText();
        r19 = r19.append(r20);
        r20 = " ";
        r19 = r19.append(r20);
        r0 = r19;
        r1 = r23;
        r19 = r0.append(r1);
        r19 = r19.toString();
        r0 = r19;
        r15.setText(r0);
        r5 = 0;
        if (r24 == 0) goto L_0x0179;
    L_0x0062:
        r5 = new com.adobe.air.Certificate;
        r5.<init>();
        r0 = r24;
        r5.setCertificate(r0);
    L_0x006c:
        r19 = "IDA_CERTIFICATE_DETAILS";
        r0 = r19;
        r6 = com.adobe.air.utils.Utils.GetResourceString(r0, r14);
        r19 = 8;
        r0 = r19;
        r0 = new java.lang.Object[r0];
        r19 = r0;
        r20 = 0;
        r21 = r5.getIssuedToCommonName();
        r19[r20] = r21;
        r20 = 1;
        r21 = r5.getIssuedToOrganization();
        r19[r20] = r21;
        r20 = 2;
        r21 = r5.getIssuedToOrganizationalUnit();
        r19[r20] = r21;
        r20 = 3;
        r21 = r5.getIssuedByCommonName();
        r19[r20] = r21;
        r20 = 4;
        r21 = r5.getIssuedByOrganization();
        r19[r20] = r21;
        r20 = 5;
        r21 = r5.getIssuedByOrganizationalUnit();
        r19[r20] = r21;
        r20 = 6;
        r21 = r5.getIssuedOn();
        r19[r20] = r21;
        r20 = 7;
        r21 = r5.getExpiresOn();
        r19[r20] = r21;
        r0 = r19;
        r8 = java.lang.String.format(r6, r0);
        r19 = "CertificateDetails";
        r0 = r19;
        r1 = r18;
        r2 = r17;
        r4 = com.adobe.air.utils.Utils.GetWidgetInViewByNameFromPackage(r0, r1, r2);
        r4 = (android.widget.TextView) r4;
        r19 = android.widget.TextView.BufferType.SPANNABLE;
        r0 = r19;
        r4.setText(r8, r0);
        r19 = "NeutralButton";
        r0 = r19;
        r1 = r18;
        r2 = r17;
        r12 = com.adobe.air.utils.Utils.GetWidgetInViewByNameFromPackage(r0, r1, r2);
        r12 = (android.widget.Button) r12;
        r19 = new com.adobe.air.SSLSecurityDialog$1;
        r0 = r19;
        r1 = r22;
        r0.<init>(r7);
        r0 = r19;
        r12.setOnClickListener(r0);
        r19 = "PositiveButton";
        r0 = r19;
        r1 = r18;
        r2 = r17;
        r13 = com.adobe.air.utils.Utils.GetWidgetInViewByNameFromPackage(r0, r1, r2);
        r13 = (android.widget.Button) r13;
        if (r26 == 0) goto L_0x0182;
    L_0x0103:
        r19 = new com.adobe.air.SSLSecurityDialog$2;
        r0 = r19;
        r1 = r22;
        r0.<init>(r7);
        r0 = r19;
        r13.setOnClickListener(r0);
        r19 = 0;
        r0 = r19;
        r13.setVisibility(r0);
    L_0x0118:
        r19 = "NegativeButton";
        r0 = r19;
        r1 = r18;
        r2 = r17;
        r11 = com.adobe.air.utils.Utils.GetWidgetInViewByNameFromPackage(r0, r1, r2);
        r11 = (android.widget.Button) r11;
        r19 = new com.adobe.air.SSLSecurityDialog$3;
        r0 = r19;
        r1 = r22;
        r0.<init>(r7);
        r0 = r19;
        r11.setOnClickListener(r0);
        r16.setView(r17);
        r19 = new com.adobe.air.SSLSecurityDialog$4;
        r0 = r19;
        r1 = r22;
        r0.<init>();
        r0 = r16;
        r1 = r19;
        r0.setOnKeyListener(r1);
        r19 = new com.adobe.air.SSLSecurityDialog$5;
        r0 = r19;
        r1 = r22;
        r0.<init>(r7);
        r0 = r19;
        r10.runOnUiThread(r0);
        r0 = r22;
        r0 = r0.m_lock;
        r19 = r0;
        r19.lock();
        r0 = r22;
        r0 = r0.m_useraction;	 Catch:{ InterruptedException -> 0x018a, all -> 0x0195 }
        r19 = r0;
        if (r19 != 0) goto L_0x016f;
    L_0x0166:
        r0 = r22;
        r0 = r0.m_condition;	 Catch:{ InterruptedException -> 0x018a, all -> 0x0195 }
        r19 = r0;
        r19.await();	 Catch:{ InterruptedException -> 0x018a, all -> 0x0195 }
    L_0x016f:
        r0 = r22;
        r0 = r0.m_lock;
        r19 = r0;
        r19.unlock();
    L_0x0178:
        return;
    L_0x0179:
        r5 = new com.adobe.air.Certificate;
        r0 = r25;
        r5.<init>(r0);
        goto L_0x006c;
    L_0x0182:
        r19 = 8;
        r0 = r19;
        r13.setVisibility(r0);
        goto L_0x0118;
    L_0x018a:
        r19 = move-exception;
        r0 = r22;
        r0 = r0.m_lock;
        r19 = r0;
        r19.unlock();
        goto L_0x0178;
    L_0x0195:
        r19 = move-exception;
        r0 = r22;
        r0 = r0.m_lock;
        r20 = r0;
        r20.unlock();
        throw r19;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.SSLSecurityDialog.ShowSSLDialog(java.lang.String, byte[], android.net.http.SslCertificate, boolean):void");
    }

    private void SetUserAction(String action) {
        this.m_lock.lock();
        this.m_useraction = action;
        this.m_condition.signal();
        this.m_lock.unlock();
    }

    public String show(String server, SslCertificate certificate) {
        ShowSSLDialog(server, null, certificate, false);
        if (this.m_useraction != null) {
        }
        return this.m_useraction;
    }

    public String getUserAction() {
        return this.m_useraction;
    }
}
