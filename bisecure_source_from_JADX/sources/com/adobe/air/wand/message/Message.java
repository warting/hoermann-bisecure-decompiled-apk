package com.adobe.air.wand.message;

public abstract class Message {
    protected final Data mData;
    protected final Header mHeader;

    public static abstract class Data {
    }

    public static abstract class Header {
        protected long mTimestamp = 0;
        protected String mTitle = null;
        protected Type mType = null;

        public Header(String title, Type type, long timestamp) {
            this.mTitle = title;
            this.mType = type;
            this.mTimestamp = timestamp;
        }

        public String getTitle() {
            return this.mTitle;
        }

        public Type getType() {
            return this.mType;
        }

        public long getTimestamp() {
            return this.mTimestamp;
        }

        public void setTitle(String title) {
            this.mTitle = title;
        }

        public void setType(Type type) {
            this.mType = type;
        }

        public void setTimestamp(long timestamp) {
            this.mTimestamp = timestamp;
        }
    }

    public enum Type {
        REQUEST("REQUEST"),
        RESPONSE("RESPONSE"),
        NOTIFICATION("NOTIFICATION");
        
        private final String mType;

        private Type(String type) {
            this.mType = type;
        }

        public String toString() {
            return this.mType;
        }
    }

    public Header getHeader() {
        return this.mHeader;
    }

    public Data getData() {
        return this.mData;
    }

    public Message(Header header, Data data) {
        this.mHeader = header;
        this.mData = data;
    }
}
