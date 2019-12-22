package com.adobe.air;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build.VERSION;
import android.view.WindowManager;
import java.util.Arrays;

public class DeviceRotation implements SensorEventListener {
    private Context mContext;
    private SensorManager mSensorManager;
    private float m_pitch;
    private float[] m_quaternion_data = new float[4];
    private float m_roll;
    private float m_yaw;

    public void onSensorChanged(SensorEvent se) {
        if (se.sensor.getType() == 15) {
            float q0;
            float q1;
            float q2;
            float q3;
            Context context = this.mContext;
            Context context2 = this.mContext;
            int orientation = ((WindowManager) context.getSystemService("window")).getDefaultDisplay().getRotation();
            SensorManager sensorManager = this.mSensorManager;
            SensorManager.getQuaternionFromVector(this.m_quaternion_data, se.values);
            float[] tempQuat = new float[4];
            tempQuat = Arrays.copyOf(this.m_quaternion_data, 4);
            switch (orientation) {
                case 0:
                    this.m_quaternion_data[1] = tempQuat[1];
                    this.m_quaternion_data[2] = tempQuat[2];
                    this.m_quaternion_data[3] = tempQuat[3];
                    break;
                case 1:
                    this.m_quaternion_data[1] = -tempQuat[2];
                    this.m_quaternion_data[2] = tempQuat[1];
                    this.m_quaternion_data[3] = tempQuat[3];
                    break;
                case 2:
                    this.m_quaternion_data[1] = -tempQuat[1];
                    this.m_quaternion_data[2] = -tempQuat[2];
                    this.m_quaternion_data[3] = tempQuat[3];
                    break;
                case 3:
                    this.m_quaternion_data[1] = tempQuat[2];
                    this.m_quaternion_data[2] = -tempQuat[1];
                    this.m_quaternion_data[3] = tempQuat[3];
                    q0 = this.m_quaternion_data[0];
                    q1 = this.m_quaternion_data[1];
                    q2 = this.m_quaternion_data[2];
                    q3 = this.m_quaternion_data[3];
                    this.m_pitch = (float) Math.toDegrees(Math.atan2((double) (2.0f * ((q0 * q1) + (q2 * q3))), (double) (1.0f - (2.0f * ((q1 * q1) + (q2 * q2))))));
                    this.m_roll = (float) Math.toDegrees(Math.asin((double) (2.0f * ((q0 * q2) - (q3 * q1)))));
                    this.m_yaw = ((float) Math.toDegrees(Math.atan2((double) (2.0f * ((q0 * q3) + (q1 * q2))), (double) (1.0f - (2.0f * ((q2 * q2) + (q3 * q3))))))) + 180.0f;
                    float[] modifiedQuat = recalculateQuaternion(this.m_pitch, this.m_roll, this.m_yaw);
                    this.m_quaternion_data[0] = modifiedQuat[0];
                    this.m_quaternion_data[1] = modifiedQuat[1];
                    this.m_quaternion_data[2] = modifiedQuat[2];
                    this.m_quaternion_data[3] = modifiedQuat[3];
                    break;
            }
            if (orientation != 3) {
                q0 = this.m_quaternion_data[0];
                q1 = this.m_quaternion_data[1];
                q2 = this.m_quaternion_data[2];
                q3 = this.m_quaternion_data[3];
                this.m_pitch = (float) Math.toDegrees(Math.atan2((double) (2.0f * ((q0 * q1) + (q2 * q3))), (double) (1.0f - (2.0f * ((q1 * q1) + (q2 * q2))))));
                this.m_roll = (float) Math.toDegrees(Math.asin((double) (2.0f * ((q0 * q2) - (q3 * q1)))));
                this.m_yaw = (float) Math.toDegrees(Math.atan2((double) (2.0f * ((q0 * q3) + (q1 * q2))), (double) (1.0f - (2.0f * ((q2 * q2) + (q3 * q3))))));
            }
        }
    }

    private float[] recalculateQuaternion(float _pitch, float _roll, float _yaw) {
        float roll = (float) Math.toRadians((double) _pitch);
        float pitch = (float) Math.toRadians((double) _roll);
        float yaw = (float) Math.toRadians((double) _yaw);
        return new float[]{(float) (((Math.cos((double) (roll / 2.0f)) * Math.cos((double) (pitch / 2.0f))) * Math.cos((double) (yaw / 2.0f))) + ((Math.sin((double) (roll / 2.0f)) * Math.sin((double) (pitch / 2.0f))) * Math.sin((double) (yaw / 2.0f)))), (float) (((Math.sin((double) (roll / 2.0f)) * Math.cos((double) (pitch / 2.0f))) * Math.cos((double) (yaw / 2.0f))) - ((Math.cos((double) (roll / 2.0f)) * Math.sin((double) (pitch / 2.0f))) * Math.sin((double) (yaw / 2.0f)))), (float) (((Math.cos((double) (roll / 2.0f)) * Math.sin((double) (pitch / 2.0f))) * Math.cos((double) (yaw / 2.0f))) + ((Math.sin((double) (roll / 2.0f)) * Math.cos((double) (pitch / 2.0f))) * Math.sin((double) (yaw / 2.0f)))), (float) (((Math.cos((double) (roll / 2.0f)) * Math.cos((double) (pitch / 2.0f))) * Math.sin((double) (yaw / 2.0f))) - ((Math.sin((double) (roll / 2.0f)) * Math.sin((double) (pitch / 2.0f))) * Math.cos((double) (yaw / 2.0f))))};
    }

    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    public void removeListener() {
        if (hasRequiredSensors()) {
            this.mSensorManager.unregisterListener(this);
        }
    }

    public float getRoll() {
        return this.m_roll;
    }

    public float getYaw() {
        return this.m_yaw;
    }

    public float getPitch() {
        return this.m_pitch;
    }

    public float getW() {
        return this.m_quaternion_data[0];
    }

    public float getX() {
        return this.m_quaternion_data[1];
    }

    public float getY() {
        return this.m_quaternion_data[2];
    }

    public float getZ() {
        return this.m_quaternion_data[3];
    }

    public float[] getQuaternionData() {
        return this.m_quaternion_data;
    }

    public DeviceRotation(Context context) {
        this.mContext = context;
        if (hasRequiredSensors()) {
            this.mSensorManager = (SensorManager) this.mContext.getSystemService("sensor");
            this.mSensorManager.registerListener(this, this.mSensorManager.getDefaultSensor(15), 0);
        }
    }

    private boolean hasRequiredSensors() {
        if (VERSION.SDK_INT >= 18 && this.mContext.getPackageManager().hasSystemFeature("android.hardware.sensor.accelerometer") && this.mContext.getPackageManager().hasSystemFeature("android.hardware.sensor.gyroscope")) {
            return true;
        }
        return false;
    }
}
