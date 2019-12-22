package com.adobe.air;

public class TouchEventData {
    public float mContactX;
    public float mContactY;
    public float[] mHistory;
    public boolean mIsPrimaryPoint;
    public int mMetaState;
    public int mPointerID;
    public float mPressure;
    public int mTouchEventType;
    public float mXCoord;
    public float mYCoord;

    public TouchEventData(int touchEventType, float xCoord, float yCoord, float pressure, int pointerID, float contactX, float contactY, boolean isPrimaryPoint, float[] history, int metaState) {
        this.mTouchEventType = touchEventType;
        this.mXCoord = xCoord;
        this.mYCoord = yCoord;
        this.mPressure = pressure;
        this.mPointerID = pointerID;
        this.mContactX = contactX;
        this.mContactY = contactY;
        this.mIsPrimaryPoint = isPrimaryPoint;
        this.mHistory = history;
        this.mMetaState = metaState;
    }
}
