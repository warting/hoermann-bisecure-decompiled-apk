package com.adobe.air;

import android.content.Context;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.os.Build;
import android.os.Build.VERSION;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;
import java.util.Arrays;

public class SystemCapabilities {
    private static final String LOG_TAG = "SystemCapabilities";

    public static int GetScreenHRes(Context c) {
        Display display = ((WindowManager) c.getSystemService("window")).getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        return size.x;
    }

    public static int GetRealScreenHRes(Context c) {
        Display display = ((WindowManager) c.getSystemService("window")).getDefaultDisplay();
        Point size = new Point();
        if (VERSION.SDK_INT >= 17) {
            display.getRealSize(size);
        } else {
            display.getSize(size);
        }
        return size.x;
    }

    public static int GetScreenVRes(Context c) {
        Display display = ((WindowManager) c.getSystemService("window")).getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        return size.y;
    }

    public static int GetRealScreenVRes(Context c) {
        Display display = ((WindowManager) c.getSystemService("window")).getDefaultDisplay();
        Point size = new Point();
        if (VERSION.SDK_INT >= 17) {
            display.getRealSize(size);
        } else {
            display.getSize(size);
        }
        return size.y;
    }

    public static int GetScreenDPI(Context c) {
        String[] strArrayModelNumbers = new String[]{"SCH-I800", "SPH-P100", "SC-01C", "GT-P1000", "GT-P1010", "GT-P1000R", "GT-P1000M", "SHW-M180W", "SHW-M180L", "SHW-M180K", "SHW-M180S", "SGH-I987", "SGH-t849"};
        String modelString = Build.MODEL;
        Arrays.sort(strArrayModelNumbers);
        if (Arrays.binarySearch(strArrayModelNumbers, modelString) >= 0) {
            return 160;
        }
        WindowManager wm = (WindowManager) c.getSystemService("window");
        DisplayMetrics metrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(metrics);
        return metrics.densityDpi;
    }

    public static int GetBitsPerPixel(Context c) {
        Display disp = ((WindowManager) c.getSystemService("window")).getDefaultDisplay();
        PixelFormat info = new PixelFormat();
        PixelFormat.getPixelFormatInfo(disp.getPixelFormat(), info);
        return info.bitsPerPixel;
    }

    public static boolean HasTrackBall(Context c) {
        return c.getResources().getConfiguration().navigation == 3;
    }
}
