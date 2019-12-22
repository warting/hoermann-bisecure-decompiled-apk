package com.adobe.air;

import android.content.Context;
import android.content.res.Configuration;
import android.hardware.input.InputManager;
import android.hardware.input.InputManager.InputDeviceListener;
import android.util.SparseArray;
import android.view.InputDevice;
import android.view.KeyEvent;
import android.view.MotionEvent;
import com.adobe.air.AndroidActivityWrapper.ActivityState;

public class AndroidInputManager implements InputDeviceListener, StateChangeCallback, InputEventCallback {
    private static AndroidInputManager sAndroidInputManager = null;
    private Context mContext = null;
    private SparseArray<AndroidInputDevice> mInputDevices = null;
    private InputManager mInputManager = null;
    private long mInternalReference = 0;
    private boolean mListening = false;

    private native void OnDeviceAdded(long j, AndroidInputDevice androidInputDevice, String str);

    private native void OnDeviceRemoved(long j, String str);

    public static boolean isSupported() {
        try {
            if (Class.forName("android.hardware.input.InputManager") != null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    public static AndroidInputManager GetAndroidInputManager(Context c) {
        if (isSupported() && sAndroidInputManager == null) {
            sAndroidInputManager = new AndroidInputManager(c);
        }
        return sAndroidInputManager;
    }

    private AndroidInputManager(Context c) {
        this.mContext = c;
        if (this.mContext != null) {
            this.mInputManager = (InputManager) this.mContext.getSystemService("input");
        }
        AndroidActivityWrapper actWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        if (actWrapper != null) {
            actWrapper.addActivityStateChangeListner(this);
            actWrapper.addInputEventListner(this);
        }
        this.mInputDevices = new SparseArray();
    }

    public AndroidInputDevice getInputDevice(int deviceId) {
        return (AndroidInputDevice) this.mInputDevices.get(deviceId);
    }

    public void setInternalReference(long objRef) {
        this.mInternalReference = objRef;
    }

    public void listenForInputDevice(boolean start) {
        if (this.mInputManager != null) {
            if (start) {
                try {
                    if (!this.mListening) {
                        this.mInputManager.registerInputDeviceListener(this, null);
                        addRemoveExistingInputDevices();
                        this.mListening = true;
                        return;
                    }
                } catch (Exception e) {
                    return;
                }
            }
            if (!start && this.mListening) {
                this.mInputManager.unregisterInputDeviceListener(this);
                this.mListening = false;
            }
        }
    }

    private void addRemoveExistingInputDevices() {
        int[] deviceIds;
        int size = this.mInputDevices.size();
        int index = 0;
        while (index < size) {
            deviceIds = this.mInputManager.getInputDeviceIds();
            int num = 0;
            while (num < deviceIds.length && this.mInputDevices.keyAt(index) != deviceIds[num]) {
                num++;
            }
            if (num == deviceIds.length) {
                OnDeviceRemoved(this.mInternalReference, ((AndroidInputDevice) this.mInputDevices.valueAt(index)).getUniqueId());
                this.mInputDevices.delete(this.mInputDevices.keyAt(index));
            }
            index++;
        }
        deviceIds = this.mInputManager.getInputDeviceIds();
        for (int onInputDeviceAdded : deviceIds) {
            onInputDeviceAdded(onInputDeviceAdded);
        }
    }

    public void onInputDeviceAdded(int deviceId) {
        if (((AndroidInputDevice) this.mInputDevices.get(deviceId)) == null) {
            InputDevice inputDevice = this.mInputManager.getInputDevice(deviceId);
            if (!inputDevice.isVirtual() && (inputDevice.getSources() & 16) != 0 && (inputDevice.getSources() & 1) != 0) {
                AndroidInputDevice device = new AndroidInputDevice(inputDevice);
                this.mInputDevices.put(deviceId, device);
                OnDeviceAdded(this.mInternalReference, device, device.getUniqueId());
            }
        }
    }

    public void onInputDeviceRemoved(int deviceId) {
        AndroidInputDevice device = (AndroidInputDevice) this.mInputDevices.get(deviceId);
        if (device != null) {
            OnDeviceRemoved(this.mInternalReference, device.getUniqueId());
            this.mInputDevices.delete(deviceId);
        }
    }

    public void onInputDeviceChanged(int deviceId) {
        onInputDeviceRemoved(deviceId);
        onInputDeviceAdded(deviceId);
    }

    public boolean onKeyEvent(KeyEvent event) {
        AndroidInputDevice device = (AndroidInputDevice) this.mInputDevices.get(event.getDeviceId());
        if (device != null) {
            return device.onKeyEvent(event);
        }
        return false;
    }

    public boolean onGenericMotionEvent(MotionEvent event) {
        if ((event.getSource() & 16) != 0 && event.getAction() == 2) {
            AndroidInputDevice device = (AndroidInputDevice) this.mInputDevices.get(event.getDeviceId());
            if (device != null) {
                return device.onGenericMotionEvent(event);
            }
        }
        return false;
    }

    public void onActivityStateChanged(ActivityState state) {
        if (state == ActivityState.RESUMED) {
            listenForInputDevice(true);
        } else if (state == ActivityState.PAUSED) {
            listenForInputDevice(false);
        }
    }

    public void onConfigurationChanged(Configuration config) {
    }
}
