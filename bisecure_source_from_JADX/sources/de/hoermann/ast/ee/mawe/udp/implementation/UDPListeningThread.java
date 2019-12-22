package de.hoermann.ast.ee.mawe.udp.implementation;

import android.util.Log;
import java.net.DatagramPacket;
import java.net.SocketTimeoutException;

public class UDPListeningThread implements Runnable {
    private volatile boolean listening = true;
    private DatagramSocketBridge socket;
    private UDPSocket udpSocket;

    public UDPListeningThread(UDPSocket udpSocket, DatagramSocketBridge socket) {
        this.udpSocket = udpSocket;
        this.socket = socket;
        Log.i(UDPSocket.LOG_TAG, "Creating ListenRunnable: " + System.identityHashCode(this) + "\nUDPSocket: " + System.identityHashCode(udpSocket) + "\nDatagramSocket: " + System.identityHashCode(socket) + "\n");
    }

    public void run() {
        Log.i(UDPSocket.LOG_TAG, "Entering run() - ListenRunnable: " + System.identityHashCode(this) + "\nUDPSocket: " + System.identityHashCode(this.udpSocket) + "\nDatagramSocket: " + System.identityHashCode(this.socket) + "\n");
        while (this.listening) {
            byte[] packetContent = new byte[1024];
            DatagramPacket packet = new DatagramPacket(packetContent, packetContent.length);
            try {
                this.socket.receive(packet);
                this.udpSocket.handlePacket(packet);
                this.udpSocket.notifyReceive(true);
            } catch (SocketTimeoutException e) {
                this.udpSocket.notifyReceive(false);
            } catch (Exception e2) {
                this.udpSocket.notifyReceive(false);
                this.listening = false;
                this.udpSocket.log(e2);
            }
        }
        Log.e("LISTEN_THREAD", "he is dead jim!");
    }

    public void stop() {
        if (this.listening) {
            this.listening = false;
        }
    }
}
