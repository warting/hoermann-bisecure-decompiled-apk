package com.adobe.air;

import android.app.Activity;
import com.adobe.air.utils.AIRLogger;
import com.adobe.air.utils.Utils;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;

class DeviceProfiling {
    private static final int BUFFER_SIZE = 8192;
    private static final String DEFAULT_PROFILER_PORT = "9999";
    private static final String DELIM_STRING = "=";
    private static final String FLASH_TRUST_DIR = "FlashPlayerTrust";
    private static final String LOG_TAG = "DeviceProfiling";
    private static final String META_INF = ("META-INF" + File.separator + AndroidConstants.AIR);
    private static final String MM_DOT_CFG = "mm.cfg";
    private static final String PROFILER_HOST_ID = "raw.debugger";
    private static final String PROFILER_RES_ID = "raw.profileragent";
    private static final String PROFILER_SWF_NAME = "ProfilerAgent.swf";
    private static final String PROFILE_CONFIG_FILENAME = "Profiling.cfg";
    private static ResourceFileManager mResManager;

    DeviceProfiling() {
    }

    public static boolean checkAndInitiateProfiler(Activity act) {
        mResManager = new ResourceFileManager(act);
        boolean resDebugHost = mResManager.resExists(mResManager.lookupResId("raw.debugger"));
        boolean resProfilerHost = mResManager.resExists(mResManager.lookupResId("raw.profileragent"));
        if (resDebugHost && resProfilerHost) {
            extractProfilerResource();
            insertPreloadTagEntry();
            insertTrustConfigEntry();
            return true;
        }
        AIRLogger.m0d(LOG_TAG, "Preload SWF/debughost resource does not exist inside the APK" + resDebugHost + " " + resProfilerHost);
        return false;
    }

    private static void extractProfilerResource() {
        File preloadSWF = new File(ApplicationFileManager.getAppRoot() + File.separator + META_INF + File.separator + PROFILER_SWF_NAME);
        preloadSWF.getParentFile().mkdirs();
        try {
            mResManager.extractResource(mResManager.lookupResId("raw.profileragent"), preloadSWF);
        } catch (Exception e) {
            AIRLogger.m0d(LOG_TAG, " Exception while writing/closing preloadSWF File " + e.getMessage());
        }
    }

    private static void insertTrustConfigEntry() {
        File fTrustAppDir = new File(ApplicationFileManager.getAppRoot() + File.separator + META_INF + File.separator + FLASH_TRUST_DIR);
        fTrustAppDir.mkdir();
        try {
            Utils.copyTo(new File(Utils.GetExternalStorageDirectory() + File.separator + FLASH_TRUST_DIR), fTrustAppDir);
        } catch (Exception e) {
            AIRLogger.m0d(LOG_TAG, "Recursive Copy for FlashPlayerTrust folder failed." + e.getMessage());
        }
        try {
            Utils.writeStringToFile(ApplicationFileManager.getAppRoot() + File.separator + META_INF, new File(ApplicationFileManager.getAppRoot() + File.separator + META_INF + File.separator + FLASH_TRUST_DIR + File.separator + PROFILE_CONFIG_FILENAME));
        } catch (Exception e2) {
            AIRLogger.m0d(LOG_TAG, " Write to FlashPlayerTrust Failed" + e2.getMessage());
        }
    }

    private static void insertPreloadTagEntry() {
        File mmCFG = new File(Utils.GetExternalStorageDirectory() + File.separator + "." + AndroidConstants.ADOBE + File.separator + AndroidConstants.AIR + File.separator + MM_DOT_CFG);
        File mmCFGAppData = new File(ApplicationFileManager.getAndroidAppDataPath() + File.separator + MM_DOT_CFG);
        File debugInfo = new File(ApplicationFileManager.getAndroidAppDataPath() + File.separator + AndroidConstants.DEBUGGER_INFO);
        String preloadSWFPath = ApplicationFileManager.getAppRoot() + File.separator + META_INF + File.separator + PROFILER_SWF_NAME;
        try {
            mResManager.extractResource(mResManager.lookupResId("raw.debugger"), debugInfo);
        } catch (Exception e) {
            AIRLogger.m0d(LOG_TAG, " Extracting Resource debugInfo failed " + e.getMessage());
        }
        HashMap<String, String> parsedMap = new HashMap();
        try {
            parsedMap = Utils.parseKeyValuePairFile(debugInfo, new String(DELIM_STRING));
        } catch (Exception e2) {
            AIRLogger.m0d(LOG_TAG, " Parsing for key-value pairs failed/mm.cfg not found " + e2.getMessage());
        }
        String preloadSWFString = new String("PreloadSwf=").concat(preloadSWFPath).concat("?");
        StringBuffer fileBuffer = new StringBuffer();
        if (parsedMap.get("Host") != null) {
            preloadSWFString = preloadSWFString.concat("host=").concat((String) parsedMap.get("Host"));
        }
        preloadSWFString = preloadSWFString.concat("&").concat("port=").concat(DEFAULT_PROFILER_PORT);
        if (mmCFG.exists()) {
            try {
                BufferedReader br = new BufferedReader(new FileReader(mmCFG), BUFFER_SIZE);
                boolean entryFound = false;
                while (true) {
                    String strLine = br.readLine();
                    if (strLine == null) {
                        break;
                    }
                    if (strLine.equals(preloadSWFString)) {
                        entryFound = true;
                    }
                    fileBuffer.append(strLine).append("\n");
                }
                if (!entryFound) {
                    fileBuffer.append(preloadSWFString).append("\n");
                }
                br.close();
            } catch (Exception e22) {
                AIRLogger.m0d(LOG_TAG, "Reading from Configuration file with path" + mmCFG.getAbsolutePath() + " failed." + e22.getMessage());
            }
        } else {
            fileBuffer.append(preloadSWFString).append("\n");
        }
        try {
            Utils.writeBufferToFile(fileBuffer, mmCFGAppData);
        } catch (Exception e222) {
            AIRLogger.m0d(LOG_TAG, " Writing string buffer to file failed " + e222.getMessage());
        }
    }
}
