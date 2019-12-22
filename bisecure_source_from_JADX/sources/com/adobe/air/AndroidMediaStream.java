package com.adobe.air;

import android.net.Uri;
import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class AndroidMediaStream {
    private static final int ERROR = -2;
    private int mBufferSize = 0;
    private BufferedInputStream mBufferedStream = null;
    private Uri mContentURI = null;

    public boolean loadContentURI(String URI) {
        this.mContentURI = Uri.parse(URI);
        if (this.mBufferedStream == null) {
            try {
                this.mBufferedStream = new BufferedInputStream(AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getContentResolver().openInputStream(this.mContentURI));
            } catch (FileNotFoundException e) {
                return false;
            } catch (Exception e2) {
                return false;
            }
        }
        return true;
    }

    public int Read(byte[] buffer, int count) {
        try {
            return this.mBufferedStream.read(buffer, 0, count);
        } catch (IOException e) {
            return ERROR;
        }
    }

    public void Close() {
        if (this.mBufferedStream != null) {
            try {
                this.mBufferedStream.close();
            } catch (Exception e) {
            }
            this.mBufferedStream = null;
        }
    }
}
