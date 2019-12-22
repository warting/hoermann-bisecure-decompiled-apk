package com.adobe.air.utils;

import java.io.IOException;
import java.io.InputStream;

public class DeviceInfo {
    static String getHardwareInfo() {
        try {
            byte[] buf = new byte[1024];
            InputStream is = new ProcessBuilder(new String[]{"/system/bin/cat", "/proc/cpuinfo"}).start().getInputStream();
            int i = is.read(buf, 0, 1024);
            if (i >= 0) {
                String s = new String(buf, 0, i);
                i = s.indexOf("Hardware");
                if (i >= 0) {
                    i = s.indexOf(58, i);
                    if (i >= 0) {
                        return s.substring(i + 1, s.indexOf(10, i + 1)).trim();
                    }
                }
            }
            is.close();
        } catch (IOException e) {
        }
        return new String("");
    }

    static String getTotalMemory() {
        try {
            byte[] buf = new byte[1024];
            InputStream is = new ProcessBuilder(new String[]{"/system/bin/cat", "/proc/meminfo"}).start().getInputStream();
            int i = is.read(buf, 0, 1024);
            if (i >= 0) {
                String s = new String(buf, 0, i);
                i = s.indexOf("MemTotal");
                if (i >= 0) {
                    i = s.indexOf(58, i);
                    if (i >= 0) {
                        return s.substring(i + 1, s.indexOf(10, i + 1)).trim();
                    }
                }
            }
            is.close();
        } catch (IOException e) {
        }
        return new String("");
    }

    static String getCPUCount() {
        try {
            byte[] buf = new byte[1024];
            InputStream is = new ProcessBuilder(new String[]{"/system/bin/cat", "/sys/devices/system/cpu/present"}).start().getInputStream();
            int i = is.read(buf, 0, 1024);
            if (i >= 0) {
                String s = new String(buf, 0, i);
                i = s.indexOf("-");
                if (i >= 0) {
                    return Integer.toString(Integer.parseInt(s.substring(i + 1, i + 2)) + 1);
                }
                return Integer.toString(Integer.parseInt(s.substring(0, 1)) + 1);
            }
            is.close();
            return new String("");
        } catch (IOException e) {
        }
    }
}
