package com.adobe.air;

import android.text.Editable;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.InputMethodManager;
import com.adobe.air.utils.AIRLogger;

public class AndroidInputConnection extends BaseInputConnection {
    private static final String LOG_TAG = "AndroidInputConnection";
    private CharSequence mComposedText = null;
    private ExtractedTextRequest mExtractRequest = null;
    private ExtractedText mExtractedText = null;
    private final AIRWindowSurfaceView mWindowSurfaceView;

    private native String nativeGetTextAfterCursor(int i);

    private native String nativeGetTextBeforeCursor(int i);

    private native int nativeGetTextBoxMaxChars();

    private native void nativeSetSelection(int i, int i2);

    public AndroidInputConnection(AIRWindowSurfaceView view) {
        super(view, true);
        this.mWindowSurfaceView = view;
    }

    public boolean deleteSurroundingText(int left, int right) {
        int move;
        for (move = 0; move < right; move++) {
            AIRLogger.m0d(LOG_TAG, "[JP] deleteSurroundingText ");
            this.mWindowSurfaceView.nativeOnKeyListener(0, 22, 0, false, false, false);
            this.mWindowSurfaceView.nativeOnKeyListener(1, 22, 0, false, false, false);
        }
        int total = right + left;
        for (move = 0; move < total; move++) {
            AIRLogger.m0d(LOG_TAG, "[JP] deleteSurroundingText 2 ");
            this.mWindowSurfaceView.nativeOnKeyListener(0, 67, 0, false, false, false);
            this.mWindowSurfaceView.nativeOnKeyListener(1, 67, 0, false, false, false);
        }
        return true;
    }

    public CharSequence getTextAfterCursor(int n, int flags) {
        return nativeGetTextAfterCursor(n);
    }

    public CharSequence getTextBeforeCursor(int n, int flags) {
        return nativeGetTextBeforeCursor(n);
    }

    public ExtractedText getExtractedText(ExtractedTextRequest request, int flags) {
        this.mWindowSurfaceView.setInputConnection(this);
        ExtractedText outText = this.mWindowSurfaceView.nativeGetTextContent();
        if (outText == null || outText.text == null) {
            return null;
        }
        outText.partialEndOffset = -1;
        outText.partialStartOffset = -1;
        if ((flags & 1) == 0) {
            return outText;
        }
        outText.startOffset = 0;
        this.mExtractedText = outText;
        this.mExtractRequest = request;
        this.mWindowSurfaceView.nativeShowOriginalRect();
        return outText;
    }

    public Editable getEditable() {
        return null;
    }

    public boolean performEditorAction(int editorAction) {
        if (editorAction != 6) {
            return false;
        }
        this.mWindowSurfaceView.showSoftKeyboard(false);
        this.mWindowSurfaceView.nativeDispatchUserTriggeredSkDeactivateEvent();
        return true;
    }

    public boolean performContextMenuAction(int id) {
        switch (id) {
            case 16908319:
                id = 0;
                break;
            case 16908320:
                if (!this.mWindowSurfaceView.nativeIsTextSelected()) {
                    id = 2;
                    break;
                }
                id = 1;
                break;
            case 16908321:
                if (!this.mWindowSurfaceView.nativeIsTextSelected()) {
                    id = 4;
                    break;
                }
                id = 3;
                break;
            case 16908322:
                id = 5;
                break;
            case 16908324:
                id = 6;
                break;
            case 16908328:
                id = 7;
                break;
            case 16908329:
                id = 8;
                break;
            default:
                return false;
        }
        return this.mWindowSurfaceView.onTextBoxContextMenuItem(id);
    }

    public boolean setComposingRegion(int start, int end) {
        if (start > end) {
            int temp = start;
            start = end;
            end = temp;
        }
        ExtractedText outText = this.mWindowSurfaceView.nativeGetTextContent();
        if (end > outText.text.length() || start < 0) {
            String lastWord = outText.text.toString();
            this.mComposedText = lastWord.substring(lastWord.lastIndexOf(32) + 1);
        } else {
            this.mComposedText = outText.text.subSequence(start, end);
        }
        return true;
    }

    public boolean setComposingText(CharSequence text, int cursorPos) {
        int maxCharLength = nativeGetTextBoxMaxChars();
        if (maxCharLength != 0 && text.length() > 0) {
            ExtractedText outText = this.mWindowSurfaceView.nativeGetTextContent();
            int allowedExpansion = ((maxCharLength - outText.text.length()) + outText.selectionEnd) - outText.selectionStart;
            int len = 0;
            if (this.mComposedText != null) {
                len = this.mComposedText.length();
            }
            int min = Math.min(len + allowedExpansion, text.length());
            if (min > 0) {
                text = text.subSequence(0, min);
            } else {
                text = null;
            }
        }
        if (text != null) {
            AIRLogger.m0d(LOG_TAG, "[JP] setComposingText " + text);
            writeText(text);
            this.mComposedText = text;
            int loop;
            int i;
            if (cursorPos <= 0) {
                loop = text.length() + Math.abs(cursorPos);
                for (i = 0; i < loop; i++) {
                    AIRLogger.m0d(LOG_TAG, "[JP] setComposingText " + text);
                    this.mWindowSurfaceView.nativeOnKeyListener(0, 21, 0, false, false, false);
                    this.mWindowSurfaceView.nativeOnKeyListener(1, 21, 0, false, false, false);
                }
            } else if (cursorPos > 1) {
                loop = cursorPos - 1;
                for (i = 0; i < loop; i++) {
                    AIRLogger.m0d(LOG_TAG, "[JP] setComposingText 2 " + text);
                    this.mWindowSurfaceView.nativeOnKeyListener(0, 22, 0, false, false, false);
                    this.mWindowSurfaceView.nativeOnKeyListener(1, 22, 0, false, false, false);
                }
            }
        }
        return true;
    }

    public boolean finishComposingText() {
        this.mComposedText = null;
        if (this.mWindowSurfaceView.getIsFullScreen() && !this.mWindowSurfaceView.IsSurfaceChangedForSoftKeyboard()) {
            this.mWindowSurfaceView.nativeShowOriginalRect();
        }
        return true;
    }

    public boolean setSelection(int st, int en) {
        nativeSetSelection(st, en);
        return true;
    }

    public boolean commitText(CharSequence text, int newCursorPosition) {
        AIRLogger.m0d(LOG_TAG, "[JP] setComposingText " + text);
        writeText(text);
        this.mComposedText = null;
        return true;
    }

    private void writeText(CharSequence text) {
        int textLength = text.length();
        int offset = 0;
        if (this.mComposedText != null) {
            int cLength = this.mComposedText.length();
            int min = Math.min(textLength, cLength);
            while (offset < min && text.charAt(offset) == this.mComposedText.charAt(offset)) {
                offset++;
            }
            for (int i = offset; i < cLength; i++) {
                AIRLogger.m0d(LOG_TAG, "[JP] writeText " + text);
                this.mWindowSurfaceView.nativeOnKeyListener(0, 67, 0, false, false, false);
                this.mWindowSurfaceView.nativeOnKeyListener(1, 67, 0, false, false, false);
            }
        }
        while (offset < textLength) {
            AIRLogger.m0d(LOG_TAG, "[JP] writeText 2 " + text);
            this.mWindowSurfaceView.nativeOnKeyListener(0, 0, text.charAt(offset), false, false, false);
            this.mWindowSurfaceView.nativeOnKeyListener(1, 0, text.charAt(offset), false, false, false);
            offset++;
        }
        updateIMEText();
    }

    public void updateIMEText() {
        if (this.mExtractRequest != null) {
            InputMethodManager imm = this.mWindowSurfaceView.getInputMethodManager();
            if (imm != null && imm.isActive(this.mWindowSurfaceView)) {
                ExtractedText outText = this.mWindowSurfaceView.nativeGetTextContent();
                boolean textMatched = outText.text.toString().equals(this.mExtractedText.text.toString());
                if (!textMatched || outText.selectionStart != this.mExtractedText.selectionStart || outText.selectionEnd != this.mExtractedText.selectionEnd || outText.flags != this.mExtractedText.flags) {
                    outText.startOffset = 0;
                    if (textMatched) {
                        outText.partialStartOffset = 0;
                        outText.partialEndOffset = 0;
                        outText.text = "";
                        this.mExtractedText.flags = outText.flags;
                        this.mExtractedText.selectionStart = outText.selectionStart;
                        this.mExtractedText.selectionEnd = outText.selectionEnd;
                    } else {
                        outText.partialStartOffset = -1;
                        outText.partialEndOffset = -1;
                        this.mExtractedText = outText;
                    }
                    imm.updateExtractedText(this.mWindowSurfaceView, this.mExtractRequest.token, outText);
                }
            }
        }
    }

    public void Reset() {
        this.mComposedText = null;
        this.mExtractRequest = null;
        this.mExtractedText = null;
    }
}
