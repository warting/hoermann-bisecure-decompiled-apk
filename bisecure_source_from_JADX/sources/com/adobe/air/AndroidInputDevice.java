package com.adobe.air;

import android.view.InputDevice;
import android.view.InputDevice.MotionRange;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.view.MotionEvent;
import com.adobe.air.AndroidActivityWrapper.FlashPermission;
import java.util.ArrayList;
import java.util.List;

/* compiled from: AndroidInputManager */
class AndroidInputDevice {
    private InputDevice mDevice = null;
    private List<AndroidInputControl> mInputControls = null;
    private int mNumControls = 0;

    public AndroidInputDevice(InputDevice device) {
        this.mDevice = device;
        this.mInputControls = new ArrayList();
        for (MotionRange range : device.getMotionRanges()) {
            if ((range.getSource() & 16) != 0) {
                this.mInputControls.add(new AndroidInputControl(ControlType.AXIS, range.getAxis(), range.getMin(), range.getMax()));
                this.mNumControls++;
            }
        }
        int index = 0;
        while (index < KeyEvent.getMaxKeyCode()) {
            if (KeyCharacterMap.deviceHasKey(index) && isGameKey(index)) {
                this.mInputControls.add(new AndroidInputControl(ControlType.BUTTON, index, 0.0f, 1.0f));
                this.mNumControls++;
            }
            index++;
        }
    }

    public String getName() {
        return this.mDevice.getName();
    }

    public String getUniqueId() {
        return this.mDevice.getDescriptor();
    }

    public int getNumControls() {
        return this.mNumControls;
    }

    public AndroidInputControl getInputControl(int index) {
        return (AndroidInputControl) this.mInputControls.get(index);
    }

    private static boolean isGameKey(int keyCode) {
        switch (keyCode) {
            case 19:
            case 20:
            case 21:
            case FlashPermission.CAMERA_ROLL /*22*/:
            case 23:
                return true;
            default:
                return KeyEvent.isGamepadButton(keyCode);
        }
    }

    public boolean onKeyEvent(KeyEvent event) {
        for (int i = 0; i < this.mInputControls.size(); i++) {
            AndroidInputControl inputControl = (AndroidInputControl) this.mInputControls.get(i);
            if (inputControl.getType() == ControlType.BUTTON.ordinal() && inputControl.getCode() == event.getKeyCode()) {
                switch (event.getAction()) {
                    case 0:
                        inputControl.setData(1.0f);
                        return true;
                    case 1:
                        inputControl.setData(0.0f);
                        return true;
                    default:
                        break;
                }
            }
        }
        return false;
    }

    public boolean onGenericMotionEvent(MotionEvent event) {
        for (int i = 0; i < this.mInputControls.size(); i++) {
            AndroidInputControl inputControl = (AndroidInputControl) this.mInputControls.get(i);
            if (inputControl.getType() == ControlType.AXIS.ordinal()) {
                inputControl.setData(event.getAxisValue(inputControl.getCode()));
            }
        }
        return true;
    }
}
