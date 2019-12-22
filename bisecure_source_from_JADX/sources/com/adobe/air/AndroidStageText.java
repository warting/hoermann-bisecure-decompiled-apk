package com.adobe.air;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.graphics.drawable.shapes.Shape;
import android.os.Build.VERSION;
import android.text.InputFilter;
import android.text.InputFilter.LengthFilter;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.method.KeyListener;
import android.text.method.PasswordTransformationMethod;
import android.text.method.SingleLineTransformationMethod;
import android.util.AttributeSet;
import android.view.ActionMode;
import android.view.ActionMode.Callback;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.TextView.BufferType;
import android.widget.TextView.OnEditorActionListener;
import com.adobe.air.AndroidActivityWrapper.ActivityState;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class AndroidStageText implements StateChangeCallback {
    private static final int ALIGN_Center = 2;
    private static final int ALIGN_End = 5;
    private static final int ALIGN_Justify = 3;
    private static final int ALIGN_Left = 0;
    private static final int ALIGN_Right = 1;
    private static final int ALIGN_Start = 4;
    private static final int AUTO_CAP_All = 3;
    private static final int AUTO_CAP_None = 0;
    private static final int AUTO_CAP_Sentence = 2;
    private static final int AUTO_CAP_Word = 1;
    private static final int FOCUS_DOWN = 3;
    private static final int FOCUS_NONE = 1;
    private static final int FOCUS_UP = 2;
    private static Map<String, Typeface> FontMap = new HashMap();
    private static final int KEYBOARDTYPE_Contact = 4;
    private static final int KEYBOARDTYPE_DecimalPad = 7;
    private static final int KEYBOARDTYPE_Default = 0;
    private static final int KEYBOARDTYPE_Email = 5;
    private static final int KEYBOARDTYPE_Number = 3;
    private static final int KEYBOARDTYPE_Phone = 6;
    private static final int KEYBOARDTYPE_Punctuation = 1;
    private static final int KEYBOARDTYPE_Url = 2;
    private static final String LOG_TAG = "AndroidStageText";
    private static boolean MapCreate = false;
    private static final int RETURN_KEY_Default = 0;
    private static final int RETURN_KEY_Done = 1;
    private static final int RETURN_KEY_Go = 2;
    private static final int RETURN_KEY_Next = 3;
    private static final int RETURN_KEY_Search = 4;
    private boolean enterKeyDispatched = false;
    private AIRWindowSurfaceView mAIRSurface;
    private int mAlign = 4;
    private int mAutoCapitalize = 0;
    private boolean mAutoCorrect = false;
    private BackgroundBorderDrawable mBBDrawable;
    private int mBackgroundColor = -1;
    private boolean mBold = false;
    private int mBorderColor = -16777216;
    private Rect mBounds = new Rect();
    private ViewGroup mClip = null;
    private Rect mClipBounds = null;
    private Context mContext;
    private boolean mDisableInteraction = false;
    private boolean mDisplayAsPassword = false;
    private boolean mEditable = true;
    private String mFont;
    private int mFontSize;
    private Rect mGlobalBounds = new Rect();
    private boolean mInContentMenu = false;
    private long mInternalReference;
    private boolean mItalic = false;
    private int mKeyboardType = 0;
    private RelativeLayout mLayout;
    private String mLocale = null;
    private int mMaxChars = 0;
    private boolean mMenuInvoked = false;
    private boolean mMultiline = false;
    private boolean mNotifyLayoutComplete = false;
    private boolean mPreventDefault = false;
    private String mRestrict = null;
    private int mReturnKeyLabel = 0;
    private KeyListener mSavedKeyListener = null;
    private double mScaleFactor = 1.0d;
    private boolean mSelectionChanged = false;
    private int mTextColor = -16777216;
    private AndroidStageTextEditText mTextView;
    private AndroidStageTextImpl mView;
    private Rect mViewBounds = null;

    /* renamed from: com.adobe.air.AndroidStageText$1 */
    class C00291 implements OnEditorActionListener {
        C00291() {
        }

        public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
            AndroidStageText.this.enterKeyDispatched = true;
            boolean retDVal;
            switch (actionId) {
                case 2:
                case 3:
                    retDVal = AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, 0, 66);
                    AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, 1, 66);
                    return retDVal;
                case 5:
                    retDVal = AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, 0, 66);
                    AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, 1, 66);
                    return retDVal;
                case 6:
                    retDVal = AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, 0, 66);
                    AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, 1, 66);
                    AndroidStageText.this.mAIRSurface.DispatchSoftKeyboardEventOnBackKey();
                    return false;
                default:
                    return false;
            }
        }
    }

    public class AndroidStageTextEditText extends EditText {
        private int mLastFocusDirection = 0;
        private View m_focusedChildView = null;
        private boolean m_hasFocus = false;
        private boolean m_inRequestChildFocus = false;

        private class DelayedTransparentRegionUpdate implements Runnable {
            private AIRWindowSurfaceView m_AIRSurface;
            private int m_freqMsecs;
            private int m_nUpdates;
            private AndroidStageTextImpl m_stageText;

            public DelayedTransparentRegionUpdate(int nUpdates, int freqMsecs, AndroidStageTextImpl stageText, AIRWindowSurfaceView surface) {
                this.m_nUpdates = nUpdates;
                this.m_freqMsecs = freqMsecs;
                this.m_stageText = stageText;
                this.m_AIRSurface = surface;
            }

            public void run() {
                if (!(this.m_stageText == null || this.m_AIRSurface == null)) {
                    this.m_stageText.requestTransparentRegion(this.m_AIRSurface);
                }
                int i = this.m_nUpdates - 1;
                this.m_nUpdates = i;
                if (i > 0) {
                    this.m_stageText.postDelayed(this, (long) this.m_freqMsecs);
                }
            }
        }

        public AndroidStageTextEditText(Context context) {
            super(context);
            setBackgroundDrawable(null);
            setCompoundDrawablePadding(0);
            setPadding(0, 0, 0, 0);
        }

        public AndroidStageTextEditText(Context context, AttributeSet attrs) {
            super(context, attrs);
        }

        public AndroidStageTextEditText(Context context, AttributeSet attrs, int defStyle) {
            super(context, attrs, defStyle);
        }

        protected void onDraw(Canvas canvas) {
            if (AndroidStageText.this.mClipBounds != null) {
                canvas.save();
                int dx = -AndroidStageText.this.mViewBounds.left;
                int dy = -AndroidStageText.this.mViewBounds.top;
                canvas.clipRect(new Rect(AndroidStageText.this.mClipBounds.left + dx, AndroidStageText.this.mClipBounds.top + dy, AndroidStageText.this.mClipBounds.right + dx, AndroidStageText.this.mClipBounds.bottom + dy));
                super.onDraw(canvas);
                canvas.restore();
                return;
            }
            super.onDraw(canvas);
        }

        public boolean dispatchTouchEvent(MotionEvent event) {
            if (!this.m_hasFocus) {
                requestFocus();
            }
            return super.dispatchTouchEvent(event);
        }

        protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
            AndroidStageText stageText = AndroidStageText.this;
            super.onLayout(changed, left, top, right, bottom);
            if (stageText.mNotifyLayoutComplete) {
                stageText.mNotifyLayoutComplete = false;
                stageText.dispatchCompleteEvent(stageText.mInternalReference);
            }
            AndroidStageText.this.mView.postDelayed(new DelayedTransparentRegionUpdate(10, 75, AndroidStageText.this.mView, AndroidStageText.this.mAIRSurface), 75);
        }

        private void dispatchFocusEvent(boolean focused, int direction) {
            if (this.m_hasFocus != focused) {
                this.m_hasFocus = focused;
                AndroidStageText stageText = AndroidStageText.this;
                if (stageText.mInternalReference != 0) {
                    if (stageText.mAIRSurface != null) {
                        stageText.mAIRSurface.updateFocusedStageText(stageText, this.m_hasFocus);
                    }
                    if (focused) {
                        stageText.dispatchFocusIn(stageText.mInternalReference, direction);
                    }
                }
            }
        }

        protected void onFocusChanged(boolean focused, int direction, Rect previouslyFocusedRect) {
            super.onFocusChanged(focused, direction, previouslyFocusedRect);
            if (direction == 0) {
                direction = this.mLastFocusDirection;
            }
            this.mLastFocusDirection = 0;
            dispatchFocusEvent(focused, direction);
        }

        protected void onTextChanged(CharSequence text, int start, int before, int after) {
            super.onTextChanged(text, start, before, after);
            AndroidStageText stageText = AndroidStageText.this;
            if (stageText.mInternalReference != 0) {
                stageText.dispatchChangeEvent(stageText.mInternalReference);
            }
        }

        public boolean onTouchEvent(MotionEvent e) {
            boolean allUp = true;
            int i = 0;
            while (i < e.getPointerCount()) {
                int action = e.getAction();
                int pointerid = e.getPointerId(i);
                if (e.getPointerCount() == 1 || e.getPointerId(i) == e.getPointerId((65280 & action) >> 8)) {
                    action &= 255;
                    if (!(action == 6 || action == 1)) {
                        allUp = false;
                        break;
                    }
                }
                i++;
            }
            if (allUp) {
                if (VERSION.SDK_INT >= 11 || !AndroidStageText.this.mMenuInvoked) {
                    AndroidStageText.this.invokeSoftKeyboard(AndroidStageText.this.mInternalReference);
                }
                AndroidStageText.this.mMenuInvoked = false;
            }
            return super.onTouchEvent(e);
        }

        public void onCreateContextMenu(ContextMenu menu) {
            AndroidStageText.this.mMenuInvoked = true;
            AndroidStageText.this.mSelectionChanged = false;
            super.onCreateContextMenu(menu);
        }

        public boolean onTextContextMenuItem(int id) {
            AndroidStageText.this.mInContentMenu = true;
            boolean result = super.onTextContextMenuItem(id);
            AndroidStageText.this.mInContentMenu = false;
            AndroidStageText.this.mMenuInvoked = false;
            return result;
        }

        public void onSelectionChanged(int selStart, int selEnd) {
            super.onSelectionChanged(selStart, selEnd);
            AndroidStageText.this.mSelectionChanged = true;
            if (AndroidStageText.this.mAIRSurface != null && AndroidStageText.this.mInContentMenu) {
                AndroidStageText.this.mAIRSurface.showSoftKeyboard(true, AndroidStageText.this.mTextView);
                AndroidStageText.this.invokeSoftKeyboard(AndroidStageText.this.mInternalReference);
            }
        }

        public boolean onKeyDown(int keyCode, KeyEvent event) {
            boolean result = false;
            switch (keyCode) {
                case 4:
                case 66:
                case 82:
                    if (!AndroidStageText.this.enterKeyDispatched) {
                        result = AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, event.getAction(), keyCode);
                        break;
                    }
                    break;
            }
            if (result) {
                return result;
            }
            return super.onKeyDown(keyCode, event);
        }

        public boolean onKeyUp(int keyCode, KeyEvent event) {
            switch (keyCode) {
                case 4:
                case 66:
                case 82:
                    if (!AndroidStageText.this.enterKeyDispatched) {
                        AndroidStageText.this.handleKeyEvent(AndroidStageText.this.mInternalReference, event.getAction(), keyCode);
                        break;
                    }
                    break;
            }
            boolean result = super.onKeyUp(keyCode, event);
            AndroidStageText.this.enterKeyDispatched = false;
            return result;
        }

        public boolean onKeyPreIme(int keyCode, KeyEvent event) {
            if (AndroidStageText.this.mAIRSurface != null && keyCode == 4 && event.getAction() == 0) {
                AndroidStageText.this.mAIRSurface.DispatchSoftKeyboardEventOnBackKey();
            }
            return super.onKeyPreIme(keyCode, event);
        }

        public ActionMode startActionMode(Callback callback) {
            if (AndroidStageText.this.mAIRSurface != null && AndroidStageText.this.mSelectionChanged) {
                AndroidStageText.this.mAIRSurface.showSoftKeyboard(true, AndroidStageText.this.mTextView);
                AndroidStageText.this.invokeSoftKeyboard(AndroidStageText.this.mInternalReference);
                AndroidStageText.this.mSelectionChanged = false;
            }
            return super.startActionMode(callback);
        }
    }

    public class AndroidStageTextImpl extends ScrollView {
        public AndroidStageTextImpl(Context context) {
            super(context);
        }

        public AndroidStageTextImpl(Context context, AttributeSet attrs) {
            super(context, attrs);
        }

        public AndroidStageTextImpl(Context context, AttributeSet attrs, int defStyle) {
            super(context, attrs, defStyle);
        }

        protected void onSizeChanged(int w, int h, int oldw, int oldh) {
            super.onSizeChanged(w, h, oldw, oldh);
        }

        protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
            AndroidStageText stageText = AndroidStageText.this;
            super.onLayout(changed, left, top, right, bottom);
            if (stageText.mNotifyLayoutComplete) {
                stageText.mNotifyLayoutComplete = false;
                stageText.dispatchCompleteEvent(stageText.mInternalReference);
            }
        }

        protected void onDraw(Canvas canvas) {
            if (AndroidStageText.this.mClipBounds != null) {
                canvas.save();
                int dx = -AndroidStageText.this.mViewBounds.left;
                int dy = -AndroidStageText.this.mViewBounds.top;
                canvas.clipRect(new Rect(AndroidStageText.this.mClipBounds.left + dx, AndroidStageText.this.mClipBounds.top + dy, AndroidStageText.this.mClipBounds.right + dx, AndroidStageText.this.mClipBounds.bottom + dy));
                super.onDraw(canvas);
                canvas.restore();
                return;
            }
            super.onDraw(canvas);
        }
    }

    public class BackgroundBorderDrawable extends ShapeDrawable {
        public int mBkgColor = -1;
        public Paint mBkgPaint;
        public int mBorderColor = -16777216;
        public boolean mHaveBkg = false;
        public boolean mHaveBorder = false;

        public BackgroundBorderDrawable() {
            init();
        }

        public BackgroundBorderDrawable(Shape s) {
            super(s);
            init();
        }

        protected void onDraw(Shape shape, Canvas canvas, Paint paint) {
            if (this.mHaveBkg) {
                canvas.drawRect(getBounds(), this.mBkgPaint);
            }
            if (this.mHaveBorder) {
                super.onDraw(shape, canvas, paint);
            }
        }

        private void init() {
            this.mBkgPaint = new Paint(getPaint());
            this.mBkgPaint.setStyle(Style.FILL);
            this.mBkgPaint.setColor(this.mBkgColor);
            getPaint().setStyle(Style.STROKE);
            getPaint().setStrokeWidth(3.0f);
            getPaint().setColor(this.mBorderColor);
        }

        public void setBkgColor(int c) {
            this.mBkgColor = c;
            this.mBkgPaint.setColor(c);
        }

        public void setBorderColor(int c) {
            this.mBorderColor = c;
            getPaint().setColor(c);
        }
    }

    private class RestrictFilter implements InputFilter {
        private static final int kMapSize = 8192;
        private String mPattern = null;
        private byte[] m_map = null;

        public RestrictFilter(String pattern) {
            this.mPattern = pattern;
            if (pattern != null && !"".equals(pattern)) {
                this.m_map = new byte[kMapSize];
                SetAll(false);
                boolean inBackSlash = false;
                boolean inRange = false;
                boolean setFlag = true;
                char lastCode = '\u0000';
                if (pattern.charAt(0) == '^') {
                    SetAll(true);
                }
                for (int i = 0; i < pattern.length(); i++) {
                    char code = pattern.charAt(i);
                    boolean acceptCode = false;
                    if (!inBackSlash) {
                        switch (code) {
                            case '-':
                                inRange = true;
                                break;
                            case '\\':
                                inBackSlash = true;
                                break;
                            case '^':
                                if (setFlag) {
                                    setFlag = false;
                                } else {
                                    setFlag = true;
                                }
                                break;
                            default:
                                acceptCode = true;
                                break;
                        }
                    }
                    acceptCode = true;
                    inBackSlash = false;
                    if (acceptCode) {
                        if (inRange) {
                            for (char j = lastCode; j <= code; j = (char) (j + 1)) {
                                SetCode(j, setFlag);
                            }
                            inRange = false;
                            lastCode = '\u0000';
                        } else {
                            SetCode(code, setFlag);
                            lastCode = code;
                        }
                    }
                }
            }
        }

        public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
            CharSequence result;
            if (this.mPattern == null) {
                result = null;
            } else if (this.m_map == null) {
                result = "";
            } else {
                boolean keepOriginal = true;
                StringBuffer sb = new StringBuffer(end - start);
                int start_index = start;
                if (end - start > 1) {
                    int index = 0;
                    while (start + index < end && dstart + index < dend) {
                        if (source.charAt(start + index) != dest.charAt(dstart + index)) {
                            break;
                        }
                        sb.append(source.charAt(start + index));
                        index++;
                    }
                    start_index = start + index;
                }
                for (int i = start_index; i < end; i++) {
                    char code = source.charAt(i);
                    if (IsCharAvailable(code)) {
                        sb.append(code);
                    } else {
                        keepOriginal = false;
                    }
                }
                if (keepOriginal) {
                    return null;
                }
                if (!(source instanceof Spanned)) {
                    return sb;
                }
                CharSequence sp = new SpannableString(sb);
                TextUtils.copySpansFrom((Spanned) source, start, sb.length(), null, sp, 0);
                return sp;
            }
            return result;
        }

        boolean IsEmpty() {
            return this.mPattern != null;
        }

        boolean IsCharAvailable(char code) {
            if (this.mPattern == null) {
            }
            if (this.m_map == null) {
                return false;
            }
            return (this.m_map[code >> 3] & (1 << (code & 7))) != 0;
        }

        void SetCode(char code, boolean on) {
            if (on) {
                byte[] bArr = this.m_map;
                int i = code >> 3;
                bArr[i] = (byte) (bArr[i] | (1 << (code & 7)));
                return;
            }
            bArr = this.m_map;
            i = code >> 3;
            bArr[i] = (byte) (bArr[i] & ((1 << (code & 7)) ^ -1));
        }

        void SetAll(boolean on) {
            byte val = (byte) (on ? 255 : 0);
            for (int i = 0; i < kMapSize; i++) {
                this.m_map[i] = val;
            }
        }
    }

    private native void dispatchChangeEvent(long j);

    private native void dispatchCompleteEvent(long j);

    private native void dispatchFocusIn(long j, int i);

    private native void dispatchFocusOut(long j, int i);

    private native boolean handleKeyEvent(long j, int i, int i2);

    private native void invokeSoftKeyboard(long j);

    public AndroidStageText(boolean multiline) {
        this.mMultiline = multiline;
        this.mDisplayAsPassword = false;
        this.mInternalReference = 0;
        this.mContext = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
        this.mView = new AndroidStageTextImpl(this.mContext);
        this.mView.setFillViewport(true);
        if (VERSION.SDK_INT >= 11) {
            this.mView.setLayerType(1, null);
        }
        this.mTextView = new AndroidStageTextEditText(this.mContext);
        this.mTextView.setImeOptions(301989888);
        this.mSavedKeyListener = this.mTextView.getKeyListener();
        setFontSize(12);
        setInputType();
        this.mView.addView(this.mTextView, new LayoutParams(-1, -2));
        if (multiline) {
            this.mTextView.setTransformationMethod(null);
            this.mTextView.setHorizontallyScrolling(false);
        } else {
            this.mTextView.setSingleLine(true);
        }
        this.mTextView.setGravity(3);
        if (!(MapCreate || AndroidActivityWrapper.GetAndroidActivityWrapper().embeddedFonts())) {
            MapCreate = true;
        }
        if (!MapCreate) {
            MapCreate = true;
            try {
                String[] fileNames = this.mContext.getAssets().list("customEmbeddedFonts");
                String path = new String();
                int length = fileNames.length;
                int i = 0;
                while (i < length) {
                    String name = fileNames[i];
                    path = "customEmbeddedFonts/" + name;
                    try {
                        this.mContext.getAssets().open(path);
                        String ext = path.substring(path.lastIndexOf(46) + 1);
                        if (ext.equals("ttf") || ext.equals("otf")) {
                            Typeface customfont = Typeface.createFromAsset(this.mContext.getAssets(), path);
                            if (customfont != null) {
                                FontMap.put(name.substring(0, name.lastIndexOf(46)), customfont);
                            }
                            i++;
                        } else {
                            i++;
                        }
                    } catch (IOException e) {
                    }
                }
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }

    public void onActivityStateChanged(ActivityState state) {
    }

    public void onConfigurationChanged(Configuration config) {
    }

    public void setInternalReference(long objRef) {
        this.mInternalReference = objRef;
    }

    public void destroyInternals() {
        removeFromStage();
        this.mInternalReference = 0;
        this.mView = null;
        this.mClipBounds = null;
        this.mTextView = null;
    }

    public void addToStage(AIRWindowSurfaceView view) {
        if (this.mLayout != null) {
            removeFromStage();
        }
        this.mAIRSurface = view;
        AndroidActivityWrapper activityWrapper = view.getActivityWrapper();
        activityWrapper.addActivityStateChangeListner(this);
        this.mLayout = activityWrapper.getOverlaysLayout(true);
        this.mLayout.addView(this.mView, new RelativeLayout.LayoutParams(this.mGlobalBounds.width(), this.mGlobalBounds.height()));
        this.mTextView.setOnEditorActionListener(new C00291());
    }

    public void removeFromStage() {
        if (this.mLayout != null) {
            this.mLayout.removeView(this.mView);
            this.mLayout = null;
        }
        if (this.mAIRSurface != null) {
            AndroidActivityWrapper activityWrapper = this.mAIRSurface.getActivityWrapper();
            activityWrapper.didRemoveOverlay();
            activityWrapper.removeActivityStateChangeListner(this);
            this.mAIRSurface.updateFocusedStageText(this, false);
        }
        this.mAIRSurface = null;
    }

    public void setVisibility(boolean visible) {
        int newVisibility = visible ? 0 : 4;
        if (this.mView.getVisibility() != newVisibility) {
            this.mView.setVisibility(newVisibility);
            if (visible) {
                this.mTextView.invalidate();
            }
        }
    }

    public long updateViewBoundsWithKeyboard(int windowHeight) {
        int panning = 0;
        this.mGlobalBounds = this.mBounds;
        if (this.mAIRSurface != null) {
            Rect visibleBounds = new Rect(0, 0, this.mAIRSurface.getVisibleBoundWidth(), this.mAIRSurface.getVisibleBoundHeight());
            if (!visibleBounds.contains(this.mBounds)) {
                int top = Math.min(Math.max(0, this.mBounds.top), windowHeight);
                int bottom = Math.min(Math.max(0, this.mBounds.bottom), windowHeight);
                if (top == bottom) {
                    return 0;
                }
                int hiddenHeight = bottom - visibleBounds.bottom;
                if (hiddenHeight <= 0) {
                    return 0;
                }
                if (hiddenHeight <= top) {
                    panning = hiddenHeight;
                } else {
                    panning = top;
                    this.mGlobalBounds = new Rect(this.mBounds);
                    this.mGlobalBounds.bottom = visibleBounds.bottom + panning;
                }
            }
        }
        refreshGlobalBounds(false);
        return (long) panning;
    }

    public void resetGlobalBounds() {
        this.mGlobalBounds = this.mBounds;
        refreshGlobalBounds(false);
    }

    private void refreshGlobalBounds(final boolean doCompleteDispatch) {
        if (this.mView != null) {
            this.mView.post(new Runnable() {
                public void run() {
                    if (AndroidStageText.this.mView != null) {
                        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(AndroidStageText.this.mGlobalBounds.width(), AndroidStageText.this.mGlobalBounds.height());
                        params.leftMargin = AndroidStageText.this.mGlobalBounds.left;
                        params.topMargin = AndroidStageText.this.mGlobalBounds.top;
                        AndroidStageText.this.mView.setLayoutParams(params);
                        AndroidStageText.this.mView.requestLayout();
                        if (doCompleteDispatch) {
                            AndroidStageText.this.mNotifyLayoutComplete = true;
                        }
                    }
                }
            });
        }
    }

    public void adjustViewBounds(double x, double y, double width, double height, double scaleFactor) {
        this.mViewBounds = new Rect((int) x, (int) y, (int) (x + width), (int) (y + height));
        if (scaleFactor != this.mScaleFactor) {
            this.mScaleFactor = scaleFactor;
            setFontSize(this.mFontSize);
        }
        this.mBounds = this.mViewBounds;
        if (this.mClip != null) {
            this.mBounds.intersect(this.mClipBounds);
        }
        this.mGlobalBounds = this.mBounds;
        refreshGlobalBounds(true);
    }

    public void setClipBounds(double x, double y, double width, double height) {
        this.mClipBounds = new Rect((int) x, (int) y, (int) (x + width), (int) (y + height));
        this.mBounds = this.mViewBounds;
        this.mTextView.invalidate();
        refreshGlobalBounds(true);
    }

    public void removeClip() {
        AIRWindowSurfaceView airSurface = this.mAIRSurface;
        this.mBounds = this.mViewBounds;
        this.mClipBounds = null;
        this.mTextView.invalidate();
        refreshGlobalBounds(true);
    }

    public void setText(String text) {
        InputFilter[] filters = this.mTextView.getFilters();
        this.mTextView.setFilters(new InputFilter[0]);
        AndroidStageTextEditText androidStageTextEditText = this.mTextView;
        BufferType bufferType = (!this.mEditable || this.mDisableInteraction) ? BufferType.NORMAL : BufferType.EDITABLE;
        androidStageTextEditText.setText(text, bufferType);
        this.mTextView.setFilters(filters);
    }

    public String getText() {
        return this.mTextView.getText().toString();
    }

    public void setKeyboardType(int type) {
        this.mKeyboardType = type;
        setInputType();
    }

    public int getKeyboardType() {
        return this.mKeyboardType;
    }

    public void setDisplayAsPassword(boolean password) {
        this.mDisplayAsPassword = password;
        if (password) {
            this.mTextView.setTransformationMethod(PasswordTransformationMethod.getInstance());
        } else if (this.mMultiline) {
            this.mTextView.setTransformationMethod(null);
        } else {
            this.mTextView.setTransformationMethod(SingleLineTransformationMethod.getInstance());
        }
        setInputType();
    }

    private void setInputType() {
        int inputType = 1;
        if (!this.mDisplayAsPassword) {
            switch (this.mKeyboardType) {
                case 1:
                case 4:
                    inputType = 1;
                    break;
                case 2:
                    inputType = 17;
                    break;
                case 3:
                    inputType = 2;
                    break;
                case 5:
                    inputType = 33;
                    break;
                case 6:
                    inputType = 3;
                    break;
                case 7:
                    inputType = 8194;
                    break;
                default:
                    break;
            }
        } else if (this.mKeyboardType == 3) {
            inputType = 18;
        } else {
            inputType = 129;
        }
        if ((inputType & 15) == 1) {
            if (this.mAutoCorrect) {
                inputType |= 32768;
            } else {
                inputType |= 524288;
            }
            if (this.mAutoCapitalize != 0) {
                switch (this.mAutoCapitalize) {
                    case 1:
                        inputType |= 8192;
                        break;
                    case 2:
                        inputType |= 16384;
                        break;
                    case 3:
                        inputType |= 4096;
                        break;
                }
            }
        }
        if (this.mMultiline) {
            inputType |= 131072;
        }
        this.mTextView.setRawInputType(inputType);
        this.mTextView.invalidate();
    }

    public void setEditable(boolean inIsEditable) {
        if (inIsEditable != this.mEditable) {
            this.mEditable = inIsEditable;
            if (!this.mDisableInteraction) {
                InputFilter[] filters = this.mTextView.getFilters();
                this.mTextView.setFilters(new InputFilter[0]);
                this.mTextView.setText(this.mTextView.getText(), this.mEditable ? BufferType.EDITABLE : BufferType.NORMAL);
                this.mTextView.setFilters(filters);
                this.mTextView.setKeyListener(this.mEditable ? this.mSavedKeyListener : null);
                if (this.mEditable) {
                    setInputType();
                }
            }
        }
    }

    public void setDisableInteraction(boolean var) {
        this.mDisableInteraction = var;
        InputFilter[] filters = this.mTextView.getFilters();
        this.mTextView.setFilters(new InputFilter[0]);
        if (var) {
            this.mTextView.setText(this.mTextView.getText(), BufferType.NORMAL);
            this.mTextView.setFilters(filters);
            this.mTextView.setKeyListener(null);
            return;
        }
        KeyListener keyListener;
        this.mTextView.setText(this.mTextView.getText(), this.mEditable ? BufferType.EDITABLE : BufferType.NORMAL);
        this.mTextView.setFilters(filters);
        AndroidStageTextEditText androidStageTextEditText = this.mTextView;
        if (this.mEditable) {
            keyListener = this.mSavedKeyListener;
        } else {
            keyListener = null;
        }
        androidStageTextEditText.setKeyListener(keyListener);
        if (this.mEditable) {
            setInputType();
        }
    }

    public void setTextColor(int red, int green, int blue, int alpha) {
        this.mTextColor = Color.argb(alpha, red, green, blue);
        this.mTextView.setTextColor(this.mTextColor);
        this.mTextView.invalidate();
    }

    public int getTextColor() {
        return this.mTextColor;
    }

    private RectShape getShapeForBounds(Rect bounds) {
        RectShape rs = new RectShape();
        rs.resize((float) bounds.width(), (float) bounds.height());
        return rs;
    }

    public void setBackgroundColor(int red, int green, int blue, int alpha) {
        this.mBBDrawable.setBkgColor(Color.argb(alpha, red, green, blue));
        this.mTextView.invalidate();
    }

    public int getBackgroundColor() {
        return this.mBBDrawable.mBkgColor;
    }

    public void setBackground(boolean inBackground) {
        if (this.mBBDrawable.mHaveBkg != inBackground) {
            this.mBBDrawable.mHaveBkg = inBackground;
            this.mTextView.invalidate();
        }
    }

    public void setBorderColor(int red, int green, int blue, int alpha) {
        this.mBBDrawable.setBorderColor(Color.argb(alpha, red, green, blue));
        this.mTextView.invalidate();
    }

    public int getBorderColor() {
        return this.mBBDrawable.mBorderColor;
    }

    public void setBorder(boolean inBorder) {
        if (this.mBBDrawable.mHaveBorder != inBorder) {
            this.mBBDrawable.mHaveBorder = inBorder;
            this.mTextView.invalidate();
        }
    }

    public void setAutoCapitalize(int inAutoCapitalize) {
        if (this.mAutoCapitalize != inAutoCapitalize) {
            this.mAutoCapitalize = inAutoCapitalize;
            setInputType();
        }
    }

    public int getAutoCapitalize() {
        return this.mAutoCapitalize;
    }

    public void setAutoCorrect(boolean inIsAutoCorrect) {
        if (this.mAutoCorrect != inIsAutoCorrect) {
            this.mAutoCorrect = inIsAutoCorrect;
            setInputType();
        }
    }

    public int getReturnKeyLabel() {
        return this.mReturnKeyLabel;
    }

    public void setReturnKeyLabel(int type) {
        int imeOption = 0;
        this.mReturnKeyLabel = type;
        switch (type) {
            case 0:
                imeOption = 0;
                break;
            case 1:
                imeOption = 6;
                break;
            case 2:
                imeOption = 2;
                break;
            case 3:
                imeOption = 5;
                break;
            case 4:
                imeOption = 3;
                break;
        }
        this.mTextView.setImeOptions(imeOption | 301989888);
    }

    private void applyFilters() {
        int nFilters = 0;
        if (this.mMaxChars != 0) {
            nFilters = 0 + 1;
        }
        if (this.mRestrict != null) {
            nFilters++;
        }
        InputFilter[] filters = new InputFilter[nFilters];
        int i = 0;
        if (this.mMaxChars != 0) {
            filters[0] = new LengthFilter(this.mMaxChars);
            i = 0 + 1;
        }
        if (this.mRestrict != null) {
            filters[i] = new RestrictFilter(this.mRestrict);
            i++;
        }
        this.mTextView.setFilters(filters);
    }

    public String getRestrict() {
        return this.mRestrict;
    }

    public void clearRestrict() {
        this.mRestrict = null;
        applyFilters();
    }

    public void setRestrict(String inRestrict) {
        this.mRestrict = inRestrict;
        applyFilters();
    }

    public int getMaxChars() {
        return this.mMaxChars;
    }

    public void setMaxChars(int maxChars) {
        if (maxChars != this.mMaxChars) {
            this.mMaxChars = maxChars;
            applyFilters();
        }
    }

    public String getLocale() {
        return this.mLocale;
    }

    public void setLocale(String inLocale) {
        this.mLocale = inLocale;
    }

    public boolean getPreventDefault() {
        return this.mPreventDefault;
    }

    public void setPreventDefault(boolean inValue) {
        this.mPreventDefault = inValue;
    }

    public int getAlign() {
        return this.mAlign;
    }

    public void setAlign(int alignment) {
        this.mAlign = alignment;
        switch (alignment) {
            case 0:
            case 4:
                this.mTextView.setGravity(3);
                break;
            case 1:
            case 5:
                this.mTextView.setGravity(5);
                break;
            case 2:
                this.mTextView.setGravity(1);
                break;
        }
        this.mTextView.invalidate();
    }

    public void setFontSize(int size) {
        this.mFontSize = size;
        this.mTextView.setTextSize(0, (float) ((int) ((((double) size) * this.mScaleFactor) + 0.5d)));
        this.mTextView.invalidate();
    }

    public int getFontSize() {
        return this.mFontSize;
    }

    public void setBold(boolean bold) {
        this.mBold = bold;
        updateTypeface();
    }

    public void setItalic(boolean italic) {
        this.mItalic = italic;
        updateTypeface();
    }

    public void setFontFamily(String font) {
        this.mFont = font;
        updateTypeface();
    }

    public void updateTypeface() {
        int style = 0;
        if (this.mBold) {
            style = 0 | 1;
        }
        if (this.mItalic) {
            style |= 2;
        }
        Typeface customFontFromMap = (Typeface) FontMap.get(this.mFont);
        if (customFontFromMap == null) {
            Typeface tf = Typeface.create(this.mFont, style);
            if (tf == null) {
                switch (style) {
                    case 0:
                        this.mTextView.setTypeface(Typeface.DEFAULT);
                        break;
                    case 1:
                        this.mTextView.setTypeface(Typeface.DEFAULT_BOLD);
                        break;
                    default:
                        break;
                }
            }
            this.mTextView.setTypeface(tf, style);
        } else {
            this.mTextView.setTypeface(customFontFromMap);
        }
        this.mTextView.invalidate();
    }

    public void assignFocus() {
        this.mTextView.requestFocus();
        if (!this.mPreventDefault) {
            this.mAIRSurface.showSoftKeyboard(true, this.mTextView);
        }
        invokeSoftKeyboard(this.mInternalReference);
    }

    public void clearFocus() {
        if (this.mTextView.hasFocus()) {
            this.mTextView.clearFocus();
            this.mAIRSurface.requestFocus();
        }
        if (this.mMenuInvoked && this.mDisableInteraction) {
            this.mAIRSurface.showSoftKeyboard(false, this.mTextView);
        }
    }

    public void selectRange(int anchorIndex, int activeIndex) {
        int length = this.mTextView.length();
        if (anchorIndex < 0) {
            anchorIndex = 0;
        } else if (anchorIndex > length) {
            anchorIndex = length;
        }
        if (activeIndex < 0) {
            activeIndex = 0;
        } else if (activeIndex > length) {
            activeIndex = length;
        }
        this.mTextView.setSelection(anchorIndex, activeIndex);
        this.mTextView.invalidate();
    }

    public int getSelectionAnchorIndex() {
        return this.mTextView.getSelectionStart();
    }

    public int getSelectionActiveIndex() {
        return this.mTextView.getSelectionEnd();
    }

    public Bitmap captureSnapshot(int width, int height) {
        Bitmap bitmap = null;
        if (width >= 0 && height >= 0 && !(width == 0 && height == 0)) {
            bitmap = Bitmap.createBitmap(width, height, Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.translate((float) (-this.mView.getScrollX()), (float) (-this.mView.getScrollY()));
            if (this.mScaleFactor != 0.0d) {
                canvas.scale((float) (1.0d / this.mScaleFactor), (float) (1.0d / this.mScaleFactor));
            }
            boolean isHorizontalScrollBarEnabled = this.mView.isHorizontalScrollBarEnabled();
            boolean isVerticalScrollBarEnabled = this.mView.isVerticalScrollBarEnabled();
            this.mView.setHorizontalScrollBarEnabled(false);
            this.mView.setVerticalScrollBarEnabled(false);
            try {
                this.mView.draw(canvas);
            } catch (Exception e) {
                bitmap = null;
            }
            this.mView.setHorizontalScrollBarEnabled(isHorizontalScrollBarEnabled);
            this.mView.setVerticalScrollBarEnabled(isVerticalScrollBarEnabled);
        }
        return bitmap;
    }
}
