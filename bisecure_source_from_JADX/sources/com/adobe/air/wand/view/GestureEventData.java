package com.adobe.air.wand.view;

public class GestureEventData {
    public boolean mIsTransform = true;
    public float mOffsetX = 0.0f;
    public float mOffsetY = 0.0f;
    public int mPhase = 2;
    public float mRotation = 0.0f;
    public float mScaleX = 1.0f;
    public float mScaleY = 1.0f;
    public int mType = 0;
    public float mXCoord = 0.0f;
    public float mYCoord = 0.0f;

    public GestureEventData(int phase, int type, boolean isTransform, float xCoord, float yCoord, float scaleX, float scaleY, float rotation, float offsetX, float offsetY) {
        this.mPhase = phase;
        this.mType = type;
        this.mIsTransform = isTransform;
        this.mXCoord = xCoord;
        this.mYCoord = yCoord;
        this.mScaleX = scaleX;
        this.mScaleY = scaleY;
        this.mRotation = rotation;
        this.mOffsetX = offsetX;
        this.mOffsetY = offsetY;
    }
}
