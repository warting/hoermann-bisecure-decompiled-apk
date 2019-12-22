package com.adobe.fre;

import android.app.Activity;
import android.content.res.Resources.NotFoundException;
import java.util.Map;
import java.util.Map.Entry;

public abstract class FREContext {
    private long m_objectPointer;

    private native void registerFunction(long j, String str, FREFunction fREFunction);

    private native void registerFunctionCount(long j, int i);

    public native void dispatchStatusEventAsync(String str, String str2) throws IllegalArgumentException, IllegalStateException;

    public abstract void dispose();

    public native FREObject getActionScriptData() throws FREWrongThreadException, IllegalStateException;

    public native Activity getActivity() throws IllegalStateException;

    public abstract Map<String, FREFunction> getFunctions();

    public native int getResourceId(String str) throws IllegalArgumentException, NotFoundException, IllegalStateException;

    public native void setActionScriptData(FREObject fREObject) throws FREWrongThreadException, IllegalArgumentException, IllegalStateException;

    protected void VisitFunctions(long clientID) {
        Map<String, FREFunction> m = getFunctions();
        registerFunctionCount(clientID, m.size());
        for (Entry<String, FREFunction> e : m.entrySet()) {
            registerFunction(clientID, (String) e.getKey(), (FREFunction) e.getValue());
        }
    }
}
