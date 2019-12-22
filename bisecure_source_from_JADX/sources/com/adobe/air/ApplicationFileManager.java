package com.adobe.air;

import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

public final class ApplicationFileManager {
    private static final String APP_PREFIX = "app";
    private static final String APP_XML_PATH = "META-INF/AIR/application.xml";
    private static final String ASSET_STRING = "assets";
    public static String sAndroidPackageName;
    public static String sApkPath;
    public static String sAppDataPath;
    public static String sInitialContentName;
    private final int BUFFER_SIZE = 8192;
    private final int DEFAULT_SIZE = -1;
    private HashMap<Object, Object> mFileInfoMap = new HashMap();

    public static void setAndroidPackageName(String packageName) {
        sAndroidPackageName = packageName;
    }

    public static void setAndroidAPKPath(String apkPath) {
        sApkPath = apkPath;
    }

    private static void setAndroidDataPath(String dataPath) {
        sAppDataPath = dataPath;
    }

    public static String getAndroidApkPath() {
        return sApkPath;
    }

    public static String getAndroidAppDataPath() {
        return sAppDataPath;
    }

    public static String getAppXMLRoot() {
        return getAndroidUnzipContentPath() + File.separatorChar + APP_XML_PATH;
    }

    public static String getAppRoot() {
        return getAndroidUnzipContentPath() + File.separatorChar + ASSET_STRING;
    }

    public static String getAndroidUnzipContentPath() {
        return sAppDataPath;
    }

    private File getApkPathFile() {
        return new File(getAndroidApkPath());
    }

    private static void setInitialContentName(String name) {
        sInitialContentName = name;
    }

    ApplicationFileManager() {
        procZipContents(getApkPathFile());
    }

    public static boolean deleteUnzippedContents(String filePath) {
        File fileObj = new File(filePath);
        if (fileObj.isDirectory()) {
            File[] aFiles = fileObj.listFiles();
            for (File absolutePath : aFiles) {
                deleteUnzippedContents(absolutePath.getAbsolutePath());
            }
        }
        return fileObj.delete();
    }

    public void deleteFile(String filePath) {
        new File(filePath).delete();
    }

    public void procZipContents(File apkPath) {
        try {
            ZipFile zip = new ZipFile(apkPath);
            Enumeration<? extends ZipEntry> enumEntry = zip.entries();
            while (enumEntry.hasMoreElements()) {
                ZipEntry entry = (ZipEntry) enumEntry.nextElement();
                String assetName = entry.getName();
                if (assetName.substring(0, ASSET_STRING.length()).equals(ASSET_STRING)) {
                    this.mFileInfoMap.put(assetName, new FileInfo(entry.getSize(), true, false));
                    File assetFile = new File(assetName);
                    while (assetFile.getParent() != null && ((FileInfo) this.mFileInfoMap.get(assetFile.getParent())) == null) {
                        this.mFileInfoMap.put(assetFile.getParent(), new FileInfo(-1, false, true));
                        assetFile = new File(assetFile.getParent());
                    }
                }
            }
            zip.close();
        } catch (Exception e) {
        }
    }

    public boolean fileExists(String assetPath) {
        return this.mFileInfoMap.containsKey(!assetPath.equals("") ? new StringBuilder().append(ASSET_STRING).append(File.separator).append(assetPath).toString() : ASSET_STRING);
    }

    public boolean isDirectory(String assetPath) {
        FileInfo fileInfo = (FileInfo) this.mFileInfoMap.get(!assetPath.equals("") ? ASSET_STRING + File.separator + assetPath : ASSET_STRING);
        return fileInfo != null && fileInfo.mIsDirectory;
    }

    public long getLSize(String assetPath) {
        FileInfo fileInfo = (FileInfo) this.mFileInfoMap.get(ASSET_STRING + File.separator + assetPath);
        if (fileInfo == null || fileInfo.mFileSize == -1) {
            return 0;
        }
        return fileInfo.mFileSize;
    }

    public boolean addToCache(String filepath) {
        if (sInitialContentName == null || filepath.indexOf(sInitialContentName) == -1) {
            return false;
        }
        return true;
    }

    public boolean readFileName(String assetPath) {
        Throwable th;
        String fPath = ASSET_STRING + File.separator + assetPath;
        String fullDirPath = getAndroidUnzipContentPath() + File.separatorChar;
        File actualFile = new File(fullDirPath + fPath);
        if (actualFile.exists()) {
            return true;
        }
        ZipFile zip = null;
        try {
            ZipFile zipFile = new ZipFile(getApkPathFile());
            try {
                Enumeration<? extends ZipEntry> enumEntry = zipFile.entries();
                while (enumEntry.hasMoreElements()) {
                    ZipEntry entry = (ZipEntry) enumEntry.nextElement();
                    String assetName = entry.getName();
                    if (assetName.substring(0, ASSET_STRING.length()).equals(ASSET_STRING)) {
                        if (assetName.equals(fPath)) {
                            InputStream in = zipFile.getInputStream(entry);
                            new File(actualFile.getParent()).mkdirs();
                            BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(actualFile), 8192);
                            BufferedOutputStream bufferedOutputStream;
                            try {
                                byte[] data = new byte[8192];
                                while (true) {
                                    int readBytes = in.read(data);
                                    if (readBytes == -1) {
                                        break;
                                    }
                                    out.write(data, 0, readBytes);
                                }
                                closeInputStream(in);
                                closeOutputStream(out);
                                bufferedOutputStream = out;
                            } catch (Exception e) {
                                zip = zipFile;
                                bufferedOutputStream = out;
                                if (zip != null) {
                                    try {
                                        zip.close();
                                    } catch (Exception e2) {
                                    }
                                }
                                return true;
                            } catch (Throwable th2) {
                                th = th2;
                                zip = zipFile;
                                bufferedOutputStream = out;
                                if (zip != null) {
                                    try {
                                        zip.close();
                                    } catch (Exception e3) {
                                    }
                                }
                                throw th;
                            }
                        } else if (assetName.startsWith(fPath + "/")) {
                            new File(fullDirPath + fPath).mkdirs();
                            break;
                        }
                    }
                }
                if (zipFile != null) {
                    try {
                        zipFile.close();
                    } catch (Exception e4) {
                        zip = zipFile;
                    }
                }
                zip = zipFile;
            } catch (Exception e5) {
                zip = zipFile;
            } catch (Throwable th3) {
                th = th3;
                zip = zipFile;
            }
        } catch (Exception e6) {
            if (zip != null) {
                zip.close();
            }
            return true;
        } catch (Throwable th4) {
            th = th4;
            if (zip != null) {
                zip.close();
            }
            throw th;
        }
        return true;
    }

    public void copyFolder(String assetPath) {
        String fPath = !assetPath.equals("") ? ASSET_STRING + File.separator + assetPath : ASSET_STRING;
        String fullDirPath = getAndroidUnzipContentPath() + File.separatorChar;
        ZipInputStream in = new ZipInputStream(new BufferedInputStream(new FileInputStream(getApkPathFile()), 8192));
        BufferedOutputStream out = null;
        while (true) {
            BufferedOutputStream out2;
            try {
                ZipEntry entry = in.getNextEntry();
                if (entry != null) {
                    String assetName = entry.getName();
                    if (assetName.substring(0, ASSET_STRING.length()).equals(ASSET_STRING)) {
                        if (assetName.startsWith(fPath)) {
                            File actualFile = new File(fullDirPath + assetName);
                            new File(actualFile.getParent()).mkdirs();
                            out2 = new BufferedOutputStream(new FileOutputStream(actualFile), 8192);
                            try {
                                byte[] data = new byte[8192];
                                while (true) {
                                    int readBytes = in.read(data, 0, 8192);
                                    if (readBytes == -1) {
                                        break;
                                    }
                                    out2.write(data, 0, readBytes);
                                }
                                closeOutputStream(out2);
                            } catch (Exception e) {
                                return;
                            }
                        }
                        out2 = out;
                        out = out2;
                    }
                } else {
                    closeInputStream(in);
                    out2 = out;
                    return;
                }
            } catch (Exception e2) {
                out2 = out;
                return;
            }
        }
    }

    public String[] appDirectoryNameList(String assetPath) {
        String assetName = !assetPath.equals("") ? ASSET_STRING + File.separator + assetPath : ASSET_STRING;
        ArrayList<String> nameList = new ArrayList();
        for (String key : this.mFileInfoMap.keySet()) {
            if (!key.equals(assetName) && key.startsWith(assetName) && -1 == key.indexOf(File.separator, assetName.length() + 1)) {
                nameList.add(key.substring(assetName.length() + 1));
            }
        }
        return (String[]) nameList.toArray(new String[0]);
    }

    public boolean[] appDirectoryTypeList(String assetPath) {
        String assetName = !assetPath.equals("") ? ASSET_STRING + File.separator + assetPath : ASSET_STRING;
        ArrayList<Boolean> typeList = new ArrayList();
        for (String key : this.mFileInfoMap.keySet()) {
            if (!key.equals(assetName) && key.startsWith(assetName) && -1 == key.indexOf(File.separator, assetName.length() + 1)) {
                typeList.add(new Boolean(((FileInfo) this.mFileInfoMap.get(key)).mIsFile));
            }
        }
        boolean[] list = new boolean[typeList.size()];
        for (int i = 0; i < list.length; i++) {
            list[i] = ((Boolean) typeList.get(i)).booleanValue();
        }
        return list;
    }

    private static void RefreshAppCache(String appcachepath, String id) {
        if (!new File(appcachepath + File.separator + id).exists()) {
            deleteDir(new File(appcachepath));
        }
    }

    public static boolean deleteDir(File file) {
        if (file.isDirectory()) {
            for (File child : file.listFiles()) {
                if (!deleteDir(child)) {
                    return false;
                }
            }
        }
        if (file.delete()) {
            return true;
        }
        return false;
    }

    public static void processAndroidDataPath(String cacheDirPath) {
        String uniqueVersionID = APP_PREFIX;
        String appCacheDir = cacheDirPath + File.separator + APP_PREFIX;
        String initialContentName = null;
        try {
            Bundle bundle = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getPackageManager().getActivityInfo(AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getComponentName(), 128).metaData;
            if (bundle != null) {
                uniqueVersionID = (String) bundle.get("uniqueappversionid");
                if (AndroidActivityWrapper.IsGamePreviewMode()) {
                    uniqueVersionID = UUID.randomUUID().toString();
                }
                RefreshAppCache(appCacheDir, uniqueVersionID);
                initialContentName = (String) bundle.get("initialcontent");
            }
        } catch (NameNotFoundException e) {
        } catch (NullPointerException e2) {
        }
        setAndroidDataPath(appCacheDir + File.separator + uniqueVersionID);
        new File(appCacheDir + File.separator + uniqueVersionID).mkdirs();
        setInitialContentName(initialContentName);
    }

    private void closeInputStream(InputStream in) throws Exception {
        in.close();
    }

    private void closeOutputStream(OutputStream out) throws Exception {
        out.flush();
        out.close();
    }

    public static void checkAndCreateAppDataDir() {
        File applicationDir = new File(sAppDataPath);
        if (!applicationDir.exists()) {
            try {
                applicationDir.mkdirs();
            } catch (SecurityException e) {
            }
        }
    }
}
