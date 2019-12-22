package com.adobe.air;

import android.os.Build.VERSION;

public class FlashEGLFactory {

    public enum FlashEGLType {
        FLASHEGL10,
        FLASHEGL14
    }

    private FlashEGLFactory() {
    }

    public static FlashEGL CreateFlashEGL() {
        FlashEGLType type = FlashEGLType.FLASHEGL10;
        if (VERSION.SDK_INT >= 21 || VERSION.CODENAME.equals("L")) {
            type = FlashEGLType.FLASHEGL14;
        }
        return CreateFlashEGL(type);
    }

    public static FlashEGL CreateFlashEGL(FlashEGLType type) {
        switch (type) {
            case FLASHEGL14:
                return new FlashEGL10();
            default:
                return new FlashEGL10();
        }
    }
}
