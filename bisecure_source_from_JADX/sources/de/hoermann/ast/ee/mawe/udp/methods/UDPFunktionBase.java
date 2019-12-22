package de.hoermann.ast.ee.mawe.udp.methods;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import de.hoermann.ast.ee.mawe.udp.context.UDPSocketContext;
import de.hoermann.ast.ee.mawe.udp.implementation.SharedObject;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocket;

public class UDPFunktionBase implements FREFunction {
    protected UDPSocket getSocket(FREContext context) {
        UDPSocketContext ctx = (UDPSocketContext) context;
        if (ctx == null) {
            return null;
        }
        SharedObject so = ctx.sharedObject;
        if (so != null) {
            return so.udpSocket;
        }
        return null;
    }

    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        return null;
    }
}
