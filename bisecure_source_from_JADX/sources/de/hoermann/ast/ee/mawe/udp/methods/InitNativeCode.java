package de.hoermann.ast.ee.mawe.udp.methods;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import de.hoermann.ast.ee.mawe.udp.context.UDPSocketContext;
import de.hoermann.ast.ee.mawe.udp.implementation.SharedObject;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocket;

public class InitNativeCode implements FREFunction {
    public FREObject call(FREContext context, FREObject[] args) {
        UDPSocketContext udpContext = (UDPSocketContext) context;
        if (udpContext.sharedObject == null) {
            udpContext.sharedObject = new SharedObject();
        }
        if (udpContext.sharedObject.udpSocket == null) {
            udpContext.sharedObject.udpSocket = new UDPSocket(udpContext.getActivity().getApplicationContext(), udpContext);
        }
        return null;
    }
}
