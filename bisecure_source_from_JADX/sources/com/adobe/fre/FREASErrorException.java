package com.adobe.fre;

public class FREASErrorException extends Exception {
    public static final long serialVersionUID = 1;
    private FREObject m_thrownASException;

    public FREObject getThrownException() {
        return this.m_thrownASException;
    }
}
