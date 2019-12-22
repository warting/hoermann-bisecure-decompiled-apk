package com.adobe.air;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.Resources;
import android.content.res.Resources.NotFoundException;
import android.net.Uri;
import com.adobe.air.utils.Utils;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

public final class ResourceFileManager {
    private final Context mAppContext;
    private final Resources mAppResources;
    private ResourceIdMap mResourceIdMap = null;

    ResourceFileManager(Context appContext) {
        this.mAppContext = appContext;
        this.mAppResources = appContext.getResources();
        try {
            this.mResourceIdMap = new ResourceIdMap(this.mAppContext.getClassLoader().loadClass(this.mAppContext.getPackageName() + ".R"));
        } catch (ClassNotFoundException e) {
        }
    }

    public InputStream getFileStreamFromRawRes(int resId) throws NotFoundException {
        InputStream stream = this.mAppResources.openRawResource(resId);
        return stream == null ? stream : stream;
    }

    public String readFileFromRawRes(int resId) {
        String retString = new String();
        try {
            InputStream in = getFileStreamFromRawRes(resId);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            Utils.writeThrough(in, out);
            return new String(out.toByteArray(), "UTF-8");
        } catch (Exception e) {
            return retString;
        }
    }

    public InputStream getStream(int resId) throws NotFoundException {
        return this.mAppResources.openRawResource(resId);
    }

    public void extractResource(int resId, File path) throws IOException {
        InputStream in = getStream(resId);
        Utils.writeOut(in, path);
        in.close();
    }

    public boolean resExists(int resId) {
        if (resId <= 0) {
            return false;
        }
        try {
            if (this.mAppResources.openRawResource(resId) != null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    public int lookupResId(String resIdString) {
        try {
            if (this.mResourceIdMap != null) {
                return this.mResourceIdMap.getId(resIdString);
            }
        } catch (NotFoundException e) {
        }
        return -1;
    }

    private String remapSpecialFileNames(String resName) {
        if (resName.equals("ss.cfg") || resName.equals("ss.sgn") || resName.equals("mms.cfg")) {
            return resName.replace('.', '_');
        }
        return null;
    }

    private boolean resExists(String resName) {
        String remappedResName = remapSpecialFileNames(resName);
        if (remappedResName != null) {
            return resExists(lookupResId("raw." + remappedResName));
        }
        return false;
    }

    public AssetFileDescriptor GetAssetFileDescriptor(String resName) {
        AssetFileDescriptor resFileDes = null;
        try {
            String suffix;
            String resIdString = remapSpecialFileNames(resName);
            if (resIdString != null) {
                suffix = resIdString;
            } else {
                suffix = resName;
            }
            resFileDes = this.mAppContext.getContentResolver().openAssetFileDescriptor(Uri.parse("android.resource://" + this.mAppContext.getPackageName() + "/raw/" + suffix), "r");
        } catch (Exception e) {
        }
        return resFileDes;
    }

    public String getResourceName(int id) {
        try {
            return this.mAppResources.getResourceName(id);
        } catch (Exception e) {
            return "null";
        }
    }

    public String getResourceEntryName(int id) {
        try {
            return this.mAppResources.getResourceEntryName(id);
        } catch (Exception e) {
            return "null";
        }
    }
}
