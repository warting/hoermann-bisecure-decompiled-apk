package com.adobe.air.wand.message;

import com.adobe.air.wand.message.Message.Type;

public class Request extends Message {

    public static class Data extends com.adobe.air.wand.message.Message.Data {
        MessageDataArray mArguments = null;

        public Data(MessageDataArray args) {
            setArguments(args);
        }

        public MessageDataArray getArguments() {
            return this.mArguments;
        }

        public void setArguments(MessageDataArray args) {
            this.mArguments = args;
        }
    }

    public static class Header extends com.adobe.air.wand.message.Message.Header {
        protected String mTaskID = "";

        public Header(String title, String taskID, long timestamp) {
            super(title, Type.REQUEST, timestamp);
            this.mTaskID = taskID;
        }

        public String getTaskID() {
            return this.mTaskID;
        }

        public void setTaskID(String taskID) {
            this.mTaskID = taskID;
        }
    }

    public Request(Header header, Data data) {
        super(header, data);
    }

    public Header getHeader() {
        return (Header) this.mHeader;
    }

    public Data getData() {
        return (Data) this.mData;
    }
}
