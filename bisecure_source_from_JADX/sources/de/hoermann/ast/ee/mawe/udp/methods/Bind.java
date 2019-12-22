package de.hoermann.ast.ee.mawe.udp.methods;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocket;

public class Bind extends UDPFunktionBase {
    public FREObject call(FREContext context, FREObject[] args) {
        Exception e;
        FREObject fREObject;
        UDPSocket socket = getSocket(context);
        if (socket == null) {
            try {
                return FREObject.newObject(false);
            } catch (FREWrongThreadException e2) {
                e2.printStackTrace();
                return null;
            }
        }
        boolean success = false;
        try {
            int port = args[0].getAsInt();
            String address = args[1].getAsString();
            if (address.equals("0.0.0.0")) {
                success = socket.bind(port);
            } else {
                success = socket.bind(port, address);
            }
        } catch (IllegalStateException e3) {
            e = e3;
            socket.log(e);
            fREObject = null;
            return FREObject.newObject(success);
        } catch (FREWrongThreadException e4) {
            e = e4;
            socket.log(e);
            fREObject = null;
            return FREObject.newObject(success);
        } catch (FREInvalidObjectException e5) {
            e = e5;
            socket.log(e);
            fREObject = null;
            return FREObject.newObject(success);
        } catch (FRETypeMismatchException e6) {
            e = e6;
            socket.log(e);
            fREObject = null;
            return FREObject.newObject(success);
        }
        fREObject = null;
        try {
            return FREObject.newObject(success);
        } catch (Exception e7) {
            socket.log(e7);
            return fREObject;
        }
    }
}
