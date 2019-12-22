package de.hoermann.ast.ee.mawe.udp.methods;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocket;

public class Receive extends UDPFunktionBase {
    public FREObject call(FREContext context, FREObject[] args) {
        UDPSocket socket = getSocket(context);
        FREObject result = null;
        try {
            result = FREObject.newObject(socket.receive());
        } catch (Exception e) {
            socket.log(e);
        }
        return result;
    }
}
