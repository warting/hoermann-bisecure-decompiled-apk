package de.hoermann.ast.ee.mawe.udp.context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import de.hoermann.ast.ee.mawe.udp.methods.IsSupported;
import java.util.HashMap;
import java.util.Map;

public class UDPSocketContextBase extends FREContext {
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap();
        map.put("isSupported", new IsSupported());
        return map;
    }

    public void dispose() {
    }
}
