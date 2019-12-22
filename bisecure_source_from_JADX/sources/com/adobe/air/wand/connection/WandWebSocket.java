package com.adobe.air.wand.connection;

import android.app.Activity;
import android.net.ConnectivityManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import com.adobe.air.wand.Version;
import com.adobe.air.wand.connection.Connection.Listener;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.nio.channels.CancelledKeyException;
import java.util.Enumeration;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.util.InetAddressUtils;
import org.apache.http.impl.client.DefaultHttpClient;
import org.java_websocket.WebSocket;
import org.java_websocket.server.WebSocketServer;
import org.json.JSONObject;

public class WandWebSocket implements Connection {
    private static final String CONNECT_PING_URL = "http://dh8vjmvwgc27o.cloudfront.net/AIRGamepad/connect_ping.txt";
    private static final String LOG_TAG = "WandWebSocket";
    private static final String WEBSOCKET_PROTOCOL = "WEBSOCKET";
    private final String HANDSHAKE_SYNCHRONIZER = "HANDSHAKE_SYNCHRONIZER";
    private final String OPEN_SYNCHRONIZER = "OPEN_SYNCHRONIZER";
    private Activity mActivity = null;
    private boolean mAllowIncomingConnection = false;
    private WebSocket mConnection = null;
    private Listener mConnectionListener = null;
    private String mConnectionToken = null;
    private Handshake mHandshake = null;
    private Timer mHandshakeTimer = null;
    private boolean mIsDisposed = false;
    private String mLocalID = null;
    private WandSocketServer mWandSocketServer = null;

    private class ConnectPingTask extends AsyncTask<String, Integer, Long> {
        private ConnectPingTask() {
        }

        protected Long doInBackground(String... requestStrings) {
            if (requestStrings == null || requestStrings.length < 1) {
                return Long.valueOf(0);
            }
            try {
                new DefaultHttpClient().execute(new HttpGet(requestStrings[0]));
                return Long.valueOf(0);
            } catch (Exception e) {
                return Long.valueOf(-1);
            }
        }

        protected void onProgressUpdate(Integer... progress) {
        }

        protected void onPostExecute(Long result) {
        }
    }

    private static class Handshake {
        private static final String APPLICATION_URL = "applicationURL";
        private static final String DESTINATION_ID = "destinationID";
        private static final String PROTOCOL = "protocol";
        private static final String PUBLISHER = "publisher";
        private static final String SOURCE_ID = "sourceID";
        private static final String STATUS = "status";
        private static final String STATUS_SUCCESS = "SUCCESS";
        public static final int TIMEOUT_MILLISECONDS = 30000;
        private static final String VERSION = "version";
        private String mApplicationURL = null;
        private String mDestinationID = null;
        private String mProtocol = WandWebSocket.WEBSOCKET_PROTOCOL;
        private String mPublisher = null;
        private String mSourceID = null;
        private String mVersion = null;

        public String getProtocol() {
            return this.mProtocol;
        }

        public String getVersion() {
            return this.mVersion;
        }

        public String getSourceID() {
            return this.mSourceID;
        }

        public String getDestinationID() {
            return this.mDestinationID;
        }

        public String getPublisher() {
            return this.mPublisher;
        }

        public String getApplicationURL() {
            return this.mApplicationURL;
        }

        private Handshake() {
        }

        public static Handshake parse(String handshakeMessage) throws Exception {
            JSONObject handshakeObject = new JSONObject(handshakeMessage);
            Handshake handshake = new Handshake();
            handshake.mProtocol = handshakeObject.getString(PROTOCOL);
            handshake.mVersion = handshakeObject.getString(VERSION);
            handshake.mSourceID = handshakeObject.getString(SOURCE_ID);
            handshake.mDestinationID = handshakeObject.getString(DESTINATION_ID);
            if (handshakeObject.has(PUBLISHER)) {
                handshake.mPublisher = handshakeObject.getString(PUBLISHER);
            }
            if (handshakeObject.has(APPLICATION_URL)) {
                handshake.mApplicationURL = handshakeObject.getString(APPLICATION_URL);
            }
            return handshake;
        }

        public String getSuccessResponse(String sourceID) throws Exception {
            JSONObject successResponse = new JSONObject();
            successResponse.put(PROTOCOL, WandWebSocket.WEBSOCKET_PROTOCOL);
            successResponse.put(VERSION, this.mVersion);
            successResponse.put(SOURCE_ID, sourceID);
            successResponse.put(DESTINATION_ID, this.mSourceID);
            successResponse.put(STATUS, STATUS_SUCCESS);
            if (Version.isGreaterThanEqualTo(this.mVersion, "1.1.0")) {
                successResponse.put(PUBLISHER, this.mPublisher);
                successResponse.put(APPLICATION_URL, this.mApplicationURL);
            }
            return successResponse.toString();
        }
    }

    private class WandSocketServer extends WebSocketServer {
        private boolean mHasStartedServer = false;

        /* renamed from: com.adobe.air.wand.connection.WandWebSocket$WandSocketServer$1 */
        class C00751 extends TimerTask {
            C00751() {
            }

            public void run() {
                synchronized ("OPEN_SYNCHRONIZER") {
                    if (WandWebSocket.this.mConnection == null) {
                        return;
                    }
                    synchronized ("HANDSHAKE_SYNCHRONIZER") {
                        if (WandWebSocket.this.mHandshake != null) {
                            return;
                        }
                        WandWebSocket.this.mConnection.close(1003, "AIR Gamepad handshake timedout");
                    }
                }
            }
        }

        public WandSocketServer(InetSocketAddress address) throws UnknownHostException {
            super(address);
        }

        public void start() {
            if (!this.mHasStartedServer) {
                super.start();
                this.mHasStartedServer = true;
            }
        }

        public void stop() throws IOException, InterruptedException {
            if (this.mHasStartedServer) {
                try {
                    super.stop();
                } catch (CancelledKeyException e) {
                }
                this.mHasStartedServer = false;
                if (WandWebSocket.this.mWandSocketServer != null) {
                    if (WandWebSocket.this.mConnection != null) {
                        WandWebSocket.this.forceCloseConnection();
                    }
                    WandWebSocket.this.mWandSocketServer = null;
                    try {
                        WandWebSocket.this.startSocketServer();
                    } catch (Exception e2) {
                    }
                }
            }
        }

        /* JADX WARNING: inconsistent code. */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void onOpen(org.java_websocket.WebSocket r3, org.java_websocket.handshake.ClientHandshake r4) {
            /*
            r2 = this;
            r1 = "OPEN_SYNCHRONIZER";
            monitor-enter(r1);
            r0 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0026 }
            r0 = r0.mAllowIncomingConnection;	 Catch:{ all -> 0x0026 }
            if (r0 == 0) goto L_0x001d;
        L_0x000b:
            r0 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0026 }
            r0 = r0.mConnection;	 Catch:{ all -> 0x0026 }
            if (r0 != 0) goto L_0x001d;
        L_0x0013:
            r0 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0026 }
            r0.mConnection = r3;	 Catch:{ all -> 0x0026 }
            r2.scheduleHandshakeTimer();	 Catch:{ all -> 0x0026 }
            monitor-exit(r1);	 Catch:{ all -> 0x0026 }
        L_0x001c:
            return;
        L_0x001d:
            monitor-exit(r1);	 Catch:{ all -> 0x0026 }
            r0 = 1003; // 0x3eb float:1.406E-42 double:4.955E-321;
            r1 = "AIR Gamepad is already connected";
            r3.close(r0, r1);
            goto L_0x001c;
        L_0x0026:
            r0 = move-exception;
            monitor-exit(r1);	 Catch:{ all -> 0x0026 }
            throw r0;
            */
            throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.wand.connection.WandWebSocket.WandSocketServer.onOpen(org.java_websocket.WebSocket, org.java_websocket.handshake.ClientHandshake):void");
        }

        private void scheduleHandshakeTimer() {
            try {
                WandWebSocket.this.mHandshakeTimer.schedule(new C00751(), 30000);
            } catch (Exception e) {
            }
        }

        public void onClose(WebSocket conn, int code, String reason, boolean remote) {
            synchronized ("OPEN_SYNCHRONIZER") {
                if (WandWebSocket.this.mConnection == conn) {
                    WandWebSocket.this.mConnection = null;
                    synchronized ("HANDSHAKE_SYNCHRONIZER") {
                        if (WandWebSocket.this.mHandshake != null) {
                            WandWebSocket.this.mHandshake = null;
                            if (WandWebSocket.this.mConnectionListener != null) {
                                WandWebSocket.this.mConnectionListener.onConnectionClose();
                            }
                        }
                    }
                }
            }
        }

        /* JADX WARNING: inconsistent code. */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void onMessage(org.java_websocket.WebSocket r9, java.lang.String r10) {
            /*
            r8 = this;
            r4 = "OPEN_SYNCHRONIZER";
            monitor-enter(r4);
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0023 }
            r3 = r3.mConnection;	 Catch:{ all -> 0x0023 }
            if (r9 == r3) goto L_0x000d;
        L_0x000b:
            monitor-exit(r4);	 Catch:{ all -> 0x0023 }
        L_0x000c:
            return;
        L_0x000d:
            r5 = "HANDSHAKE_SYNCHRONIZER";
            monitor-enter(r5);	 Catch:{ all -> 0x0023 }
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0099 }
            r3 = r3.mHandshake;	 Catch:{ all -> 0x0099 }
            if (r3 == 0) goto L_0x003a;
        L_0x0018:
            r3 = "NO_OP";
            r3 = r10.equals(r3);	 Catch:{ all -> 0x0099 }
            if (r3 == 0) goto L_0x0026;
        L_0x0020:
            monitor-exit(r5);	 Catch:{ all -> 0x0099 }
            monitor-exit(r4);	 Catch:{ all -> 0x0023 }
            goto L_0x000c;
        L_0x0023:
            r3 = move-exception;
            monitor-exit(r4);	 Catch:{ all -> 0x0023 }
            throw r3;
        L_0x0026:
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0099 }
            r3 = r3.mConnectionListener;	 Catch:{ all -> 0x0099 }
            if (r3 == 0) goto L_0x0037;
        L_0x002e:
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0099 }
            r3 = r3.mConnectionListener;	 Catch:{ all -> 0x0099 }
            r3.onReceive(r10);	 Catch:{ all -> 0x0099 }
        L_0x0037:
            monitor-exit(r5);	 Catch:{ all -> 0x0099 }
            monitor-exit(r4);	 Catch:{ all -> 0x0023 }
            goto L_0x000c;
        L_0x003a:
            r2 = 0;
            r1 = "";
            r2 = com.adobe.air.wand.connection.WandWebSocket.Handshake.parse(r10);	 Catch:{ Exception -> 0x0063 }
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ Exception -> 0x006c }
            r3.validateHandshake(r2);	 Catch:{ Exception -> 0x006c }
        L_0x0046:
            if (r2 != 0) goto L_0x0073;
        L_0x0048:
            r3 = 1003; // 0x3eb float:1.406E-42 double:4.955E-321;
            r6 = new java.lang.StringBuilder;	 Catch:{ all -> 0x0099 }
            r6.<init>();	 Catch:{ all -> 0x0099 }
            r7 = "Invalid AIR Gamepad handshake : ";
            r6 = r6.append(r7);	 Catch:{ all -> 0x0099 }
            r6 = r6.append(r1);	 Catch:{ all -> 0x0099 }
            r6 = r6.toString();	 Catch:{ all -> 0x0099 }
            r9.close(r3, r6);	 Catch:{ all -> 0x0099 }
            monitor-exit(r5);	 Catch:{ all -> 0x0099 }
            monitor-exit(r4);	 Catch:{ all -> 0x0023 }
            goto L_0x000c;
        L_0x0063:
            r0 = move-exception;
            r3 = new java.lang.Exception;	 Catch:{ Exception -> 0x006c }
            r6 = "Unable to parse the handshake";
            r3.<init>(r6);	 Catch:{ Exception -> 0x006c }
            throw r3;	 Catch:{ Exception -> 0x006c }
        L_0x006c:
            r0 = move-exception;
            r2 = 0;
            r1 = r0.getMessage();	 Catch:{ all -> 0x0099 }
            goto L_0x0046;
        L_0x0073:
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0099 }
            r3.mHandshake = r2;	 Catch:{ all -> 0x0099 }
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ Exception -> 0x0091 }
            r3 = r3.mConnectionListener;	 Catch:{ Exception -> 0x0091 }
            if (r3 == 0) goto L_0x008d;
        L_0x0080:
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ Exception -> 0x0091 }
            r3 = r3.mConnectionListener;	 Catch:{ Exception -> 0x0091 }
            r6 = r2.getVersion();	 Catch:{ Exception -> 0x0091 }
            r3.onConnectionOpen(r6);	 Catch:{ Exception -> 0x0091 }
        L_0x008d:
            monitor-exit(r5);	 Catch:{ all -> 0x0099 }
            monitor-exit(r4);	 Catch:{ all -> 0x0023 }
            goto L_0x000c;
        L_0x0091:
            r0 = move-exception;
            r3 = com.adobe.air.wand.connection.WandWebSocket.this;	 Catch:{ all -> 0x0099 }
            r6 = 0;
            r3.mHandshake = r6;	 Catch:{ all -> 0x0099 }
            goto L_0x008d;
        L_0x0099:
            r3 = move-exception;
            monitor-exit(r5);	 Catch:{ all -> 0x0099 }
            throw r3;	 Catch:{ all -> 0x0023 }
            */
            throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.wand.connection.WandWebSocket.WandSocketServer.onMessage(org.java_websocket.WebSocket, java.lang.String):void");
        }

        public void onError(WebSocket conn, Exception e) {
            if (WandWebSocket.this.mConnection != null && WandWebSocket.this.mConnection != conn && conn != null) {
                try {
                    conn.close(1003, "AIR Gamepad is already connected");
                } catch (Exception e2) {
                }
            }
        }
    }

    public WandWebSocket(Activity activity) throws UnknownHostException {
        this.mActivity = activity;
        this.mHandshakeTimer = new Timer();
    }

    private void startSocketServer() throws Exception {
        if (this.mWandSocketServer == null) {
            this.mWandSocketServer = new WandSocketServer(new InetSocketAddress(getLocalIpAddress(), getPreferredPort()));
            this.mWandSocketServer.start();
        }
    }

    private void stopSocketServer() {
        WebSocketServer server = this.mWandSocketServer;
        this.mWandSocketServer = null;
        if (server != null) {
            try {
                server.stop();
            } catch (Exception e) {
            }
        }
    }

    private String constructLocalID() throws Exception {
        InetAddress fullAddress = getLocalIpAddress();
        if (fullAddress == null) {
            return null;
        }
        byte[] ipBytes = fullAddress.getAddress();
        return Long.toString((((((long) getUnsignedByte(ipBytes[3])) * 1) + (((long) getUnsignedByte(ipBytes[2])) * 256)) + (((long) getUnsignedByte(ipBytes[1])) * 65536)) + (((long) getUnsignedByte(ipBytes[0])) * 16777216), 32).toUpperCase();
    }

    public void connect() throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        } else if (this.mAllowIncomingConnection) {
            throw new Exception("Connection is already established");
        } else {
            this.mAllowIncomingConnection = true;
            if (this.mWandSocketServer == null) {
                startSocketServer();
            }
            this.mLocalID = constructLocalID();
            this.mConnectionToken = this.mLocalID;
            if (this.mConnectionListener != null) {
                this.mConnectionListener.updateConnectionToken(getConnectionToken());
            }
            if (this.mConnectionListener != null) {
                this.mConnectionListener.onConnectSuccess();
            }
        }
    }

    private void forceCloseConnection() {
        WebSocket conn = this.mConnection;
        this.mWandSocketServer.onClose(this.mConnection, 1001, "AIR Gamepad has closed", false);
        conn.close(1001, "AIR Gamepad has closed");
    }

    public void disconnect() throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        } else if (this.mAllowIncomingConnection) {
            if (this.mConnection != null) {
                forceCloseConnection();
            }
            stopSocketServer();
            this.mAllowIncomingConnection = false;
            if (this.mConnectionListener != null) {
                this.mConnectionListener.onDisconnectSuccess();
            }
        } else {
            throw new Exception("Connection is not established");
        }
    }

    public String getConnectionToken() throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        } else if (this.mAllowIncomingConnection) {
            return this.mConnectionToken == null ? "" : this.mConnectionToken;
        } else {
            throw new Exception("Connection is not established");
        }
    }

    public void registerListener(Listener listener) throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        } else if (listener == null) {
            throw new Exception("Invalid Connection.Listener");
        } else if (this.mConnectionListener != null) {
            throw new Exception("A listener is already registered");
        } else {
            this.mConnectionListener = listener;
        }
    }

    public void unregisterListener() {
        this.mConnectionListener = null;
    }

    public void send(String message) throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        } else if (this.mConnection != null) {
            try {
                this.mConnection.send(message);
            } catch (Throwable th) {
                Exception exception = new Exception("Unable to send Message");
            }
        }
    }

    private InetAddress getWiFiIpAddress() throws UnknownHostException {
        WifiManager wifiManager = (WifiManager) this.mActivity.getApplicationContext().getSystemService("wifi");
        if (wifiManager == null) {
            return null;
        }
        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
        if (wifiInfo == null || wifiInfo.getIpAddress() == 0) {
            return null;
        }
        return InetAddress.getByName(String.format("%d.%d.%d.%d", new Object[]{Integer.valueOf(wifiInfo.getIpAddress() & 255), Integer.valueOf((wifiInfo.getIpAddress() >> 8) & 255), Integer.valueOf((wifiInfo.getIpAddress() >> 16) & 255), Integer.valueOf((wifiInfo.getIpAddress() >> 24) & 255)}));
    }

    private InetAddress getWiFiHotspotIpAddress() throws UnknownHostException, SocketException {
        if (((ConnectivityManager) this.mActivity.getSystemService("connectivity")) == null) {
            return null;
        }
        WifiManager wifiManager = (WifiManager) this.mActivity.getApplicationContext().getSystemService("wifi");
        if (wifiManager == null) {
            return null;
        }
        boolean isWifiApEnabled = false;
        for (Method method : wifiManager.getClass().getDeclaredMethods()) {
            if (method.getName().equals("isWifiApEnabled")) {
                try {
                    if (((Boolean) method.invoke(wifiManager, new Object[0])).booleanValue()) {
                        isWifiApEnabled = true;
                    }
                } catch (IllegalArgumentException e) {
                } catch (IllegalAccessException e2) {
                } catch (InvocationTargetException e3) {
                }
            }
        }
        if (!isWifiApEnabled) {
            return null;
        }
        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
        if (wifiInfo == null) {
            return null;
        }
        int i;
        String wiFiMAC = wifiInfo.getMacAddress().toLowerCase();
        byte[] wifiMACBytes = new byte[6];
        if (wiFiMAC.indexOf(":") == -1 && wiFiMAC.length() == 12) {
            for (i = 0; i < wifiMACBytes.length; i++) {
                wifiMACBytes[i] = (byte) Integer.parseInt(wiFiMAC.substring(i * 2, (i * 2) + 2), 16);
            }
        } else {
            String[] hex = wiFiMAC.split(":");
            i = 0;
            while (i < wifiMACBytes.length && i < hex.length) {
                wifiMACBytes[i] = (byte) Integer.parseInt(hex[i], 16);
                i++;
            }
        }
        Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
        while (en.hasMoreElements()) {
            NetworkInterface intf = (NetworkInterface) en.nextElement();
            Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses();
            while (enumIpAddr.hasMoreElements()) {
                InetAddress inetAddress = (InetAddress) enumIpAddr.nextElement();
                if (!inetAddress.isLoopbackAddress() && InetAddressUtils.isIPv4Address(inetAddress.getHostAddress())) {
                    try {
                        byte[] mac = intf.getHardwareAddress();
                        if (mac != null && mac.length == 6) {
                            boolean macMatches = true;
                            for (i = 0; i < mac.length; i++) {
                                if (mac[i] != wifiMACBytes[i]) {
                                    macMatches = false;
                                    break;
                                }
                            }
                            if (macMatches) {
                                return inetAddress;
                            }
                        }
                    } catch (SocketException e4) {
                    }
                }
            }
        }
        return null;
    }

    private InetAddress getLocalIpAddress() {
        try {
            InetAddress ipAddress = getWiFiIpAddress();
            if (ipAddress == null) {
                return getWiFiHotspotIpAddress();
            }
            return ipAddress;
        } catch (Exception e) {
            return null;
        }
    }

    private int getPreferredPort() {
        return 1234;
    }

    private int getUnsignedByte(byte value) {
        return value >= (byte) 0 ? value : value + 256;
    }

    private void validateHandshake(Handshake handshake) throws Exception {
        if (handshake == null) {
            throw new Exception("Handshake is null");
        }
        String version = handshake.getVersion();
        if (!Pattern.matches("\\d+\\.\\d+\\.\\d+", version)) {
            throw new Exception("Invalid version format");
        } else if (Version.isGreaterThan(version, "1.1.0") || !Version.isGreaterThanEqualTo(version, Version.V1_0_0)) {
            throw new Exception("Unsupported version");
        } else if (!WEBSOCKET_PROTOCOL.equals(handshake.getProtocol())) {
            throw new Exception("Invalid protocol");
        } else if (!this.mLocalID.equals(handshake.getDestinationID())) {
            throw new Exception("Invalid destinationID");
        } else if (!Version.isGreaterThanEqualTo(version, "1.1.0")) {
        } else {
            if (handshake.getPublisher() == null) {
                throw new Exception("Invalid publisher");
            }
            String appURL = handshake.getApplicationURL();
            if (appURL == null) {
                throw new Exception("Invalid applicationURL");
            }
            try {
                URL url = new URL(appURL);
            } catch (Exception e) {
                throw new Exception("Invalid applicationURL");
            }
        }
    }

    public void onConnectionChanged() {
        if (!this.mIsDisposed && this.mAllowIncomingConnection) {
            try {
                String currentLocalID = constructLocalID();
                if (this.mLocalID != null || currentLocalID != null) {
                    if (this.mLocalID == null || currentLocalID == null || !this.mLocalID.equals(currentLocalID)) {
                        disconnect();
                        connect();
                    }
                }
            } catch (Exception e) {
            }
        }
    }

    private void pingServerOnConnect(String publisher, String applicationURL) throws Exception {
        if (publisher == null || applicationURL == null) {
            new ConnectPingTask().execute(new String[]{CONNECT_PING_URL});
            return;
        }
        new ConnectPingTask().execute(new String[]{"http://dh8vjmvwgc27o.cloudfront.net/AIRGamepad/connect_ping.txt?publisher=" + URLEncoder.encode(publisher, "UTF-8") + "&applicationURL=" + URLEncoder.encode(applicationURL, "UTF-8")});
    }

    public void onReadyForConnection() throws Exception {
        if (this.mHandshake == null || this.mLocalID == null) {
            throw new Exception("Invalid state at onReadyForConnection callback.");
        }
        this.mConnection.send(this.mHandshake.getSuccessResponse(this.mLocalID));
        pingServerOnConnect(this.mHandshake.mPublisher, this.mHandshake.mApplicationURL);
    }

    public void dispose() throws Exception {
        if (!this.mIsDisposed) {
            this.mIsDisposed = true;
            if (this.mAllowIncomingConnection) {
                disconnect();
            }
            unregisterListener();
            if (this.mConnection != null) {
                this.mConnection.close(1001, "AIR Gamepad has closed");
            }
            this.mConnection = null;
            this.mHandshake = null;
            if (this.mHandshakeTimer != null) {
                this.mHandshakeTimer.cancel();
                this.mHandshakeTimer.purge();
            }
            this.mHandshakeTimer = null;
            this.mWandSocketServer = null;
            this.mActivity = null;
        }
    }
}
