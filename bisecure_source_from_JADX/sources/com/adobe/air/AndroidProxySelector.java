package com.adobe.air;

import java.net.Proxy;
import java.net.Proxy.Type;
import java.net.ProxySelector;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;

public final class AndroidProxySelector {
    private static final int LIST_HEAD = 0;
    private static final String LOG_TAG = "AndroidProxySelector";

    public static String getProxyUrl(String urlToConnect) {
        try {
            List<Proxy> proxyServers = ProxySelector.getDefault().select(new URI(urlToConnect));
            if (proxyServers.isEmpty()) {
                return "";
            }
            Proxy proxyUrl = (Proxy) proxyServers.get(0);
            if (Proxy.NO_PROXY != proxyUrl) {
                if (Type.HTTP == proxyUrl.type()) {
                    return proxyUrl.address().toString();
                }
            }
            return "";
        } catch (URISyntaxException e) {
        } catch (IllegalArgumentException e2) {
        } catch (IndexOutOfBoundsException e3) {
        }
    }
}
