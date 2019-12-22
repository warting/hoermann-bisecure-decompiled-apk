package de.hoermann.ast.ee.mawe.udp.context;

import com.adobe.fre.FREFunction;
import de.hoermann.ast.ee.mawe.udp.implementation.SharedObject;
import de.hoermann.ast.ee.mawe.udp.implementation.UDPSocketListener;
import de.hoermann.ast.ee.mawe.udp.methods.Bind;
import de.hoermann.ast.ee.mawe.udp.methods.Close;
import de.hoermann.ast.ee.mawe.udp.methods.InitNativeCode;
import de.hoermann.ast.ee.mawe.udp.methods.ReadPacket;
import de.hoermann.ast.ee.mawe.udp.methods.Receive;
import de.hoermann.ast.ee.mawe.udp.methods.Send;
import java.util.Map;

public class UDPSocketContext extends UDPSocketContextBase implements UDPSocketListener {
    public SharedObject sharedObject = new SharedObject();

    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = super.getFunctions();
        map.put("initNativeCode", new InitNativeCode());
        map.put("send", new Send());
        map.put("bind", new Bind());
        map.put("receive", new Receive());
        map.put("readPacket", new ReadPacket());
        map.put("close", new Close());
        return map;
    }

    public void dispose() {
        if (this.sharedObject != null) {
            if (this.sharedObject.udpSocket == null) {
                this.sharedObject = null;
                return;
            }
            this.sharedObject.udpSocket.dispose();
            this.sharedObject.udpSocket = null;
            this.sharedObject = null;
            super.dispose();
        }
    }

    public void onStatusEvent(String code, String level) {
        dispatchStatusEventAsync(code, level);
    }

    public void onSend(boolean success) {
    }

    public void onReceive(boolean success) {
    }
}
