package de.hoermann.ast.ee.mawe.udp.implementation;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.wifi.WifiManager;
import android.text.format.Formatter;
import android.util.Log;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.util.concurrent.LinkedBlockingQueue;

public class UDPSocket {
    public static final String LOG_TAG = "UDP_Socket";
    private String address;
    private Context applicationContext;
    private Thread listenThread;
    private UDPSocketListener listener;
    private int port;
    private Thread sendingThread;
    private DatagramSocketBridge socket;
    private LinkedBlockingQueue<DatagramPacket> theReceiveQueue;
    private LinkedBlockingQueue<DatagramPacket> theSendQueue;
    private UDPListeningThread udpListeningThread;
    private UDPSendingThread udpSendingThread;

    public UDPSocket(Context applicationContext) {
        this.applicationContext = applicationContext;
        init();
    }

    public UDPSocket(Context applicationContext, UDPSocketListener listener) {
        this.applicationContext = applicationContext;
        setListener(listener);
        init();
    }

    private void init() {
        try {
            this.socket = new DatagramSocketBridge(this);
            Log.i(LOG_TAG, "Creating UDPSocket: " + System.identityHashCode(this) + "\nDatagramSocket: " + System.identityHashCode(this.socket) + "\n\t socket.getBroadcast: " + this.socket.getBroadcast());
        } catch (Exception e) {
            log(e);
            Log.e(LOG_TAG, "Error creating Socket", e);
        }
        this.theReceiveQueue = new LinkedBlockingQueue();
        this.theSendQueue = new LinkedBlockingQueue();
        Log.i(LOG_TAG, "Creating Queues for UDPSocket: " + System.identityHashCode(this) + "\nReceiveQueue: " + System.identityHashCode(this.theReceiveQueue) + "\nSendQueue: " + System.identityHashCode(this.theSendQueue));
    }

    public void setListener(UDPSocketListener listener) {
        this.listener = listener;
    }

    private void startSendingThread() {
        if (this.sendingThread == null) {
            this.udpSendingThread = new UDPSendingThread(this, this.socket);
            this.sendingThread = new Thread(this.udpSendingThread);
            this.sendingThread.start();
            Log.i(LOG_TAG, "Starting SendThread: " + System.identityHashCode(this.sendingThread) + "\nRunnable: " + System.identityHashCode(this.udpSendingThread) + "\n");
        }
    }

    private void stopSendingThread() {
        if (this.sendingThread != null) {
            Log.i(LOG_TAG, "Stopping SendThread: " + System.identityHashCode(this.sendingThread) + "\nRunnable: " + System.identityHashCode(this.udpSendingThread) + "\n");
            this.udpSendingThread.stop();
            Thread t = this.sendingThread;
            this.sendingThread = null;
            t.interrupt();
        }
    }

    private void startListeningThread() {
        if (this.listenThread == null) {
            this.udpListeningThread = new UDPListeningThread(this, this.socket);
            this.listenThread = new Thread(this.udpListeningThread);
            this.listenThread.start();
            Log.i(LOG_TAG, "Starting ListenThread: " + System.identityHashCode(this.listenThread) + "\nRunnable: " + System.identityHashCode(this.udpListeningThread) + "\n");
        }
    }

    private void stopListeningThread() {
        if (this.listenThread != null) {
            Log.i(LOG_TAG, "Stopping ListenThread: " + System.identityHashCode(this.listenThread) + "\nRunnable: " + System.identityHashCode(this.udpListeningThread) + "\n");
            this.udpListeningThread.stop();
            Thread t = this.listenThread;
            this.listenThread = null;
            t.interrupt();
        }
    }

    public void dispose() {
        Log.i(LOG_TAG, "Disposing UDPSocket: " + System.identityHashCode(this) + "\nDatagramSocket: " + System.identityHashCode(this.socket) + "\n");
        close();
        setListener(null);
    }

    public boolean bind(int port) {
        try {
            this.socket.bind(new InetSocketAddress(port));
            this.port = this.socket.getLocalPort();
            this.address = this.socket.getLocalAddress().getHostAddress();
            return true;
        } catch (Exception e) {
            log(e);
            Log.e(LOG_TAG, "Error Binding UDPSocket", e);
            return false;
        }
    }

    public boolean bind(int port, String host) {
        log("bind on " + host + ":" + port);
        try {
            this.socket.bind(new InetSocketAddress(host, port));
            this.port = this.socket.getLocalPort();
            this.address = this.socket.getLocalAddress().getHostAddress();
            Log.i(LOG_TAG, "Binging UDPSocket: " + System.identityHashCode(this) + "\nTo: " + host + ":" + port + "\nDatagramSocket: " + System.identityHashCode(this.socket) + "\n\t socket.getBroadcast: " + this.socket.getBroadcast());
            return true;
        } catch (Exception e) {
            log(e);
            Log.e(LOG_TAG, "Error Binding UDPSocket", e);
            return false;
        }
    }

    public boolean close() {
        stopListeningThread();
        stopSendingThread();
        this.socket.close();
        return true;
    }

    public String getAddress() {
        return this.address;
    }

    public int getPort() {
        return this.port;
    }

    public DatagramPacket readReceivedPacket() {
        return (DatagramPacket) this.theReceiveQueue.poll();
    }

    public DatagramPacket readPacketToSend() {
        return (DatagramPacket) this.theSendQueue.poll();
    }

    public boolean receive() {
        startListeningThread();
        return true;
    }

    public boolean send(byte[] data, String ip, int port) {
        if (this.sendingThread == null) {
            startSendingThread();
        }
        try {
            this.theSendQueue.add(new DatagramPacket(data, data.length, InetAddress.getByName(ip), port));
            return true;
        } catch (Exception e) {
            log(e);
            Log.e(LOG_TAG, "Error sending Packet", e);
            return false;
        }
    }

    public void handlePacket(DatagramPacket packet) {
        if (packet.getAddress() != null) {
            byte[] dst = new byte[packet.getLength()];
            System.arraycopy(packet.getData(), 0, dst, 0, dst.length);
            packet.setData(dst);
            this.theReceiveQueue.add(packet);
            dispatchStatusEvent("receive", "");
        }
    }

    public void log(Exception e) {
        dispatchStatusEvent("error", Log.getStackTraceString(e));
    }

    public void log(String message) {
        dispatchStatusEvent("log", "[UDP_ANE] " + message);
    }

    void notifySend(boolean success) {
        if (this.listener != null) {
            this.listener.onSend(success);
        }
    }

    void notifyReceive(boolean success) {
        if (this.listener != null) {
            this.listener.onReceive(success);
        }
    }

    public String getLocalIpAddress() {
        if (((ConnectivityManager) this.applicationContext.getSystemService("connectivity")).getNetworkInfo(1).isAvailable()) {
            return Formatter.formatIpAddress(((WifiManager) this.applicationContext.getSystemService("wifi")).getConnectionInfo().getIpAddress());
        }
        return null;
    }

    private boolean dispatchStatusEvent(String code, String level) {
        if (this.listener == null) {
            return false;
        }
        this.listener.onStatusEvent(code, level);
        return true;
    }
}
