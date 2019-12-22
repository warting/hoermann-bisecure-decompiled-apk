package de.hoermann.ast.ee.mawe.udp.implementation;

import android.util.Log;
import java.net.DatagramPacket;
import java.nio.channels.IllegalBlockingModeException;

public class UDPSendingThread implements Runnable {
    private volatile boolean running = true;
    private DatagramSocketBridge socket;
    private UDPSocket udpSocket;

    public UDPSendingThread(UDPSocket udpSocket, DatagramSocketBridge socket) {
        this.socket = socket;
        this.udpSocket = udpSocket;
        Log.i(UDPSocket.LOG_TAG, "Creating SendRunnable: " + System.identityHashCode(this) + "\nUDPSocket: " + System.identityHashCode(udpSocket) + "\nDatagramSocket: " + System.identityHashCode(socket) + "\n");
    }

    public void run() {
        Log.i(UDPSocket.LOG_TAG, "Entering run() - SendRunnable: " + System.identityHashCode(this) + "\nUDPSocket: " + System.identityHashCode(this.udpSocket) + "\nDatagramSocket: " + System.identityHashCode(this.socket) + "\n");
        while (this.running) {
            DatagramPacket packet = this.udpSocket.readPacketToSend();
            while (packet != null) {
                try {
                    this.socket.send(packet);
                    this.udpSocket.notifySend(true);
                } catch (Exception e) {
                    this.udpSocket.log(e);
                    this.udpSocket.notifySend(false);
                } catch (IllegalBlockingModeException e2) {
                    Log.e(UDPSocket.LOG_TAG, "IllegalBlockingModeException - SendRunnable: " + System.identityHashCode(this) + "\nUDPSocket: " + System.identityHashCode(this.udpSocket) + "\nDatagramSocket: " + System.identityHashCode(this.socket) + "\nDatagramChannel: " + System.identityHashCode(this.socket.getChannel()) + "\n\t DatagramChannel.isBlocking: " + this.socket.getChannel().isBlocking());
                    this.udpSocket.notifySend(false);
                    Log.e(UDPSocket.LOG_TAG, "Error Sending Udp Packet - " + this.socket.getChannel().isBlocking(), e2);
                }
                packet = this.udpSocket.readPacketToSend();
            }
        }
    }

    public void stop() {
        if (this.running) {
            this.running = false;
        }
    }
}
