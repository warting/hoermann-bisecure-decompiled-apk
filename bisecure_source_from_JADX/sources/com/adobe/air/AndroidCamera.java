package com.adobe.air;

import android.content.res.Configuration;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.Size;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import com.adobe.air.AndroidActivityWrapper.ActivityState;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;

public class AndroidCamera {
    private static final int CAMERA_POSITION_UNKNOWN = -1;
    private static final String LOG_TAG = "AndroidCamera";
    private static boolean sAreMultipleCamerasSupportedInitialized = false;
    private static boolean sAreMultipleCamerasSupportedOnDevice = false;
    private static Class<?> sCameraInfoClass = null;
    private static Method sMIDGetCameraInfo = null;
    private static Method sMIDGetNumberOfCameras = null;
    private static Method sMIDOpen = null;
    private static Method sMIDOpenWithCameraID = null;
    private StateChangeCallback mActivityStateCB = null;
    private byte[] mBuffer1 = null;
    private byte[] mBuffer2 = null;
    private byte[] mCallbackBuffer = null;
    private boolean mCallbacksRegistered = false;
    private Camera mCamera = null;
    private int mCameraId = 0;
    private boolean mCapturing = false;
    private long mClientId = 0;
    private boolean mInitialized = false;
    private boolean mPreviewSurfaceValid = true;

    /* renamed from: com.adobe.air.AndroidCamera$1 */
    class C00231 implements PreviewCallback {
        C00231() {
        }

        public void onPreviewFrame(byte[] data, Camera camera) {
            try {
                if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                    AndroidCamera.this.nativeOnFrameCaptured(AndroidCamera.this.mClientId, data);
                }
                if (AndroidCamera.this.mCallbackBuffer == AndroidCamera.this.mBuffer1) {
                    AndroidCamera.this.mCallbackBuffer = AndroidCamera.this.mBuffer2;
                } else {
                    AndroidCamera.this.mCallbackBuffer = AndroidCamera.this.mBuffer1;
                }
                AndroidCamera.this.mCamera.addCallbackBuffer(AndroidCamera.this.mCallbackBuffer);
            } catch (Exception e) {
            }
        }
    }

    /* renamed from: com.adobe.air.AndroidCamera$2 */
    class C00242 implements StateChangeCallback {
        C00242() {
        }

        public void onActivityStateChanged(ActivityState state) {
            if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                if (state == ActivityState.RESUMED && AndroidCamera.this.mPreviewSurfaceValid) {
                    AndroidCamera.this.nativeOnCanOpenCamera(AndroidCamera.this.mClientId);
                } else if (state == ActivityState.PAUSED) {
                    AndroidCamera.this.nativeOnShouldCloseCamera(AndroidCamera.this.mClientId);
                }
            }
        }

        public void onConfigurationChanged(Configuration config) {
        }
    }

    class PreviewSurfaceCallback implements Callback {
        PreviewSurfaceCallback() {
        }

        public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        }

        public void surfaceCreated(SurfaceHolder holder) {
            AndroidCamera.this.mPreviewSurfaceValid = true;
            if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                AndroidCamera.this.nativeOnCanOpenCamera(AndroidCamera.this.mClientId);
            }
        }

        public void surfaceDestroyed(SurfaceHolder holder) {
            AndroidCamera.this.mPreviewSurfaceValid = false;
            if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                AndroidCamera.this.nativeOnShouldCloseCamera(AndroidCamera.this.mClientId);
            }
        }
    }

    private native void nativeOnCanOpenCamera(long j);

    private native void nativeOnFrameCaptured(long j, byte[] bArr);

    private native void nativeOnShouldCloseCamera(long j);

    public AndroidCamera(long clientId) {
        this.mClientId = clientId;
        areMultipleCamerasSupportedOnDevice();
    }

    public static boolean areMultipleCamerasSupportedOnDevice() {
        if (sAreMultipleCamerasSupportedInitialized) {
            return sAreMultipleCamerasSupportedOnDevice;
        }
        sAreMultipleCamerasSupportedInitialized = true;
        try {
            sMIDOpenWithCameraID = Camera.class.getMethod("open", new Class[]{Integer.TYPE});
            sMIDGetNumberOfCameras = Camera.class.getDeclaredMethod("getNumberOfCameras", (Class[]) null);
            try {
                sCameraInfoClass = Class.forName("android.hardware.Camera$CameraInfo");
                sMIDGetCameraInfo = Camera.class.getMethod("getCameraInfo", new Class[]{Integer.TYPE, sCameraInfoClass});
                if (!(sMIDOpenWithCameraID == null || sMIDGetNumberOfCameras == null || sMIDGetCameraInfo == null)) {
                    sAreMultipleCamerasSupportedOnDevice = true;
                }
                return sAreMultipleCamerasSupportedOnDevice;
            } catch (Exception e) {
                return false;
            }
        } catch (NoSuchMethodException e2) {
            return false;
        }
    }

    public boolean open(int cameraId) {
        if (this.mCamera != null) {
            return true;
        }
        SurfaceHolder holder = null;
        try {
            holder = AndroidActivityWrapper.GetAndroidActivityWrapper().getCameraView().getHolder();
            if (!(holder == null || holder.getSurface() == null)) {
                if (sAreMultipleCamerasSupportedOnDevice) {
                    this.mCamera = (Camera) sMIDOpenWithCameraID.invoke(null, new Object[]{Integer.valueOf(cameraId)});
                    this.mCameraId = cameraId;
                } else {
                    this.mCamera = Camera.open();
                    this.mCameraId = 0;
                }
                this.mCamera.setPreviewDisplay(holder);
            }
        } catch (Exception e) {
            if (this.mCamera != null) {
                this.mCamera.release();
                this.mCamera = null;
            }
        }
        if (this.mCamera == null) {
            return false;
        }
        holder.addCallback(new PreviewSurfaceCallback());
        return true;
    }

    public Camera getCamera() {
        return this.mCamera;
    }

    public int[] getSupportedFps() {
        int[] retval = new int[0];
        try {
            List<Integer> fpsVals = this.mCamera.getParameters().getSupportedPreviewFrameRates();
            retval = new int[fpsVals.size()];
            int i = 0;
            for (Integer fps : fpsVals) {
                int i2 = i + 1;
                retval[i] = fps.intValue();
                i = i2;
            }
        } catch (Exception e) {
        }
        return retval;
    }

    public int getCameraPosition() {
        int position = -1;
        if (sAreMultipleCamerasSupportedOnDevice) {
            Object cameraInfo = null;
            Field field = null;
            if (sCameraInfoClass != null) {
                try {
                    cameraInfo = sCameraInfoClass.newInstance();
                } catch (Exception e) {
                    return position;
                }
            }
            try {
                sMIDGetCameraInfo.invoke(this.mCamera, new Object[]{Integer.valueOf(this.mCameraId), cameraInfo});
                if (cameraInfo != null) {
                    try {
                        field = cameraInfo.getClass().getField("facing");
                    } catch (Exception e2) {
                        return position;
                    }
                }
                try {
                    position = field.getInt(cameraInfo);
                } catch (Exception e3) {
                    return position;
                }
            } catch (Exception e4) {
                return position;
            }
        }
        return position;
    }

    public static int getNumberOfCameras() {
        if (areMultipleCamerasSupportedOnDevice()) {
            try {
                return ((Integer) sMIDGetNumberOfCameras.invoke(null, (Object[]) null)).intValue();
            } catch (Exception e) {
            }
        }
        return 1;
    }

    public int[] getSupportedFormats() {
        int[] retval = new int[0];
        try {
            List<Integer> formatVals = this.mCamera.getParameters().getSupportedPreviewFormats();
            retval = new int[formatVals.size()];
            int i = 0;
            for (Integer format : formatVals) {
                int i2 = i + 1;
                retval[i] = format.intValue();
                i = i2;
            }
        } catch (Exception e) {
        }
        return retval;
    }

    public int[] getSupportedVideoSizes() {
        int[] retval = new int[0];
        try {
            List<Size> sizes = this.mCamera.getParameters().getSupportedPreviewSizes();
            retval = new int[(sizes.size() * 2)];
            int i = 0;
            for (Size size : sizes) {
                int i2 = i + 1;
                retval[i] = size.width;
                i = i2 + 1;
                retval[i2] = size.height;
            }
        } catch (Exception e) {
        }
        return retval;
    }

    public int getCaptureWidth() {
        try {
            return this.mCamera.getParameters().getPreviewSize().width;
        } catch (Exception e) {
            return 0;
        }
    }

    public int getCaptureHeight() {
        try {
            return this.mCamera.getParameters().getPreviewSize().height;
        } catch (Exception e) {
            return 0;
        }
    }

    public int getCaptureFormat() {
        try {
            return this.mCamera.getParameters().getPreviewFormat();
        } catch (Exception e) {
            return 0;
        }
    }

    public boolean setContinuousFocusMode() {
        if (this.mCamera == null) {
            return false;
        }
        try {
            Parameters params = this.mCamera.getParameters();
            List<String> modes = params.getSupportedFocusModes();
            if (modes.contains("continuous-video")) {
                params.setFocusMode("continuous-video");
                this.mCamera.setParameters(params);
                return true;
            } else if (!modes.contains("edof")) {
                return false;
            } else {
                params.setFocusMode("edof");
                this.mCamera.setParameters(params);
                return true;
            }
        } catch (Exception e) {
            return false;
        }
    }

    public boolean autoFocus() {
        if (this.mCamera == null || !this.mCapturing) {
            return false;
        }
        try {
            String focusMode = this.mCamera.getParameters().getFocusMode();
            if (focusMode == "fixed" || focusMode == "infinity" || focusMode == "continuous-video") {
                return false;
            }
            this.mCamera.autoFocus(null);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean startCapture(int wd, int ht, int fps, int preferredFormat) {
        if (this.mCamera == null) {
            return false;
        }
        boolean retval = false;
        try {
            Parameters parameters = this.mCamera.getParameters();
            parameters.setPreviewSize(wd, ht);
            parameters.setPreviewFrameRate(fps);
            parameters.setPreviewFormat(preferredFormat);
            this.mCamera.setParameters(parameters);
            this.mCamera.setPreviewCallbackWithBuffer(new C00231());
            this.mCamera.startPreview();
            parameters = this.mCamera.getParameters();
            int bufferSize = (parameters.getPreviewSize().width * parameters.getPreviewSize().height) * ImageFormat.getBitsPerPixel(parameters.getPreviewFormat());
            this.mBuffer1 = new byte[bufferSize];
            this.mBuffer2 = new byte[bufferSize];
            this.mCallbackBuffer = this.mBuffer1;
            this.mCamera.addCallbackBuffer(this.mCallbackBuffer);
            retval = true;
            this.mCapturing = true;
            return true;
        } catch (Exception e) {
            return retval;
        }
    }

    public void stopCapture() {
        if (this.mCamera != null) {
            this.mCamera.setPreviewCallback(null);
            this.mCamera.stopPreview();
            this.mCallbackBuffer = null;
            this.mBuffer1 = null;
            this.mBuffer2 = null;
        }
        this.mCapturing = false;
    }

    public void close() {
        if (this.mCamera != null) {
            stopCapture();
            this.mCamera.release();
            this.mCamera = null;
        }
    }

    public void registerCallbacks(boolean register) {
        this.mCallbacksRegistered = register;
        if (register) {
            if (this.mActivityStateCB == null) {
                this.mActivityStateCB = new C00242();
            }
            AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityStateChangeListner(this.mActivityStateCB);
            return;
        }
        if (this.mActivityStateCB != null) {
            AndroidActivityWrapper.GetAndroidActivityWrapper().removeActivityStateChangeListner(this.mActivityStateCB);
        }
        this.mActivityStateCB = null;
    }
}
