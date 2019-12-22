package com.adobe.air.net;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.DhcpInfo;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.text.format.Formatter;
import java.util.Vector;

class AndroidNetworkInfo {
    private static final String LOG_TAG = "AndroidNetworkInfo";
    private static AndroidNetworkInfo sAndroidNetworkInfo = null;
    private Context mContext;
    private Vector<NetworkInterface> mInterfaces = new Vector();

    public static AndroidNetworkInfo GetAndroidNetworkInfo(Context context) {
        if (sAndroidNetworkInfo == null) {
            sAndroidNetworkInfo = new AndroidNetworkInfo(context);
        }
        return sAndroidNetworkInfo;
    }

    private AndroidNetworkInfo(Context context) {
        this.mContext = context;
    }

    public int GetNetworkInterfacesCount() {
        this.mInterfaces.clear();
        enumerateNetworkInterfaces();
        return this.mInterfaces.size();
    }

    public void InterfacesReadComplete() {
        this.mInterfaces.clear();
    }

    private void enumerateNetworkInterfaces() {
        try {
            NetworkInfo[] infos = ((ConnectivityManager) this.mContext.getSystemService("connectivity")).getAllNetworkInfo();
            for (NetworkInfo info : infos) {
                NetworkInterface ni;
                switch (info.getType()) {
                    case 1:
                        ni = getWifiData(info);
                        break;
                    default:
                        ni = getDefaultData(info);
                        break;
                }
                this.mInterfaces.add(ni);
            }
        } catch (Exception e) {
            this.mInterfaces.clear();
        }
    }

    public NetworkInterface GetNetworkInterface(int index) {
        if (index < 0 || index >= this.mInterfaces.size()) {
            return null;
        }
        return (NetworkInterface) this.mInterfaces.elementAt(index);
    }

    NetworkInterface getWifiData(NetworkInfo info) {
        WifiInfo wifiInfo;
        NetworkInterface networkInterface = new NetworkInterface();
        WifiManager wifiManager = (WifiManager) this.mContext.getSystemService("wifi");
        if (wifiManager == null) {
            wifiInfo = wifiManager.getConnectionInfo();
        } else {
            wifiInfo = wifiManager.getConnectionInfo();
        }
        if (wifiInfo == null) {
            networkInterface.active = info.isConnected();
            networkInterface.displayName = info.getTypeName();
            networkInterface.name = info.getTypeName();
        } else {
            networkInterface.active = info.isConnected();
            networkInterface.displayName = info.getTypeName();
            networkInterface.name = info.getTypeName();
        }
        if (wifiInfo != null) {
            String macAddr = wifiInfo.getMacAddress();
            if (macAddr == null) {
                macAddr = "";
            }
            networkInterface.hardwareAddress = macAddr;
        }
        networkInterface.addAddress(getAddress(info));
        return networkInterface;
    }

    NetworkInterface getDefaultData(NetworkInfo info) {
        NetworkInterface networkInterface = new NetworkInterface();
        networkInterface.active = info.isConnected();
        networkInterface.displayName = info.getTypeName();
        networkInterface.name = info.getTypeName();
        return networkInterface;
    }

    InterfaceAddress getAddress(NetworkInfo info) {
        InterfaceAddress interfaceAddress = new InterfaceAddress();
        if (!info.isConnected()) {
            return null;
        }
        WifiManager wifiManager = (WifiManager) this.mContext.getSystemService("wifi");
        if (wifiManager == null) {
            return null;
        }
        DhcpInfo dhcp = wifiManager.getDhcpInfo();
        if (dhcp != null) {
            interfaceAddress.address = Formatter.formatIpAddress(dhcp.ipAddress);
            interfaceAddress.prefixLength = Integer.bitCount(dhcp.netmask);
            interfaceAddress.broadcast = Formatter.formatIpAddress(dhcp.ipAddress | (dhcp.netmask ^ -1));
            interfaceAddress.ipVersion = "IPv4";
            return interfaceAddress;
        }
        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
        if (wifiInfo == null) {
            return null;
        }
        interfaceAddress.address = Formatter.formatIpAddress(wifiInfo.getIpAddress());
        interfaceAddress.ipVersion = "IPv4";
        return interfaceAddress;
    }
}
