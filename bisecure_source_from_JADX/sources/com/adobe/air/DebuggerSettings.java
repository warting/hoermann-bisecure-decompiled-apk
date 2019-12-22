package com.adobe.air;

public final class DebuggerSettings {
    private int debuggerPort = -1;
    private String host = null;
    private boolean listenForConn = false;

    DebuggerSettings() {
    }

    DebuggerSettings(int port, String hostOrIP, boolean dolisten) {
        this.debuggerPort = port;
        this.host = hostOrIP;
        this.listenForConn = dolisten;
    }

    public int getDebuggerPort() {
        return this.debuggerPort;
    }

    public String getHost() {
        return this.host;
    }

    public boolean shouldListen() {
        return this.listenForConn;
    }

    public void setDebugerPort(int port) {
        this.debuggerPort = port;
    }

    public void setHost(String hostOrIP) {
        this.host = hostOrIP;
    }

    public void setListen(boolean listen) {
        this.listenForConn = listen;
    }
}
