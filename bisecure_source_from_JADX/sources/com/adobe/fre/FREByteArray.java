package com.adobe.fre;

import java.nio.ByteBuffer;

public class FREByteArray extends FREObject {
    private long m_dataPointer;

    public native void acquire() throws FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native ByteBuffer getBytes() throws FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native long getLength() throws FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    public native void release() throws FREInvalidObjectException, FREWrongThreadException, IllegalStateException;

    private FREByteArray(CFREObjectWrapper obj) {
        super(obj);
    }

    protected FREByteArray() throws FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, IllegalStateException {
        super("flash.utils.ByteArray", null);
    }

    public static FREByteArray newByteArray() throws FREASErrorException, FREWrongThreadException, IllegalStateException {
        try {
            return new FREByteArray();
        } catch (FRETypeMismatchException e) {
        } catch (FREInvalidObjectException e2) {
        } catch (FRENoSuchNameException e3) {
        }
        return null;
    }
}
