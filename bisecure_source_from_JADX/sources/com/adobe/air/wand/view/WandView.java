package com.adobe.air.wand.view;

import android.content.res.Configuration;
import android.graphics.Bitmap;

public interface WandView {

    public interface Listener {
        String getConnectionToken();

        void onLoadCompanion(Configuration configuration) throws Exception;
    }

    public enum ScreenOrientation {
        LANDSCAPE("LANDSCAPE"),
        PORTRAIT("PORTRAIT"),
        REVERSE_LANDSCAPE("REVERSE_LANDSCAPE"),
        REVERSE_PORTRAIT("REVERSE_PORTRAIT"),
        AUTO("AUTO"),
        INHERIT("INHERIT");
        
        private final String mOrientation;

        private ScreenOrientation(String orientation) {
            this.mOrientation = orientation;
        }

        public String toString() {
            return this.mOrientation;
        }

        public static ScreenOrientation getScreenOrientation(String orientation) throws Exception {
            if (LANDSCAPE.toString().equals(orientation)) {
                return LANDSCAPE;
            }
            if (PORTRAIT.toString().equals(orientation)) {
                return PORTRAIT;
            }
            if (REVERSE_LANDSCAPE.toString().equals(orientation)) {
                return REVERSE_LANDSCAPE;
            }
            if (REVERSE_PORTRAIT.toString().equals(orientation)) {
                return REVERSE_PORTRAIT;
            }
            if (AUTO.toString().equals(orientation)) {
                return AUTO;
            }
            if (INHERIT.toString().equals(orientation)) {
                return INHERIT;
            }
            throw new Exception("Unspported screen orientation");
        }
    }

    void drawImage(Bitmap bitmap) throws Exception;

    TouchSensor getTouchSensor();

    void loadCompanionView() throws Exception;

    void loadDefaultView() throws Exception;

    void registerListener(Listener listener) throws Exception;

    void setScreenOrientation(ScreenOrientation screenOrientation) throws Exception;

    void unregisterListener();

    void updateConnectionToken(String str);
}
