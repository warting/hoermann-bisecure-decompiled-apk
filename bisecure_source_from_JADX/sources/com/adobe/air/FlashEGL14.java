package com.adobe.air;

import android.app.Activity;
import android.opengl.EGL14;
import android.opengl.EGLConfig;
import android.opengl.EGLContext;
import android.opengl.EGLDisplay;
import android.opengl.EGLSurface;
import android.opengl.GLES10;
import android.os.Build;
import android.os.Build.VERSION;
import android.view.SurfaceView;
import com.adobe.flashruntime.air.VideoViewAIR;
import java.util.Scanner;

public class FlashEGL14 implements FlashEGL {
    private static int EGL_BUFFER_DESTROYED = 12437;
    private static int EGL_BUFFER_PRESERVED = 12436;
    private static int EGL_CONTEXT_CLIENT_VERSION = 12440;
    private static int EGL_COVERAGE_BUFFERS_NV = 12512;
    private static int EGL_COVERAGE_SAMPLES_NV = 12513;
    private static int EGL_OPENGL_ES2_BIT = 4;
    private static int EGL_SWAP_BEHAVIOR = 12435;
    private static final int MAX_CONFIGS = 100;
    private static String TAG = "FlashEGL14";
    private static int[] cfgAttrs = new int[]{12339, -1, 12325, -1, 12326, -1, 12352, EGL_OPENGL_ES2_BIT, 12344};
    private static int[] fbPBufferSurfaceAttrs = new int[]{12375, 64, 12374, 64, 12344};
    private static int[] fbWindowSurfaceDefAttrs = new int[]{12344};
    private static int[] fbWindowSurfaceOffAttrs = new int[]{EGL_SWAP_BEHAVIOR, EGL_BUFFER_DESTROYED, 12344};
    private static int[] fbWindowSurfaceOnAttrs = new int[]{EGL_SWAP_BEHAVIOR, EGL_BUFFER_PRESERVED, 12344};
    private int kAlphaBits = 5;
    private int kBlueBits = 4;
    private int kColorBits = 6;
    private int kConfigId = 1;
    private int kCsaaSamp = 10;
    private int kDepthBits = 7;
    private int kGreenBits = 3;
    private int kMsaaSamp = 9;
    private int kNumElements = 12;
    private int kRedBits = 2;
    private int kStencilBits = 8;
    private int kSurfaceTypes = 0;
    private int kSwapPreserve = 11;
    private int kSwapPreserveDefault = 0;
    private int kSwapPreserveOff = 2;
    private int kSwapPreserveOn = 1;
    private EGL14 mEgl = null;
    private EGLConfig mEglConfig = null;
    private int mEglConfigCount = 0;
    private EGLConfig[] mEglConfigList = null;
    volatile EGLContext mEglContext = EGL14.EGL_NO_CONTEXT;
    private EGLDisplay mEglDisplay = EGL14.EGL_NO_DISPLAY;
    private EGLSurface mEglPbufferSurface = EGL14.EGL_NO_SURFACE;
    private EGLSurface mEglSurface = EGL14.EGL_NO_SURFACE;
    private int[] mEglVersion = null;
    private EGLSurface mEglWindowSurface = EGL14.EGL_NO_SURFACE;
    private boolean mIsARGBSurface = false;
    private boolean mIsBufferPreserve = false;
    private boolean mIsES3Device = false;
    private boolean mIsGPUOOM = false;
    private int mPbufferConfigCount = 0;
    private int mPixmapConfigCount = 0;
    private int mWindowConfigCount = 0;

    public void FlashEGL14() {
        this.mEgl = null;
        this.mEglDisplay = EGL14.EGL_NO_DISPLAY;
        this.mEglConfig = null;
        this.mEglContext = EGL14.EGL_NO_CONTEXT;
        this.mEglSurface = EGL14.EGL_NO_SURFACE;
        this.mEglWindowSurface = EGL14.EGL_NO_SURFACE;
        this.mEglPbufferSurface = EGL14.EGL_NO_SURFACE;
        this.mIsARGBSurface = false;
    }

    private int XX(int i, int a) {
        return (this.kNumElements * i) + a;
    }

    public boolean HasGLContext() {
        return this.mEglContext != EGL14.EGL_NO_CONTEXT;
    }

    public int GetSurfaceWidth() {
        int[] w = new int[1];
        EGL14 egl14 = this.mEgl;
        EGL14.eglQuerySurface(this.mEglDisplay, this.mEglSurface, 12375, w, 0);
        return w[0];
    }

    public int GetSurfaceHeight() {
        int[] h = new int[1];
        EGL14 egl14 = this.mEgl;
        EGL14.eglQuerySurface(this.mEglDisplay, this.mEglSurface, 12374, h, 0);
        return h[0];
    }

    public boolean IsEmulator() {
        return Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic");
    }

    public boolean ChooseConfig(EGLDisplay display, int[] attrs, EGLConfig[] configs, int configsLen, int[] numConfig) {
        EGL14 egl14;
        if (IsEmulator()) {
            int[] numConf = new int[1];
            egl14 = this.mEgl;
            EGL14.eglGetConfigs(display, null, 0, 0, numConf, 0);
            int configurations = numConf[0];
            EGLConfig[] conf = new EGLConfig[configurations];
            egl14 = this.mEgl;
            EGL14.eglGetConfigs(display, conf, 0, configurations, numConf, 0);
            int count = 0;
            int attrsLen = attrs.length;
            if (attrs.length % 2 != 0) {
                attrsLen = attrs.length - 1;
            }
            for (int index = 0; index < configurations; index++) {
                int len = 0;
                while (len < attrsLen) {
                    if (attrs[len + 1] != -1) {
                        int[] attribVal = new int[1];
                        egl14 = this.mEgl;
                        EGL14.eglGetConfigAttrib(display, conf[index], attrs[len], attribVal, 0);
                        if ((attribVal[0] & attrs[len + 1]) != attrs[len + 1]) {
                            break;
                        }
                    }
                    len += 2;
                }
                if (len == attrsLen) {
                    if (configs != null && count < configsLen) {
                        configs[count] = conf[index];
                    }
                    count++;
                }
            }
            numConfig[0] = count;
            return true;
        }
        egl14 = this.mEgl;
        return EGL14.eglChooseConfig(display, attrs, 0, configs, 0, configsLen, numConfig, 0);
    }

    public int[] GetNumConfigs() {
        int[] arr = new int[4];
        int[] num_config = new int[1];
        EGLConfig[] configList = new EGLConfig[100];
        ChooseConfig(this.mEglDisplay, cfgAttrs, configList, 100, num_config);
        int i = num_config[0];
        arr[0] = i;
        this.mEglConfigCount = i;
        cfgAttrs[1] = 4;
        ChooseConfig(this.mEglDisplay, cfgAttrs, configList, 100, num_config);
        i = num_config[0];
        arr[1] = i;
        this.mWindowConfigCount = i;
        cfgAttrs[1] = 2;
        ChooseConfig(this.mEglDisplay, cfgAttrs, configList, 100, num_config);
        i = num_config[0];
        arr[2] = i;
        this.mPixmapConfigCount = i;
        cfgAttrs[1] = 1;
        ChooseConfig(this.mEglDisplay, cfgAttrs, configList, 100, num_config);
        int i2 = num_config[0];
        arr[3] = i2;
        this.mPbufferConfigCount = i2;
        cfgAttrs[1] = -1;
        return arr;
    }

    public int[] GetConfigs(boolean hasEglNvCoverageSample, boolean isEglVersion_1_4) {
        int[] arr = new int[(this.mEglConfigCount * this.kNumElements)];
        int[] num_config = new int[1];
        int[] retVal = new int[1];
        this.mEglConfigList = new EGLConfig[this.mEglConfigCount];
        checkEglError("Before eglChooseConfig");
        ChooseConfig(this.mEglDisplay, cfgAttrs, this.mEglConfigList, this.mEglConfigCount, num_config);
        checkEglError("After eglChooseConfig");
        int max = num_config[0];
        this.mEglConfigCount = max;
        int i = 0;
        while (i < max) {
            EGL14 egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12339, retVal, 0);
            arr[XX(i, this.kSurfaceTypes)] = retVal[0];
            arr[XX(i, this.kConfigId)] = i;
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12324, retVal, 0);
            arr[XX(i, this.kRedBits)] = retVal[0];
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12323, retVal, 0);
            arr[XX(i, this.kGreenBits)] = retVal[0];
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12322, retVal, 0);
            arr[XX(i, this.kBlueBits)] = retVal[0];
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12321, retVal, 0);
            arr[XX(i, this.kAlphaBits)] = retVal[0];
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12320, retVal, 0);
            arr[XX(i, this.kColorBits)] = retVal[0];
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12325, retVal, 0);
            arr[XX(i, this.kDepthBits)] = retVal[0];
            egl14 = this.mEgl;
            EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12326, retVal, 0);
            arr[XX(i, this.kStencilBits)] = retVal[0];
            arr[XX(i, this.kCsaaSamp)] = 0;
            arr[XX(i, this.kMsaaSamp)] = 0;
            if (hasEglNvCoverageSample) {
                egl14 = this.mEgl;
                EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], EGL_COVERAGE_SAMPLES_NV, retVal, 0);
                if (retVal[0] != 1) {
                    arr[XX(i, this.kCsaaSamp)] = retVal[0];
                }
            } else {
                egl14 = this.mEgl;
                EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfigList[i], 12337, retVal, 0);
                if (retVal[0] != 1) {
                    arr[XX(i, this.kMsaaSamp)] = retVal[0];
                }
            }
            if (isEglVersion_1_4) {
                int i2;
                int XX = XX(i, this.kSwapPreserve);
                if ((this.mEglVersion[0] > 1 || this.mEglVersion[1] > 3) && (arr[XX(i, this.kSurfaceTypes)] & EGL_BUFFER_PRESERVED) != 0) {
                    i2 = 1;
                } else {
                    i2 = 0;
                }
                arr[XX] = i2;
            } else {
                arr[XX(i, this.kSwapPreserve)] = 0;
            }
            i++;
        }
        return arr;
    }

    public void SetConfig(int index) {
        this.mEglConfig = this.mEglConfigList[index];
        int[] retVal = new int[1];
        EGL14 egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12324, retVal, 0);
        int red = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12323, retVal, 0);
        int green = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12322, retVal, 0);
        int blue = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12321, retVal, 0);
        int alpha = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12325, retVal, 0);
        int depth = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12326, retVal, 0);
        int stencil = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12337, retVal, 0);
        int samples = retVal[0];
        egl14 = this.mEgl;
        EGL14.eglGetConfigAttrib(this.mEglDisplay, this.mEglConfig, 12338, retVal, 0);
        int buffers = retVal[0];
    }

    public int CreateDummySurfaceAndContext() {
        if (this.mEglDisplay == EGL14.EGL_NO_DISPLAY) {
            return 12296;
        }
        EGL14 egl14;
        if (this.mEglContext != EGL14.EGL_NO_CONTEXT) {
            if (this.mEglWindowSurface != EGL14.EGL_NO_SURFACE) {
                egl14 = this.mEgl;
                EGL14.eglMakeCurrent(this.mEglDisplay, this.mEglWindowSurface, this.mEglWindowSurface, this.mEglContext);
                return 12288;
            } else if (this.mEglPbufferSurface != EGL14.EGL_NO_SURFACE) {
                egl14 = this.mEgl;
                EGL14.eglMakeCurrent(this.mEglDisplay, this.mEglPbufferSurface, this.mEglPbufferSurface, this.mEglContext);
                return 12288;
            } else {
                egl14 = this.mEgl;
                EGL14.eglMakeCurrent(this.mEglDisplay, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_CONTEXT);
                egl14 = this.mEgl;
                EGL14.eglDestroyContext(this.mEglDisplay, this.mEglContext);
                this.mEglContext = EGL14.EGL_NO_CONTEXT;
            }
        }
        int[] num_config = new int[1];
        EGLConfig[] configList = new EGLConfig[]{1};
        ChooseConfig(this.mEglDisplay, cfgAttrs, configList, 1, num_config);
        cfgAttrs[1] = -1;
        if (num_config[0] == 0) {
            return 12294;
        }
        int[] attrib_list = new int[]{EGL_CONTEXT_CLIENT_VERSION, 2, 12344};
        boolean ES3available = false;
        if (VERSION.SDK_INT >= 18) {
            egl14 = this.mEgl;
            this.mEglContext = EGL14.eglCreateContext(this.mEglDisplay, configList[0], EGL14.EGL_NO_CONTEXT, attrib_list, 0);
            if (this.mEglContext == EGL14.EGL_NO_CONTEXT) {
                return 12294;
            }
            checkEglError("After creating dummy context for checking gl version");
            egl14 = this.mEgl;
            EGLSurface mEglPbufferSurface = EGL14.eglCreatePbufferSurface(this.mEglDisplay, configList[0], fbPBufferSurfaceAttrs, 0);
            checkEglError("After eglCreatePbufferSurface for checking gl version");
            if (mEglPbufferSurface == EGL14.EGL_NO_SURFACE) {
                return 12294;
            }
            egl14 = this.mEgl;
            EGL14.eglMakeCurrent(this.mEglDisplay, mEglPbufferSurface, mEglPbufferSurface, this.mEglContext);
            checkEglError("After eglMakeCurrent for checking gl version");
            String strGLVersion = GLES10.glGetString(7938);
            int mOpenGLVersionMajor = 0;
            if (strGLVersion != null) {
                Scanner scanner = new Scanner(strGLVersion);
                scanner.useDelimiter("[^\\w']+");
                while (scanner.hasNext()) {
                    if (scanner.hasNextInt()) {
                        mOpenGLVersionMajor = scanner.nextInt();
                        break;
                    } else if (scanner.hasNext()) {
                        scanner.next();
                    }
                }
            }
            if (mOpenGLVersionMajor >= 3) {
                ES3available = true;
            }
            egl14 = this.mEgl;
            EGL14.eglMakeCurrent(this.mEglDisplay, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_CONTEXT);
            egl14 = this.mEgl;
            EGL14.eglDestroySurface(this.mEglDisplay, mEglPbufferSurface);
            egl14 = this.mEgl;
            EGL14.eglDestroyContext(this.mEglDisplay, this.mEglContext);
            this.mEglContext = EGL14.EGL_NO_CONTEXT;
        }
        if (ES3available) {
            attrib_list[1] = 3;
            checkEglError("Before eglCreateContext es3");
            egl14 = this.mEgl;
            this.mEglContext = EGL14.eglCreateContext(this.mEglDisplay, configList[0], EGL14.EGL_NO_CONTEXT, attrib_list, 0);
            checkEglError("After eglCreateContext es3");
            if (this.mEglContext != EGL14.EGL_NO_CONTEXT) {
                this.mIsES3Device = true;
            }
        }
        if (this.mEglContext == EGL14.EGL_NO_CONTEXT) {
            attrib_list[1] = 2;
            checkEglError("Before eglCreateContext es2");
            egl14 = this.mEgl;
            this.mEglContext = EGL14.eglCreateContext(this.mEglDisplay, configList[0], EGL14.EGL_NO_CONTEXT, attrib_list, 0);
            checkEglError("After eglCreateContext es2");
            if (this.mEglContext == EGL14.EGL_NO_CONTEXT) {
                return 12294;
            }
        }
        checkEglError("Before eglCreatePbufferSurface");
        egl14 = this.mEgl;
        this.mEglPbufferSurface = EGL14.eglCreatePbufferSurface(this.mEglDisplay, configList[0], fbPBufferSurfaceAttrs, 0);
        checkEglError("After eglCreatePbufferSurface");
        if (this.mEglPbufferSurface == EGL14.EGL_NO_SURFACE) {
            return 12294;
        }
        checkEglError("Before eglMakeCurrent");
        egl14 = this.mEgl;
        EGL14.eglMakeCurrent(this.mEglDisplay, this.mEglPbufferSurface, this.mEglPbufferSurface, this.mEglContext);
        checkEglError("After eglMakeCurrent");
        return 12288;
    }

    public int InitEGL() {
        if (this.mEglContext != EGL14.EGL_NO_CONTEXT) {
            return 12288;
        }
        this.mEgl = new EGL14();
        checkEglError("Before eglGetDisplay");
        EGL14 egl14 = this.mEgl;
        this.mEglDisplay = EGL14.eglGetDisplay(0);
        int eglError = checkEglError("After eglGetDisplay");
        if (12288 != eglError) {
            return eglError;
        }
        this.mEglVersion = new int[2];
        checkEglError("Before eglInitialize");
        egl14 = this.mEgl;
        EGL14.eglInitialize(this.mEglDisplay, this.mEglVersion, 0, this.mEglVersion, 1);
        eglError = checkEglError("After eglInitialize");
        if (12288 == eglError) {
            return 12288;
        }
        return eglError;
    }

    public boolean DestroyGLContext() {
        if (this.mEglContext == EGL14.EGL_NO_CONTEXT || this.mEglDisplay == EGL14.EGL_NO_DISPLAY) {
            return false;
        }
        checkEglError("DestroyGLContext: Before eglMakeCurrent for noSurface");
        EGL14 egl14 = this.mEgl;
        EGL14.eglMakeCurrent(this.mEglDisplay, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_CONTEXT);
        checkEglError("DestroyGLContext: After eglMakeCurrent");
        if (this.mEglPbufferSurface != EGL14.EGL_NO_SURFACE) {
            egl14 = this.mEgl;
            EGL14.eglDestroySurface(this.mEglDisplay, this.mEglPbufferSurface);
            this.mEglPbufferSurface = EGL14.EGL_NO_SURFACE;
        }
        checkEglError("Before eglDestroyContext");
        egl14 = this.mEgl;
        boolean result = EGL14.eglDestroyContext(this.mEglDisplay, this.mEglContext);
        checkEglError("After eglDestroyContext");
        this.mEglContext = EGL14.EGL_NO_CONTEXT;
        return result;
    }

    public int CreateGLContext(boolean replace) {
        if (this.mEglConfig == null) {
            return 12293;
        }
        if (this.mEglContext != EGL14.EGL_NO_CONTEXT && !replace) {
            return 12288;
        }
        int glVersion;
        EGL14 egl14;
        if (this.mIsES3Device) {
            glVersion = 3;
        } else {
            glVersion = 2;
        }
        int[] attrib_list = new int[]{EGL_CONTEXT_CLIENT_VERSION, glVersion, 12344};
        if (replace) {
            EGLContext oldContext = this.mEglContext;
            checkEglError("Before eglCreateContext");
            egl14 = this.mEgl;
            this.mEglContext = EGL14.eglCreateContext(this.mEglDisplay, this.mEglConfig, oldContext, attrib_list, 0);
            checkEglError("After eglCreateContext");
            egl14 = this.mEgl;
            EGL14.eglDestroyContext(this.mEglDisplay, oldContext);
            checkEglError("After eglDestroyContext");
        } else {
            checkEglError("Before eglCreateContext");
            egl14 = this.mEgl;
            this.mEglContext = EGL14.eglCreateContext(this.mEglDisplay, this.mEglConfig, EGL14.EGL_NO_CONTEXT, attrib_list, 0);
            checkEglError("After eglCreateContext");
        }
        if (this.mEglContext == EGL14.EGL_NO_CONTEXT) {
            return 12294;
        }
        if (EGL14.EGL_NO_SURFACE == this.mEglPbufferSurface) {
            checkEglError("Before eglCreatePbufferSurface");
            egl14 = this.mEgl;
            this.mEglPbufferSurface = EGL14.eglCreatePbufferSurface(this.mEglDisplay, this.mEglConfig, fbPBufferSurfaceAttrs, 0);
            checkEglError("After eglCreatePbufferSurface");
        }
        return 12288;
    }

    public void TerminateEGL() {
        if (!(this.mEgl == null || this.mEglDisplay == EGL14.EGL_NO_DISPLAY)) {
            EGL14 egl14 = this.mEgl;
            EGL14.eglTerminate(this.mEglDisplay);
        }
        this.mEglDisplay = EGL14.EGL_NO_DISPLAY;
    }

    public void ReleaseGPUResources() {
        if (this.mEglContext != EGL14.EGL_NO_CONTEXT) {
            checkEglError("Before eglMakeCurrent");
            EGL14 egl14 = this.mEgl;
            EGL14.eglMakeCurrent(this.mEglDisplay, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_CONTEXT);
            checkEglError("After eglMakeCurrent");
            synchronized (this.mEgl) {
                checkEglError("Before eglDestroySurface");
                if (this.mEglWindowSurface != EGL14.EGL_NO_SURFACE) {
                    egl14 = this.mEgl;
                    EGL14.eglDestroySurface(this.mEglDisplay, this.mEglWindowSurface);
                    this.mEglWindowSurface = EGL14.EGL_NO_SURFACE;
                }
                checkEglError("After eglDestroySurface (window)");
            }
            if (this.mEglPbufferSurface != EGL14.EGL_NO_SURFACE) {
                checkEglError("Before eglDestroySurface (pbuffer)");
                egl14 = this.mEgl;
                EGL14.eglDestroySurface(this.mEglDisplay, this.mEglPbufferSurface);
                checkEglError("After eglDestroySurface (pbuffer)");
                this.mEglPbufferSurface = EGL14.EGL_NO_SURFACE;
            }
            checkEglError("Before eglDestroyContext");
            egl14 = this.mEgl;
            EGL14.eglDestroyContext(this.mEglDisplay, this.mEglContext);
            checkEglError("After eglDestroyContext");
            this.mEglContext = EGL14.EGL_NO_CONTEXT;
            this.mEglSurface = EGL14.EGL_NO_SURFACE;
        }
    }

    public void SwapEGLBuffers() {
        if (12288 == MakeGLCurrent()) {
            checkEglError("Before eglSwapBuffers");
            EGL14 egl14 = this.mEgl;
            EGL14.eglSwapBuffers(this.mEglDisplay, this.mEglSurface);
            checkEglError("After eglSwapBuffers");
        }
    }

    public int MakeGLCurrent() {
        if (this.mEglContext == EGL14.EGL_NO_CONTEXT) {
            return 12294;
        }
        if (this.mEglSurface == EGL14.EGL_NO_SURFACE) {
            return 12301;
        }
        if (this.mEglDisplay == EGL14.EGL_NO_DISPLAY) {
            return 12296;
        }
        checkEglError("Before eglMakeCurrent");
        EGL14 egl14 = this.mEgl;
        EGL14.eglMakeCurrent(this.mEglDisplay, this.mEglSurface, this.mEglSurface, this.mEglContext);
        return checkEglError("After eglMakeCurrent");
    }

    public int CreateWindowSurface(SurfaceView view, int swapPreserveBehavior) {
        if (this.mIsGPUOOM) {
            return 12291;
        }
        boolean isAIRWindowSurfaceView = view instanceof AIRWindowSurfaceView;
        if (!(view instanceof VideoViewAIR) && !(view instanceof AIRStage3DSurfaceView) && !isAIRWindowSurfaceView) {
            return 12301;
        }
        if (this.mEglWindowSurface != EGL14.EGL_NO_SURFACE) {
            this.mEglSurface = this.mEglWindowSurface;
            return MakeGLCurrent();
        }
        EGL14 egl14;
        boolean checkSwapPreserve = true;
        if (swapPreserveBehavior == this.kSwapPreserveOn) {
            checkEglError("Before eglCreateWindowSurface");
            egl14 = this.mEgl;
            this.mEglWindowSurface = EGL14.eglCreateWindowSurface(this.mEglDisplay, this.mEglConfig, view.getHolder(), fbWindowSurfaceOnAttrs, 0);
            if (this.mEglWindowSurface == EGL14.EGL_NO_SURFACE) {
                checkEglError("After eglCreateWindowSurface");
                checkSwapPreserve = false;
            }
        } else if (swapPreserveBehavior == this.kSwapPreserveOff) {
            checkEglError("Before eglCreateWindowSurface");
            egl14 = this.mEgl;
            this.mEglWindowSurface = EGL14.eglCreateWindowSurface(this.mEglDisplay, this.mEglConfig, view.getHolder(), fbWindowSurfaceOffAttrs, 0);
            if (this.mEglWindowSurface == EGL14.EGL_NO_SURFACE) {
                checkEglError("After eglCreateWindowSurface");
                checkSwapPreserve = false;
            }
        }
        if (this.mEglWindowSurface == EGL14.EGL_NO_SURFACE) {
            checkEglError("Before eglCreateWindowSurface");
            egl14 = this.mEgl;
            this.mEglWindowSurface = EGL14.eglCreateWindowSurface(this.mEglDisplay, this.mEglConfig, view.getHolder(), fbWindowSurfaceDefAttrs, 0);
            int error = checkEglError("After eglCreateWindowSurface");
            if (error != 12288) {
                return error;
            }
            checkSwapPreserve = true;
        }
        if (this.mEglWindowSurface == EGL14.EGL_NO_SURFACE) {
            return 12301;
        }
        this.mEglSurface = this.mEglWindowSurface;
        if (isAIRWindowSurfaceView) {
            ((AIRWindowSurfaceView) view).setFlashEGL(this);
            Activity main_activity = ((AIRWindowSurfaceView) view).getActivityWrapper().getActivity();
            if (main_activity != null) {
                main_activity.getWindow().setSoftInputMode(34);
            }
        }
        int[] swapBehavior = new int[]{0};
        this.mIsBufferPreserve = false;
        if (checkSwapPreserve) {
            EGL14 egl142 = this.mEgl;
            if (EGL14.eglQuerySurface(this.mEglDisplay, this.mEglSurface, EGL_SWAP_BEHAVIOR, swapBehavior, 0)) {
                this.mIsBufferPreserve = swapBehavior[0] == EGL_BUFFER_PRESERVED;
            }
        }
        return MakeGLCurrent();
    }

    public boolean DestroyWindowSurface() {
        if (this.mEglWindowSurface == EGL14.EGL_NO_SURFACE) {
            return false;
        }
        checkEglError("Before eglMakeCurrent");
        EGL14 egl14 = this.mEgl;
        EGL14.eglMakeCurrent(this.mEglDisplay, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_SURFACE, EGL14.EGL_NO_CONTEXT);
        if (12288 != checkEglError("After eglMakeCurrent")) {
            return false;
        }
        checkEglError("Before eglDestroySurface (window)");
        egl14 = this.mEgl;
        EGL14.eglDestroySurface(this.mEglDisplay, this.mEglWindowSurface);
        if (12288 != checkEglError("After eglDestroySurface (window)")) {
            return false;
        }
        if (this.mEglSurface == this.mEglWindowSurface) {
            this.mEglSurface = EGL14.EGL_NO_SURFACE;
        }
        this.mEglWindowSurface = EGL14.EGL_NO_SURFACE;
        if (!(this.mEglPbufferSurface == EGL14.EGL_NO_SURFACE || this.mEglContext == EGL14.EGL_NO_CONTEXT)) {
            this.mEglSurface = this.mEglPbufferSurface;
            egl14 = this.mEgl;
            EGL14.eglMakeCurrent(this.mEglDisplay, this.mEglSurface, this.mEglSurface, this.mEglContext);
            if (12288 != checkEglError("After eglMakeCurrent")) {
                return false;
            }
        }
        return true;
    }

    public boolean IsARGBSurface() {
        return this.mIsARGBSurface;
    }

    public boolean IsBufferPreserve() {
        return this.mIsBufferPreserve;
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private int checkEglError(java.lang.String r8) {
        /*
        r7 = this;
        r6 = 12288; // 0x3000 float:1.7219E-41 double:6.071E-320;
        r2 = r7.mEgl;
        r1 = android.opengl.EGL14.eglGetError();
        if (r1 == r6) goto L_0x0072;
    L_0x000a:
        r2 = r7.mIsGPUOOM;
        if (r2 != 0) goto L_0x0072;
    L_0x000e:
        r2 = 12291; // 0x3003 float:1.7223E-41 double:6.0726E-320;
        if (r1 != r2) goto L_0x0072;
    L_0x0012:
        r2 = r7.mEglWindowSurface;
        r3 = android.opengl.EGL14.EGL_NO_SURFACE;
        if (r2 == r3) goto L_0x004a;
    L_0x0018:
        r2 = r7.mEgl;
        r2 = r7.mEglDisplay;
        r3 = r7.mEglWindowSurface;
        android.opengl.EGL14.eglDestroySurface(r2, r3);
        r2 = r7.mEgl;
        r0 = android.opengl.EGL14.eglGetError();
        r2 = android.opengl.EGL14.EGL_NO_SURFACE;
        r7.mEglWindowSurface = r2;
        r2 = android.opengl.EGL14.EGL_NO_SURFACE;
        r7.mEglSurface = r2;
        if (r0 == r6) goto L_0x0031;
    L_0x0031:
        r2 = android.opengl.EGL14.EGL_NO_SURFACE;
        r7.mEglWindowSurface = r2;
        r2 = r7.mEgl;
        r2 = r7.mEglDisplay;
        r3 = android.opengl.EGL14.EGL_NO_SURFACE;
        r4 = android.opengl.EGL14.EGL_NO_SURFACE;
        r5 = android.opengl.EGL14.EGL_NO_CONTEXT;
        android.opengl.EGL14.eglMakeCurrent(r2, r3, r4, r5);
        r2 = r7.mEgl;
        r0 = android.opengl.EGL14.eglGetError();
        if (r0 == r6) goto L_0x004a;
    L_0x004a:
        r2 = r7.mEglPbufferSurface;
        r3 = android.opengl.EGL14.EGL_NO_SURFACE;
        if (r2 == r3) goto L_0x006f;
    L_0x0050:
        r2 = r7.mEglContext;
        r3 = android.opengl.EGL14.EGL_NO_CONTEXT;
        if (r2 == r3) goto L_0x006f;
    L_0x0056:
        r2 = r7.mEglPbufferSurface;
        r7.mEglSurface = r2;
        r2 = r7.mEgl;
        r2 = r7.mEglDisplay;
        r3 = r7.mEglSurface;
        r4 = r7.mEglSurface;
        r5 = r7.mEglContext;
        android.opengl.EGL14.eglMakeCurrent(r2, r3, r4, r5);
        r2 = r7.mEgl;
        r0 = android.opengl.EGL14.eglGetError();
        if (r0 == r6) goto L_0x006f;
    L_0x006f:
        r2 = 1;
        r7.mIsGPUOOM = r2;
    L_0x0072:
        return r1;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.FlashEGL14.checkEglError(java.lang.String):int");
    }
}
