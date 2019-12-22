package de.hoermann.ast.ee.mawe.udp.implementation;

public interface UDPSocketListener {
    void onReceive(boolean z);

    void onSend(boolean z);

    void onStatusEvent(String str, String str2);
}
