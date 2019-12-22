package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.Region;
import android.graphics.Region.Op;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.ResultReceiver;
import android.provider.Settings.System;
import android.text.ClipboardManager;
import android.text.util.Linkify;
import android.util.DisplayMetrics;
import android.view.ContextMenu;
import android.view.Display;
import android.view.GestureDetector;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.MenuItem.OnMenuItemClickListener;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnSystemUiVisibilityChangeListener;
import android.view.ViewConfiguration;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputMethodManager;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.adobe.air.AndroidActivityWrapper.FlashPermission;
import com.adobe.air.AndroidLocale.STRING_ID;
import com.adobe.air.gestures.AIRGestureListener;
import com.adobe.air.utils.AIRLogger;
import com.adobe.air.utils.Utils;
import com.adobe.flashruntime.air.VideoViewAIR;
import com.adobe.flashruntime.shared.VideoView;

public class AIRWindowSurfaceView extends SurfaceView implements Callback {
    static final int CURSOR_POS_END_DOCUMENT = 3;
    static final int CURSOR_POS_END_LINE = 1;
    static final int CURSOR_POS_START_DOCUMENT = 2;
    static final int CURSOR_POS_START_LINE = 0;
    static final int ID_COPY = 3;
    static final int ID_COPY_ALL = 4;
    static final int ID_CUT = 1;
    static final int ID_CUT_ALL = 2;
    static final int ID_PASTE = 5;
    static final int ID_SELECT_ALL = 0;
    static final int ID_START_SELECTING = 7;
    static final int ID_STOP_SELECTING = 8;
    static final int ID_SWITCH_INPUT_METHOD = 6;
    private static final String LOG_TAG = "AIRWindowSurfaceView";
    static final int LONG_PRESS_DELAY = 500;
    static final int MAX_MOVE_ACTION_ALLOWED = 4;
    static final int POST_TOUCH_MESSAGE_AFTER_DELAY = 0;
    private static final int kDefaultBitsPerPixel = 32;
    private static final int kMotionEventButtonSecondary = 2;
    private static final int kMotionEventToolTypeEraser = 4;
    private static final int kMotionEventToolTypeStylus = 2;
    private static final int kTouchActionBegin = 2;
    private static final int kTouchActionEnd = 4;
    private static final int kTouchActionHoverBegin = 16;
    private static final int kTouchActionHoverEnd = 32;
    private static final int kTouchActionHoverMove = 8;
    private static final int kTouchActionMove = 1;
    private static final int kTouchMetaStateIsEraser = 67108864;
    private static final int kTouchMetaStateIsPen = 33554432;
    private static final int kTouchMetaStateMask = 234881024;
    private static final int kTouchMetaStateSideButton1 = 134217728;
    private boolean inTouch;
    public final int kMultitouchGesture;
    public final int kMultitouchNone;
    public final int kMultitouchRaw;
    private final float kSampleSize;
    private AndroidActivityWrapper mActivityWrapper;
    private int mBoundHeight;
    private int mBoundWidth;
    private boolean mContextMenuVisible;
    private int mCurrentOrientation;
    private int mCurrentSurfaceFormat;
    private boolean mDispatchUserTriggeredSkDeactivate;
    private float mDownX;
    private float mDownY;
    private boolean mEatTouchRelease;
    protected FlashEGL mFlashEGL;
    private AndroidStageText mFocusedStageText;
    private AndroidWebView mFocusedWebView;
    private GestureDetector mGestureDetector;
    private AIRGestureListener mGestureListener;
    private boolean mHideSoftKeyboardOnWindowFocusChange;
    private boolean mHoverInProgress;
    private int mHoverMetaState;
    private HoverTimeoutHandler mHoverTimeoutHandler;
    private int mHt;
    private AndroidInputConnection mInputConnection;
    InputMethodReceiver mInputMethodReceiver;
    private boolean mIsFullScreen;
    private float mLastTouchedXCoord;
    private float mLastTouchedYCoord;
    private CheckLongPress mLongPressCheck;
    private boolean mMaliWorkaround;
    private MetaKeyState mMetaAltState;
    private MetaKeyState mMetaShiftState;
    private int mMultitouchMode;
    private boolean mNeedsCompositingSurface;
    private Paint mPaint;
    private Paint mPaintScaled;
    private AndroidStageText mResizedStageText;
    private AndroidWebView mResizedWebView;
    private ScaleGestureDetector mScaleGestureDetector;
    private int mScaledTouchSlop;
    private int mSkipHeightFromTop;
    private boolean mSurfaceChangedForSoftKeyboard;
    protected SurfaceHolder mSurfaceHolder;
    private boolean mSurfaceValid;
    private Rect mTextBoxBounds;
    private boolean mTrackBallPressed;
    private VideoView mVideoView;
    private int mVisibleBoundHeight;
    private int mVisibleBoundWidth;
    private int mWd;
    private boolean mWindowHasFocus;

    /* renamed from: com.adobe.air.AIRWindowSurfaceView$4 */
    class C00174 implements OnClickListener {
        C00174() {
        }

        public void onClick(DialogInterface dialog, int whichButton) {
        }
    }

    class CheckLongPress implements Runnable {
        CheckLongPress() {
        }

        public void run() {
            AIRWindowSurfaceView.this.performLongClick();
        }
    }

    class HoverTimeoutHandler extends Handler {
        static final int INTERVAL = 500;
        private AIRWindowSurfaceView mAIRWindowSurfaceView;
        private long mLastMove;

        public HoverTimeoutHandler(AIRWindowSurfaceView airWindowSurfaceView) {
            this.mAIRWindowSurfaceView = airWindowSurfaceView;
        }

        public void handleMessage(Message msg) {
            if (System.currentTimeMillis() - this.mLastMove >= 500) {
                AIRWindowSurfaceView.this.mHoverInProgress = false;
                Entrypoints.registerTouchCallback(0, new TouchEventData(32, this.mAIRWindowSurfaceView.mLastTouchedXCoord, this.mAIRWindowSurfaceView.mLastTouchedYCoord, 0.0f, 0, 0.0f, 0.0f, true, null, this.mAIRWindowSurfaceView.mHoverMetaState), null);
                return;
            }
            AIRWindowSurfaceView.this.mHoverTimeoutHandler.sendEmptyMessageDelayed(0, 500);
        }

        public void setLastMove(long lastMove) {
            this.mLastMove = lastMove;
        }
    }

    class InputMethodReceiver extends ResultReceiver {
        public InputMethodReceiver() {
            super(AIRWindowSurfaceView.this.getHandler());
        }

        protected void onReceiveResult(int resultCode, Bundle resultData) {
            if (resultCode == 1 || resultCode == 3) {
                AIRWindowSurfaceView.this.nativeShowOriginalRect();
            } else {
                AIRWindowSurfaceView.this.nativeSetKeyboardVisible(true);
            }
        }
    }

    private class MenuHandler implements OnMenuItemClickListener {
        private MenuHandler() {
        }

        public boolean onMenuItemClick(MenuItem item) {
            return AIRWindowSurfaceView.this.onTextBoxContextMenuItem(item.getItemId());
        }
    }

    private enum MetaKeyState {
        INACTIVE,
        ACTIVE,
        PRESSED,
        LOCKED
    }

    private native void nativeCutText(boolean z);

    private native void nativeDeleteTextLine();

    private native void nativeDispatchFullScreenEvent(boolean z);

    private native void nativeDispatchSelectionChangeEvent(boolean z);

    private native void nativeForceReDraw();

    private native int nativeGetMultitouchMode();

    private native String nativeGetSelectedText();

    private native int nativeGetSoftKeyboardType();

    private native Rect nativeGetTextBoxBounds();

    private native void nativeInsertText(String str);

    private native boolean nativeIsEditable();

    private native boolean nativeIsFullScreenInteractive();

    private native boolean nativeIsMultiLineTextField();

    private native boolean nativeIsPasswordField();

    private native boolean nativeIsTextFieldInSelectionMode();

    private native boolean nativeIsTextFieldSelectable();

    private native void nativeMoveCursor(int i);

    private native void nativeOnFormatChangeListener(int i);

    private native void nativeOnSizeChangedListener(int i, int i2, boolean z);

    private native boolean nativePerformWindowPanning(int i, int i2);

    private native void nativeSelectAllText();

    private native void nativeSetKeyboardVisible(boolean z);

    private native void nativeSurfaceCreated();

    public native void nativeDispatchUserTriggeredSkDeactivateEvent();

    public native ExtractedText nativeGetTextContent();

    public native int nativeGetTextContentLength();

    public native boolean nativeIsTextSelected();

    public native boolean nativeOnDoubleClickListener(float f, float f2);

    public native boolean nativeOnKeyListener(int i, int i2, int i3, boolean z, boolean z2, boolean z3);

    public native void nativeShowOriginalRect();

    public AIRWindowSurfaceView(Context context, AndroidActivityWrapper aActivityWrapper) {
        super(context);
        this.kMultitouchNone = 0;
        this.kMultitouchRaw = 1;
        this.kMultitouchGesture = 2;
        this.kSampleSize = 4.0f;
        this.mWd = 0;
        this.mHt = 0;
        this.mSurfaceValid = false;
        this.mSkipHeightFromTop = 0;
        this.mSurfaceHolder = null;
        this.mFlashEGL = null;
        this.mBoundHeight = 0;
        this.mBoundWidth = 0;
        this.mVisibleBoundWidth = 0;
        this.mVisibleBoundHeight = 0;
        this.mMultitouchMode = 0;
        this.mPaint = null;
        this.mPaintScaled = null;
        this.mMaliWorkaround = false;
        this.mHoverInProgress = false;
        this.mHoverMetaState = 0;
        this.mCurrentOrientation = 0;
        this.mEatTouchRelease = false;
        this.mContextMenuVisible = false;
        this.mLongPressCheck = null;
        this.mIsFullScreen = false;
        this.mSurfaceChangedForSoftKeyboard = false;
        this.mDispatchUserTriggeredSkDeactivate = true;
        this.mHideSoftKeyboardOnWindowFocusChange = false;
        this.mTrackBallPressed = false;
        this.mWindowHasFocus = true;
        this.mNeedsCompositingSurface = false;
        this.mCurrentSurfaceFormat = -1;
        this.mFocusedWebView = null;
        this.mResizedWebView = null;
        this.mFocusedStageText = null;
        this.mResizedStageText = null;
        this.inTouch = false;
        this.mMetaShiftState = MetaKeyState.INACTIVE;
        this.mMetaAltState = MetaKeyState.INACTIVE;
        this.mHoverTimeoutHandler = new HoverTimeoutHandler(this);
        this.mInputMethodReceiver = new InputMethodReceiver();
        this.mSurfaceHolder = getHolder();
        this.mActivityWrapper = aActivityWrapper;
        setSurfaceFormat(false);
        this.mGestureListener = new AIRGestureListener(context, this);
        this.mGestureDetector = new GestureDetector(context, this.mGestureListener, null, false);
        this.mScaleGestureDetector = new ScaleGestureDetector(context, this.mGestureListener);
        setWillNotDraw(false);
        setClickable(true);
        setEnabled(true);
        setFocusable(true);
        setFocusableInTouchMode(true);
        this.mScaledTouchSlop = ViewConfiguration.get(context).getScaledTouchSlop();
        this.mSurfaceHolder.addCallback(this);
        setZOrderMediaOverlay(true);
        this.mActivityWrapper.registerPlane(this, 3);
    }

    public AndroidActivityWrapper getActivityWrapper() {
        return this.mActivityWrapper;
    }

    public View returnThis() {
        return this;
    }

    public void onWindowFocusChanged(boolean hasWindowFocus) {
        this.mWindowHasFocus = hasWindowFocus;
        if (this.mLongPressCheck != null) {
            removeCallbacks(this.mLongPressCheck);
        }
        if (this.mHideSoftKeyboardOnWindowFocusChange) {
            InputMethodManager imm = getInputMethodManager();
            if (imm != null) {
                imm.hideSoftInputFromWindow(getWindowToken(), 0);
            }
            this.mHideSoftKeyboardOnWindowFocusChange = false;
        }
        if (this.mIsFullScreen) {
            HideSystemUI();
        }
        if (hasWindowFocus) {
            this.mContextMenuVisible = false;
        }
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        boolean z = false;
        if (!AllowOSToHandleKeys(keyCode)) {
            int unichar = event.getUnicodeChar();
            if (this.mMetaShiftState == MetaKeyState.ACTIVE || this.mMetaShiftState == MetaKeyState.LOCKED || this.mMetaAltState == MetaKeyState.ACTIVE || this.mMetaAltState == MetaKeyState.LOCKED) {
                unichar = GetMetaKeyCharacter(event);
            }
            HandleMetaKeyAction(event);
            if (!(this.mTrackBallPressed || this.mLongPressCheck == null)) {
                removeCallbacks(this.mLongPressCheck);
            }
            if (this.mActivityWrapper.isApplicationLaunched() && !HandleShortCuts(keyCode, event)) {
                z = nativeOnKeyListener(event.getAction(), keyCode, unichar, event.isAltPressed(), event.isShiftPressed(), event.isSymPressed());
                if (this.mInputConnection != null) {
                    this.mInputConnection.updateIMEText();
                }
            }
        }
        return z;
    }

    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (AllowOSToHandleKeys(keyCode)) {
            return false;
        }
        int unichar = event.getUnicodeChar();
        if (this.mMetaShiftState == MetaKeyState.ACTIVE || this.mMetaShiftState == MetaKeyState.LOCKED || this.mMetaAltState == MetaKeyState.ACTIVE || this.mMetaAltState == MetaKeyState.LOCKED) {
            unichar = GetMetaKeyCharacter(event);
        }
        if (this.mLongPressCheck != null) {
            removeCallbacks(this.mLongPressCheck);
        }
        if (keyCode == 23) {
            this.mTrackBallPressed = false;
        }
        if (!this.mActivityWrapper.isApplicationLaunched()) {
            return false;
        }
        boolean val = nativeOnKeyListener(event.getAction(), keyCode, unichar, event.isAltPressed(), event.isShiftPressed(), event.isSymPressed());
        if (this.mInputConnection != null) {
            this.mInputConnection.updateIMEText();
        }
        if (val || event.getKeyCode() != 4 || !event.isTracking() || event.isCanceled()) {
            return val;
        }
        this.mActivityWrapper.getActivity().moveTaskToBack(false);
        return true;
    }

    public boolean onGenericMotionEvent(MotionEvent e) {
        if (e.getAction() == 9 || e.getAction() == 10 || e.getAction() == 7) {
            return onTouchEvent(e);
        }
        return false;
    }

    protected void onFocusChanged(boolean focused, int direction, Rect previouslyFocusedRect) {
        AIRLogger.m0d(LOG_TAG, "*** *** onFocusChanged: AIR");
        if (!(!focused || this.mFocusedStageText == null || this.inTouch)) {
            this.mDispatchUserTriggeredSkDeactivate = true;
            forceSoftKeyboardDown();
        }
        super.onFocusChanged(focused, direction, previouslyFocusedRect);
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean onTouchEvent(android.view.MotionEvent r45) {
        /*
        r44 = this;
        r40 = 1;
        r15 = 1;
        r0 = r44;
        r0.inTouch = r15;
        r27 = r45.getAction();
        r0 = r27;
        r0 = r0 & 255;
        r27 = r0;
        r15 = 9;
        r0 = r27;
        if (r0 == r15) goto L_0x0022;
    L_0x0017:
        r15 = 10;
        r0 = r27;
        if (r0 == r15) goto L_0x0022;
    L_0x001d:
        r15 = 7;
        r0 = r27;
        if (r0 != r15) goto L_0x0070;
    L_0x0022:
        r33 = 1;
    L_0x0024:
        r15 = r44.hasFocus();
        if (r15 != 0) goto L_0x0073;
    L_0x002a:
        if (r33 != 0) goto L_0x0073;
    L_0x002c:
        r0 = r44;
        r15 = r0.mActivityWrapper;
        r17 = 0;
        r0 = r17;
        r34 = r15.getOverlaysLayout(r0);
        if (r34 == 0) goto L_0x0073;
    L_0x003a:
        r0 = r44;
        r15 = r0.mFocusedStageText;
        if (r15 == 0) goto L_0x004e;
    L_0x0040:
        r0 = r44;
        r15 = r0.mFocusedStageText;
        r15 = r15.getPreventDefault();
        r17 = 1;
        r0 = r17;
        if (r15 == r0) goto L_0x0073;
    L_0x004e:
        r44.requestFocus();
        r34.clearFocus();
        r29 = r34.getChildCount();
        r32 = 0;
    L_0x005a:
        r0 = r32;
        r1 = r29;
        if (r0 >= r1) goto L_0x0073;
    L_0x0060:
        r0 = r34;
        r1 = r32;
        r43 = r0.getChildAt(r1);
        if (r43 == 0) goto L_0x006d;
    L_0x006a:
        r43.clearFocus();
    L_0x006d:
        r32 = r32 + 1;
        goto L_0x005a;
    L_0x0070:
        r33 = 0;
        goto L_0x0024;
    L_0x0073:
        r15 = 5;
        r0 = r27;
        if (r0 == r15) goto L_0x007a;
    L_0x0078:
        if (r27 != 0) goto L_0x00ac;
    L_0x007a:
        r32 = 0;
    L_0x007c:
        r15 = r45.getPointerCount();
        r0 = r32;
        if (r0 >= r15) goto L_0x00ac;
    L_0x0084:
        r0 = r45;
        r1 = r32;
        r35 = r0.getPointerId(r1);
        r0 = r44;
        r15 = r0.mGestureListener;
        r0 = r45;
        r1 = r32;
        r17 = r0.getX(r1);
        r0 = r45;
        r1 = r32;
        r18 = r0.getY(r1);
        r0 = r17;
        r1 = r18;
        r2 = r35;
        r15.setDownTouchPoint(r0, r1, r2);
        r32 = r32 + 1;
        goto L_0x007c;
    L_0x00ac:
        if (r27 != 0) goto L_0x00b5;
    L_0x00ae:
        r0 = r44;
        r15 = r0.mGestureListener;
        r15.mayStartNewTransformGesture();
    L_0x00b5:
        r15 = 5;
        r0 = r27;
        if (r0 != r15) goto L_0x01f4;
    L_0x00ba:
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 1;
        r0 = r17;
        r15.setCouldBeTwoFingerTap(r0);
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 0;
        r0 = r45;
        r1 = r17;
        r17 = r0.getX(r1);
        r18 = 0;
        r0 = r45;
        r1 = r18;
        r18 = r0.getY(r1);
        r19 = 0;
        r0 = r45;
        r1 = r19;
        r19 = r0.getPointerId(r1);
        r0 = r17;
        r1 = r18;
        r2 = r19;
        r15.setPrimaryPointOfTwoFingerTap(r0, r1, r2);
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 1;
        r0 = r45;
        r1 = r17;
        r17 = r0.getX(r1);
        r18 = 1;
        r0 = r45;
        r1 = r18;
        r18 = r0.getY(r1);
        r19 = 1;
        r0 = r45;
        r1 = r19;
        r19 = r0.getPointerId(r1);
        r0 = r17;
        r1 = r18;
        r2 = r19;
        r15.setSecondaryPointOfTwoFingerTap(r0, r1, r2);
    L_0x011b:
        r0 = r44;
        r15 = r0.mActivityWrapper;
        r15 = r15.isApplicationLaunched();
        if (r15 == 0) goto L_0x0365;
    L_0x0125:
        r36 = r45.getPointerCount();
        r28 = 0;
        r37 = 0;
    L_0x012d:
        r0 = r37;
        r1 = r36;
        if (r0 >= r1) goto L_0x0367;
    L_0x0133:
        r0 = r45;
        r1 = r37;
        r6 = r0.getX(r1);
        r0 = r45;
        r1 = r37;
        r15 = r0.getY(r1);
        r0 = r44;
        r0 = r0.mSkipHeightFromTop;
        r17 = r0;
        r0 = r17;
        r0 = (float) r0;
        r17 = r0;
        r7 = r15 + r17;
        r0 = r44;
        r0.mLastTouchedXCoord = r6;
        r0 = r44;
        r0.mLastTouchedYCoord = r7;
        r16 = 1;
        r26 = r45.getAction();
        r0 = r45;
        r1 = r37;
        r9 = r0.getPointerId(r1);
        r41 = 0;
        r14 = r45.getMetaState();
        r15 = android.os.Build.VERSION.SDK_INT;
        r17 = 14;
        r0 = r17;
        if (r15 < r0) goto L_0x0193;
    L_0x0174:
        r15 = -234881025; // 0xfffffffff1ffffff float:-2.535301E30 double:NaN;
        r14 = r14 & r15;
        r0 = r45;
        r1 = r37;
        r42 = r0.getToolType(r1);
        r15 = 4;
        r0 = r42;
        if (r0 != r15) goto L_0x0246;
    L_0x0185:
        r15 = 67108864; // 0x4000000 float:1.5046328E-36 double:3.31561842E-316;
        r14 = r14 | r15;
    L_0x0188:
        r15 = r45.getButtonState();
        r15 = r15 & 2;
        if (r15 == 0) goto L_0x0193;
    L_0x0190:
        r15 = 134217728; // 0x8000000 float:3.85186E-34 double:6.63123685E-316;
        r14 = r14 | r15;
    L_0x0193:
        if (r28 == 0) goto L_0x0250;
    L_0x0195:
        r26 = 3;
        r16 = 4;
    L_0x0199:
        r0 = r44;
        r1 = r16;
        r15 = r0.IsTouchEventHandlingAllowed(r1, r6, r7);
        if (r15 == 0) goto L_0x034a;
    L_0x01a3:
        r0 = r45;
        r1 = r37;
        r10 = r0.getSize(r1);
        r11 = r10;
        if (r9 != 0) goto L_0x02e0;
    L_0x01ae:
        r12 = 1;
    L_0x01af:
        r31 = r45.getHistorySize();
        r15 = r31 + 1;
        r15 = r15 * 3;
        r13 = new float[r15];
        r38 = 0;
        r30 = 0;
        r39 = r38;
    L_0x01bf:
        r0 = r30;
        r1 = r31;
        if (r0 >= r1) goto L_0x02e3;
    L_0x01c5:
        r38 = r39 + 1;
        r0 = r45;
        r1 = r37;
        r2 = r30;
        r15 = r0.getHistoricalX(r1, r2);
        r13[r39] = r15;
        r39 = r38 + 1;
        r0 = r45;
        r1 = r37;
        r2 = r30;
        r15 = r0.getHistoricalY(r1, r2);
        r13[r38] = r15;
        r38 = r39 + 1;
        r0 = r45;
        r1 = r37;
        r2 = r30;
        r15 = r0.getHistoricalPressure(r1, r2);
        r13[r39] = r15;
        r30 = r30 + 1;
        r39 = r38;
        goto L_0x01bf;
    L_0x01f4:
        r15 = 6;
        r0 = r27;
        if (r0 != r15) goto L_0x0214;
    L_0x01f9:
        r0 = r44;
        r15 = r0.mGestureListener;
        r15 = r15.getCouldBeTwoFingerTap();
        r17 = 1;
        r0 = r17;
        if (r15 != r0) goto L_0x0214;
    L_0x0207:
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 2;
        r0 = r17;
        r15.setCouldBeTwoFingerTap(r0);
        goto L_0x011b;
    L_0x0214:
        r15 = 1;
        r0 = r27;
        if (r0 != r15) goto L_0x0234;
    L_0x0219:
        r0 = r44;
        r15 = r0.mGestureListener;
        r15 = r15.getCouldBeTwoFingerTap();
        r17 = 2;
        r0 = r17;
        if (r15 != r0) goto L_0x0234;
    L_0x0227:
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 3;
        r0 = r17;
        r15.setCouldBeTwoFingerTap(r0);
        goto L_0x011b;
    L_0x0234:
        r15 = 2;
        r0 = r27;
        if (r0 == r15) goto L_0x011b;
    L_0x0239:
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 0;
        r0 = r17;
        r15.setCouldBeTwoFingerTap(r0);
        goto L_0x011b;
    L_0x0246:
        r15 = 2;
        r0 = r42;
        if (r0 != r15) goto L_0x0188;
    L_0x024b:
        r15 = 33554432; // 0x2000000 float:9.403955E-38 double:1.6578092E-316;
        r14 = r14 | r15;
        goto L_0x0188;
    L_0x0250:
        r15 = r45.getPointerCount();
        r17 = 1;
        r0 = r17;
        if (r15 == r0) goto L_0x0269;
    L_0x025a:
        r15 = 65280; // 0xff00 float:9.1477E-41 double:3.22526E-319;
        r15 = r15 & r26;
        r15 = r15 >> 8;
        r0 = r45;
        r15 = r0.getPointerId(r15);
        if (r9 != r15) goto L_0x0199;
    L_0x0269:
        r0 = r26;
        r0 = r0 & 255;
        r26 = r0;
        switch(r26) {
            case 0: goto L_0x02c4;
            case 1: goto L_0x02ca;
            case 2: goto L_0x0272;
            case 3: goto L_0x02c8;
            case 4: goto L_0x0272;
            case 5: goto L_0x02c4;
            case 6: goto L_0x02ca;
            case 7: goto L_0x028b;
            case 8: goto L_0x0272;
            case 9: goto L_0x0283;
            case 10: goto L_0x0287;
            default: goto L_0x0272;
        };
    L_0x0272:
        r0 = r44;
        r15 = r0.mHoverTimeoutHandler;
        r18 = java.lang.System.currentTimeMillis();
        r0 = r18;
        r15.setLastMove(r0);
        r16 = 1;
        goto L_0x0199;
    L_0x0283:
        r16 = 16;
        goto L_0x0199;
    L_0x0287:
        r16 = 32;
        goto L_0x0199;
    L_0x028b:
        r16 = 8;
        r15 = android.os.Build.VERSION.SDK_INT;
        r17 = 14;
        r0 = r17;
        if (r15 >= r0) goto L_0x0199;
    L_0x0295:
        r0 = r44;
        r15 = r0.mHoverTimeoutHandler;
        r18 = java.lang.System.currentTimeMillis();
        r0 = r18;
        r15.setLastMove(r0);
        r0 = r44;
        r0.mHoverMetaState = r14;
        r0 = r44;
        r15 = r0.mHoverInProgress;
        if (r15 != 0) goto L_0x0199;
    L_0x02ac:
        r0 = r44;
        r15 = r0.mHoverTimeoutHandler;
        r17 = 0;
        r18 = 500; // 0x1f4 float:7.0E-43 double:2.47E-321;
        r0 = r17;
        r1 = r18;
        r15.sendEmptyMessageDelayed(r0, r1);
        r41 = 1;
        r15 = 1;
        r0 = r44;
        r0.mHoverInProgress = r15;
        goto L_0x0199;
    L_0x02c4:
        r16 = 2;
        goto L_0x0199;
    L_0x02c8:
        r28 = 1;
    L_0x02ca:
        r16 = 4;
        r0 = r44;
        r15 = r0.mGestureListener;
        r15.endTwoFingerGesture();
        r0 = r44;
        r15 = r0.mGestureListener;
        r17 = 1;
        r0 = r17;
        r15.setCheckForSwipe(r0);
        goto L_0x0199;
    L_0x02e0:
        r12 = 0;
        goto L_0x01af;
    L_0x02e3:
        r0 = r45;
        r1 = r37;
        r8 = r0.getPressure(r1);
        r13[r39] = r6;
        r15 = r39 + 1;
        r13[r15] = r7;
        r15 = r39 + 2;
        r13[r15] = r8;
        r14 = r14 & -2;
        r5 = 0;
        switch(r16) {
            case 1: goto L_0x035d;
            case 2: goto L_0x035d;
            case 8: goto L_0x034e;
            default: goto L_0x02fb;
        };
    L_0x02fb:
        if (r5 == 0) goto L_0x0311;
    L_0x02fd:
        r4 = new com.adobe.air.TouchEventData;
        r4.<init>(r5, r6, r7, r8, r9, r10, r11, r12, r13, r14);
        if (r40 == 0) goto L_0x035f;
    L_0x0304:
        r15 = 0;
        r17 = 0;
        r0 = r17;
        r15 = com.adobe.air.Entrypoints.registerTouchCallback(r15, r4, r0);
        if (r15 == 0) goto L_0x035f;
    L_0x030f:
        r40 = 1;
    L_0x0311:
        r15 = 8;
        r0 = r16;
        if (r0 == r15) goto L_0x034a;
    L_0x0317:
        r15 = 1;
        r0 = r16;
        if (r0 == r15) goto L_0x034a;
    L_0x031c:
        r15 = 3;
        r0 = r26;
        if (r0 != r15) goto L_0x0323;
    L_0x0321:
        r14 = r14 | 1;
    L_0x0323:
        r4 = new com.adobe.air.TouchEventData;
        r24 = 0;
        r15 = r4;
        r17 = r6;
        r18 = r7;
        r19 = r8;
        r20 = r9;
        r21 = r10;
        r22 = r11;
        r23 = r12;
        r25 = r14;
        r15.<init>(r16, r17, r18, r19, r20, r21, r22, r23, r24, r25);
        if (r40 == 0) goto L_0x0362;
    L_0x033d:
        r15 = 0;
        r17 = 0;
        r0 = r17;
        r15 = com.adobe.air.Entrypoints.registerTouchCallback(r15, r4, r0);
        if (r15 == 0) goto L_0x0362;
    L_0x0348:
        r40 = 1;
    L_0x034a:
        r37 = r37 + 1;
        goto L_0x012d;
    L_0x034e:
        r5 = 8;
        r15 = android.os.Build.VERSION.SDK_INT;
        r17 = 14;
        r0 = r17;
        if (r15 >= r0) goto L_0x02fb;
    L_0x0358:
        if (r41 == 0) goto L_0x02fb;
    L_0x035a:
        r5 = r5 | 16;
        goto L_0x02fb;
    L_0x035d:
        r5 = 1;
        goto L_0x02fb;
    L_0x035f:
        r40 = 0;
        goto L_0x0311;
    L_0x0362:
        r40 = 0;
        goto L_0x034a;
    L_0x0365:
        r40 = 0;
    L_0x0367:
        if (r40 == 0) goto L_0x038d;
    L_0x0369:
        r0 = r44;
        r15 = r0.mScaleGestureDetector;	 Catch:{ Exception -> 0x0393 }
        r0 = r45;
        r15 = r15.onTouchEvent(r0);	 Catch:{ Exception -> 0x0393 }
        if (r15 == 0) goto L_0x038d;
    L_0x0375:
        r40 = 1;
    L_0x0377:
        if (r40 == 0) goto L_0x0390;
    L_0x0379:
        r0 = r44;
        r15 = r0.mGestureDetector;
        r0 = r45;
        r15 = r15.onTouchEvent(r0);
        if (r15 == 0) goto L_0x0390;
    L_0x0385:
        r40 = 1;
    L_0x0387:
        r15 = 0;
        r0 = r44;
        r0.inTouch = r15;
        return r40;
    L_0x038d:
        r40 = 0;
        goto L_0x0377;
    L_0x0390:
        r40 = 0;
        goto L_0x0387;
    L_0x0393:
        r15 = move-exception;
        goto L_0x0377;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AIRWindowSurfaceView.onTouchEvent(android.view.MotionEvent):boolean");
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

    public void surfaceCreated(SurfaceHolder holder) {
        this.mActivityWrapper.planeStepCascade();
        if (this.mIsFullScreen) {
            setFullScreen();
        }
        if (this.mActivityWrapper.isStarted() || this.mActivityWrapper.isResumed() || (Build.MANUFACTURER.equalsIgnoreCase("SAMSUNG") && Build.MODEL.equalsIgnoreCase("GT-I9300"))) {
            nativeSurfaceCreated();
        }
    }

    public static boolean hasNavBar(Activity activity, View rootView) {
        if (activity == null || rootView == null || VERSION.SDK_INT < 17) {
            return true;
        }
        boolean hasMenuKey = ViewConfiguration.get(activity.getApplicationContext()).hasPermanentMenuKey();
        if (KeyCharacterMap.deviceHasKey(4) || hasMenuKey) {
            return true;
        }
        Display d = activity.getWindowManager().getDefaultDisplay();
        DisplayMetrics realDisplayMetrics = new DisplayMetrics();
        d.getRealMetrics(realDisplayMetrics);
        int viewHeight = rootView.getHeight();
        if (viewHeight == 0 || realDisplayMetrics.heightPixels != viewHeight) {
            return true;
        }
        return false;
    }

    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        boolean orientationChanged = true;
        Activity main_activity = this.mActivityWrapper.getActivity();
        Display display = ((WindowManager) main_activity.getSystemService("window")).getDefaultDisplay();
        Point size = new Point();
        if (!(hasNavBar(main_activity, getRootView()) || hasStatusBar(main_activity.getWindow()))) {
            HideSystemUI();
        }
        if ((this.mIsFullScreen || !(hasNavBar(main_activity, getRootView()) || hasStatusBar(main_activity.getWindow()))) && VERSION.SDK_INT >= 17) {
            display.getRealSize(size);
        } else {
            display.getSize(size);
        }
        this.mBoundHeight = size.y;
        this.mBoundWidth = size.x;
        this.mVisibleBoundHeight = height;
        this.mVisibleBoundWidth = width;
        nativeOnFormatChangeListener(format);
        if (!this.mSurfaceValid) {
            this.mSurfaceValid = true;
            this.mActivityWrapper.onSurfaceInitialized();
            setMultitouchMode(nativeGetMultitouchMode());
        }
        if (this.mSurfaceValid) {
            int orientation = getResources().getConfiguration().orientation;
            if (orientation != this.mCurrentOrientation) {
                showSoftKeyboard(false);
                nativeDispatchUserTriggeredSkDeactivateEvent();
                this.mDispatchUserTriggeredSkDeactivate = false;
            } else if ((orientation == 1 || orientation == 2) && height < this.mHt) {
                if (height != 0) {
                    if (nativePerformWindowPanning(orientation, this.mHt - height)) {
                        this.mSurfaceChangedForSoftKeyboard = true;
                        return;
                    }
                }
                return;
            }
            if (this.mCurrentOrientation == orientation) {
                orientationChanged = false;
            }
            this.mCurrentOrientation = orientation;
            this.mWd = width;
            this.mHt = height;
            nativeOnSizeChangedListener(this.mWd, this.mHt, orientationChanged);
            OrientationManager orientationManager = OrientationManager.getOrientationManager();
            if (orientationManager.mDispatchOrientationChangePending) {
                orientationManager.nativeOrientationChanged(orientationManager.mBeforeOrientation, orientationManager.mAfterOrientation);
                orientationManager.mDispatchOrientationChangePending = false;
            }
            nativeForceReDraw();
            forceSoftKeyboardDown();
        }
    }

    public void forceSoftKeyboardDown() {
        nativeShowOriginalRect();
        setScrollTo(0);
        if (this.mDispatchUserTriggeredSkDeactivate && this.mSurfaceChangedForSoftKeyboard) {
            nativeDispatchUserTriggeredSkDeactivateEvent();
        }
        nativeSetKeyboardVisible(false);
        this.mDispatchUserTriggeredSkDeactivate = true;
        this.mSurfaceChangedForSoftKeyboard = false;
    }

    public boolean isSurfaceValid() {
        return this.mSurfaceValid;
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
        this.mSurfaceValid = false;
        if (this.mFlashEGL != null) {
            this.mFlashEGL.DestroyWindowSurface();
        }
        this.mActivityWrapper.onSurfaceDestroyed();
        this.mActivityWrapper.planeBreakCascade();
    }

    public void showSoftKeyboard(boolean show, View view) {
        AIRLogger.m0d(LOG_TAG, "showSoftKeyboard show: " + show);
        InputMethodManager imm = getInputMethodManager();
        if (show) {
            imm.showSoftInput(view, 0, this.mInputMethodReceiver);
            return;
        }
        if (this.mSurfaceChangedForSoftKeyboard) {
            this.mDispatchUserTriggeredSkDeactivate = false;
        }
        imm.hideSoftInputFromWindow(getWindowToken(), 0);
        if (this.mInputConnection != null) {
            this.mInputConnection.Reset();
        }
        nativeSetKeyboardVisible(false);
    }

    public void showSoftKeyboard(boolean show) {
        showSoftKeyboard(show, this);
    }

    public void updateFocusedStageWebView(AndroidWebView webView, boolean focused) {
        if (focused) {
            this.mFocusedWebView = webView;
        } else if (this.mFocusedWebView == webView) {
            this.mFocusedWebView = null;
        }
    }

    public boolean isStageWebViewInFocus() {
        if (this.mFocusedWebView != null) {
            return this.mFocusedWebView.isInTextEditingMode();
        }
        return false;
    }

    public long panStageWebViewInFocus() {
        if (this.mFocusedWebView == null) {
            return 0;
        }
        this.mResizedWebView = this.mFocusedWebView;
        return this.mFocusedWebView.updateViewBoundsWithKeyboard(this.mHt);
    }

    public void updateFocusedStageText(AndroidStageText stageText, boolean focused) {
        if (focused) {
            this.mFocusedStageText = stageText;
        } else if (this.mFocusedStageText == stageText) {
            this.mFocusedStageText = null;
        }
    }

    public boolean isStageTextInFocus() {
        return this.mFocusedStageText != null;
    }

    public long panStageTextInFocus() {
        if (this.mFocusedStageText == null) {
            return 0;
        }
        this.mResizedStageText = this.mFocusedStageText;
        return this.mFocusedStageText.updateViewBoundsWithKeyboard(this.mHt);
    }

    private boolean IsIMEInFullScreen() {
        return getInputMethodManager().isFullscreenMode();
    }

    public boolean setScrollTo(final int height) {
        this.mSkipHeightFromTop = height;
        final RelativeLayout overlays = this.mActivityWrapper.getOverlaysLayout(false);
        if (overlays != null) {
            post(new Runnable() {
                public void run() {
                    if (height == 0 && AIRWindowSurfaceView.this.mResizedWebView != null) {
                        AIRWindowSurfaceView.this.mResizedWebView.resetGlobalBounds();
                        AIRWindowSurfaceView.this.mResizedWebView = null;
                    }
                    if (height == 0 && AIRWindowSurfaceView.this.mResizedStageText != null) {
                        AIRWindowSurfaceView.this.mResizedStageText.resetGlobalBounds();
                        AIRWindowSurfaceView.this.mResizedStageText = null;
                    }
                    overlays.setPadding(0, -height, 0, 0);
                    overlays.requestLayout();
                }
            });
        }
        return true;
    }

    private void setSurfaceFormatImpl(boolean async, final int format) {
        if (async) {
            post(new Runnable() {
                public void run() {
                    AIRWindowSurfaceView.this.mSurfaceHolder.setFormat(format);
                    AIRWindowSurfaceView.this.mCurrentSurfaceFormat = format;
                }
            });
            return;
        }
        this.mSurfaceHolder.setFormat(format);
        this.mCurrentSurfaceFormat = format;
    }

    public void setSurfaceFormat(boolean async) {
        if (!this.mActivityWrapper.useRGB565()) {
            if (!(this.mNeedsCompositingSurface || this.mActivityWrapper.needsCompositingSurface())) {
                AndroidActivityWrapper androidActivityWrapper = this.mActivityWrapper;
                if (AndroidActivityWrapper.isGingerbread()) {
                    setSurfaceFormatImpl(async, 2);
                    return;
                }
            }
            setSurfaceFormatImpl(async, 1);
        } else if (this.mNeedsCompositingSurface) {
            setSurfaceFormatImpl(async, 1);
        } else {
            setSurfaceFormatImpl(async, 4);
        }
    }

    public void setCompositingHint(boolean needsCompositingSurface) {
        this.mNeedsCompositingSurface = needsCompositingSurface;
        if (!needsCompositingSurface || this.mCurrentSurfaceFormat != 1) {
            if (needsCompositingSurface || this.mCurrentSurfaceFormat != 2) {
                setSurfaceFormat(true);
            }
        }
    }

    protected void draw(int x, int y, int wd, int ht, Bitmap bm) {
        if (this.mSurfaceValid) {
            Canvas c;
            Rect dst = new Rect(x, y, x + wd, y + ht);
            Rect intersection = dst;
            int skipHeight = this.mSkipHeightFromTop;
            if (skipHeight != 0) {
                Rect viewRect = new Rect(0, skipHeight, this.mWd, this.mHt);
                if (Rect.intersects(dst, viewRect)) {
                    intersection = new Rect(dst);
                    intersection.intersect(viewRect);
                    intersection.top -= skipHeight;
                    intersection.bottom -= skipHeight;
                    if (this.mIsFullScreen) {
                        intersection.union(new Rect(0, intersection.bottom, this.mWd, this.mHt));
                    }
                    c = this.mSurfaceHolder.lockCanvas(intersection);
                    if (!this.mIsFullScreen && intersection.bottom > this.mHt - skipHeight) {
                        intersection.bottom = this.mHt - skipHeight;
                    }
                } else {
                    return;
                }
            }
            c = this.mSurfaceHolder.lockCanvas(intersection);
            try {
                synchronized (this.mSurfaceHolder) {
                    c.clipRect(intersection);
                    if (skipHeight != 0 && this.mIsFullScreen) {
                        c.drawColor(-16777216);
                    }
                    if (this.mMaliWorkaround) {
                        this.mPaint = null;
                        c.drawColor(0, Mode.CLEAR);
                    } else if (this.mPaint == null && this.mCurrentSurfaceFormat != 4) {
                        this.mPaint = new Paint();
                        this.mPaint.setXfermode(new PorterDuffXfermode(Mode.SRC));
                        this.mPaint.setFilterBitmap(false);
                    }
                    c.drawBitmap(bm, 0.0f, (float) (-skipHeight), this.mPaint);
                }
                if (c != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(c);
                }
            } catch (Exception e) {
                if (c != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(c);
                }
            } catch (Throwable th) {
                if (c != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(c);
                }
            }
            if (this.mInputConnection != null) {
                this.mInputConnection.updateIMEText();
            }
        }
    }

    protected void drawScaled(int srcX, int srcY, int srcWd, int srcHt, Bitmap bm, int dstX, int dstY, int dstWd, int dstHt, boolean fullsc, int bgColor) {
        if (this.mSurfaceValid) {
            Canvas c = null;
            try {
                Rect lockedDst;
                Rect dstRect = new Rect(dstX, dstY, dstX + dstWd, dstY + dstHt);
                Rect intersection = dstRect;
                if (fullsc) {
                    lockedDst = new Rect(0, 0, this.mWd, this.mHt);
                } else {
                    lockedDst = new Rect(dstX, dstY, dstX + dstWd, dstY + dstHt);
                }
                if (this.mSkipHeightFromTop != 0) {
                    int skipHeight = this.mSkipHeightFromTop;
                    Rect viewRect = new Rect(0, skipHeight, this.mWd, this.mHt);
                    if (Rect.intersects(dstRect, viewRect)) {
                        intersection = new Rect(dstRect);
                        intersection.intersect(viewRect);
                        intersection.top -= skipHeight;
                        intersection.bottom -= skipHeight;
                        dstRect = intersection;
                        if (!fullsc) {
                            lockedDst = intersection;
                        }
                        if (!fullsc && intersection.bottom > this.mHt - skipHeight) {
                            intersection.bottom = this.mHt - skipHeight;
                        }
                    } else if (null != null) {
                        this.mSurfaceHolder.unlockCanvasAndPost(null);
                        return;
                    } else {
                        return;
                    }
                }
                Rect srcRect = new Rect(srcX, srcY, srcX + srcWd, srcY + srcHt);
                c = this.mSurfaceHolder.lockCanvas(lockedDst);
                synchronized (this.mSurfaceHolder) {
                    if (fullsc) {
                        c.drawRGB(Color.red(bgColor), Color.green(bgColor), Color.blue(bgColor));
                    }
                    if (this.mMaliWorkaround) {
                        this.mPaint = null;
                        c.drawColor(0, Mode.CLEAR);
                    } else if (this.mPaintScaled == null && this.mCurrentSurfaceFormat != 4) {
                        this.mPaintScaled = new Paint();
                        this.mPaintScaled.setXfermode(new PorterDuffXfermode(Mode.SRC));
                    }
                    c.drawBitmap(bm, srcRect, dstRect, this.mPaintScaled);
                }
                if (c != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(c);
                }
            } catch (Exception e) {
                if (c != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(c);
                }
            } catch (Throwable th) {
                if (c != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(c);
                }
            }
            if (this.mInputConnection != null) {
                this.mInputConnection.updateIMEText();
            }
        }
    }

    public void drawBitmap(int srcX, int srcY, int srcWd, int srcHt, Bitmap bm) {
        draw(srcX, srcY, srcWd, srcHt, bm);
    }

    public void drawBitmap(int srcX, int srcY, int srcWd, int srcHt, Bitmap bm, int dstX, int dstY, int dstWd, int dstHt, boolean fullsc, int bgColor) {
        drawScaled(srcX, srcY, srcWd, srcHt, bm, dstX, dstY, dstWd, dstHt, fullsc, bgColor);
    }

    public boolean getIsFullScreen() {
        return this.mIsFullScreen;
    }

    private static boolean supportsSystemUiVisibilityAPI() {
        return VERSION.SDK_INT >= 11;
    }

    private static boolean supportsSystemUiFlags() {
        return VERSION.SDK_INT >= 14;
    }

    private boolean hasStatusBar(Window window) {
        Rect visibleRect = new Rect();
        window.getDecorView().getWindowVisibleDisplayFrame(visibleRect);
        return visibleRect.top > 0;
    }

    private void HideSystemUI() {
        if (supportsSystemUiVisibilityAPI()) {
            View v;
            DoSetOnSystemUiVisibilityChangeListener();
            if (supportsSystemUiFlags()) {
                v = this;
            } else {
                v = this;
            }
            if (VERSION.SDK_INT >= 19) {
                setSystemUiVisibility(5895);
            }
        }
    }

    private void DoSetOnSystemUiVisibilityChangeListener() {
        final AIRWindowSurfaceView theThis = this;
        setOnSystemUiVisibilityChangeListener(new OnSystemUiVisibilityChangeListener() {
            public void onSystemUiVisibilityChange(int visibility) {
                theThis.setOnSystemUiVisibilityChangeListener(null);
                if (theThis.getIsFullScreen()) {
                    AIRWindowSurfaceView.this.HideSystemUI();
                    theThis.nativeDispatchFullScreenEvent(true);
                    return;
                }
                theThis.nativeDispatchFullScreenEvent(false);
            }
        });
    }

    public void setFullScreen() {
        if (!this.mIsFullScreen) {
            this.mIsFullScreen = true;
            this.mActivityWrapper.setIsFullScreen(this.mIsFullScreen);
            if (supportsSystemUiVisibilityAPI()) {
                DoSetOnSystemUiVisibilityChangeListener();
                HideSystemUI();
            }
            this.mActivityWrapper.planeBreakCascade();
        }
        Activity main_activity = this.mActivityWrapper.getActivity();
        if (main_activity != null) {
            Window main_window = main_activity.getWindow();
            if (Build.MANUFACTURER.equalsIgnoreCase("SAMSUNG") || !supportsSystemUiVisibilityAPI() || hasStatusBar(main_window)) {
                main_window.setFlags(1024, 1024);
            }
        }
    }

    public void clearFullScreen() {
        this.mIsFullScreen = false;
        this.mActivityWrapper.setIsFullScreen(this.mIsFullScreen);
        if (supportsSystemUiVisibilityAPI()) {
            if (supportsSystemUiFlags()) {
                DoSetOnSystemUiVisibilityChangeListener();
                setSystemUiVisibility(0);
            } else {
                DoSetOnSystemUiVisibilityChangeListener();
                setSystemUiVisibility(0);
            }
        }
        Activity main_activity = this.mActivityWrapper.getActivity();
        if (main_activity != null) {
            main_activity.getWindow().clearFlags(1024);
        }
        this.mActivityWrapper.planeBreakCascade();
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

    public int getColorDepth() {
        if (this.mCurrentSurfaceFormat == 4) {
            return kTouchActionHoverBegin;
        }
        Activity main_activity = this.mActivityWrapper.getActivity();
        if (main_activity == null) {
            return 32;
        }
        Display display = ((WindowManager) main_activity.getSystemService("window")).getDefaultDisplay();
        PixelFormat info = new PixelFormat();
        PixelFormat.getPixelFormatInfo(display.getPixelFormat(), info);
        return info.bitsPerPixel;
    }

    public int getAppSpecifiedPixelFormat() {
        if (this.mActivityWrapper.useRGB565()) {
            return kTouchActionHoverBegin;
        }
        return 32;
    }

    public void showActionScript2Warning() {
        Activity main_activity = this.mActivityWrapper.getActivity();
        if (main_activity != null) {
            Builder errorDialog = new Builder(main_activity);
            TextView text = new TextView(main_activity);
            text.setText("Your application is attempting to run ActionScript2.0, which is not supported on smart phone profile. \nSee the Adobe Developer Connection for more info www.adobe.com/devnet");
            Linkify.addLinks(text, 1);
            errorDialog.setView(text);
            errorDialog.setTitle("Action Script 2.0");
            errorDialog.setNeutralButton("OK", new C00174());
            errorDialog.show();
        }
    }

    public boolean IsLandScape() {
        return this.mCurrentOrientation == 2;
    }

    public boolean onCheckIsTextEditor() {
        return true;
    }

    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        if (this.mActivityWrapper.isApplicationLaunched() && nativeIsEditable()) {
            outAttrs.imeOptions |= 1073741824;
            outAttrs.imeOptions |= 268435456;
            outAttrs.imeOptions |= 6;
            int keyboard = nativeGetSoftKeyboardType();
            outAttrs.inputType |= 1;
            switch (keyboard) {
                case 2:
                    outAttrs.inputType = 17;
                    break;
                case 3:
                    outAttrs.inputType = 2;
                    break;
                case 4:
                    outAttrs.inputType = 1;
                    break;
                case 5:
                    outAttrs.inputType = 33;
                    break;
                case 6:
                    outAttrs.inputType = 3;
                    break;
                case 7:
                    outAttrs.inputType = 8194;
                    break;
            }
            if (nativeIsPasswordField()) {
                outAttrs.inputType |= 128;
            }
            if (nativeIsMultiLineTextField()) {
                outAttrs.inputType |= 131072;
            }
            this.mInputConnection = new AndroidInputConnection(this);
            outAttrs.initialSelStart = -1;
            outAttrs.initialSelEnd = -1;
            outAttrs.initialCapsMode = 0;
        } else {
            this.mInputConnection = null;
            outAttrs.imeOptions = 268435456;
        }
        return this.mInputConnection;
    }

    public void RestartInput() {
        this.mMetaShiftState = MetaKeyState.INACTIVE;
        this.mMetaAltState = MetaKeyState.INACTIVE;
        InputMethodManager imm = getInputMethodManager();
        if (imm != null) {
            imm.restartInput(this);
        }
        if (this.mInputConnection != null) {
            this.mInputConnection.Reset();
        }
    }

    public InputMethodManager getInputMethodManager() {
        return (InputMethodManager) getContext().getSystemService("input_method");
    }

    public boolean performLongClick() {
        if (!this.mWindowHasFocus) {
            return false;
        }
        Rect bounds = nativeGetTextBoxBounds();
        if (bounds == null) {
            return false;
        }
        if ((this.mLastTouchedXCoord <= ((float) bounds.left) || this.mLastTouchedXCoord >= ((float) bounds.right) || this.mLastTouchedYCoord <= ((float) bounds.top) || this.mLastTouchedYCoord >= ((float) bounds.bottom)) && !this.mTrackBallPressed) {
            return false;
        }
        this.mTrackBallPressed = false;
        if (super.performLongClick()) {
            return true;
        }
        return false;
    }

    protected void onCreateContextMenu(ContextMenu menu) {
        super.onCreateContextMenu(menu);
        if (!this.mIsFullScreen || nativeIsFullScreenInteractive()) {
            ClipboardManager clip = (ClipboardManager) getContext().getSystemService("clipboard");
            MenuHandler handler = new MenuHandler();
            boolean isEditable = nativeIsEditable();
            boolean isSelectable = nativeIsTextFieldSelectable();
            if (isSelectable || isEditable) {
                if (isSelectable) {
                    boolean textPresent = nativeGetTextContentLength() > 0;
                    if (textPresent) {
                        menu.add(0, 0, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_SELECT_ALL)).setOnMenuItemClickListener(handler).setAlphabeticShortcut('a');
                        if (nativeIsTextFieldInSelectionMode()) {
                            menu.add(0, 8, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_STOP_SELECTING_TEXT)).setOnMenuItemClickListener(handler);
                        } else {
                            menu.add(0, 7, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_SELECT_TEXT)).setOnMenuItemClickListener(handler);
                        }
                    }
                    if (!nativeIsPasswordField() && textPresent) {
                        boolean isTextSelected = nativeIsTextSelected();
                        if (isEditable) {
                            if (isTextSelected) {
                                menu.add(0, 1, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_CUT_STRING)).setOnMenuItemClickListener(handler).setAlphabeticShortcut('x');
                            } else {
                                menu.add(0, 2, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_CUT_ALL_STRING)).setOnMenuItemClickListener(handler);
                            }
                        }
                        if (isTextSelected) {
                            menu.add(0, 3, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_COPY_STRING)).setOnMenuItemClickListener(handler).setAlphabeticShortcut('c');
                        } else {
                            menu.add(0, 4, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_COPY_ALL_STRING)).setOnMenuItemClickListener(handler);
                        }
                    }
                }
                if (isEditable) {
                    if (clip != null && clip.hasText()) {
                        menu.add(0, 5, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_PASTE_STRING)).setOnMenuItemClickListener(handler).setAlphabeticShortcut('v');
                    }
                    menu.add(0, 6, 0, AndroidLocale.GetLocalizedString(STRING_ID.IDA_INPUT_METHOD_STRING)).setOnMenuItemClickListener(handler);
                }
                this.mEatTouchRelease = true;
                this.mContextMenuVisible = true;
                menu.setHeaderTitle(AndroidLocale.GetLocalizedString(STRING_ID.IDA_CONTEXT_MENU_TITLE_STRING));
            }
        }
    }

    private void postCheckLongPress() {
        if (this.mLongPressCheck == null) {
            this.mLongPressCheck = new CheckLongPress();
        }
        postDelayed(this.mLongPressCheck, 500);
    }

    public boolean onTextBoxContextMenuItem(int id) {
        ClipboardManager clip = (ClipboardManager) getContext().getSystemService("clipboard");
        switch (id) {
            case 0:
                nativeSelectAllText();
                break;
            case 1:
                String cutPortion = nativeGetSelectedText();
                if (cutPortion != null) {
                    nativeCutText(false);
                    if (nativeIsPasswordField()) {
                        cutPortion = Utils.ReplaceTextContentWithStars(cutPortion);
                    }
                    clip.setText(cutPortion);
                }
                SetSelectionMode(false);
                break;
            case 2:
                CharSequence cutAll = nativeGetTextContent().text;
                if (cutAll != null) {
                    nativeCutText(true);
                    if (nativeIsPasswordField()) {
                        cutAll = Utils.ReplaceTextContentWithStars(cutAll.toString());
                    }
                    clip.setText(cutAll);
                    break;
                }
                break;
            case 3:
                String copy = nativeGetSelectedText();
                if (copy != null) {
                    if (nativeIsPasswordField()) {
                        copy = Utils.ReplaceTextContentWithStars(copy);
                    }
                    clip.setText(copy);
                }
                SetSelectionMode(false);
                break;
            case 4:
                CharSequence copyAll = nativeGetTextContent().text;
                if (copyAll != null) {
                    if (nativeIsPasswordField()) {
                        copyAll = Utils.ReplaceTextContentWithStars(copyAll.toString());
                    }
                    clip.setText(copyAll);
                    break;
                }
                break;
            case 5:
                CharSequence toPaste = clip.getText();
                if (toPaste != null) {
                    nativeInsertText(toPaste.toString());
                }
                SetSelectionMode(false);
                break;
            case 6:
                InputMethodManager imm = getInputMethodManager();
                if (imm != null) {
                    imm.showInputMethodPicker();
                    break;
                }
                break;
            case 7:
                SetSelectionMode(true);
                break;
            case 8:
                SetSelectionMode(false);
                break;
            default:
                return false;
        }
        if (this.mInputConnection != null) {
            this.mInputConnection.updateIMEText();
        }
        return true;
    }

    private boolean IsTouchEventHandlingAllowed(int stage, float xCoord, float yCoord) {
        boolean bIsPointInTextBox = IsPointInTextBox(xCoord, yCoord, stage);
        if (stage == 2) {
            this.mDownX = xCoord;
            this.mDownY = yCoord;
            this.mEatTouchRelease = false;
            if (!bIsPointInTextBox) {
                return true;
            }
            postCheckLongPress();
            return true;
        } else if (stage == 1) {
            if (!bIsPointInTextBox) {
                return true;
            }
            if (!IsTouchMove(xCoord, yCoord)) {
                return false;
            }
            if (this.mLongPressCheck == null) {
                return true;
            }
            removeCallbacks(this.mLongPressCheck);
            return true;
        } else if (stage != 4 || this.mLongPressCheck == null) {
            return true;
        } else {
            removeCallbacks(this.mLongPressCheck);
            return true;
        }
    }

    private boolean IsTouchMove(float x, float y) {
        float scrollX = this.mDownX - x;
        float scrollY = this.mDownY - y;
        if (((float) Math.sqrt((double) ((scrollX * scrollX) + (scrollY * scrollY)))) >= ((float) this.mScaledTouchSlop)) {
            return true;
        }
        return false;
    }

    private boolean IsPointInTextBox(float x, float y, int stage) {
        boolean bIsPointInTextBox;
        if (stage == 2) {
            this.mTextBoxBounds = nativeGetTextBoxBounds();
        }
        if (this.mTextBoxBounds == null || ((int) x) <= this.mTextBoxBounds.left || ((int) x) >= this.mTextBoxBounds.right || ((int) y) <= this.mTextBoxBounds.top || ((int) y) >= this.mTextBoxBounds.bottom) {
            bIsPointInTextBox = false;
        } else {
            bIsPointInTextBox = true;
        }
        if (stage == 4) {
            this.mTextBoxBounds = null;
        }
        return bIsPointInTextBox;
    }

    private void HandleMetaKeyAction(KeyEvent event) {
        switch (event.getKeyCode()) {
            case 57:
            case 58:
                if (event.getRepeatCount() == 0) {
                    this.mMetaAltState = GetMetaKeyState(this.mMetaAltState, event.isAltPressed(), false);
                    return;
                }
                return;
            case 59:
            case 60:
                if (event.getRepeatCount() == 0) {
                    this.mMetaShiftState = GetMetaKeyState(this.mMetaShiftState, event.isShiftPressed(), false);
                    return;
                }
                return;
            default:
                this.mMetaShiftState = GetMetaKeyState(this.mMetaShiftState, event.isShiftPressed(), true);
                this.mMetaAltState = GetMetaKeyState(this.mMetaAltState, event.isAltPressed(), true);
                return;
        }
    }

    private MetaKeyState GetMetaKeyState(MetaKeyState curState, boolean isPressed, boolean isNormalKey) {
        if (isNormalKey) {
            switch (curState) {
                case INACTIVE:
                case PRESSED:
                    return isPressed ? MetaKeyState.PRESSED : MetaKeyState.INACTIVE;
                case ACTIVE:
                    return isPressed ? MetaKeyState.PRESSED : MetaKeyState.INACTIVE;
                case LOCKED:
                    return MetaKeyState.LOCKED;
                default:
                    return MetaKeyState.INACTIVE;
            }
        } else if (!isPressed) {
            return MetaKeyState.INACTIVE;
        } else {
            switch (curState) {
                case INACTIVE:
                case PRESSED:
                    return MetaKeyState.ACTIVE;
                case ACTIVE:
                    return MetaKeyState.LOCKED;
                default:
                    return MetaKeyState.INACTIVE;
            }
        }
    }

    int GetMetaKeyCharacter(KeyEvent event) {
        int state = 0;
        if (this.mMetaShiftState == MetaKeyState.LOCKED || this.mMetaShiftState == MetaKeyState.ACTIVE) {
            state = 0 | 1;
        }
        if (this.mMetaAltState == MetaKeyState.LOCKED || this.mMetaAltState == MetaKeyState.ACTIVE) {
            state |= 2;
        }
        return event.getUnicodeChar(state);
    }

    private boolean AllowOSToHandleKeys(int keyCode) {
        switch (keyCode) {
            case 24:
            case 25:
            case 26:
                return true;
            default:
                return false;
        }
    }

    public void HideSoftKeyboardOnWindowFocusChange() {
        this.mHideSoftKeyboardOnWindowFocusChange = true;
    }

    private boolean HandleShortCuts(int keyCode, KeyEvent event) {
        if (keyCode == 23) {
            if (this.mTrackBallPressed || this.mContextMenuVisible) {
                return true;
            }
            this.mTrackBallPressed = true;
            postCheckLongPress();
            return false;
        } else if (!event.isAltPressed()) {
            return false;
        } else {
            switch (keyCode) {
                case 19:
                    nativeMoveCursor(2);
                    return true;
                case 20:
                    nativeMoveCursor(3);
                    return true;
                case 21:
                    nativeMoveCursor(0);
                    return true;
                case FlashPermission.CAMERA_ROLL /*22*/:
                    nativeMoveCursor(1);
                    return true;
                case 67:
                    nativeDeleteTextLine();
                    return true;
                default:
                    return false;
            }
        }
    }

    public void setInputConnection(AndroidInputConnection ic) {
        this.mInputConnection = ic;
    }

    public void setFlashEGL(FlashEGL egl) {
        this.mFlashEGL = egl;
    }

    public boolean IsPasswordVisibleSettingEnabled() {
        try {
            return System.getInt(getContext().getContentResolver(), "show_password") == 1;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean IsTouchUpHandlingAllowed() {
        if (this.mEatTouchRelease) {
            return false;
        }
        return true;
    }

    public void SetSelectionMode(boolean mode) {
        nativeDispatchSelectionChangeEvent(mode);
    }

    public boolean onKeyPreIme(int keyCode, KeyEvent event) {
        if (keyCode == 4 && event.getAction() == 0) {
            DispatchSoftKeyboardEventOnBackKey();
        }
        return false;
    }

    public void DispatchSoftKeyboardEventOnBackKey() {
        if ((this.mIsFullScreen && !this.mSurfaceChangedForSoftKeyboard) || this.mFlashEGL != null || IsIMEInFullScreen() || !(this.mSurfaceChangedForSoftKeyboard || nativeIsEditable())) {
            nativeDispatchUserTriggeredSkDeactivateEvent();
            if (!(this.mSurfaceChangedForSoftKeyboard || nativeIsEditable())) {
                nativeShowOriginalRect();
            }
        }
        if (this.mIsFullScreen) {
            HideSystemUI();
        }
    }

    public boolean IsSurfaceChangedForSoftKeyboard() {
        return this.mSurfaceChangedForSoftKeyboard;
    }

    public int getKeyboardHeight() {
        return this.mHt - getVisibleBoundHeight();
    }

    public void SetSurfaceChangedForSoftKeyboard(boolean val) {
        this.mSurfaceChangedForSoftKeyboard = val;
    }

    public VideoView getVideoView() {
        if (this.mVideoView == null) {
            this.mVideoView = new VideoViewAIR(getContext(), this.mActivityWrapper);
        }
        return this.mVideoView;
    }

    public boolean gatherTransparentRegion(Region region) {
        int[] origin = new int[2];
        getLocationInWindow(origin);
        region.op(origin[0], origin[1], this.mVisibleBoundWidth, this.mVisibleBoundHeight, Op.REPLACE);
        return false;
    }
}
