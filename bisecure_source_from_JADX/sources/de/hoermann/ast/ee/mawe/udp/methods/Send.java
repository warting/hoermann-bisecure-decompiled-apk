package de.hoermann.ast.ee.mawe.udp.methods;

import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocket;
import java.nio.ByteBuffer;

public class Send extends UDPFunktionBase {
    public FREObject call(FREContext context, FREObject[] args) {
        Exception e;
        FREObject result;
        boolean success = false;
        UDPSocket socket = getSocket(context);
        FREByteArray byteArray = args[0];
        if (byteArray != null) {
            try {
                String ip = args[1].getAsString();
                int port = args[2].getAsInt();
                byteArray.acquire();
                ByteBuffer byteBuffer = byteArray.getBytes();
                byte[] bytes = new byte[byteBuffer.limit()];
                byteBuffer.get(bytes);
                byteArray.release();
                success = socket.send(bytes, ip, port);
            } catch (IllegalStateException e2) {
                e = e2;
                socket.log(e);
                result = null;
                result = FREObject.newObject(success);
                return result;
            } catch (FRETypeMismatchException e3) {
                e = e3;
                socket.log(e);
                result = null;
                result = FREObject.newObject(success);
                return result;
            } catch (FREWrongThreadException e4) {
                e = e4;
                socket.log(e);
                result = null;
                result = FREObject.newObject(success);
                return result;
            } catch (FREInvalidObjectException e5) {
                e = e5;
                socket.log(e);
                result = null;
                result = FREObject.newObject(success);
                return result;
            }
        }
        result = null;
        try {
            result = FREObject.newObject(success);
        } catch (Exception e6) {
            socket.log(e6);
        }
        return result;
    }
}
