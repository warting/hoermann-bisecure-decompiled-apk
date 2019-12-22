package com.adobe.fre;

public interface FREExtension {
    FREContext createContext(String str);

    void dispose();

    void initialize();
}
