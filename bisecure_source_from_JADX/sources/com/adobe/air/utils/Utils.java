package com.adobe.air.utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.res.Resources;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.os.Process;
import android.view.LayoutInflater;
import android.view.View;
import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.BuildConfig;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Scanner;

public class Utils {
    private static String sRuntimePackageName;

    public static native boolean nativeConnectDebuggerSocket(String str);

    public static String getRuntimePackageName() {
        return sRuntimePackageName;
    }

    public static void setRuntimePackageName(String runtimePackageName) {
        sRuntimePackageName = runtimePackageName;
    }

    public static boolean hasCaptiveRuntime() {
        return !BuildConfig.APPLICATION_ID.equals(sRuntimePackageName);
    }

    static void KillProcess() {
        Process.killProcess(Process.myPid());
    }

    public static boolean writeStringToFile(String value, String filePath) {
        File debuggerInfo = new File(filePath);
        if (!debuggerInfo.exists()) {
            try {
                debuggerInfo.createNewFile();
            } catch (IOException e) {
                return false;
            }
        }
        byte[] data = value.getBytes();
        try {
            OutputStream pOut = new FileOutputStream(debuggerInfo);
            pOut.write(data, 0, data.length);
            pOut.close();
            return true;
        } catch (IOException e2) {
            return false;
        }
    }

    public static void writeOut(InputStream in, File f) throws IOException {
        OutputStream out = new FileOutputStream(f);
        writeThrough(in, out);
        out.close();
    }

    public static void writeThrough(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[4096];
        while (true) {
            int len = in.read(buffer);
            if (len == -1) {
                return;
            }
            if (out != null) {
                out.write(buffer, 0, len);
                out.flush();
            }
        }
    }

    public static void copyTo(File source, File dest) throws IOException {
        if (source.isDirectory()) {
            dest.mkdirs();
            for (File sourceChild : source.listFiles()) {
                copyTo(sourceChild, new File(dest, sourceChild.getName()));
            }
            return;
        }
        InputStream in = new FileInputStream(source);
        OutputStream out = new FileOutputStream(dest);
        copyTo(in, out);
        in.close();
        out.close();
    }

    public static void copyTo(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[1024];
        while (true) {
            int read = in.read(buffer);
            if (read > 0) {
                out.write(buffer, 0, read);
            } else {
                return;
            }
        }
    }

    public static void writeBufferToFile(StringBuffer out, File path) throws IOException {
        FileWriter buf = new FileWriter(path);
        buf.write(out.toString());
        buf.close();
    }

    public static HashMap<String, String> parseKeyValuePairFile(File path, String delim) throws FileNotFoundException, IllegalStateException {
        return parseKeyValuePairFile(new FileInputStream(path), delim);
    }

    public static HashMap<String, String> parseKeyValuePairFile(InputStream stream, String delim) throws IllegalStateException {
        HashMap<String, String> keyValue = new HashMap();
        Scanner scanner = new Scanner(stream);
        while (scanner.hasNextLine()) {
            Scanner lineScanner = new Scanner(scanner.nextLine());
            lineScanner.useDelimiter(delim);
            if (lineScanner.hasNext()) {
                keyValue.put(lineScanner.next().trim(), lineScanner.next().trim());
            }
            lineScanner.close();
        }
        scanner.close();
        return keyValue;
    }

    public static void writeStringToFile(String content, File path) throws IOException {
        FileWriter out = new FileWriter(path);
        out.write(content);
        out.close();
    }

    public static String ReplaceTextContentWithStars(String text) {
        int length = text.length();
        char[] val = new char[length];
        for (int i = 0; i < length; i++) {
            val[i] = '*';
        }
        return new String(val);
    }

    public static String GetResourceStringFromRuntime(String name, Resources resources) {
        return resources.getString(resources.getIdentifier(name, "string", sRuntimePackageName));
    }

    public static View GetWidgetInViewByName(String name, Resources resources, View view) {
        return view.findViewById(resources.getIdentifier(name, "id", sRuntimePackageName));
    }

    public static View GetLayoutViewFromRuntime(String type, Resources resources, LayoutInflater inf) {
        int resourceId = resources.getIdentifier(type, "layout", sRuntimePackageName);
        if (resourceId != 0) {
            return inf.inflate(resourceId, null);
        }
        return null;
    }

    public static View GetLayoutView(String type, Resources resources, LayoutInflater inf) {
        int resourceId = resources.getIdentifier(type, "layout", AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getPackageName());
        if (resourceId != 0) {
            return inf.inflate(resourceId, null);
        }
        return null;
    }

    public static View GetWidgetInViewByNameFromPackage(String name, Resources resources, View view) {
        return view.findViewById(resources.getIdentifier(name, "id", AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getPackageName()));
    }

    public static View GetWidgetInView(String name, Resources resources, View view) {
        return view.findViewById(resources.getIdentifier(name, "id", AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getPackageName()));
    }

    public static String GetResourceString(String name, Resources resources) {
        return resources.getString(resources.getIdentifier(name, "string", AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getPackageName()));
    }

    public static String GetExternalStorageDirectory() {
        return Environment.getExternalStorageDirectory().getAbsolutePath();
    }

    public static String GetSharedDataDirectory() {
        return Environment.getDataDirectory().getAbsolutePath();
    }

    public static String GetLibCorePath(Context context) {
        return GetNativeLibraryPath(context, "libCore.so");
    }

    public static String GetLibSTLPath(Context context) {
        return GetNativeLibraryPath(context, "libc++_shared.so");
    }

    public static String GetNativeLibraryPath(Context context, String name) {
        String nativeLibraryPath = null;
        try {
            ApplicationInfo info = context.getPackageManager().getApplicationInfo(sRuntimePackageName, 0);
            Field nativeLibDirField = ApplicationInfo.class.getField("nativeLibraryDir");
            Field codePath = ApplicationInfo.class.getField("sourceDir");
            if (nativeLibDirField != null) {
                nativeLibraryPath = ((String) codePath.get(info)).startsWith("/system/app/") ? new String("/system/lib/" + sRuntimePackageName + "/" + name) : ((String) nativeLibDirField.get(info)).concat("/" + name);
            }
        } catch (Exception e) {
        }
        if (nativeLibraryPath == null) {
            return new String("/data/data/" + sRuntimePackageName + "/lib/" + name);
        }
        return nativeLibraryPath;
    }

    public static String GetNativeExtensionPath(Context context, String name) {
        String str = null;
        try {
            ApplicationInfo info = context.getPackageManager().getApplicationInfo(sRuntimePackageName, 0);
            Field nativeLibDirField = ApplicationInfo.class.getField("nativeLibraryDir");
            Field codePath = ApplicationInfo.class.getField("sourceDir");
            File aneLib = null;
            try {
                aneLib = new File(info.nativeLibraryDir, name);
            } catch (Exception e) {
            }
            if (aneLib != null) {
                if (aneLib.exists()) {
                    return aneLib.getAbsolutePath();
                }
            }
            if (nativeLibDirField != null) {
                str = ((String) codePath.get(info)).startsWith("/system/app/") ? new String("/system/lib/" + sRuntimePackageName + "/" + name) : new String("/data/data/" + context.getPackageName() + "/lib/" + name);
            }
        } catch (Exception e2) {
        }
        if (str == null) {
            str = new String("/data/data/" + sRuntimePackageName + "/lib/" + name);
        }
        return str;
    }

    public static String GetTelemetrySettings(Context context, String telemetryFileName, String monocleCompanionAppId) {
        Throwable th;
        String settings = null;
        ByteArrayOutputStream sos = null;
        InputStream stream = null;
        try {
            stream = context.getResources().getAssets().open(telemetryFileName, 1);
            OutputStream sos2 = new ByteArrayOutputStream();
            OutputStream outputStream;
            try {
                copyTo(stream, sos2);
                settings = sos2.toString();
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (Exception e) {
                        outputStream = sos2;
                    }
                }
                if (sos2 != null) {
                    sos2.close();
                }
                outputStream = sos2;
            } catch (Exception e2) {
                outputStream = sos2;
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (Exception e3) {
                    }
                }
                if (sos != null) {
                    sos.close();
                }
                if (settings == null) {
                    try {
                        settings = context.createPackageContext(monocleCompanionAppId, 0).getSharedPreferences("telemetry", 1).getString("content", "");
                    } catch (Exception e4) {
                    }
                }
                return settings;
            } catch (Throwable th2) {
                th = th2;
                outputStream = sos2;
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (Exception e5) {
                        throw th;
                    }
                }
                if (sos != null) {
                    sos.close();
                }
                throw th;
            }
        } catch (Exception e6) {
            if (stream != null) {
                stream.close();
            }
            if (sos != null) {
                sos.close();
            }
            if (settings == null) {
                settings = context.createPackageContext(monocleCompanionAppId, 0).getSharedPreferences("telemetry", 1).getString("content", "");
            }
            return settings;
        } catch (Throwable th3) {
            th = th3;
            if (stream != null) {
                stream.close();
            }
            if (sos != null) {
                sos.close();
            }
            throw th;
        }
        if (settings == null) {
            settings = context.createPackageContext(monocleCompanionAppId, 0).getSharedPreferences("telemetry", 1).getString("content", "");
        }
        return settings;
    }

    public static boolean isNetworkAvailable(Context ctx) {
        NetworkInfo networkInfo = ((ConnectivityManager) ctx.getSystemService("connectivity")).getActiveNetworkInfo();
        if (networkInfo == null || !networkInfo.isConnected()) {
            return false;
        }
        return true;
    }
}
