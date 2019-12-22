package com.adobe.fre;

public class FREObject {
    private long m_objectPointer;

    protected static class CFREObjectWrapper {
        private long m_objectPointer;

        private CFREObjectWrapper(long obj) {
            this.m_objectPointer = obj;
        }
    }

    private native void FREObjectFromBoolean(boolean z) throws FREWrongThreadException;

    private native void FREObjectFromClass(String str, FREObject[] fREObjectArr) throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException;

    private native void FREObjectFromDouble(double d) throws FREWrongThreadException;

    private native void FREObjectFromInt(int i) throws FREWrongThreadException;

    private native void FREObjectFromString(String str) throws FREWrongThreadException;

    public static native FREObject newObject(String str, FREObject[] fREObjectArr) throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException;

    public native FREObject callMethod(String str, FREObject[] fREObjectArr) throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException;

    public native boolean getAsBool() throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native double getAsDouble() throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native int getAsInt() throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native String getAsString() throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native FREObject getProperty(String str) throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException;

    public native void setProperty(String str, FREObject fREObject) throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREReadOnlyException, FREWrongThreadException, IllegalStateException;

    protected FREObject(CFREObjectWrapper obj) {
        this.m_objectPointer = obj.m_objectPointer;
    }

    protected FREObject(int value) throws FREWrongThreadException {
        FREObjectFromInt(value);
    }

    protected FREObject(double value) throws FREWrongThreadException {
        FREObjectFromDouble(value);
    }

    protected FREObject(boolean value) throws FREWrongThreadException {
        FREObjectFromBoolean(value);
    }

    protected FREObject(String value) throws FREWrongThreadException {
        FREObjectFromString(value);
    }

    public static FREObject newObject(int value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public static FREObject newObject(double value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public static FREObject newObject(boolean value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public static FREObject newObject(String value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public FREObject(String className, FREObject[] constructorArgs) throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException {
        FREObjectFromClass(className, constructorArgs);
    }
}
