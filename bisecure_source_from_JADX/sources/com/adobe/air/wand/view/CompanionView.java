package com.adobe.air.wand.view;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.ScaleGestureDetector;
import android.view.View;

public class CompanionView extends View {
    private static final String LOG_TAG = "CompanionView";
    static final int POST_TOUCH_MESSAGE_AFTER_DELAY = 0;
    public static final int kTouchActionBegin = 2;
    public static final int kTouchActionEnd = 4;
    public static final int kTouchActionMove = 1;
    public static final int kTouchMetaStateIsEraser = 67108864;
    public static final int kTouchMetaStateIsPen = 33554432;
    public static final int kTouchMetaStateMask = 234881024;
    public static final int kTouchMetaStateSideButton1 = 134217728;
    public final int kMultitouchGesture = 2;
    public final int kMultitouchNone = 0;
    public final int kMultitouchRaw = 1;
    private int mBoundHeight = 0;
    private int mBoundWidth = 0;
    private int mCurrentOrientation = 0;
    private GestureDetector mGestureDetector;
    private GestureListener mGestureListener;
    private boolean mIsFullScreen = false;
    private int mMultitouchMode = 2;
    private ScaleGestureDetector mScaleGestureDetector;
    private int mSkipHeightFromTop = 0;
    private TouchSensor mTouchSensor = null;
    private int mVisibleBoundHeight = 0;
    private int mVisibleBoundWidth = 0;

    public CompanionView(Context context) {
        super(context);
        initView(context);
    }

    public CompanionView(Context context, AttributeSet attr) {
        super(context, attr);
        initView(context);
    }

    private void initView(Context context) {
        this.mTouchSensor = new TouchSensor();
        this.mGestureListener = new GestureListener(context, this);
        this.mGestureDetector = new GestureDetector(context, this.mGestureListener, null, false);
        this.mScaleGestureDetector = new ScaleGestureDetector(context, this.mGestureListener);
        setWillNotDraw(false);
        setClickable(true);
        setEnabled(true);
        setFocusable(true);
        setFocusableInTouchMode(true);
    }

    public View returnThis() {
        return this;
    }

    public void onWindowFocusChanged(boolean hasWindowFocus) {
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        return false;
    }

    public boolean onKeyUp(int keyCode, KeyEvent event) {
        return false;
    }

    protected void onFocusChanged(boolean focused, int direction, Rect previouslyFocusedRect) {
        super.onFocusChanged(focused, direction, previouslyFocusedRect);
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean onTouchEvent(android.view.MotionEvent r40) {
        /*
        r39 = this;
        r37 = 1;
        r26 = r40.getAction();
        r0 = r26;
        r0 = r0 & 255;
        r26 = r0;
        r31 = 0;
        if (r31 != 0) goto L_0x00af;
    L_0x0010:
        r0 = r39;
        r12 = r0.mGestureListener;
        if (r12 == 0) goto L_0x00af;
    L_0x0016:
        r12 = 5;
        r0 = r26;
        if (r0 == r12) goto L_0x001d;
    L_0x001b:
        if (r26 != 0) goto L_0x004d;
    L_0x001d:
        r30 = 0;
    L_0x001f:
        r12 = r40.getPointerCount();
        r0 = r30;
        if (r0 >= r12) goto L_0x004d;
    L_0x0027:
        r0 = r40;
        r1 = r30;
        r32 = r0.getPointerId(r1);
        r0 = r39;
        r12 = r0.mGestureListener;
        r0 = r40;
        r1 = r30;
        r14 = r0.getX(r1);
        r0 = r40;
        r1 = r30;
        r16 = r0.getY(r1);
        r0 = r16;
        r1 = r32;
        r12.setDownTouchPoint(r14, r0, r1);
        r30 = r30 + 1;
        goto L_0x001f;
    L_0x004d:
        if (r26 != 0) goto L_0x0056;
    L_0x004f:
        r0 = r39;
        r12 = r0.mGestureListener;
        r12.mayStartNewTransformGesture();
    L_0x0056:
        r12 = 5;
        r0 = r26;
        if (r0 != r12) goto L_0x016a;
    L_0x005b:
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 1;
        r12.setCouldBeTwoFingerTap(r14);
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 0;
        r0 = r40;
        r14 = r0.getX(r14);
        r16 = 0;
        r0 = r40;
        r1 = r16;
        r16 = r0.getY(r1);
        r17 = 0;
        r0 = r40;
        r1 = r17;
        r17 = r0.getPointerId(r1);
        r0 = r16;
        r1 = r17;
        r12.setPrimaryPointOfTwoFingerTap(r14, r0, r1);
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 1;
        r0 = r40;
        r14 = r0.getX(r14);
        r16 = 1;
        r0 = r40;
        r1 = r16;
        r16 = r0.getY(r1);
        r17 = 1;
        r0 = r40;
        r1 = r17;
        r17 = r0.getPointerId(r1);
        r0 = r16;
        r1 = r17;
        r12.setSecondaryPointOfTwoFingerTap(r14, r0, r1);
    L_0x00af:
        r33 = r40.getPointerCount();
        r27 = 0;
        r34 = 0;
    L_0x00b7:
        r0 = r34;
        r1 = r33;
        if (r0 >= r1) goto L_0x024d;
    L_0x00bd:
        r0 = r40;
        r1 = r34;
        r5 = r0.getX(r1);
        r0 = r40;
        r1 = r34;
        r12 = r0.getY(r1);
        r0 = r39;
        r14 = r0.mSkipHeightFromTop;
        r14 = (float) r14;
        r6 = r12 + r14;
        r4 = 1;
        r25 = r40.getAction();
        r0 = r40;
        r1 = r34;
        r8 = r0.getPointerId(r1);
        r13 = r40.getMetaState();
        r12 = android.os.Build.VERSION.SDK_INT;
        r14 = 14;
        if (r12 < r14) goto L_0x010a;
    L_0x00eb:
        r12 = -234881025; // 0xfffffffff1ffffff float:-2.535301E30 double:NaN;
        r13 = r13 & r12;
        r0 = r40;
        r1 = r34;
        r38 = r0.getToolType(r1);
        r12 = 4;
        r0 = r38;
        if (r0 != r12) goto L_0x01ad;
    L_0x00fc:
        r12 = 67108864; // 0x4000000 float:1.5046328E-36 double:3.31561842E-316;
        r13 = r13 | r12;
    L_0x00ff:
        r12 = r40.getButtonState();
        r12 = r12 & 2;
        if (r12 == 0) goto L_0x010a;
    L_0x0107:
        r12 = 134217728; // 0x8000000 float:3.85186E-34 double:6.63123685E-316;
        r13 = r13 | r12;
    L_0x010a:
        if (r27 == 0) goto L_0x01b7;
    L_0x010c:
        r25 = 3;
        r4 = 4;
    L_0x010f:
        r0 = r39;
        r12 = r0.IsTouchEventHandlingAllowed(r4, r5, r6);
        if (r12 == 0) goto L_0x0247;
    L_0x0117:
        r0 = r40;
        r1 = r34;
        r9 = r0.getSize(r1);
        r10 = r9;
        if (r8 != 0) goto L_0x01f6;
    L_0x0122:
        r11 = 1;
    L_0x0123:
        r29 = r40.getHistorySize();
        r12 = r29 + 1;
        r12 = r12 * 3;
        r0 = new float[r12];
        r23 = r0;
        r35 = 0;
        r28 = 0;
        r36 = r35;
    L_0x0135:
        r0 = r28;
        r1 = r29;
        if (r0 >= r1) goto L_0x01f9;
    L_0x013b:
        r35 = r36 + 1;
        r0 = r40;
        r1 = r34;
        r2 = r28;
        r12 = r0.getHistoricalX(r1, r2);
        r23[r36] = r12;
        r36 = r35 + 1;
        r0 = r40;
        r1 = r34;
        r2 = r28;
        r12 = r0.getHistoricalY(r1, r2);
        r23[r35] = r12;
        r35 = r36 + 1;
        r0 = r40;
        r1 = r34;
        r2 = r28;
        r12 = r0.getHistoricalPressure(r1, r2);
        r23[r36] = r12;
        r28 = r28 + 1;
        r36 = r35;
        goto L_0x0135;
    L_0x016a:
        r12 = 6;
        r0 = r26;
        if (r0 != r12) goto L_0x0184;
    L_0x016f:
        r0 = r39;
        r12 = r0.mGestureListener;
        r12 = r12.getCouldBeTwoFingerTap();
        r14 = 1;
        if (r12 != r14) goto L_0x0184;
    L_0x017a:
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 2;
        r12.setCouldBeTwoFingerTap(r14);
        goto L_0x00af;
    L_0x0184:
        r12 = 1;
        r0 = r26;
        if (r0 != r12) goto L_0x019e;
    L_0x0189:
        r0 = r39;
        r12 = r0.mGestureListener;
        r12 = r12.getCouldBeTwoFingerTap();
        r14 = 2;
        if (r12 != r14) goto L_0x019e;
    L_0x0194:
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 3;
        r12.setCouldBeTwoFingerTap(r14);
        goto L_0x00af;
    L_0x019e:
        r12 = 2;
        r0 = r26;
        if (r0 == r12) goto L_0x00af;
    L_0x01a3:
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 0;
        r12.setCouldBeTwoFingerTap(r14);
        goto L_0x00af;
    L_0x01ad:
        r12 = 2;
        r0 = r38;
        if (r0 != r12) goto L_0x00ff;
    L_0x01b2:
        r12 = 33554432; // 0x2000000 float:9.403955E-38 double:1.6578092E-316;
        r13 = r13 | r12;
        goto L_0x00ff;
    L_0x01b7:
        r12 = r40.getPointerCount();
        r14 = 1;
        if (r12 == r14) goto L_0x01cd;
    L_0x01be:
        r12 = 65280; // 0xff00 float:9.1477E-41 double:3.22526E-319;
        r12 = r12 & r25;
        r12 = r12 >> 8;
        r0 = r40;
        r12 = r0.getPointerId(r12);
        if (r8 != r12) goto L_0x010f;
    L_0x01cd:
        r0 = r25;
        r0 = r0 & 255;
        r25 = r0;
        switch(r25) {
            case 0: goto L_0x01d9;
            case 1: goto L_0x01de;
            case 2: goto L_0x01d6;
            case 3: goto L_0x01dc;
            case 4: goto L_0x01d6;
            case 5: goto L_0x01d9;
            case 6: goto L_0x01de;
            default: goto L_0x01d6;
        };
    L_0x01d6:
        r4 = 1;
        goto L_0x010f;
    L_0x01d9:
        r4 = 2;
        goto L_0x010f;
    L_0x01dc:
        r27 = 1;
    L_0x01de:
        r4 = 4;
        r0 = r39;
        r12 = r0.mGestureListener;
        if (r12 == 0) goto L_0x010f;
    L_0x01e5:
        r0 = r39;
        r12 = r0.mGestureListener;
        r12.endTwoFingerGesture();
        r0 = r39;
        r12 = r0.mGestureListener;
        r14 = 1;
        r12.setCheckForSwipe(r14);
        goto L_0x010f;
    L_0x01f6:
        r11 = 0;
        goto L_0x0123;
    L_0x01f9:
        r0 = r40;
        r1 = r34;
        r7 = r0.getPressure(r1);
        r23[r36] = r5;
        r12 = r36 + 1;
        r23[r12] = r6;
        r12 = r36 + 2;
        r23[r12] = r7;
        r13 = r13 & -2;
        r12 = 1;
        if (r4 == r12) goto L_0x0224;
    L_0x0210:
        r12 = 3;
        r0 = r25;
        if (r0 != r12) goto L_0x0217;
    L_0x0215:
        r13 = r13 | 1;
    L_0x0217:
        r3 = new com.adobe.air.TouchEventData;
        r12 = 0;
        r3.<init>(r4, r5, r6, r7, r8, r9, r10, r11, r12, r13);
        r0 = r39;
        r12 = r0.mTouchSensor;
        r12.dispatchEvent(r3);
    L_0x0224:
        r15 = 0;
        switch(r4) {
            case 1: goto L_0x024b;
            case 2: goto L_0x024b;
            default: goto L_0x0228;
        };
    L_0x0228:
        if (r15 == 0) goto L_0x0247;
    L_0x022a:
        r3 = new com.adobe.air.TouchEventData;
        r14 = r3;
        r16 = r5;
        r17 = r6;
        r18 = r7;
        r19 = r8;
        r20 = r9;
        r21 = r10;
        r22 = r11;
        r24 = r13;
        r14.<init>(r15, r16, r17, r18, r19, r20, r21, r22, r23, r24);
        r0 = r39;
        r12 = r0.mTouchSensor;
        r12.dispatchEvent(r3);
    L_0x0247:
        r34 = r34 + 1;
        goto L_0x00b7;
    L_0x024b:
        r15 = 1;
        goto L_0x0228;
    L_0x024d:
        r0 = r39;
        r12 = r0.mScaleGestureDetector;
        if (r12 == 0) goto L_0x0263;
    L_0x0253:
        if (r37 == 0) goto L_0x027a;
    L_0x0255:
        r0 = r39;
        r12 = r0.mScaleGestureDetector;	 Catch:{ Exception -> 0x0280 }
        r0 = r40;
        r12 = r12.onTouchEvent(r0);	 Catch:{ Exception -> 0x0280 }
        if (r12 == 0) goto L_0x027a;
    L_0x0261:
        r37 = 1;
    L_0x0263:
        r0 = r39;
        r12 = r0.mGestureDetector;
        if (r12 == 0) goto L_0x0279;
    L_0x0269:
        if (r37 == 0) goto L_0x027d;
    L_0x026b:
        r0 = r39;
        r12 = r0.mGestureDetector;
        r0 = r40;
        r12 = r12.onTouchEvent(r0);
        if (r12 == 0) goto L_0x027d;
    L_0x0277:
        r37 = 1;
    L_0x0279:
        return r37;
    L_0x027a:
        r37 = 0;
        goto L_0x0263;
    L_0x027d:
        r37 = 0;
        goto L_0x0279;
    L_0x0280:
        r12 = move-exception;
        goto L_0x0263;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.wand.view.CompanionView.onTouchEvent(android.view.MotionEvent):boolean");
    }

    public void onGestureListener(int gesturePhase, int gestureType, boolean isTransform, float locX, float locY, float scaleX, float scaleY, float rotation, float offsetX, float offsetY) {
        this.mTouchSensor.dispatchEvent(new GestureEventData(gesturePhase, gestureType, isTransform, locX, locY, scaleX, scaleY, rotation, offsetX, offsetY));
    }

    public TouchSensor getTouchSensor() {
        return this.mTouchSensor;
    }

    protected void onSizeChanged(int width, int height, int oldWidth, int oldHeight) {
        super.onSizeChanged(width, height, oldWidth, oldHeight);
    }

    public void setMultitouchMode(int multitouchMode) {
        this.mMultitouchMode = multitouchMode;
    }

    public int getMultitouchMode() {
        return this.mMultitouchMode;
    }

    public boolean getIsFullScreen() {
        return this.mIsFullScreen;
    }

    public int getBoundWidth() {
        return this.mBoundWidth;
    }

    public int getBoundHeight() {
        return this.mBoundHeight;
    }

    public int getVisibleBoundWidth() {
        return this.mVisibleBoundWidth;
    }

    public int getVisibleBoundHeight() {
        return this.mVisibleBoundHeight;
    }

    public boolean IsLandScape() {
        return this.mCurrentOrientation == 2;
    }

    private boolean IsTouchEventHandlingAllowed(int stage, float xCoord, float yCoord) {
        return true;
    }

    public boolean IsTouchUpHandlingAllowed() {
        return true;
    }
}
