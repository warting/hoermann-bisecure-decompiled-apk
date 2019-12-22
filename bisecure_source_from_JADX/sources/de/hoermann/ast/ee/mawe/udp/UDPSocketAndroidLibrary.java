package de.hoermann.ast.ee.mawe.udp;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import de.hoermann.ast.ee.mawe.udp.context.UDPSocketContext;
import de.hoermann.ast.ee.mawe.udp.context.UDPSocketContextBase;

public class UDPSocketAndroidLibrary implements FREExtension {
    public void initialize() {
    }

    public FREContext createContext(String arg) {
        if ("shared".equals(arg)) {
            return new UDPSocketContextBase();
        }
        return new UDPSocketContext();
    }

    public void dispose() {
    }
}
