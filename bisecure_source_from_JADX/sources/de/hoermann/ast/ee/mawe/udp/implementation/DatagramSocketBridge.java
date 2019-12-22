package de.hoermann.ast.ee.mawe.udp.implementation;

import android.os.Build.VERSION;
import android.util.Log;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketAddress;
import java.net.SocketException;
import java.nio.channels.ClosedByInterruptException;
import java.nio.channels.DatagramChannel;

public class DatagramSocketBridge {
    private DatagramSocket[] sockets;
    private UDPSocket udp;

    public DatagramSocketBridge(UDPSocket udpSocket) throws IOException {
        int apiLevel = VERSION.SDK_INT;
        if (apiLevel <= 22) {
            this.sockets = new DatagramSocket[1];
            udpSocket.log("detected API-Level: " + apiLevel + " => using SINGLE SOCKET approach");
        } else {
            this.sockets = new DatagramSocket[2];
            udpSocket.log("detected API-Level: " + apiLevel + " => using MULTI SOCKET approach");
        }
        initSockets();
    }

    public boolean getBroadcast() throws SocketException {
        return getSendSocket().getBroadcast() && getReceiveSocket().getBroadcast();
    }

    public void send(DatagramPacket p) throws IOException {
        try {
            getSendSocket().send(p);
        } catch (ClosedByInterruptException e) {
            Log.e("DatagramSocketBridge", "failed to send", e);
        }
    }

    public DatagramChannel getChannel() {
        return getSendSocket().getChannel();
    }

    public synchronized void setSoTimeout(int timeout) throws SocketException {
        getReceiveSocket().setSoTimeout(timeout);
    }

    public synchronized void receive(DatagramPacket p) throws IOException {
        try {
            getReceiveSocket().receive(p);
        } catch (ClosedByInterruptException e) {
            Log.e("DatagramSocketBridge", "failed to receive", e);
        }
    }

    public synchronized void bind(SocketAddress addr) throws SocketException {
        getReceiveSocket().bind(addr);
    }

    public int getLocalPort() {
        return getReceiveSocket().getLocalPort();
    }

    public InetAddress getLocalAddress() {
        return getReceiveSocket().getLocalAddress();
    }

    public void close() {
        for (DatagramSocket socket : this.sockets) {
            socket.close();
        }
    }

    private DatagramSocket getSendSocket() {
        return this.sockets[0];
    }

    private DatagramSocket getReceiveSocket() {
        return this.sockets.length == 1 ? this.sockets[0] : this.sockets[1];
    }

    private void initSockets() throws IOException {
        for (int i = 0; i < this.sockets.length; i++) {
            DatagramChannel channel = DatagramChannel.open();
            channel.configureBlocking(true);
            this.sockets[i] = channel.socket();
            this.sockets[i].setBroadcast(true);
            this.sockets[i].setReuseAddress(true);
        }
    }
}
