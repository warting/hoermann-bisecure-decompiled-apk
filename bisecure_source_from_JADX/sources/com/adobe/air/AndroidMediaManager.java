package com.adobe.air;

import android.app.Activity;
import android.app.Application;
import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.ContentUris;
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
import android.provider.MediaStore.Images.Media;
import android.provider.MediaStore.Images.Thumbnails;
import com.adobe.air.AndroidActivityWrapper.PlaneID;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

public class AndroidMediaManager {
    public static final int ERROR_ACTIVITY_DESTROYED = 2;
    public static final int ERROR_IMAGE_PICKER_NOT_FOUND = 1;
    private static long MediaManagerObjectPointer = 0;
    private static final String PHONE_STORAGE = "phoneStorage";
    private ActivityResultCallback mActivityResultCB = null;
    private boolean mCallbacksRegistered = false;

    /* renamed from: com.adobe.air.AndroidMediaManager$1 */
    class C00271 implements ActivityResultCallback {
        C00271() {
        }

        public void onActivityResult(int requestCode, int resultCode, Intent data) {
            if (requestCode == 2 && AndroidMediaManager.MediaManagerObjectPointer != 0 && AndroidMediaManager.this.mCallbacksRegistered) {
                AndroidMediaManager.this.onBrowseImageResult(resultCode, data, AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity());
                AndroidMediaManager.this.unregisterCallbacks();
            }
        }
    }

    public native void useImagePickerData(long j, boolean z, boolean z2, String str, String str2, String str3);

    public native void useStreamData(long j, boolean z, boolean z2, String str);

    public AndroidMediaManager() {
        MediaManagerObjectPointer = 0;
    }

    public void registerCallbacks() {
        doCallbackRegistration(true);
    }

    public void unregisterCallbacks() {
        doCallbackRegistration(false);
    }

    private void doCallbackRegistration(boolean register) {
        this.mCallbacksRegistered = register;
        if (register) {
            if (this.mActivityResultCB == null) {
                this.mActivityResultCB = new C00271();
            }
            AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityResultListener(this.mActivityResultCB);
        } else if (this.mActivityResultCB != null) {
            AndroidActivityWrapper.GetAndroidActivityWrapper().removeActivityResultListener(this.mActivityResultCB);
            this.mActivityResultCB = null;
        }
    }

    public static boolean AddImage(Application app, Bitmap bm, boolean ignoreAlpha) {
        if (app == null) {
            return false;
        }
        String str;
        ContentResolver cr = app.getContentResolver();
        try {
            str = Media.insertImage(cr, bm, null, null);
        } catch (Exception e) {
            str = null;
        }
        if (str == null) {
            str = SaveImage(PHONE_STORAGE, cr, bm, ignoreAlpha);
        }
        if (str == null) {
            return false;
        }
        try {
            Cursor cursor = cr.query(Uri.parse(str), new String[]{"_data"}, null, null, null);
            if (cursor != null) {
                int nativePath_index = cursor.getColumnIndexOrThrow("_data");
                cursor.moveToFirst();
                MediaScannerConnection.scanFile(AndroidActivityWrapper.GetAndroidActivityWrapper().getDefaultContext(), new String[]{cursor.getString(nativePath_index)}, null, null);
            }
        } catch (Exception e2) {
        }
        return true;
    }

    private static String SaveImage(String volumeName, ContentResolver cr, Bitmap bm, boolean ignoreAlpha) {
        Uri url = null;
        try {
            ContentValues values = new ContentValues();
            if (ignoreAlpha) {
                values.put("mime_type", "image/jpeg");
            } else {
                values.put("mime_type", "image/png");
            }
            Date date = new Date();
            values.put("datetaken", Long.valueOf(date.getTime()));
            values.put("date_added", Long.valueOf(date.getTime() / 1000));
            url = cr.insert(Media.getContentUri(volumeName), values);
            if (url != null) {
                OutputStream imageOut = cr.openOutputStream(url);
                try {
                    bm.compress(CompressFormat.JPEG, 90, imageOut);
                    long id = ContentUris.parseId(url);
                    SaveThumbnail(volumeName, cr, SaveThumbnail(volumeName, cr, bm, id, 320.0f, 240.0f, 1), id, 50.0f, 50.0f, 3);
                } catch (Exception e) {
                    if (url != null) {
                        cr.delete(url, null, null);
                        url = null;
                    }
                } finally {
                    imageOut.close();
                }
            }
        } catch (Exception e2) {
            if (url != null) {
                cr.delete(url, null, null);
                url = null;
            }
        }
        if (url != null) {
            return url.toString();
        }
        return null;
    }

    private static final Bitmap SaveThumbnail(String volumeName, ContentResolver cr, Bitmap source, long id, float width, float height, int kind) {
        if (source == null) {
            return null;
        }
        Matrix matrix = new Matrix();
        try {
            matrix.setScale(width / ((float) source.getWidth()), height / ((float) source.getHeight()));
            Bitmap thumb = Bitmap.createBitmap(source, 0, 0, source.getWidth(), source.getHeight(), matrix, true);
            ContentValues values = new ContentValues(4);
            values.put("kind", Integer.valueOf(kind));
            values.put("image_id", Integer.valueOf((int) id));
            values.put("height", Integer.valueOf(thumb.getHeight()));
            values.put("width", Integer.valueOf(thumb.getWidth()));
            Uri url = null;
            try {
                url = cr.insert(Thumbnails.getContentUri(volumeName), values);
                if (url != null) {
                    OutputStream thumbOut = cr.openOutputStream(url);
                    thumb.compress(CompressFormat.JPEG, 100, thumbOut);
                    thumbOut.close();
                }
            } catch (Exception e) {
                if (null != null) {
                    cr.delete(null, null, null);
                    url = null;
                }
            }
            return url == null ? null : thumb;
        } catch (Exception e2) {
            return null;
        }
    }

    public int BrowseImage(long platformMediaManagerOperationObject) {
        int errorCode = 0;
        try {
            AndroidActivityWrapper act = AndroidActivityWrapper.GetAndroidActivityWrapper();
            Intent galleryIntent = new Intent();
            galleryIntent.setType("image/*");
            galleryIntent.setAction("android.intent.action.PICK");
            if (act.getActivity() != null) {
                act.getActivity().startActivityForResult(Intent.createChooser(galleryIntent, ""), 2);
            } else {
                errorCode = 2;
            }
        } catch (ActivityNotFoundException e) {
            errorCode = 1;
        }
        if (errorCode == 0) {
            registerCallbacks();
            MediaManagerObjectPointer = platformMediaManagerOperationObject;
        }
        return errorCode;
    }

    public void onBrowseImageResult(int resultCode, Intent data, Activity act) {
        if (resultCode == 0) {
            useImagePickerData(MediaManagerObjectPointer, false, true, "", "", "");
        } else if (resultCode == -1) {
            try {
                Activity activity = act;
                Cursor cursor = activity.managedQuery(data.getData(), new String[]{"_data", "mime_type", "_display_name"}, null, null, null);
                if (cursor == null) {
                    useImagePickerData(MediaManagerObjectPointer, false, false, "", "", "");
                    return;
                }
                int nativePath_index = cursor.getColumnIndexOrThrow("_data");
                int mediaName_index = cursor.getColumnIndexOrThrow("_display_name");
                cursor.moveToFirst();
                String nativePath = cursor.getString(nativePath_index);
                String mediaType = new String("image");
                String mediaName = cursor.getString(mediaName_index);
                if (nativePath == null || nativePath.startsWith("http")) {
                    useStreamData(MediaManagerObjectPointer, true, true, data.getDataString());
                    return;
                }
                Bitmap myBitmap = BitmapFactory.decodeFile(nativePath);
                ExifInterface ei = null;
                try {
                    ei = new ExifInterface(nativePath);
                } catch (IOException e) {
                }
                int orientation = ei.getAttributeInt("Orientation", 1);
                switch (orientation) {
                    case 3:
                        myBitmap = rotateImage(myBitmap, 180);
                        break;
                    case PlaneID.PLANE_STAGE3D /*6*/:
                        myBitmap = rotateImage(myBitmap, 90);
                        break;
                    case 8:
                        myBitmap = rotateImage(myBitmap, 270);
                        break;
                }
                if (orientation != 1) {
                    try {
                        OutputStream fileOutputStream = new FileOutputStream(new File(nativePath));
                        if (myBitmap != null) {
                            try {
                                myBitmap.compress(CompressFormat.JPEG, 100, fileOutputStream);
                            } catch (Exception e2) {
                                OutputStream outputStream = fileOutputStream;
                            }
                        }
                        fileOutputStream.flush();
                        fileOutputStream.close();
                    } catch (Exception e3) {
                    }
                }
                useImagePickerData(MediaManagerObjectPointer, true, true, nativePath, mediaType, mediaName);
            } catch (IllegalArgumentException e4) {
                useImagePickerData(MediaManagerObjectPointer, false, false, "", "", "");
            } catch (Exception e5) {
                useImagePickerData(MediaManagerObjectPointer, false, false, "", "", "");
            }
        }
    }

    private static Bitmap rotateImage(Bitmap img, int degree) {
        Matrix matrix = new Matrix();
        matrix.postRotate((float) degree);
        Bitmap rotatedImg = Bitmap.createBitmap(img, 0, 0, img.getWidth(), img.getHeight(), matrix, true);
        img.recycle();
        return rotatedImg;
    }
}
