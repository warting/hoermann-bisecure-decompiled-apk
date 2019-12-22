package com.adobe.air;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.io.SyncFailedException;
import java.security.KeyStore;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

public final class JavaTrustStoreHelper {
    private static final String LOG_TAG = "JavaTrustStoreHelper";
    private static SystemKeyStoreManager mSystemKeyStoreMgr = initSystemKeyStoreMgr();

    private interface SystemKeyStoreManager {
        KeyStore getKeyStore();

        long getTimestamp();
    }

    private static class SystemKeyStoreManager_files implements SystemKeyStoreManager {
        private static final String kDirectoryPath = "/system/etc/security/cacerts";
        private int mNumFilesWhenCreated;

        private SystemKeyStoreManager_files() {
            this.mNumFilesWhenCreated = -1;
        }

        public static boolean isValid() {
            return new File(kDirectoryPath).exists();
        }

        public long getTimestamp() {
            String[] files = getFileListing();
            if (this.mNumFilesWhenCreated != -1 && files.length != this.mNumFilesWhenCreated) {
                return Long.MAX_VALUE;
            }
            long newestFileTime = 0;
            for (String str : files) {
                newestFileTime = Math.max(new File("/system/etc/security/cacerts/" + str).lastModified(), newestFileTime);
            }
            return newestFileTime;
        }

        private static String[] getFileListing() {
            return new File(kDirectoryPath).list();
        }

        public KeyStore getKeyStore() {
            try {
                KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
                keyStore.load(null);
                CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
                String[] files = getFileListing();
                this.mNumFilesWhenCreated = files.length;
                for (int i = 0; i < files.length; i++) {
                    keyStore.setCertificateEntry(String.valueOf(i), certFactory.generateCertificate(new FileInputStream(new File("/system/etc/security/cacerts/" + files[i]))));
                }
                return keyStore;
            } catch (Exception e) {
                this.mNumFilesWhenCreated = -1;
                return null;
            }
        }
    }

    private static class SystemKeyStoreManager_stub implements SystemKeyStoreManager {
        private SystemKeyStoreManager_stub() {
        }

        public KeyStore getKeyStore() {
            return null;
        }

        public long getTimestamp() {
            return 0;
        }
    }

    private static class SystemKeyStoreManager_sysprop implements SystemKeyStoreManager {
        private static final String kTheProp = "javax.net.ssl.trustStore";

        private SystemKeyStoreManager_sysprop() {
        }

        public static boolean isValid() {
            return System.getProperty(kTheProp) != null;
        }

        public KeyStore getKeyStore() {
            try {
                KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
                String theProp = System.getProperty(kTheProp);
                if (theProp == null) {
                    return null;
                }
                File newFile = new File(theProp);
                if (newFile == null) {
                    return null;
                }
                keyStore.load(new FileInputStream(newFile), null);
                return keyStore;
            } catch (Exception e) {
                return null;
            }
        }

        public long getTimestamp() {
            return new File(System.getProperty(kTheProp)).lastModified();
        }
    }

    private static boolean isAirCertBundleStale(String airCertBundleName) {
        File airCertBundle = new File(airCertBundleName);
        if (airCertBundle.exists()) {
            return mSystemKeyStoreMgr.getTimestamp() > airCertBundle.lastModified();
        } else {
            return true;
        }
    }

    private static SystemKeyStoreManager initSystemKeyStoreMgr() {
        if (SystemKeyStoreManager_sysprop.isValid()) {
            return new SystemKeyStoreManager_sysprop();
        }
        if (SystemKeyStoreManager_files.isValid()) {
            return new SystemKeyStoreManager_files();
        }
        return new SystemKeyStoreManager_stub();
    }

    private static long getTrustStoreTimestamp() {
        return mSystemKeyStoreMgr.getTimestamp();
    }

    private static TrustManagerFactory getX509TrustManagerFactory() {
        try {
            TrustManagerFactory tmf = TrustManagerFactory.getInstance("X509");
            tmf.init(mSystemKeyStoreMgr.getKeyStore());
            return tmf;
        } catch (Exception e) {
            return null;
        }
    }

    private static X509TrustManager getX509TrustManager() {
        TrustManagerFactory tmf = getX509TrustManagerFactory();
        if (tmf == null) {
            return null;
        }
        TrustManager[] systemTMs = tmf.getTrustManagers();
        for (int i = 0; i < systemTMs.length; i++) {
            if (systemTMs[i] instanceof X509TrustManager) {
                return systemTMs[i];
            }
        }
        return null;
    }

    public static void copyTimestamp(String src, String dst) {
        try {
            new File(dst).setLastModified(new File(src).lastModified());
        } catch (SecurityException e) {
        } catch (IllegalArgumentException e2) {
        }
    }

    private static int dumpAcceptedIssuersToFile(X509TrustManager tm, RandomAccessFile f) throws CertificateEncodingException, IOException, SyncFailedException {
        X509Certificate[] caCert = tm.getAcceptedIssuers();
        for (X509Certificate encoded : caCert) {
            byte[] certBuffer = encoded.getEncoded();
            f.writeInt(certBuffer.length);
            f.write(certBuffer);
        }
        f.getFD().sync();
        return caCert.length;
    }

    public static boolean enumerateRootCAs(String airCertBundleFile, String tempFileForJava) {
        boolean rv = false;
        if (!isAirCertBundleStale(airCertBundleFile)) {
            return false;
        }
        X509TrustManager tm = getX509TrustManager();
        if (tm == null) {
            return false;
        }
        try {
            File tempFile = new File(tempFileForJava);
            RandomAccessFile rndAccessFile = new RandomAccessFile(tempFile, "rw");
            rndAccessFile.setLength(0);
            int numCerts = dumpAcceptedIssuersToFile(tm, rndAccessFile);
            tempFile.setLastModified(getTrustStoreTimestamp());
            rndAccessFile.close();
            rv = true;
        } catch (FileNotFoundException e) {
        } catch (IOException e2) {
        } catch (CertificateEncodingException e3) {
        } catch (IllegalArgumentException e4) {
        } catch (SecurityException e5) {
        }
        return rv;
    }
}
