package com.adobe.air;

import java.util.ArrayList;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class FileChooserStub {
    public static final String TAG = FileChooserStub.class.toString();
    private AIRExpandableFileChooser fileChooser;
    private Condition m_condition = this.m_lock.newCondition();
    private ArrayList<String> m_filenames = null;
    private ArrayList<String> m_filterList = new ArrayList();
    private Lock m_lock = new ReentrantLock();
    private String m_userAction = null;

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void show(java.lang.String r10, boolean r11, boolean r12) {
        /*
        r9 = this;
        r2 = r11;
        r3 = r12;
        r5 = r9;
        r4 = r10;
        r6 = com.adobe.air.AndroidActivityWrapper.GetAndroidActivityWrapper();
        r8 = r6.getActivity();
        if (r8 != 0) goto L_0x0012;
    L_0x000e:
        r8 = r6.WaitForNewActivity();
    L_0x0012:
        r0 = new com.adobe.air.FileChooserStub$1;
        r1 = r9;
        r0.<init>(r2, r3, r4, r5);
        r8.runOnUiThread(r0);
        r0 = r9.m_lock;
        r0.lock();
        r0 = r9.m_userAction;	 Catch:{ InterruptedException -> 0x0046, all -> 0x004d }
        if (r0 != 0) goto L_0x0029;
    L_0x0024:
        r0 = r9.m_condition;	 Catch:{ InterruptedException -> 0x0046, all -> 0x004d }
        r0.await();	 Catch:{ InterruptedException -> 0x0046, all -> 0x004d }
    L_0x0029:
        r0 = r9.m_lock;
        r0.unlock();
    L_0x002e:
        r0 = r9.fileChooser;
        r0 = r0.GetFileNames();
        r9.m_filenames = r0;
        r0 = r9.m_filenames;
        if (r0 == 0) goto L_0x0054;
    L_0x003a:
        r7 = 0;
    L_0x003b:
        r0 = r9.m_filenames;
        r0 = r0.size();
        if (r7 >= r0) goto L_0x0054;
    L_0x0043:
        r7 = r7 + 1;
        goto L_0x003b;
    L_0x0046:
        r0 = move-exception;
        r0 = r9.m_lock;
        r0.unlock();
        goto L_0x002e;
    L_0x004d:
        r0 = move-exception;
        r1 = r9.m_lock;
        r1.unlock();
        throw r0;
    L_0x0054:
        return;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.FileChooserStub.show(java.lang.String, boolean, boolean):void");
    }

    public void addFilter(String filterSpec) {
        this.m_filterList.add(filterSpec);
    }

    public void SetUserAction(String userAction) {
        this.m_lock.lock();
        this.m_userAction = userAction;
        this.m_condition.signal();
        this.m_lock.unlock();
    }

    public int getNumFilenames() {
        return this.m_filenames.size();
    }

    public String getFilename(int index) {
        if (index >= this.m_filenames.size()) {
            return null;
        }
        return (String) this.m_filenames.get(index);
    }

    public boolean userCancelled() {
        if (this.m_userAction == null || this.m_userAction.equals("cancel")) {
            return true;
        }
        return false;
    }
}
