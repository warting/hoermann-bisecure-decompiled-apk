package com.adobe.air;

/* compiled from: ApplicationFileManager */
class FileInfo {
    public long mFileSize;
    public boolean mIsDirectory;
    public boolean mIsFile;

    FileInfo(long fileSize, boolean isFile, boolean isDirectory) {
        this.mFileSize = fileSize;
        this.mIsFile = isFile;
        this.mIsDirectory = isDirectory;
    }
}
