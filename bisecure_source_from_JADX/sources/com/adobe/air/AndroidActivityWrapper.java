package com.adobe.air;

import android.app.Activity;
import android.app.Application;
import android.app.Dialog;
import android.app.KeyguardManager;
import android.app.UiModeManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.content.res.Resources.Theme;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SurfaceView;
import android.view.View;
import android.view.WindowManager.LayoutParams;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;
import com.adobe.air.telephony.AndroidTelephonyManager;
import com.adobe.air.utils.Utils;
import com.adobe.flashplayer.HDMIUtils;
import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class AndroidActivityWrapper {
    private static final String ADOBE_COM = "adobe.com";
    private static final int ASPECT_RATIO_ANY = 3;
    private static final int ASPECT_RATIO_LANDSCAPE = 2;
    private static final int ASPECT_RATIO_PORTRAIT = 1;
    public static final int IMAGE_PICKER_REQUEST_CODE = 2;
    private static final int INVOKE_EVENT_OPEN_URL = 1;
    private static final int INVOKE_EVENT_STANDARD = 0;
    private static final String LOG_TAG = "AndroidActivityWrapper";
    public static final int STILL_PICTURE_REQUEST_CODE = 3;
    public static final int VIDEO_CAPTURE_REQUEST_CODE = 4;
    public static final int WEBVIEW_UPLOAD_FILE_CHOOSER_CODE = 5;
    private static final String WWW_ADOBE_COM = "www.adobe.com";
    private static boolean mIsAndroidTV = false;
    private static AndroidActivityWrapper sActivityWrapper = null;
    private static AndroidTelephonyManager sAndroidTelephonyManager = null;
    private static boolean sApplicationLaunched = false;
    private static boolean sDepthAndStencil = false;
    private static Entrypoints sEntryPoint = null;
    private static String sGamePreviewHost = "";
    private static boolean sHasCaptiveRuntime = false;
    private static AndroidIdleState sIdleStateManager = null;
    private static boolean sIsSwfPreviewMode = false;
    private static boolean sRuntimeLibrariesLoaded = false;
    private int debuggerPort = -1;
    private KeyguardManager keyGuardManager = null;
    private boolean mActivateEventPending = false;
    private List<ActivityResultCallback> mActivityResultListeners = null;
    private ActivityState mActivityState = ActivityState.STARTED;
    private List<StateChangeCallback> mActivityStateListeners = null;
    private ConfigDownloadListener mConfigDownloadListener = null;
    private boolean mContainsVideo = false;
    private DebuggerSettings mDebuggerSettings = new DebuggerSettings();
    private List<String> mDeclaredPermissions = null;
    private boolean mDisplayWaitingDialog = false;
    private String mExtraArgs = null;
    private boolean mFullScreenSetFromMetaData = false;
    private int mHardKeyboardHidden = 2;
    private int mHardKeyboardType = 0;
    private List<InputEventCallback> mInputEventListeners = null;
    private boolean mInvokeEventPendingFromOnCreate = false;
    private boolean mIsADL = false;
    private boolean mIsDebuggerMode = false;
    private boolean mIsFullScreen = false;
    private String mLibCorePath = null;
    private OrientationManager mOrientationManager = null;
    private boolean mRGB565Override = false;
    private String mRootDir = null;
    private boolean mScreenOn = true;
    private boolean mShowDebuggerDialog = false;
    private int mTargetSdkVersion = 0;
    private String mXmlPath = null;
    private Activity m_activity = null;
    private Application m_application = null;
    private AndroidCameraView m_cameraView = null;
    private FlashEGL m_flashEGL = null;
    private FrameLayout m_layout = null;
    private AIRWindowSurfaceView m_mainView = null;
    private Condition m_newActivityCondition = null;
    private Lock m_newActivityLock = null;
    private RelativeLayout m_overlaysLayout = null;
    private boolean m_planeBreakCascade = false;
    private boolean m_planeCascadeInit = false;
    private int m_planeCascadeStep = 0;
    private List<SurfaceView> m_planes = null;
    private Context m_runtimeContext = null;
    private boolean m_skipKickCascade = true;
    private SurfaceView m_videoView = null;

    interface ActivityResultCallback {
        void onActivityResult(int i, int i2, Intent intent);
    }

    public enum ActivityState {
        STARTED,
        RESTARTED,
        RESUMED,
        PAUSED,
        STOPPED,
        DESTROYED
    }

    private enum DebugMode {
        None,
        ConnectMode,
        ListenMode,
        ConflictMode
    }

    public final class FlashPermission {
        public static final int CAMERA = 4;
        public static final int CAMERA_ROLL = 22;
        public static final int CAMERA_UI = 50;
        public static final int LOCATION = 1;
        public static final int MICROPHONE = 2;
        public static final int NETWORK = 296;
        public static final int STORAGE = 8;
        public static final int WIFI = 100;
    }

    interface InputEventCallback {
        boolean onGenericMotionEvent(MotionEvent motionEvent);

        boolean onKeyEvent(KeyEvent keyEvent);
    }

    public final class PermissionStatus {
        public static final int DENIED = 2;
        public static final int GRANTED = 1;
        public static final int UNKNOWN = 0;
    }

    public static class PlaneID {
        public static final int PLANE_CAMERA = 5;
        public static final int PLANE_COUNT = 8;
        public static final int PLANE_FLASH = 3;
        public static final int PLANE_OVERLAY = 2;
        public static final int PLANE_STAGE3D = 6;
        public static final int PLANE_STAGETEXT = 1;
        public static final int PLANE_STAGEVIDEO = 7;
        public static final int PLANE_STAGEVIDEOAUTOMATIC = 4;
        public static final int PLANE_STAGEWEBVIEW = 0;
    }

    interface StateChangeCallback {
        void onActivityStateChanged(ActivityState activityState);

        void onConfigurationChanged(Configuration configuration);
    }

    private native void nativeActivateEvent();

    private native void nativeDeactivateEvent();

    private native void nativeLowMemoryEvent();

    private native void nativeNotifyPermissionRequestResult(int i, int i2);

    private native void nativeOnFocusListener(boolean z);

    private native void nativeSendInvokeEventWithData(String str, String str2, int i);

    private native void nativeSetVisible(boolean z);

    public boolean isScreenOn() {
        return this.mScreenOn;
    }

    public boolean isScreenLocked() {
        return this.keyGuardManager.inKeyguardRestrictedInputMode();
    }

    public boolean isResumed() {
        return this.mActivityState == ActivityState.RESUMED;
    }

    public boolean isStarted() {
        return this.mActivityState == ActivityState.STARTED || this.mActivityState == ActivityState.RESTARTED;
    }

    public static boolean isGingerbread() {
        return VERSION.SDK_INT >= 9;
    }

    public static boolean isHoneycomb() {
        return VERSION.SDK_INT >= 11;
    }

    public static boolean isIceCreamSandwich() {
        return VERSION.SDK_INT >= 14;
    }

    public static boolean isJellybean() {
        return VERSION.SDK_INT >= 16;
    }

    public static AndroidActivityWrapper CreateAndroidActivityWrapper(Activity act) {
        return CreateAndroidActivityWrapper(act, Boolean.valueOf(false));
    }

    private static boolean isAndroidTV(Activity activity) {
        try {
            if (((UiModeManager) activity.getSystemService("uimode")).getCurrentModeType() == 4) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    public static AndroidActivityWrapper CreateAndroidActivityWrapper(Activity act, Boolean hasCaptiveRuntime) {
        sHasCaptiveRuntime = hasCaptiveRuntime.booleanValue();
        if (hasCaptiveRuntime.booleanValue()) {
            Utils.setRuntimePackageName(act.getApplicationContext().getPackageName());
        } else {
            Utils.setRuntimePackageName(BuildConfig.APPLICATION_ID);
        }
        if (sActivityWrapper == null) {
            sActivityWrapper = new AndroidActivityWrapper(act);
        }
        mIsAndroidTV = isAndroidTV(act);
        return sActivityWrapper;
    }

    boolean manifestDeclaresPermission(int flashPermission) {
        return manifestDeclaresPermission(FlashToAndroidPermission(flashPermission));
    }

    boolean manifestDeclaresPermission(String permission) {
        if (permission == null) {
            return false;
        }
        if (this.mDeclaredPermissions == null) {
            try {
                String[] permissions = this.m_application.getPackageManager().getPackageInfo(this.m_application.getPackageName(), 4096).requestedPermissions;
                if (permissions.length > 0) {
                    this.mDeclaredPermissions = Arrays.asList(permissions);
                }
            } catch (Exception e) {
                this.mDeclaredPermissions = null;
            }
        }
        if (this.mDeclaredPermissions != null) {
            return this.mDeclaredPermissions.contains(permission);
        }
        return false;
    }

    int GetTargetSdkVersion() {
        if (this.mTargetSdkVersion == 0) {
            try {
                this.mTargetSdkVersion = this.m_application.getPackageManager().getPackageInfo(this.m_application.getPackageName(), 4096).applicationInfo.targetSdkVersion;
            } catch (Exception e) {
            }
        }
        return this.mTargetSdkVersion;
    }

    private AndroidActivityWrapper(Activity act) {
        this.m_activity = act;
        this.m_newActivityLock = new ReentrantLock();
        this.m_newActivityCondition = this.m_newActivityLock.newCondition();
        this.m_application = act.getApplication();
        LoadRuntimeLibraries();
        this.keyGuardManager = (KeyguardManager) act.getSystemService("keyguard");
    }

    public static AndroidActivityWrapper GetAndroidActivityWrapper() {
        return sActivityWrapper;
    }

    public static boolean GetHasCaptiveRuntime() {
        return sHasCaptiveRuntime;
    }

    public static boolean GetIsAndroidTV() {
        return mIsAndroidTV;
    }

    public static boolean IsGamePreviewMode() {
        return sIsSwfPreviewMode;
    }

    public static boolean GetDepthAndStencilForGamePreview() {
        return sDepthAndStencil;
    }

    public static boolean ShouldShowGamePreviewWatermark() {
        Boolean shouldShow = Boolean.valueOf(sIsSwfPreviewMode);
        if (shouldShow.booleanValue() && (sGamePreviewHost.equalsIgnoreCase("www.adobe.com") || sGamePreviewHost.equalsIgnoreCase(ADOBE_COM))) {
            shouldShow = Boolean.valueOf(false);
        }
        return shouldShow.booleanValue();
    }

    public Activity getActivity() {
        return this.m_activity;
    }

    public void setSpeakerphoneOn(boolean on) {
        ((AudioManager) getActivity().getSystemService("audio")).setSpeakerphoneOn(on);
    }

    public boolean getSpeakerphoneOn() {
        return ((AudioManager) getActivity().getSystemService("audio")).isSpeakerphoneOn();
    }

    public boolean getWebContentsDebuggingEnabled() {
        try {
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null) {
                Boolean debuggingEnabled = (Boolean) bundle.get("webContentsDebuggingEnabled");
                if (debuggingEnabled != null) {
                    return debuggingEnabled.booleanValue();
                }
            }
        } catch (NameNotFoundException e) {
        }
        return false;
    }

    public boolean disableMediaCodec() {
        try {
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null) {
                Boolean mediaCodecDisabled = (Boolean) bundle.get("disableMediaCodec");
                if (mediaCodecDisabled != null) {
                    return mediaCodecDisabled.booleanValue();
                }
            }
        } catch (NameNotFoundException e) {
        }
        return false;
    }

    public boolean embeddedFonts() {
        try {
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null) {
                Boolean embeddedFontsPresent = (Boolean) bundle.get("embeddedFonts");
                if (embeddedFontsPresent != null) {
                    return embeddedFontsPresent.booleanValue();
                }
            }
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void registerPlane(SurfaceView view, int type) {
        this.m_planes.set(type, view);
        planeBreakCascade();
    }

    public void unregisterPlane(int type) {
        this.m_planes.set(type, null);
        planeBreakCascade();
    }

    public void planeCleanCascade() {
        if (!this.m_planeCascadeInit) {
            this.m_planeCascadeInit = true;
            planeBreakCascade();
        }
    }

    public void planeBreakCascade() {
        int count = 0;
        for (int c = 0; c < 8; c++) {
            if (this.m_planes.get(c) != null) {
                count++;
            }
        }
        if (count > 1) {
            this.m_planeBreakCascade = true;
        }
    }

    private boolean planeRemovedSuccessfully(SurfaceView sfView) {
        if (!sfView.getHolder().getSurface().isValid()) {
            return true;
        }
        if ((Build.MODEL.equals("LT18i") || Build.MODEL.equals("LT15i") || Build.MODEL.equals("Arc")) && isIceCreamSandwich() && this.m_layout.indexOfChild(sfView) < 0) {
            return true;
        }
        return false;
    }

    public void planeKickCascade() {
        if (!isHoneycomb() || !this.m_skipKickCascade) {
            if (!isJellybean() || !this.mContainsVideo) {
                planeCleanCascade();
                if (this.m_layout != null) {
                    if (this.m_planeBreakCascade) {
                        int c = 0;
                        while (c < 8) {
                            if (this.m_planes.get(c) != null && this.m_layout.indexOfChild((View) this.m_planes.get(c)) >= 0) {
                                this.m_layout.removeView((View) this.m_planes.get(c));
                            }
                            c++;
                        }
                        this.m_planeBreakCascade = false;
                        c = 0;
                        while (c < 8) {
                            if (this.m_planes.get(c) != null && !planeRemovedSuccessfully((SurfaceView) this.m_planes.get(c))) {
                                this.m_planeBreakCascade = true;
                                break;
                            }
                            c++;
                        }
                        this.m_planeCascadeStep = 0;
                    }
                    if (this.m_planeCascadeStep == 0) {
                        planeStepCascade();
                        this.m_mainView.requestFocus();
                    }
                }
            }
        }
    }

    public void planeStepCascade() {
        this.m_skipKickCascade = false;
        if (this.m_layout != null && !this.m_planeBreakCascade) {
            while (this.m_planeCascadeStep < 8) {
                if (this.m_planes.get(this.m_planeCascadeStep) != null) {
                    if (this.m_layout.indexOfChild((View) this.m_planes.get(this.m_planeCascadeStep)) < 0) {
                        this.m_layout.addView((View) this.m_planes.get(this.m_planeCascadeStep), 0);
                    }
                    this.m_planeCascadeStep++;
                    return;
                }
                this.m_planeCascadeStep++;
            }
        }
    }

    public void ensureZOrder() {
        int c = 7;
        while (c >= 0) {
            if (this.m_planes.get(c) != null && this.m_layout.indexOfChild((View) this.m_planes.get(c)) >= 0) {
                this.m_layout.bringChildToFront((View) this.m_planes.get(c));
            }
            c--;
        }
    }

    public Context getRuntimeContext() {
        return this.m_runtimeContext;
    }

    public Application getApplication() {
        return this.m_application;
    }

    public Context getApplicationContext() {
        return this.m_application;
    }

    public Context getDefaultContext() {
        if (this.m_activity != null) {
            return this.m_activity;
        }
        return this.m_application;
    }

    public int getDefaultIntentFlags() {
        if (this.m_activity != null) {
            return 0;
        }
        return 268435456;
    }

    public RelativeLayout getOverlaysLayout(boolean create) {
        if (create && this.m_overlaysLayout == null) {
            this.m_overlaysLayout = new RelativeLayout(this.m_activity);
            this.m_layout.addView(this.m_overlaysLayout);
        }
        return this.m_overlaysLayout;
    }

    public void didRemoveOverlay() {
        if (this.m_overlaysLayout != null && this.m_overlaysLayout.getChildCount() == 0) {
            this.m_layout.removeView(this.m_overlaysLayout);
            this.m_overlaysLayout = null;
        }
    }

    public View getView() {
        return this.m_mainView;
    }

    public AndroidCameraView getCameraView() {
        return this.m_cameraView;
    }

    public boolean isApplicationLaunched() {
        return sApplicationLaunched;
    }

    public FlashEGL getEgl() {
        if (this.m_flashEGL == null) {
            this.m_flashEGL = FlashEGLFactory.CreateFlashEGL();
        }
        return this.m_flashEGL;
    }

    public boolean isSurfaceValid() {
        return this.m_mainView != null && this.m_mainView.isSurfaceValid();
    }

    public void SendIntentToRuntime(Class<?> cls, String action, String category) {
        try {
            Intent intent = new Intent(this.m_runtimeContext, cls);
            intent.setAction(action);
            intent.addCategory(category);
            this.m_activity.startActivity(intent);
        } catch (Exception e) {
        }
    }

    public void SendIntentToRuntime(Class<?> cls, String action, String category, String extraName, String extraValue) {
        try {
            Intent intent = new Intent(this.m_runtimeContext, cls);
            intent.setAction(action);
            intent.addCategory(category);
            intent.putExtra(extraName, extraValue);
            this.m_activity.startActivity(intent);
        } catch (Exception e) {
        }
    }

    public void StartDownloadConfigService() {
        Intent svcIntent = new Intent();
        svcIntent.setPackage(Utils.getRuntimePackageName());
        svcIntent.setAction(AIRService.INTENT_DOWNLOAD_CONFIG);
        try {
            getApplicationContext().startService(svcIntent);
        } catch (SecurityException e) {
        }
    }

    public void ShowImmediateUpdateDialog() {
        String airDownloadURL = null;
        try {
            Bundle metadata = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (metadata != null) {
                airDownloadURL = (String) metadata.get("airDownloadURL");
            }
        } catch (NameNotFoundException e) {
        }
        if (airDownloadURL != null) {
            SendIntentToRuntime(AIRUpdateDialog.class, "android.intent.action.MAIN", "AIRUpdateDialog", "airDownloadURL", airDownloadURL);
        } else {
            SendIntentToRuntime(AIRUpdateDialog.class, "android.intent.action.MAIN", "AIRUpdateDialog");
        }
    }

    private void initializeAndroidAppVars(ApplicationInfo appInfo) {
        ApplicationFileManager.setAndroidPackageName(appInfo.packageName);
        ApplicationFileManager.setAndroidAPKPath(appInfo.sourceDir);
        ApplicationFileManager.processAndroidDataPath(this.m_application.getCacheDir().getAbsolutePath());
    }

    private void parseArgs(Activity act, String[] args) {
        String xmlFilePath = "";
        String rootDirectory = "";
        String extraArgs = "";
        String isADL = "false";
        String isDebuggerMode = "false";
        String isSwfPreviewMode = "false";
        String gamePreviewHost = "";
        try {
            xmlFilePath = args[0];
            rootDirectory = args[1];
            extraArgs = args[2];
            isADL = args[3];
            isDebuggerMode = args[4];
            if (args.length >= 6) {
                isSwfPreviewMode = args[5];
                gamePreviewHost = args[6];
            }
        } catch (ArrayIndexOutOfBoundsException e) {
        }
        this.mExtraArgs = extraArgs;
        this.mIsADL = Boolean.valueOf(isADL).booleanValue();
        this.mIsDebuggerMode = Boolean.valueOf(isDebuggerMode).booleanValue();
        sIsSwfPreviewMode = Boolean.valueOf(isSwfPreviewMode).booleanValue();
        sGamePreviewHost = gamePreviewHost;
        initializeAndroidAppVars(this.m_activity.getApplicationInfo());
        if (this.mIsADL) {
            this.mXmlPath = xmlFilePath;
            this.mRootDir = rootDirectory;
            return;
        }
        this.mXmlPath = ApplicationFileManager.getAppXMLRoot();
        this.mRootDir = ApplicationFileManager.getAppRoot();
    }

    public void onCreate(Activity act, String[] args) {
        this.m_activity = act;
        this.mActivityState = ActivityState.STARTED;
        parseArgs(act, args);
        SignalNewActivityCreated();
        try {
            this.m_runtimeContext = this.m_activity.createPackageContext(Utils.getRuntimePackageName(), 4);
        } catch (Exception e) {
        }
        if (!this.mIsDebuggerMode || this.mIsADL || sApplicationLaunched || DeviceProfiling.checkAndInitiateProfiler(this.m_activity)) {
            afterOnCreate();
        } else {
            checkForDebuggerAndLaunchDialog();
        }
        this.mInvokeEventPendingFromOnCreate = true;
        this.mConfigDownloadListener = ConfigDownloadListener.GetConfigDownloadListener();
    }

    private void afterOnCreate() {
        try {
            if (this.m_planes == null) {
                this.m_planes = new ArrayList(8);
                for (int c = 0; c < 8; c++) {
                    this.m_planes.add(c, null);
                }
            }
            Context appContext = getApplicationContext();
            this.m_layout = new FrameLayout(appContext);
            this.m_mainView = new AIRWindowSurfaceView(appContext, this);
            if (this.m_cameraView == null) {
                this.m_cameraView = new AndroidCameraView(appContext, this);
            }
            if (this.m_cameraView != null) {
                this.m_layout.addView(this.m_cameraView, 8, 16);
            }
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null) {
                Boolean containsVideo = (Boolean) bundle.get("containsVideo");
                if (containsVideo != null && containsVideo.booleanValue()) {
                    this.mContainsVideo = containsVideo.booleanValue();
                    this.m_videoView = this.m_mainView.getVideoView();
                    this.m_layout.addView(this.m_videoView, 0);
                }
            }
            this.m_layout.addView(this.m_mainView);
            if (this.m_overlaysLayout != null) {
                this.m_layout.addView(this.m_overlaysLayout);
            }
            this.m_activity.setContentView(this.m_layout);
            if (!((!this.mIsADL && !this.mShowDebuggerDialog) || this.m_activity == null || this.m_activity.getCurrentFocus() == this.m_mainView)) {
                this.m_mainView.requestFocus();
                this.m_mainView.onWindowFocusChanged(true);
            }
            if (!this.mFullScreenSetFromMetaData) {
                setFullScreenFromMetaData();
            }
            this.mFullScreenSetFromMetaData = true;
            if (getIsFullScreen()) {
                this.m_mainView.setFullScreen();
            }
            this.mHardKeyboardHidden = this.m_activity.getResources().getConfiguration().hardKeyboardHidden;
            this.mHardKeyboardType = this.m_activity.getResources().getConfiguration().keyboard;
            this.mOrientationManager = OrientationManager.getOrientationManager();
            this.mOrientationManager.onActivityCreated(this.m_activity, this.m_mainView);
            callActivityStateListeners();
            HDMIUtils.initHelper(appContext);
        } catch (Exception e) {
        }
    }

    private void LaunchApplication(Activity act, AIRWindowSurfaceView view, String appXmlPath, String appRootDir, String extraArgs, boolean isADL, boolean isDebuggerMode) {
        if (!sApplicationLaunched) {
            if (isADL) {
                try {
                    String s = act.getIntent().getStringExtra("args");
                    if (s != null) {
                        String[] args = s.split(" ");
                        appXmlPath = args[0];
                        appRootDir = args[1];
                        if (args.length >= 2) {
                            extraArgs = args[2] + " ";
                        }
                        for (int i = 3; i < args.length; i++) {
                            extraArgs = extraArgs + args[i] + " ";
                        }
                    }
                } catch (Exception e) {
                }
            } else {
                try {
                    if (sIsSwfPreviewMode) {
                        try {
                            String data = act.getIntent().getDataString();
                            if (data != null && data.indexOf("?") > 0) {
                                int aspectRatioToSet = -1;
                                for (String option : data.substring(data.indexOf("?") + 1).split("&")) {
                                    if (option.substring(0, option.indexOf("=")).equalsIgnoreCase("depthAndStencil")) {
                                        if (option.substring(option.indexOf("=") + 1).equalsIgnoreCase("true")) {
                                            sDepthAndStencil = true;
                                        } else {
                                            sDepthAndStencil = false;
                                        }
                                    } else {
                                        if (option.substring(0, option.indexOf("=")).equalsIgnoreCase("autoorients")) {
                                            if (option.substring(option.indexOf("=") + 1).equalsIgnoreCase("true")) {
                                                setAutoOrients(true);
                                            } else {
                                                setAutoOrients(false);
                                            }
                                        } else {
                                            if (option.substring(0, option.indexOf("=")).equalsIgnoreCase("aspectratio")) {
                                                String value = option.substring(option.indexOf("=") + 1);
                                                if (value.equalsIgnoreCase("portrait")) {
                                                    aspectRatioToSet = 1;
                                                } else {
                                                    if (value.equalsIgnoreCase("landscape")) {
                                                        aspectRatioToSet = 2;
                                                    } else {
                                                        if (value.equalsIgnoreCase("any")) {
                                                            aspectRatioToSet = 3;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (aspectRatioToSet != -1) {
                                    setAspectRatio(aspectRatioToSet);
                                }
                            }
                        } catch (Exception e2) {
                        }
                    }
                } catch (Exception e3) {
                    return;
                }
            }
            Context appContext = getApplicationContext();
            sEntryPoint = new Entrypoints();
            sEntryPoint.EntryMain(appXmlPath, appRootDir, extraArgs, Utils.getRuntimePackageName(), view, act.getApplication(), act.getApplicationInfo(), appContext, this, isADL, isDebuggerMode);
            sIdleStateManager = AndroidIdleState.GetIdleStateManager(appContext);
            sApplicationLaunched = true;
        }
    }

    private void setMainView(View view) {
        if (sApplicationLaunched && sEntryPoint != null) {
            boolean isInMultiWindow = false;
            if (VERSION.SDK_INT >= 24) {
                isInMultiWindow = this.m_activity.isInMultiWindowMode();
            }
            if (isResumed() || isInMultiWindow) {
                try {
                    sEntryPoint.setMainView(view);
                } catch (Exception e) {
                }
            }
        }
    }

    public void initCallStateListener() {
        if (sAndroidTelephonyManager == null) {
            sAndroidTelephonyManager = AndroidTelephonyManager.CreateAndroidTelephonyManager(getApplicationContext());
            sAndroidTelephonyManager.listen(true);
        }
    }

    public void onPause() {
        this.mActivityState = ActivityState.PAUSED;
        callActivityStateListeners();
        if (this.m_mainView != null) {
            this.m_mainView.forceSoftKeyboardDown();
        }
        if (this.mOrientationManager != null) {
            this.mOrientationManager.onActivityPaused();
        }
        if (sIdleStateManager != null) {
            sIdleStateManager.releaseLock();
        }
        if (isApplicationLaunched()) {
            nativeOnFocusListener(false);
            nativeDeactivateEvent();
        }
        planeBreakCascade();
    }

    public void onResume() {
        this.mActivityState = ActivityState.RESUMED;
        callActivityStateListeners();
        if (this.mOrientationManager != null) {
            this.mOrientationManager.onActivityResumed();
        }
        if (sIdleStateManager != null) {
            sIdleStateManager.acquireLock();
        }
        if (isApplicationLaunched()) {
            nativeActivateEvent();
            nativeOnFocusListener(true);
        } else {
            this.mActivateEventPending = true;
        }
        this.m_skipKickCascade = true;
        planeBreakCascade();
    }

    public void onRestart() {
        this.mActivityState = ActivityState.RESTARTED;
        callActivityStateListeners();
        if (this.m_mainView != null) {
            this.m_mainView.HideSoftKeyboardOnWindowFocusChange();
        }
        SetVisible(true);
    }

    public void onStop() {
        this.mActivityState = ActivityState.STOPPED;
        callActivityStateListeners();
        SetVisible(false);
    }

    public void onDestroy() {
        this.mActivityState = ActivityState.DESTROYED;
        callActivityStateListeners();
        if (this.mOrientationManager != null) {
            this.mOrientationManager.onActivityDestroyed();
        }
        for (int c = 0; c < 8; c++) {
            if (this.m_planes.get(c) != null) {
                this.m_layout.removeView((View) this.m_planes.get(c));
            }
        }
        if (this.m_overlaysLayout != null) {
            this.m_layout.removeView(this.m_overlaysLayout);
        }
        this.m_activity = null;
        this.m_cameraView = null;
        this.m_mainView = null;
        this.m_layout = null;
        setMainView(null);
        HDMIUtils.closeHelper();
    }

    public void SendInvokeEvent() {
        Intent intent = this.m_activity.getIntent();
        String invokeEvtData = null;
        String action = intent.getAction();
        String type = intent.getType();
        if (!"android.intent.action.SEND".equals(action) || type == null) {
            if (!"android.intent.action.SEND_MULTIPLE".equals(action) || type == null) {
                invokeEvtData = intent.getDataString();
            } else if (type.startsWith("image/")) {
                invokeEvtData = handleSendMultipleImages(intent);
            }
        } else if ("text/plain".equals(type)) {
            invokeEvtData = handleSendText(intent);
        } else if (type.startsWith("image/")) {
            invokeEvtData = handleSendImage(intent);
        }
        int invokeEvtType = 0;
        if (invokeEvtData != null) {
            invokeEvtType = 1;
        }
        nativeSendInvokeEventWithData(invokeEvtData, intent.getAction(), invokeEvtType);
    }

    String handleSendText(Intent intent) {
        return intent.getStringExtra("android.intent.extra.TEXT");
    }

    String handleSendImage(Intent intent) {
        Parcelable obj = intent.getParcelableExtra("android.intent.extra.STREAM");
        if (obj != null) {
            return ((Uri) obj).toString();
        }
        return null;
    }

    String handleSendMultipleImages(Intent intent) {
        ArrayList<Uri> imageUris = intent.getParcelableArrayListExtra("android.intent.extra.STREAM");
        if (imageUris == null) {
            return null;
        }
        String uriListString = imageUris.toString();
        return uriListString.substring(1, uriListString.length() - 1);
    }

    public void onNewIntent(Intent ii) {
        this.m_activity.setIntent(ii);
        SendInvokeEvent();
    }

    public void onSurfaceInitialized() {
        setMainView(this.m_mainView);
        SetVisible(true);
        if (this.mDisplayWaitingDialog) {
            showDialogWaitingForConnection(this.debuggerPort);
            this.mDisplayWaitingDialog = false;
        }
        LaunchApplication(this.m_activity, this.m_mainView, this.mXmlPath, this.mRootDir, this.mExtraArgs, this.mIsADL, this.mIsDebuggerMode);
        if (this.mInvokeEventPendingFromOnCreate) {
            if (!this.mIsADL) {
                SendInvokeEvent();
            }
            this.mInvokeEventPendingFromOnCreate = false;
        }
        if (this.mActivateEventPending) {
            nativeActivateEvent();
            this.mActivateEventPending = false;
        }
        planeCleanCascade();
    }

    public void finish() {
        if (this.m_activity != null) {
            this.m_activity.finish();
        }
    }

    public void onSurfaceDestroyed() {
        SetVisible(false);
    }

    public void onScreenStateChanged(boolean isScreenOn) {
        this.mScreenOn = isScreenOn;
        SetVisible(isScreenOn);
        if (isScreenOn) {
            this.m_skipKickCascade = false;
            planeBreakCascade();
        }
    }

    private void SetVisible(boolean visible) {
        if (visible) {
            if (isSurfaceValid() && this.mScreenOn && this.mActivityState != ActivityState.STOPPED && this.mActivityState != ActivityState.DESTROYED) {
                nativeSetVisible(true);
            }
        } else if (isApplicationLaunched()) {
            nativeSetVisible(false);
        }
    }

    public void onConfigurationChanged(Configuration newConfig) {
        this.mHardKeyboardHidden = newConfig.hardKeyboardHidden;
        this.mHardKeyboardType = newConfig.keyboard;
        this.mOrientationManager.onConfigurationChanged(newConfig);
        callActivityStateListeners(newConfig);
    }

    public boolean dispatchKeyEvent(KeyEvent event, boolean handled) {
        return callInputEventListeners(event);
    }

    public boolean dispatchGenericMotionEvent(MotionEvent event, boolean handled) {
        return callInputEventListeners(event);
    }

    public void onLowMemory() {
        nativeLowMemoryEvent();
    }

    public int getOrientation() {
        return this.mOrientationManager.getOrientation();
    }

    public int getDeviceOrientation() {
        return this.mOrientationManager.getDeviceOrientation();
    }

    public void setOrientation(int orientation) {
        this.mOrientationManager.setOrientation(orientation);
    }

    public void setAspectRatio(int aspectRatio) {
        this.mOrientationManager.setAspectRatio(aspectRatio);
    }

    public void setAutoOrients(boolean autoOrients) {
        this.mOrientationManager.setAutoOrients(autoOrients);
    }

    public boolean getAutoOrients() {
        return this.mOrientationManager.getAutoOrients();
    }

    public int[] getSupportedOrientations() {
        return this.mOrientationManager.getSupportedOrientations();
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        callActivityResultListeners(requestCode, resultCode, data);
    }

    public boolean isHardKeyboardHidden() {
        return this.mHardKeyboardHidden == 2;
    }

    public int getHardKeyboardType() {
        return this.mHardKeyboardType;
    }

    public boolean needsCompositingSurface() {
        return true;
    }

    public void setUseRGB565(Boolean value) {
        this.mRGB565Override = value.booleanValue();
    }

    public boolean useRGB565() {
        if (this.mIsADL) {
            return this.mRGB565Override;
        }
        ResourceFileManager pResFileManager = new ResourceFileManager(this.m_activity);
        return !pResFileManager.resExists(pResFileManager.lookupResId(AndroidConstants.ANDROID_RESOURCE_RGBA8888));
    }

    public void BroadcastIntent(String action, String data) {
        try {
            if (!data.trim().startsWith("file://") || isAvailablePath(data)) {
                getDefaultContext().startActivity(Intent.parseUri(data, 0).setAction(action).addFlags(getDefaultIntentFlags()));
            } else {
                Toast.makeText(getDefaultContext(), "Requested URL is not available", 0).show();
            }
        } catch (URISyntaxException e) {
        } catch (ActivityNotFoundException e2) {
        }
    }

    private boolean isAvailablePath(String path) {
        if (new File(Uri.parse(path).getPath()).exists()) {
            return true;
        }
        return false;
    }

    public void LaunchMarketPlaceForAIR(String airDownloadURL) {
        String marketPlaceURL = airDownloadURL;
        if (marketPlaceURL == null) {
            marketPlaceURL = "market://details?id=" + Utils.getRuntimePackageName();
        }
        try {
            BroadcastIntent("android.intent.action.VIEW", marketPlaceURL);
        } catch (Exception e) {
        }
    }

    public String GetLibCorePath() {
        if (this.mLibCorePath == null) {
            this.mLibCorePath = Utils.GetLibCorePath(this.m_application);
        }
        return this.mLibCorePath;
    }

    private void LoadRuntimeLibraries() {
        if (!sRuntimeLibrariesLoaded) {
            try {
                System.load(Utils.GetLibSTLPath(this.m_application));
                System.load(GetLibCorePath());
                sRuntimeLibrariesLoaded = true;
            } catch (UnsatisfiedLinkError e) {
            }
        }
    }

    private void showDialogUnableToListenOnPort(int debuggerPort) {
        new ListenErrorDialog(this.m_activity, debuggerPort).createAndShowDialog();
    }

    private void checkForDebuggerAndLaunchDialog() {
        Exception e;
        Throwable th;
        boolean z = true;
        if (!this.mIsADL) {
            ResourceFileManager pResFileManager = new ResourceFileManager(this.m_activity);
            String hostOrIPaddress = null;
            DebugMode mDebugMode = DebugMode.None;
            if (pResFileManager.resExists(pResFileManager.lookupResId(AndroidConstants.ANDROID_RESOURCE_DEBUG_RAW_INFO))) {
                try {
                    HashMap<String, String> keyValPairs = Utils.parseKeyValuePairFile(pResFileManager.getFileStreamFromRawRes(pResFileManager.lookupResId(AndroidConstants.ANDROID_RESOURCE_DEBUG_RAW_INFO)), "=");
                    String value = (String) keyValPairs.get("incomingDebugPort");
                    if (value != null) {
                        try {
                            this.debuggerPort = Integer.parseInt(value);
                            mDebugMode = DebugMode.ListenMode;
                        } catch (NumberFormatException e2) {
                        }
                    }
                    value = (String) keyValPairs.get("outgoingDebugHost");
                    if (value != null) {
                        hostOrIPaddress = value;
                        if (mDebugMode == DebugMode.ListenMode) {
                            mDebugMode = DebugMode.ConflictMode;
                            throw new Exception("listen and connect are mutually exclusive.");
                        }
                        mDebugMode = DebugMode.ConnectMode;
                    }
                } catch (Exception e3) {
                    return;
                }
            }
            switch (mDebugMode) {
                case ListenMode:
                    DebuggerSettings debuggerSettings;
                    boolean portAvailable = true;
                    ServerSocket socket = null;
                    try {
                        ServerSocket socket2 = new ServerSocket(this.debuggerPort, 1, InetAddress.getLocalHost());
                        try {
                            socket2.close();
                            if (socket2 != null) {
                                try {
                                    socket2.close();
                                } catch (IOException e4) {
                                    socket = socket2;
                                }
                            }
                            socket = socket2;
                        } catch (IOException e5) {
                            socket = socket2;
                            portAvailable = false;
                            if (socket != null) {
                                try {
                                    socket.close();
                                } catch (IOException e6) {
                                }
                            }
                            if (portAvailable) {
                                this.mDisplayWaitingDialog = true;
                                afterOnCreate();
                            } else {
                                showDialogUnableToListenOnPort(this.debuggerPort);
                            }
                            debuggerSettings = this.mDebuggerSettings;
                            if (mDebugMode != DebugMode.ListenMode) {
                                z = false;
                            }
                            debuggerSettings.setListen(z);
                            this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                            return;
                        } catch (SecurityException e7) {
                            socket = socket2;
                            portAvailable = false;
                            if (socket != null) {
                                try {
                                    socket.close();
                                } catch (IOException e8) {
                                }
                            }
                            if (portAvailable) {
                                showDialogUnableToListenOnPort(this.debuggerPort);
                            } else {
                                this.mDisplayWaitingDialog = true;
                                afterOnCreate();
                            }
                            debuggerSettings = this.mDebuggerSettings;
                            if (mDebugMode != DebugMode.ListenMode) {
                                z = false;
                            }
                            debuggerSettings.setListen(z);
                            this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                            return;
                        } catch (Exception e9) {
                            e = e9;
                            socket = socket2;
                            try {
                                if (!e.getClass().getName().equals("android.os.NetworkOnMainThreadException")) {
                                    portAvailable = false;
                                }
                                if (socket != null) {
                                    try {
                                        socket.close();
                                    } catch (IOException e10) {
                                    }
                                }
                                if (portAvailable) {
                                    this.mDisplayWaitingDialog = true;
                                    afterOnCreate();
                                } else {
                                    showDialogUnableToListenOnPort(this.debuggerPort);
                                }
                                debuggerSettings = this.mDebuggerSettings;
                                if (mDebugMode != DebugMode.ListenMode) {
                                    z = false;
                                }
                                debuggerSettings.setListen(z);
                                this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                                return;
                            } catch (Throwable th2) {
                                th = th2;
                                if (socket != null) {
                                    try {
                                        socket.close();
                                    } catch (IOException e11) {
                                    }
                                }
                                throw th;
                            }
                        } catch (Throwable th3) {
                            th = th3;
                            socket = socket2;
                            if (socket != null) {
                                socket.close();
                            }
                            throw th;
                        }
                    } catch (IOException e12) {
                        portAvailable = false;
                        if (socket != null) {
                            socket.close();
                        }
                        if (portAvailable) {
                            showDialogUnableToListenOnPort(this.debuggerPort);
                        } else {
                            this.mDisplayWaitingDialog = true;
                            afterOnCreate();
                        }
                        debuggerSettings = this.mDebuggerSettings;
                        if (mDebugMode != DebugMode.ListenMode) {
                            z = false;
                        }
                        debuggerSettings.setListen(z);
                        this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                        return;
                    } catch (SecurityException e13) {
                        portAvailable = false;
                        if (socket != null) {
                            socket.close();
                        }
                        if (portAvailable) {
                            this.mDisplayWaitingDialog = true;
                            afterOnCreate();
                        } else {
                            showDialogUnableToListenOnPort(this.debuggerPort);
                        }
                        debuggerSettings = this.mDebuggerSettings;
                        if (mDebugMode != DebugMode.ListenMode) {
                            z = false;
                        }
                        debuggerSettings.setListen(z);
                        this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                        return;
                    } catch (Exception e14) {
                        e = e14;
                        if (e.getClass().getName().equals("android.os.NetworkOnMainThreadException")) {
                            portAvailable = false;
                        }
                        if (socket != null) {
                            socket.close();
                        }
                        if (portAvailable) {
                            showDialogUnableToListenOnPort(this.debuggerPort);
                        } else {
                            this.mDisplayWaitingDialog = true;
                            afterOnCreate();
                        }
                        debuggerSettings = this.mDebuggerSettings;
                        if (mDebugMode != DebugMode.ListenMode) {
                            z = false;
                        }
                        debuggerSettings.setListen(z);
                        this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                        return;
                    }
                    if (portAvailable) {
                        this.mDisplayWaitingDialog = true;
                        afterOnCreate();
                    } else {
                        showDialogUnableToListenOnPort(this.debuggerPort);
                    }
                    debuggerSettings = this.mDebuggerSettings;
                    if (mDebugMode != DebugMode.ListenMode) {
                        z = false;
                    }
                    debuggerSettings.setListen(z);
                    this.mDebuggerSettings.setDebugerPort(this.debuggerPort);
                    return;
                case ConnectMode:
                    if (Utils.nativeConnectDebuggerSocket(hostOrIPaddress)) {
                        this.mDebuggerSettings.setHost(hostOrIPaddress);
                        afterOnCreate();
                        return;
                    }
                    showDialogforIpAddress(hostOrIPaddress);
                    return;
                case None:
                    afterOnCreate();
                    return;
                case ConflictMode:
                    return;
                default:
                    return;
            }
        }
    }

    private void showDialogforIpAddress(String hostOrAddress) {
        Context appContext = getApplicationContext();
        new RemoteDebuggerDialog(this.m_activity).createAndShowDialog(hostOrAddress);
    }

    private void closeDialogWaitingForConnection() {
        Context appContext = getApplicationContext();
        try {
            Intent intent = new Intent();
            intent.setAction("android.intent.action.MAIN");
            intent.addCategory("RemoteDebuggerListenerDialogClose");
            intent.putExtra("debuggerPort", this.debuggerPort);
            appContext.sendBroadcast(intent);
        } catch (Exception e) {
        }
    }

    private void showDialogWaitingForConnection(int debuggerPort) {
        if (sHasCaptiveRuntime) {
            final int aDebuggerPort = debuggerPort;
            new Thread(new Runnable() {
                public void run() {
                    try {
                        Thread.sleep(30000);
                        new Socket(InetAddress.getLocalHost(), aDebuggerPort).close();
                    } catch (Exception e) {
                    }
                }
            }).start();
            return;
        }
        try {
            Context appContext = getApplicationContext();
            Intent intent = new Intent(this.m_runtimeContext, RemoteDebuggerListenerDialog.class);
            intent.setAction("android.intent.action.MAIN");
            intent.addCategory("RemoteDebuggerListenerDialog");
            intent.putExtra("debuggerPort", debuggerPort);
            this.m_activity.startActivity(intent);
        } catch (Exception e) {
        }
    }

    public void gotResultFromDialog(boolean ok, String hostOrAddress) {
        boolean hostReachable = false;
        if (ok) {
            if (hostOrAddress.length() != 0) {
                hostReachable = Utils.nativeConnectDebuggerSocket(hostOrAddress);
            }
            if (hostReachable) {
                this.mDebuggerSettings.setHost(hostOrAddress);
                this.mDebuggerSettings.setListen(false);
                this.mShowDebuggerDialog = true;
            } else {
                showDialogforIpAddress(hostOrAddress);
            }
        }
        if (hostReachable || !ok) {
            afterOnCreate();
        }
    }

    public void addInputEventListner(InputEventCallback cb) {
        if (this.mInputEventListeners == null) {
            this.mInputEventListeners = new ArrayList();
        }
        if (!this.mInputEventListeners.contains(cb)) {
            this.mInputEventListeners.add(cb);
        }
    }

    public void removeInputEventListner(InputEventCallback cb) {
        if (this.mInputEventListeners != null) {
            this.mInputEventListeners.remove(cb);
        }
    }

    private boolean callInputEventListeners(KeyEvent event) {
        boolean handled = false;
        if (this.mInputEventListeners == null) {
            return 0;
        }
        try {
            int size = this.mInputEventListeners.size();
            for (int i = 0; i < size; i++) {
                handled = handled || ((InputEventCallback) this.mInputEventListeners.get(i)).onKeyEvent(event);
            }
        } catch (Exception e) {
        }
        return handled;
    }

    private boolean callInputEventListeners(MotionEvent event) {
        boolean handled = false;
        if (this.mInputEventListeners == null) {
            return 0;
        }
        try {
            int size = this.mInputEventListeners.size();
            for (int i = 0; i < size; i++) {
                handled = handled || ((InputEventCallback) this.mInputEventListeners.get(i)).onGenericMotionEvent(event);
            }
        } catch (Exception e) {
        }
        return handled;
    }

    public void addActivityStateChangeListner(StateChangeCallback cb) {
        if (this.mActivityStateListeners == null) {
            this.mActivityStateListeners = new ArrayList();
        }
        if (!this.mActivityStateListeners.contains(cb)) {
            this.mActivityStateListeners.add(cb);
        }
    }

    public void removeActivityStateChangeListner(StateChangeCallback cb) {
        if (this.mActivityStateListeners != null) {
            this.mActivityStateListeners.remove(cb);
        }
    }

    private void callActivityStateListeners() {
        if (this.mActivityStateListeners != null) {
            try {
                int size = this.mActivityStateListeners.size();
                for (int i = 0; i < size; i++) {
                    ((StateChangeCallback) this.mActivityStateListeners.get(i)).onActivityStateChanged(this.mActivityState);
                }
            } catch (Exception e) {
            }
        }
    }

    private void callActivityStateListeners(Configuration config) {
        if (this.mActivityStateListeners != null) {
            try {
                int size = this.mActivityStateListeners.size();
                for (int i = 0; i < size; i++) {
                    ((StateChangeCallback) this.mActivityStateListeners.get(i)).onConfigurationChanged(config);
                }
            } catch (Exception e) {
            }
        }
    }

    public void addActivityResultListener(ActivityResultCallback cb) {
        if (this.mActivityResultListeners == null) {
            this.mActivityResultListeners = new ArrayList();
        }
        if (!this.mActivityResultListeners.contains(cb)) {
            this.mActivityResultListeners.add(cb);
        }
    }

    public void removeActivityResultListener(ActivityResultCallback cb) {
        if (this.mActivityResultListeners != null) {
            this.mActivityResultListeners.remove(cb);
        }
    }

    private void callActivityResultListeners(int requestCode, int resultCode, Intent data) {
        if (this.mActivityResultListeners != null) {
            try {
                int size = this.mActivityResultListeners.size();
                for (int i = 0; i < size; i++) {
                    ((ActivityResultCallback) this.mActivityResultListeners.get(i)).onActivityResult(requestCode, resultCode, data);
                }
            } catch (Exception e) {
            }
        }
    }

    private void SignalNewActivityCreated() {
        this.m_newActivityLock.lock();
        this.m_newActivityCondition.signalAll();
        this.m_newActivityLock.unlock();
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.app.Activity WaitForNewActivity() {
        /*
        r2 = this;
        r0 = r2.m_newActivityLock;
        r0.lock();
        r0 = r2.m_activity;	 Catch:{ InterruptedException -> 0x0016, all -> 0x001d }
        if (r0 != 0) goto L_0x000e;
    L_0x0009:
        r0 = r2.m_newActivityCondition;	 Catch:{ InterruptedException -> 0x0016, all -> 0x001d }
        r0.await();	 Catch:{ InterruptedException -> 0x0016, all -> 0x001d }
    L_0x000e:
        r0 = r2.m_newActivityLock;
        r0.unlock();
    L_0x0013:
        r0 = r2.m_activity;
        return r0;
    L_0x0016:
        r0 = move-exception;
        r0 = r2.m_newActivityLock;
        r0.unlock();
        goto L_0x0013;
    L_0x001d:
        r0 = move-exception;
        r1 = r2.m_newActivityLock;
        r1.unlock();
        throw r0;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidActivityWrapper.WaitForNewActivity():android.app.Activity");
    }

    private void setFullScreenFromMetaData() {
        try {
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null) {
                Boolean fullScreen = (Boolean) bundle.get("fullScreen");
                if (fullScreen != null && fullScreen.booleanValue()) {
                    this.m_mainView.setFullScreen();
                }
            }
        } catch (NameNotFoundException e) {
        }
    }

    protected void setIsFullScreen(boolean aFullScreen) {
        this.mIsFullScreen = aFullScreen;
    }

    protected boolean getIsFullScreen() {
        return this.mIsFullScreen;
    }

    public String GetAppCacheDirectory() {
        return this.m_application.getCacheDir().getAbsolutePath();
    }

    public String GetAppDataDirectory() {
        return this.m_application.getApplicationInfo().dataDir;
    }

    public String GetRuntimeDataDirectory() {
        return this.m_runtimeContext.getApplicationInfo().dataDir + "/";
    }

    public void finishActivityFromChild(Activity child, int requestCode) {
    }

    public void finishFromChild(Activity child) {
    }

    public void onAttachedToWindow() {
    }

    public void onBackPressed() {
    }

    public void onContentChanged() {
    }

    public boolean onContextItemSelected(MenuItem item, boolean superRetVal) {
        return superRetVal;
    }

    public void onContextMenuClosed(Menu menu) {
    }

    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
    }

    public CharSequence onCreateDescription(CharSequence superRetVal) {
        return superRetVal;
    }

    public boolean onCreateOptionsMenu(Menu menu, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onCreatePanelMenu(int featureId, Menu menu, boolean superRetVal) {
        return superRetVal;
    }

    public View onCreatePanelView(int featureId, View superRetVal) {
        return superRetVal;
    }

    public boolean onCreateThumbnail(Bitmap outBitmap, Canvas canvas, boolean superRetVal) {
        return superRetVal;
    }

    public View onCreateView(String name, Context context, AttributeSet attrs, View superRetVal) {
        return superRetVal;
    }

    public void onDetachedFromWindow() {
    }

    public boolean onKeyDown(int keyCode, KeyEvent event, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onKeyLongPress(int keyCode, KeyEvent event, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onKeyMultiple(int keyCode, int repeatCount, KeyEvent event, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onKeyUp(int keyCode, KeyEvent event, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onMenuItemSelected(int featureId, MenuItem item, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onMenuOpened(int featureId, Menu menu, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onOptionsItemSelected(MenuItem item, boolean superRetVal) {
        return superRetVal;
    }

    public void onOptionsMenuClosed(Menu menu) {
    }

    public void onPanelClosed(int featureId, Menu menu) {
    }

    public boolean onPrepareOptionsMenu(Menu menu, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onPreparePanel(int featureId, View view, Menu menu, boolean superRetVal) {
        return superRetVal;
    }

    public Object onRetainNonConfigurationInstance(Object superRetVal) {
        return superRetVal;
    }

    public boolean onSearchRequested(boolean superRetVal) {
        return superRetVal;
    }

    public boolean onTouchEvent(MotionEvent event, boolean superRetVal) {
        return superRetVal;
    }

    public boolean onTrackballEvent(MotionEvent event, boolean superRetVal) {
        return superRetVal;
    }

    public void onUserInteraction() {
    }

    public void onWindowAttributesChanged(LayoutParams params) {
    }

    public void onWindowFocusChanged(boolean hasFocus) {
    }

    public void onApplyThemeResource(Theme theme, int resid, boolean first) {
    }

    public void onChildTitleChanged(Activity childActivity, CharSequence title) {
    }

    public Dialog onCreateDialog(int id, Bundle args, Dialog superRetVal) {
        return superRetVal;
    }

    public Dialog onCreateDialog(int id, Dialog superRetVal) {
        return superRetVal;
    }

    public void onPostCreate(Bundle savedInstanceState) {
    }

    public void onPostResume() {
    }

    public void onPrepareDialog(int id, Dialog dialog, Bundle args) {
    }

    public void onPrepareDialog(int id, Dialog dialog) {
    }

    public void onRestoreInstanceState(Bundle savedInstanceState) {
    }

    public void onSaveInstanceState(Bundle outState) {
    }

    public void onTitleChanged(CharSequence title, int color) {
    }

    public void onUserLeaveHint() {
    }

    public DebuggerSettings GetDebuggerSettings() {
        return this.mDebuggerSettings;
    }

    public void applyDownloadedConfig() {
        if (sEntryPoint != null) {
            sEntryPoint.EntryApplyDownloadedConfig();
        }
    }

    public int checkPermission(int flashPermission) {
        String permission = FlashToAndroidPermission(flashPermission);
        if (!manifestDeclaresPermission(permission)) {
            return 2;
        }
        int status = this.m_activity.checkCallingOrSelfPermission(permission);
        boolean showRationale = true;
        if (GetTargetSdkVersion() >= 23 && VERSION.SDK_INT >= 23) {
            showRationale = this.m_activity.shouldShowRequestPermissionRationale(permission);
        }
        if (status == 0) {
            return 1;
        }
        if (status != -1 || showRationale) {
            return 2;
        }
        return 0;
    }

    public String FlashToAndroidPermission(int flashPermission) {
        switch (flashPermission) {
            case 1:
                return "android.permission.ACCESS_FINE_LOCATION";
            case 2:
                return "android.permission.RECORD_AUDIO";
            case 4:
                return "android.permission.CAMERA";
            case 8:
                return "android.permission.WRITE_EXTERNAL_STORAGE";
            case FlashPermission.WIFI /*100*/:
                return "android.permission.ACCESS_WIFI_STATE";
            case FlashPermission.NETWORK /*296*/:
                return "android.permission.ACCESS_NETWORK_STATE";
            default:
                return null;
        }
    }

    public int AndroidToFlashPermission(String permission) {
        Object obj = -1;
        switch (permission.hashCode()) {
            case -1888586689:
                if (permission.equals("android.permission.ACCESS_FINE_LOCATION")) {
                    obj = null;
                    break;
                }
                break;
            case 393388709:
                if (permission.equals("android.permission.ACCESS_NETWORK_STATE")) {
                    obj = 5;
                    break;
                }
                break;
            case 463403621:
                if (permission.equals("android.permission.CAMERA")) {
                    obj = 3;
                    break;
                }
                break;
            case 1365911975:
                if (permission.equals("android.permission.WRITE_EXTERNAL_STORAGE")) {
                    obj = 1;
                    break;
                }
                break;
            case 1675316546:
                if (permission.equals("android.permission.ACCESS_WIFI_STATE")) {
                    obj = 4;
                    break;
                }
                break;
            case 1831139720:
                if (permission.equals("android.permission.RECORD_AUDIO")) {
                    obj = 2;
                    break;
                }
                break;
        }
        switch (obj) {
            case null:
                return 1;
            case 1:
                return 8;
            case 2:
                return 2;
            case 3:
                return 4;
            case 4:
                return 100;
            case 5:
                return FlashPermission.NETWORK;
            default:
                return 0;
        }
    }

    public void requestPermission(int flashPermission) {
        if (VERSION.SDK_INT < 23 || GetTargetSdkVersion() < 23) {
            nativeNotifyPermissionRequestResult(flashPermission, checkPermission(flashPermission));
            return;
        }
        String permission = FlashToAndroidPermission(flashPermission);
        this.m_activity.requestPermissions(new String[]{permission}, 0);
    }

    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        int status = 2;
        if (grantResults.length > 0) {
            if (grantResults[0] == 0) {
                status = 1;
            }
            nativeNotifyPermissionRequestResult(AndroidToFlashPermission(permissions[0]), status);
        }
    }
}
