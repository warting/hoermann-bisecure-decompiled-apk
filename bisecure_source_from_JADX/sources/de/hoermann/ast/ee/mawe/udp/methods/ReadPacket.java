package de.hoermann.ast.ee.mawe.udp.methods;

import com.adobe.fre.FREASErrorException;
import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREReadOnlyException;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocket;
import java.net.DatagramPacket;
import java.nio.ByteBuffer;

public class ReadPacket extends UDPFunktionBase {
    public FREObject call(FREContext context, FREObject[] args) {
        Exception e;
        UDPSocket socket = getSocket(context);
        FREObject result = null;
        DatagramPacket packet = socket.readReceivedPacket();
        if (packet == null) {
            return null;
        }
        try {
            result = FREObject.newObject("flash.events.DatagramSocketDataEvent", new FREObject[]{FREObject.newObject("data")});
            FREByteArray byteArray = args[0];
            byteArray.setProperty("length", FREObject.newObject(packet.getData().length));
            byteArray.acquire();
            ByteBuffer bytes = byteArray.getBytes();
            bytes.position(0);
            bytes.put(packet.getData());
            byteArray.release();
            result.setProperty("srcAddress", FREObject.newObject(packet.getAddress().getHostAddress()));
            result.setProperty("srcPort", FREObject.newObject(packet.getPort()));
            result.setProperty("dstAddress", FREObject.newObject(socket.getAddress()));
            result.setProperty("dstPort", FREObject.newObject(socket.getPort()));
            return result;
        } catch (IllegalStateException e2) {
            e = e2;
        } catch (FRETypeMismatchException e3) {
            e = e3;
        } catch (FREASErrorException e4) {
            e = e4;
        } catch (FREInvalidObjectException e5) {
            e = e5;
        } catch (FREWrongThreadException e6) {
            e = e6;
        } catch (FRENoSuchNameException e7) {
            e = e7;
        } catch (FREReadOnlyException e8) {
            e = e8;
        }
        socket.log(e);
        return result;
    }
}
