package com.adobe.air;

import android.content.SharedPreferences.Editor;
import android.util.Base64;

class AndroidEncryptedLocalStore {
    private static final String LOG_TAG = "AndroidELS -------";

    AndroidEncryptedLocalStore() {
    }

    public boolean setItem(String fileName, String key, byte[] bytesValue) throws OutOfMemoryError {
        String stringValue = Base64.encodeToString(bytesValue, 0);
        Editor editor = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(fileName, 0).edit();
        editor.putString(key, stringValue);
        return editor.commit();
    }

    public byte[] getItem(String fileName, String key) throws OutOfMemoryError {
        String stringValue = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(fileName, 0).getString(key, null);
        if (stringValue != null) {
            return Base64.decode(stringValue, 0);
        }
        return null;
    }

    public boolean removeItem(String fileName, String key) {
        Editor editor = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(fileName, 0).edit();
        editor.remove(key);
        return editor.commit();
    }

    public boolean reset(String fileName) {
        Editor editor = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(fileName, 0).edit();
        editor.clear();
        return editor.commit();
    }
}
