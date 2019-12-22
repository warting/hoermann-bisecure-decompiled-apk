package com.adobe.air;

/* compiled from: AndroidInputManager */
class AndroidInputControl {
    private int mCode = 0;
    private long mInternalReference;
    private float mMaxValue = 0.0f;
    private float mMinValue = 0.0f;
    private ControlType mType;
    private float mValue = 0.0f;

    private native void OnValueChange(long j, float f);

    public AndroidInputControl(ControlType type, int code, float minValue, float maxValue) {
        this.mType = type;
        this.mCode = code;
        this.mMinValue = minValue;
        this.mMaxValue = maxValue;
    }

    public void setInternalReference(long objRef) {
        this.mInternalReference = objRef;
    }

    public int getType() {
        return this.mType.ordinal();
    }

    public int getCode() {
        return this.mCode;
    }

    public float getValue() {
        return this.mValue;
    }

    public float getMinValue() {
        return this.mMinValue;
    }

    public float getMaxValue() {
        return this.mMaxValue;
    }

    public String getId() {
        return this.mType.name() + "_" + this.mCode;
    }

    public void setData(float value) {
        if (this.mValue != value) {
            this.mValue = value;
            OnValueChange(this.mInternalReference, this.mValue);
        }
    }
}
