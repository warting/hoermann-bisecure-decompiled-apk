package com.adobe.air.net;

import java.util.Vector;

public class NetworkInterface {
    public boolean active = false;
    private Vector<InterfaceAddress> addresses = new Vector();
    public String displayName = "";
    public String hardwareAddress = "";
    public int mtu = -1;
    public String name = "";
    public NetworkInterface parent = null;
    public NetworkInterface subInterfaces = null;

    public void addAddress(InterfaceAddress address) {
        this.addresses.add(address);
    }

    public int GetAddressesCount() {
        return this.addresses.size();
    }

    public InterfaceAddress GetAddress(int i) {
        return (InterfaceAddress) this.addresses.elementAt(i);
    }
}
