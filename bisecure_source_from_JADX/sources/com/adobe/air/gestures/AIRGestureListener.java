package com.adobe.air.gestures;

import android.content.Context;
import android.os.Build.VERSION;
import android.view.GestureDetector.OnDoubleTapListener;
import android.view.GestureDetector.OnGestureListener;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.OnScaleGestureListener;
import android.view.ViewConfiguration;
import com.adobe.air.AIRWindowSurfaceView;
import com.adobe.air.SystemCapabilities;

public class AIRGestureListener implements OnGestureListener, OnDoubleTapListener, OnScaleGestureListener {
    private static final String LOG_TAG = "AIRGestureListener";
    private static final int MAX_TOUCH_POINTS = 2;
    private static final float MM_PER_INCH = 25.4f;
    private static final float _FP_GESTURE_PAN_THRESHOLD_MM = 3.0f;
    private static final float _FP_GESTURE_ROTATION_THRESHOLD_DEGREES = 15.0f;
    private static final float _FP_GESTURE_SWIPE_PRIMARY_AXIS_MIN_MM = 10.0f;
    private static final float _FP_GESTURE_SWIPE_SECONDARY_AXIS_MAX_MM = 5.0f;
    private static final float _FP_GESTURE_ZOOM_PER_AXIS_THRESHOLD_MM = 3.0f;
    private static final float _FP_GESTURE_ZOOM_THRESHOLD_MM = 8.0f;
    private static final int kGestureAll = 8;
    private static final int kGestureBegin = 2;
    private static final int kGestureEnd = 4;
    private static final int kGesturePan = 1;
    private static final int kGestureRotate = 2;
    private static final int kGestureSwipe = 5;
    private static final int kGestureTwoFingerTap = 3;
    private static final int kGestureUpdate = 1;
    private static final int kGestureZoom = 0;
    private static int screenPPI = 0;
    private boolean mCheckForSwipe = true;
    private int mCouldBeTwoFingerTap = 0;
    private boolean mDidOccurTwoFingerGesture = false;
    private TouchPoint[] mDownTouchPoints;
    private boolean mInPanTransformGesture = false;
    private boolean mInRotateTransformGesture = false;
    private boolean mInZoomTransformGesture = false;
    private boolean mInZoomTransformGestureX = false;
    private boolean mInZoomTransformGestureY = false;
    private float mPreviousAbsoluteRotation = 0.0f;
    private float mPreviousPanLocX = 0.0f;
    private float mPreviousPanLocY = 0.0f;
    private float mPreviousRotateLocX = 0.0f;
    private float mPreviousRotateLocY = 0.0f;
    private float mPreviousZoomLocX = 0.0f;
    private float mPreviousZoomLocY = 0.0f;
    private TouchPoint mPrimaryPointOfTwoFingerTap = null;
    private TouchPoint mSecondaryPointOfTwoFingerTap = null;
    private AIRWindowSurfaceView mSurfaceView;
    private long mTwoFingerTapStartTime = 0;

    private class TouchPoint {
        private int pid;
        /* renamed from: x */
        private float f2x;
        /* renamed from: y */
        private float f3y;

        TouchPoint() {
            this.f2x = 0.0f;
            this.f3y = 0.0f;
            this.pid = 0;
        }

        TouchPoint(float xVal, float yVal, int pointerID) {
            this.f2x = xVal;
            this.f3y = yVal;
            this.pid = pointerID;
        }

        private void assign(float xVal, float yVal, int pointerID) {
            this.f2x = xVal;
            this.f3y = yVal;
            this.pid = pointerID;
        }
    }

    private native boolean nativeOnGestureListener(int i, int i2, boolean z, float f, float f2, float f3, float f4, float f5, float f6, float f7, float f8);

    public AIRGestureListener(Context context, AIRWindowSurfaceView aSurfaceView) {
        this.mSurfaceView = aSurfaceView;
        this.mDownTouchPoints = new TouchPoint[2];
        for (int i = 0; i < 2; i++) {
            this.mDownTouchPoints[i] = new TouchPoint();
        }
        this.mSecondaryPointOfTwoFingerTap = new TouchPoint();
        screenPPI = SystemCapabilities.GetScreenDPI(context);
    }

    public TouchPoint getDownTouchPoint(int pid) {
        if (pid < 0 || pid >= 2) {
            return null;
        }
        return this.mDownTouchPoints[pid];
    }

    public void setDownTouchPoint(float x, float y, int pid) {
        if (pid >= 0 && pid < 2) {
            this.mDownTouchPoints[pid].assign(x, y, pid);
        }
    }

    public void setCouldBeTwoFingerTap(int iVal) {
        this.mCouldBeTwoFingerTap = iVal;
        if (iVal == 0) {
            this.mTwoFingerTapStartTime = System.currentTimeMillis();
            this.mDidOccurTwoFingerGesture = false;
        }
    }

    public int getCouldBeTwoFingerTap() {
        return this.mCouldBeTwoFingerTap;
    }

    public void setSecondaryPointOfTwoFingerTap(float x, float y, int pid) {
        this.mSecondaryPointOfTwoFingerTap = new TouchPoint(x, y, pid);
    }

    public void setPrimaryPointOfTwoFingerTap(float x, float y, int pid) {
        this.mPrimaryPointOfTwoFingerTap = new TouchPoint(x, y, pid);
    }

    public void mayStartNewTransformGesture() {
        this.mInRotateTransformGesture = false;
        this.mInZoomTransformGesture = false;
        this.mInZoomTransformGestureX = false;
        this.mInZoomTransformGestureY = false;
        this.mInPanTransformGesture = false;
    }

    public boolean getCheckForSwipe() {
        return this.mCheckForSwipe;
    }

    public void setCheckForSwipe(boolean aVal) {
        this.mCheckForSwipe = aVal;
    }

    public boolean endTwoFingerGesture() {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode == 2) {
            long currentTime = System.currentTimeMillis();
            if (!this.mDidOccurTwoFingerGesture && this.mCouldBeTwoFingerTap == 3 && currentTime - this.mTwoFingerTapStartTime < ((long) ViewConfiguration.getTapTimeout())) {
                onTwoFingerTap();
            }
            endRotateGesture();
            endPanGesture();
        }
        return true;
    }

    private void endRotateGesture() {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode == 2 && this.mInRotateTransformGesture) {
            nativeOnGestureListener(4, 2, true, this.mPreviousRotateLocX, this.mPreviousRotateLocY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
            this.mInRotateTransformGesture = false;
        }
    }

    private void endZoomGesture() {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode == 2 && this.mInZoomTransformGesture) {
            nativeOnGestureListener(4, 0, true, this.mPreviousZoomLocX, this.mPreviousZoomLocY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
            this.mInZoomTransformGesture = false;
            this.mInZoomTransformGestureX = false;
            this.mInZoomTransformGestureY = false;
        }
    }

    private void endPanGesture() {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode == 2 && this.mInPanTransformGesture) {
            nativeOnGestureListener(4, 1, true, this.mPreviousPanLocX, this.mPreviousPanLocY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
            this.mInPanTransformGesture = false;
        }
    }

    public boolean onDown(MotionEvent e) {
        return true;
    }

    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
        return true;
    }

    public void onLongPress(MotionEvent e) {
    }

    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode != 2) {
            return true;
        }
        float rotation = 0.0f;
        float offsetX = 0.0f;
        float offsetY = 0.0f;
        float locX;
        float locY;
        if (e2.getPointerCount() == 2) {
            int gesturePhase = 1;
            locX = (e2.getX(0) + e2.getX(1)) / 2.0f;
            locY = (e2.getY(0) + e2.getY(1)) / 2.0f;
            TouchPoint[] currentTouchPoint = new TouchPoint[2];
            for (int i = 0; i < 2; i++) {
                currentTouchPoint[i] = new TouchPoint(e2.getX(i), e2.getY(i), e2.getPointerId(i));
            }
            int pid1 = currentTouchPoint[0].pid;
            int pid2 = currentTouchPoint[1].pid;
            if (pid1 >= 0 && pid1 < 2 && pid2 >= 0 && pid2 < 2) {
                if (!this.mInPanTransformGesture) {
                    float absoluteRotation = getRotation(this.mDownTouchPoints[pid1], this.mDownTouchPoints[pid2], currentTouchPoint[0], currentTouchPoint[1]);
                    if (Math.abs(absoluteRotation) > 180.0f) {
                        if (absoluteRotation > 0.0f) {
                            absoluteRotation = (360.0f - absoluteRotation) * -1.0f;
                        } else {
                            absoluteRotation += 360.0f;
                        }
                    }
                    if (this.mInRotateTransformGesture || Math.abs(absoluteRotation) > _FP_GESTURE_ROTATION_THRESHOLD_DEGREES) {
                        if (!this.mInRotateTransformGesture) {
                            gesturePhase = 2;
                            this.mInRotateTransformGesture = true;
                            this.mPreviousAbsoluteRotation = 0.0f;
                            this.mDidOccurTwoFingerGesture = true;
                        }
                        rotation = absoluteRotation - this.mPreviousAbsoluteRotation;
                        if (Math.abs(rotation) > 180.0f) {
                            if (rotation > 0.0f) {
                                rotation = (360.0f - rotation) * -1.0f;
                            } else {
                                rotation += 360.0f;
                            }
                        }
                        this.mPreviousAbsoluteRotation = absoluteRotation;
                        this.mPreviousRotateLocX = locX;
                        this.mPreviousRotateLocY = locY;
                        nativeOnGestureListener(gesturePhase, 2, true, locX, locY, 1.0f, 1.0f, rotation, 0.0f, 0.0f, 0.0f);
                        rotation = 0.0f;
                    }
                }
                if (!(this.mInZoomTransformGesture || this.mInRotateTransformGesture)) {
                    if (isPanGesture(this.mDownTouchPoints[pid1], this.mDownTouchPoints[pid2], currentTouchPoint[0], currentTouchPoint[1])) {
                        if (!this.mInPanTransformGesture) {
                            gesturePhase = 2;
                            this.mInPanTransformGesture = true;
                            this.mDidOccurTwoFingerGesture = true;
                        }
                        offsetX = -1.0f * distanceX;
                        offsetY = -1.0f * distanceY;
                        this.mPreviousPanLocX = locX;
                        this.mPreviousPanLocY = locY;
                        nativeOnGestureListener(gesturePhase, 1, true, locX, locY, 1.0f, 1.0f, rotation, offsetX, offsetY, 0.0f);
                    } else if (this.mInPanTransformGesture) {
                        endPanGesture();
                        setDownTouchPoint(currentTouchPoint[0].f2x, currentTouchPoint[0].f3y, currentTouchPoint[0].pid);
                        setDownTouchPoint(currentTouchPoint[1].f2x, currentTouchPoint[1].f3y, currentTouchPoint[1].pid);
                    }
                }
            }
        } else if (e2.getPointerCount() == 1) {
            int pid_swipe = e2.getPointerId(0);
            if (pid_swipe >= 0 && pid_swipe < 2 && this.mCheckForSwipe && e1.getPointerCount() == 1) {
                boolean isSwipe;
                float velocity = 0.0f;
                float delta_x = e2.getX(0) - this.mDownTouchPoints[pid_swipe].f2x;
                float delta_y = e2.getY(0) - this.mDownTouchPoints[pid_swipe].f3y;
                if ((Math.abs(delta_x) * MM_PER_INCH) / ((float) screenPPI) >= _FP_GESTURE_SWIPE_PRIMARY_AXIS_MIN_MM && (Math.abs(delta_y) * MM_PER_INCH) / ((float) screenPPI) <= _FP_GESTURE_SWIPE_SECONDARY_AXIS_MAX_MM) {
                    isSwipe = true;
                    offsetX = delta_x > 0.0f ? 1.0f : -1.0f;
                    offsetY = 0.0f;
                    velocity = ((e2.getX(0) - e1.getX(0)) / ((float) (e2.getEventTime() - e1.getEventTime()))) * 1000.0f;
                } else if ((Math.abs(delta_y) * MM_PER_INCH) / ((float) screenPPI) < _FP_GESTURE_SWIPE_PRIMARY_AXIS_MIN_MM || (Math.abs(delta_x) * MM_PER_INCH) / ((float) screenPPI) > _FP_GESTURE_SWIPE_SECONDARY_AXIS_MAX_MM) {
                    isSwipe = false;
                } else {
                    isSwipe = true;
                    offsetX = 0.0f;
                    offsetY = delta_y > 0.0f ? 1.0f : -1.0f;
                    velocity = ((e2.getY(0) - e1.getY(0)) / ((float) (e2.getEventTime() - e1.getEventTime()))) * 1000.0f;
                }
                if (isSwipe) {
                    locX = e1.getX(0);
                    locY = e2.getY(0);
                    if (velocity < 0.0f) {
                        velocity *= -1.0f;
                    }
                    nativeOnGestureListener(8, 5, true, locX, locY, 1.0f, 1.0f, 0.0f, offsetX, offsetY, velocity);
                    this.mCheckForSwipe = false;
                }
            }
        }
        return true;
    }

    public void onShowPress(MotionEvent e) {
    }

    public boolean onTwoFingerTap() {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode != 2) {
            return 1;
        }
        boolean retVal;
        float locX = (this.mSecondaryPointOfTwoFingerTap.f2x + this.mPrimaryPointOfTwoFingerTap.f2x) / 2.0f;
        float locY = (this.mSecondaryPointOfTwoFingerTap.f3y + this.mPrimaryPointOfTwoFingerTap.f3y) / 2.0f;
        if (1 == null || !nativeOnGestureListener(8, 3, false, locX, locY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f)) {
            retVal = false;
        } else {
            retVal = true;
        }
        this.mCouldBeTwoFingerTap = 0;
        return retVal;
    }

    public boolean onSingleTapConfirmed(MotionEvent me) {
        return true;
    }

    public boolean onSingleTapUp(MotionEvent e) {
        return true;
    }

    public boolean onDoubleTap(MotionEvent me) {
        if (me.getPointerCount() != 1) {
            return true;
        }
        if (1 == null || !this.mSurfaceView.nativeOnDoubleClickListener(me.getX(0), me.getY(0))) {
            return false;
        }
        return true;
    }

    public boolean onDoubleTapEvent(MotionEvent e) {
        return true;
    }

    public boolean onScaleBegin(ScaleGestureDetector detector) {
        if (this.mInZoomTransformGesture) {
            endZoomGesture();
        }
        return true;
    }

    public boolean onScale(ScaleGestureDetector detector) {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode != 2) {
            return true;
        }
        int gesturePhase = 1;
        float locX = detector.getFocusX();
        float locY = detector.getFocusY();
        float scaleX = 1.0f;
        float scaleY = 1.0f;
        double initialDistance = (double) detector.getPreviousSpan();
        double deltaDistance = Math.abs(((double) detector.getCurrentSpan()) - initialDistance);
        double deltaDistanceX = 0.0d;
        double deltaDistanceY = 0.0d;
        if (VERSION.SDK_INT >= 11) {
            deltaDistanceX = (double) Math.abs(detector.getCurrentSpanX() - detector.getPreviousSpanX());
            deltaDistanceY = (double) Math.abs(detector.getCurrentSpanY() - detector.getPreviousSpanY());
        }
        if (initialDistance == 0.0d) {
            return false;
        }
        if (!this.mInZoomTransformGesture && (25.399999618530273d * deltaDistance) / ((double) screenPPI) <= 8.0d) {
            return false;
        }
        if (!this.mInZoomTransformGesture) {
            this.mInZoomTransformGesture = true;
            gesturePhase = 2;
            this.mDidOccurTwoFingerGesture = true;
        }
        if (VERSION.SDK_INT >= 11) {
            if (!(detector.getPreviousSpanX() == 0.0f || detector.getCurrentSpanX() == 0.0f || (!this.mInZoomTransformGestureX && (25.399999618530273d * deltaDistanceX) / ((double) screenPPI) <= 3.0d))) {
                scaleX = Math.abs(detector.getCurrentSpanX() / detector.getPreviousSpanX());
                this.mInZoomTransformGestureX = true;
            }
            if (!(detector.getPreviousSpanY() == 0.0f || detector.getCurrentSpanY() == 0.0f || (!this.mInZoomTransformGestureY && (25.399999618530273d * deltaDistanceY) / ((double) screenPPI) <= 3.0d))) {
                scaleY = Math.abs(detector.getCurrentSpanY() / detector.getPreviousSpanY());
                this.mInZoomTransformGestureY = true;
            }
        } else {
            float scaleFactor = detector.getScaleFactor();
            scaleX = scaleFactor;
            scaleY = scaleFactor;
        }
        this.mPreviousZoomLocX = locX;
        this.mPreviousZoomLocY = locY;
        nativeOnGestureListener(gesturePhase, 0, true, locX, locY, scaleX, scaleY, 0.0f, 0.0f, 0.0f, 0.0f);
        return true;
    }

    public void onScaleEnd(ScaleGestureDetector detector) {
        int multitouchMode = this.mSurfaceView.getMultitouchMode();
        this.mSurfaceView.getClass();
        if (multitouchMode == 2 && this.mInZoomTransformGesture) {
            float scaleFactor = detector.getScaleFactor();
            nativeOnGestureListener(4, 0, true, this.mPreviousZoomLocX, this.mPreviousZoomLocY, scaleFactor, scaleFactor, 0.0f, 0.0f, 0.0f, 0.0f);
        }
    }

    private float getRotation(TouchPoint initial_pt1, TouchPoint initial_pt2, TouchPoint current_pt1, TouchPoint current_pt2) {
        if (initial_pt1.pid != current_pt1.pid || initial_pt2.pid != current_pt2.pid) {
            return 0.0f;
        }
        return (float) (((Math.atan2((double) (current_pt2.f3y - current_pt1.f3y), (double) (current_pt2.f2x - current_pt1.f2x)) * 180.0d) / 3.141592653589793d) - ((Math.atan2((double) (initial_pt2.f3y - initial_pt1.f3y), (double) (initial_pt2.f2x - initial_pt1.f2x)) * 180.0d) / 3.141592653589793d));
    }

    private boolean isPanGesture(TouchPoint initial_pt1, TouchPoint initial_pt2, TouchPoint current_pt1, TouchPoint current_pt2) {
        float delta_pt1_x = current_pt1.f2x - initial_pt1.f2x;
        float delta_pt1_y = current_pt1.f3y - initial_pt1.f3y;
        float delta_pt2_x = current_pt2.f2x - initial_pt2.f2x;
        float delta_pt2_y = current_pt2.f3y - initial_pt2.f3y;
        float minTranslation_x = Math.min(Math.abs(delta_pt1_x), Math.abs(delta_pt2_x));
        float minTranslation_y = Math.min(Math.abs(delta_pt1_y), Math.abs(delta_pt2_y));
        double absoluteTranslation = Math.sqrt((double) ((minTranslation_x * minTranslation_x) + (minTranslation_y * minTranslation_y)));
        if (((delta_pt1_x < 0.0f || delta_pt2_x < 0.0f) && (delta_pt1_x > 0.0f || delta_pt2_x > 0.0f)) || (((delta_pt1_y < 0.0f || delta_pt2_y < 0.0f) && (delta_pt1_y > 0.0f || delta_pt2_y > 0.0f)) || (!this.mInPanTransformGesture && absoluteTranslation <= ((double) ((3.0f * ((float) screenPPI)) / MM_PER_INCH))))) {
            return false;
        }
        return true;
    }

    private double distanceBetweenPoints(TouchPoint pt1, TouchPoint pt2) {
        return Math.sqrt(Math.pow((double) (pt2.f2x - pt1.f2x), 2.0d) + Math.pow((double) (pt2.f3y - pt1.f3y), 2.0d));
    }
}
