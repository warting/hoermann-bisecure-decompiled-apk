package com.adobe.air;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build.VERSION;
import android.os.Environment;
import android.provider.MediaStore.Images.Media;
import com.adobe.air.AndroidActivityWrapper.PlaneID;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public final class CameraUI implements ActivityResultCallback {
    public static final int ERROR_ACTIVITY_DESTROYED = 4;
    public static final int ERROR_CAMERA_BUSY = 1;
    public static final int ERROR_CAMERA_ERROR = 2;
    public static final int ERROR_CAMERA_UNAVAILABLE = 3;
    private static final String LOG_TAG = "CameraUI";
    private static final String PHONE_STORAGE = "phoneStorage";
    public static final int REQUESTED_MEDIA_TYPE_IMAGE = 1;
    public static final int REQUESTED_MEDIA_TYPE_INVALID = 0;
    public static final int REQUESTED_MEDIA_TYPE_VIDEO = 2;
    private static String sCameraRollPath = null;
    private static CameraUI sCameraUI = null;
    private boolean mCameraBusy = false;
    private String mImagePath = null;
    private long mLastClientId = 0;

    private native void nativeOnCameraCancel(long j);

    private native void nativeOnCameraError(long j, int i);

    private native void nativeOnCameraResult(long j, String str, String str2, String str3);

    private void onCameraError(int cameraErrorId) {
        if (this.mLastClientId != 0) {
            nativeOnCameraError(this.mLastClientId, cameraErrorId);
            this.mLastClientId = 0;
        }
    }

    private void onCameraCancel() {
        if (this.mLastClientId != 0) {
            nativeOnCameraCancel(this.mLastClientId);
            this.mLastClientId = 0;
        }
    }

    private void onCameraResult(String mediaUri, String mediaType, String mediaName) {
        if (this.mLastClientId != 0) {
            nativeOnCameraResult(this.mLastClientId, mediaUri, mediaType, mediaName);
            this.mLastClientId = 0;
        }
    }

    private CameraUI() {
    }

    public static synchronized CameraUI getCameraUI() {
        CameraUI cameraUI;
        synchronized (CameraUI.class) {
            if (sCameraUI == null) {
                sCameraUI = new CameraUI();
                AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityResultListener(sCameraUI);
            }
            cameraUI = sCameraUI;
        }
        return cameraUI;
    }

    public Object clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException();
    }

    public void unregisterCallbacks(long clientId) {
        if (this.mLastClientId == clientId) {
            this.mLastClientId = 0;
        }
    }

    private String toMediaType(String mimeType) {
        if (mimeType == null) {
            return null;
        }
        if (mimeType.startsWith("image/")) {
            return new String("image");
        }
        if (mimeType.startsWith("video/")) {
            return new String("video");
        }
        return null;
    }

    private File getFileFromUri(Uri uri, Activity activity) {
        Cursor cursor = getCursorFromUri(uri, activity, new String[]{"_data"});
        if (cursor == null) {
            return null;
        }
        try {
            File f = new File(cursor.getString(cursor.getColumnIndexOrThrow("_data")));
            return f;
        } catch (IllegalArgumentException e) {
            return null;
        } finally {
            cursor.close();
        }
    }

    private Cursor getCursorFromUri(Uri uri, Activity activity, String[] cursorProj) {
        int i = 1;
        Cursor cursor = null;
        int i2;
        try {
            cursor = activity.getContentResolver().query(uri, cursorProj, null, null, null);
            if (cursor.moveToFirst()) {
                if (cursor != null) {
                    i2 = 1;
                } else {
                    i2 = 0;
                }
                if (cursor.moveToFirst()) {
                    i = 0;
                }
                if ((i2 & i) == 0) {
                    return cursor;
                }
                cursor.close();
                return cursor;
            }
            cursor.close();
            if (cursor != null) {
                i2 = 1;
            } else {
                i2 = 0;
            }
            if (cursor.moveToFirst()) {
                i = 0;
            }
            if ((i2 & i) != 0) {
                cursor.close();
            }
            return null;
        } catch (Throwable th) {
            Throwable th2 = th;
            if (cursor != null) {
                i2 = 1;
            } else {
                i2 = 0;
            }
            if (cursor.moveToFirst()) {
                i = 0;
            }
            if ((i2 & i) != 0) {
                cursor.close();
            }
        }
    }

    private void processImageSuccessResult() {
        Exception e;
        String mediaType = new String("image");
        File f = new File(this.mImagePath);
        String mediaName = f.getName();
        String[] path = new String[]{this.mImagePath};
        ExifInterface exif = null;
        String orientation = "";
        try {
            exif = new ExifInterface(this.mImagePath);
        } catch (IOException e2) {
            e2.printStackTrace();
        }
        Bitmap bmap = rotateBitmap(BitmapFactory.decodeFile(this.mImagePath), Integer.parseInt(exif.getAttribute("Orientation")));
        try {
            OutputStream outputStream;
            OutputStream outStream = new FileOutputStream(f);
            if (bmap != null) {
                try {
                    bmap.compress(CompressFormat.JPEG, 100, outStream);
                } catch (Exception e3) {
                    e = e3;
                    outputStream = outStream;
                    e.printStackTrace();
                    MediaScannerConnection.scanFile(AndroidActivityWrapper.GetAndroidActivityWrapper().getDefaultContext(), path, null, null);
                    onCameraResult(this.mImagePath, mediaType, mediaName);
                }
            }
            outStream.flush();
            outStream.close();
            outputStream = outStream;
        } catch (Exception e4) {
            e = e4;
            e.printStackTrace();
            MediaScannerConnection.scanFile(AndroidActivityWrapper.GetAndroidActivityWrapper().getDefaultContext(), path, null, null);
            onCameraResult(this.mImagePath, mediaType, mediaName);
        }
        MediaScannerConnection.scanFile(AndroidActivityWrapper.GetAndroidActivityWrapper().getDefaultContext(), path, null, null);
        onCameraResult(this.mImagePath, mediaType, mediaName);
    }

    public Bitmap rotateBitmap(Bitmap bitmap, int orientation) {
        Matrix matrix = new Matrix();
        switch (orientation) {
            case 2:
                matrix.setScale(-1.0f, 1.0f);
                break;
            case 3:
                matrix.setRotate(180.0f);
                break;
            case 4:
                matrix.setRotate(180.0f);
                matrix.postScale(-1.0f, 1.0f);
                break;
            case 5:
                matrix.setRotate(90.0f);
                matrix.postScale(-1.0f, 1.0f);
                break;
            case PlaneID.PLANE_STAGE3D /*6*/:
                matrix.setRotate(90.0f);
                break;
            case PlaneID.PLANE_STAGEVIDEO /*7*/:
                matrix.setRotate(-90.0f);
                matrix.postScale(-1.0f, 1.0f);
                break;
            case 8:
                matrix.setRotate(-90.0f);
                break;
            default:
                return bitmap;
        }
        try {
            Bitmap bmRotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
            bitmap.recycle();
            return bmRotated;
        } catch (OutOfMemoryError e) {
            e.printStackTrace();
            return null;
        }
    }

    /* JADX WARNING: inconsistent code. */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void processVideoSuccessResult(android.content.Intent r15) {
        /*
        r14 = this;
        r13 = 2;
        r8 = 0;
        r6 = 0;
        r1 = 0;
        r4 = 0;
        r11 = 3;
        r10 = new java.lang.String[r11];
        r11 = 0;
        r12 = "_data";
        r10[r11] = r12;
        r11 = 1;
        r12 = "mime_type";
        r10[r11] = r12;
        r11 = "_display_name";
        r10[r13] = r11;
        r11 = r15.getData();
        r12 = com.adobe.air.AndroidActivityWrapper.GetAndroidActivityWrapper();
        r12 = r12.getActivity();
        r0 = r14.getCursorFromUri(r11, r12, r10);
        if (r0 == 0) goto L_0x0067;
    L_0x0028:
        r9 = 0;
        r7 = 0;
        r3 = 0;
        r11 = "_data";
        r9 = r0.getColumnIndexOrThrow(r11);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r11 = "mime_type";
        r7 = r0.getColumnIndexOrThrow(r11);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r11 = "_display_name";
        r3 = r0.getColumnIndexOrThrow(r11);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r8 = r0.getString(r9);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        if (r8 == 0) goto L_0x0063;
    L_0x0043:
        r6 = r0.getString(r7);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r4 = r14.toMediaType(r6);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        if (r4 != 0) goto L_0x0055;
    L_0x004d:
        r5 = new java.lang.String;	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r11 = "video";
        r5.<init>(r11);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r4 = r5;
    L_0x0055:
        r1 = r0.getString(r3);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        if (r1 != 0) goto L_0x0063;
    L_0x005b:
        r2 = new java.lang.String;	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r11 = "";
        r2.<init>(r11);	 Catch:{ IllegalArgumentException -> 0x007d, all -> 0x0083 }
        r1 = r2;
    L_0x0063:
        r0.close();
        r0 = 0;
    L_0x0067:
        if (r4 == 0) goto L_0x0071;
    L_0x0069:
        r11 = "image";
        r11 = r4.equals(r11);
        if (r11 != 0) goto L_0x0079;
    L_0x0071:
        r11 = "video";
        r11 = r4.equals(r11);
        if (r11 == 0) goto L_0x0089;
    L_0x0079:
        r14.onCameraResult(r8, r4, r1);
    L_0x007c:
        return;
    L_0x007d:
        r11 = move-exception;
        r0.close();
        r0 = 0;
        goto L_0x0067;
    L_0x0083:
        r11 = move-exception;
        r0.close();
        r0 = 0;
        throw r11;
    L_0x0089:
        r14.onCameraError(r13);
        goto L_0x007c;
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.CameraUI.processVideoSuccessResult(android.content.Intent):void");
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 3 || requestCode == 4) {
            this.mCameraBusy = false;
            if (this.mLastClientId != 0) {
                switch (resultCode) {
                    case -1:
                        if (requestCode == 3) {
                            if (this.mImagePath != null) {
                                processImageSuccessResult();
                                this.mImagePath = null;
                                return;
                            }
                            onCameraCancel();
                            return;
                        } else if (requestCode == 4) {
                            processVideoSuccessResult(data);
                            return;
                        } else {
                            return;
                        }
                    case 0:
                        if (this.mImagePath != null) {
                            this.mImagePath = null;
                        }
                        onCameraCancel();
                        return;
                    default:
                        if (this.mImagePath != null) {
                            this.mImagePath = null;
                        }
                        onCameraError(2);
                        return;
                }
            }
        }
    }

    public void launch(long clientId, int requestedMediaType) {
        if (clientId != 0) {
            if (this.mCameraBusy) {
                nativeOnCameraError(clientId, 1);
                return;
            }
            int cameraResult;
            if (this.mLastClientId != 0) {
                onCameraError(1);
            }
            this.mLastClientId = clientId;
            this.mCameraBusy = true;
            switch (requestedMediaType) {
                case 1:
                    cameraResult = stillPictureWork();
                    break;
                case 2:
                    cameraResult = videoCaptureWork();
                    break;
                default:
                    cameraResult = 3;
                    break;
            }
            if (cameraResult != 0) {
                this.mCameraBusy = false;
                onCameraError(cameraResult);
            }
        }
    }

    private int videoCaptureWork() {
        try {
            Activity activity = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
            if (activity == null) {
                return 4;
            }
            Intent intent = new Intent("android.media.action.VIDEO_CAPTURE");
            intent.putExtra("android.intent.extra.videoQuality", 0);
            activity.startActivityForResult(intent, 4);
            return 0;
        } catch (ActivityNotFoundException e) {
            return 3;
        }
    }

    private String getCameraRollDirectory(Activity activity) {
        if (sCameraRollPath != null) {
            return sCameraRollPath;
        }
        Uri imageUri = null;
        if (imageUri == null) {
            try {
                imageUri = activity.getContentResolver().insert(Media.INTERNAL_CONTENT_URI, new ContentValues());
            } catch (Exception e) {
            }
        }
        if (imageUri == null) {
            try {
                imageUri = activity.getContentResolver().insert(Media.getContentUri(PHONE_STORAGE), new ContentValues());
            } catch (Exception e2) {
            }
        }
        if (imageUri != null) {
            try {
                sCameraRollPath = getFileFromUri(imageUri, activity).getParent();
            } catch (ActivityNotFoundException e3) {
            } catch (NullPointerException e4) {
            } finally {
                activity.getContentResolver().delete(imageUri, null, null);
            }
        } else {
            File pictureFolderPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
            if (pictureFolderPath.exists()) {
                sCameraRollPath = pictureFolderPath.toString();
            }
        }
        return sCameraRollPath;
    }

    private int stillPictureWork() {
        int rv = 0;
        Activity activity = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
        if (activity == null) {
            return 4;
        }
        if ((AndroidActivityWrapper.GetAndroidActivityWrapper().GetTargetSdkVersion() < 23 || VERSION.SDK_INT < 23) && getCameraRollDirectory(activity) == null) {
            return 2;
        }
        File checkFile;
        String fileName = new SimpleDateFormat("'IMG'_yyyyMMdd_HHmmss").format(new Date(System.currentTimeMillis()));
        String checkPath = null;
        if (AndroidActivityWrapper.GetAndroidActivityWrapper().GetTargetSdkVersion() < 23 || VERSION.SDK_INT < 23) {
            checkPath = getCameraRollDirectory(activity) + "/" + fileName + ".jpg";
            checkFile = new File(checkPath);
            if (checkFile.exists()) {
                checkFile = null;
            }
        } else {
            File storageDir = new File(activity.getCacheDir(), "Pictures");
            if (!storageDir.exists()) {
                storageDir.mkdirs();
            }
            try {
                checkFile = File.createTempFile(fileName, ".jpg", storageDir);
                checkPath = checkFile.getAbsolutePath();
            } catch (IOException e) {
                checkFile = null;
            }
        }
        if (checkFile == null) {
            return 2;
        }
        try {
            Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
            if (AndroidActivityWrapper.GetAndroidActivityWrapper().GetTargetSdkVersion() < 23 || VERSION.SDK_INT < 23) {
                intent.putExtra("output", Uri.fromFile(checkFile));
            } else {
                Uri photoURI = null;
                try {
                    photoURI = CameraUIProvider.getUriForFile(activity, activity.getPackageName() + ".provider", checkFile);
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
                intent.putExtra("output", photoURI);
                intent.setFlags(2);
            }
            activity.startActivityForResult(intent, 3);
        } catch (ActivityNotFoundException e3) {
            rv = 3;
            checkPath = null;
        } catch (NullPointerException e4) {
            rv = 2;
            checkPath = null;
        }
        this.mImagePath = checkPath;
        return rv;
    }
}
