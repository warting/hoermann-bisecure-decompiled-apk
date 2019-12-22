package com.adobe.air.wand.motionsensor;

import android.app.Activity;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

public abstract class MotionSensor {
    protected static final String LOG_TAG = "MotionSensor";
    protected Activity mActivity = null;
    protected boolean mRegistered = false;
    protected Sensor mSensor = null;
    protected int mSensorDelay = 1;
    protected SensorEventListener mSensorEventListener = null;
    protected SensorManager mSensorManager = null;

    public interface Listener {
        void onSensorChanged(float[] fArr, long j);
    }

    public MotionSensor(Activity activity, int sensorType) {
        this.mActivity = activity;
        this.mSensorManager = (SensorManager) this.mActivity.getSystemService("sensor");
        this.mSensor = this.mSensorManager.getDefaultSensor(sensorType);
        if (this.mSensor == null) {
        }
    }

    private float[] getScreenOrientedValues(float[] values) {
        values = (float[]) values.clone();
        int rotation = this.mActivity.getWindowManager().getDefaultDisplay().getRotation();
        if (rotation != 0) {
            if (rotation == 2) {
                values[0] = -values[0];
                values[1] = -values[1];
            } else if (rotation == 1) {
                newY = values[0];
                values[0] = -values[1];
                values[1] = newY;
            } else if (rotation == 3) {
                newY = -values[0];
                values[0] = values[1];
                values[1] = newY;
            }
        }
        return values;
    }

    public void setListener(final Listener listener) {
        SensorEventListener sensorEventListener;
        boolean wasRegistered = this.mRegistered;
        stop();
        if (listener == null) {
            sensorEventListener = null;
        } else {
            sensorEventListener = new SensorEventListener() {
                public void onSensorChanged(SensorEvent sensorevent) {
                    listener.onSensorChanged(MotionSensor.this.getScreenOrientedValues(sensorevent.values), sensorevent.timestamp);
                }

                public void onAccuracyChanged(Sensor sensor, int newAccuracy) {
                }
            };
        }
        this.mSensorEventListener = sensorEventListener;
        if (wasRegistered) {
            start();
        }
    }

    public void start(int sensorDelay) {
        if (!this.mRegistered && this.mSensor != null) {
            this.mSensorDelay = sensorDelay * 1000;
            start();
        }
    }

    public void start() {
        if (!this.mRegistered && this.mSensor != null) {
            this.mRegistered = this.mSensorManager.registerListener(this.mSensorEventListener, this.mSensor, this.mSensorDelay);
            if (!this.mRegistered) {
            }
        }
    }

    public void stop() {
        if (this.mRegistered) {
            this.mSensorManager.unregisterListener(this.mSensorEventListener, this.mSensor);
            this.mRegistered = false;
        }
    }

    public boolean available() {
        return this.mSensor != null;
    }

    public boolean active() {
        return this.mRegistered;
    }

    public void dispose() {
        stop();
        setListener(null);
        this.mSensor = null;
        this.mSensorManager = null;
        this.mActivity = null;
    }
}
