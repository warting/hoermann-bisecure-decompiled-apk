package com.adobe.air.wand.message;

import com.adobe.air.wand.message.Message.Type;

public class Response extends Message {

    public static class Data extends com.adobe.air.wand.message.Message.Data {
        protected MessageDataObject mResult = null;

        public Data(MessageDataObject result) {
            setResult(result);
        }

        public Object getResult() {
            return this.mResult;
        }

        public void setResult(MessageDataObject result) {
            this.mResult = result;
        }
    }

    public static class Header extends com.adobe.air.wand.message.Message.Header {
        protected Status mStatus = null;
        protected String mTaskID = "";

        public Header(String title, String taskID, long timestamp, Status status) {
            super(title, Type.RESPONSE, timestamp);
            this.mStatus = status;
            this.mTaskID = taskID;
        }

        public Status getStatus() {
            return this.mStatus;
        }

        public void setStatus(Status status) {
            this.mStatus = status;
        }

        public String getTaskID() {
            return this.mTaskID;
        }

        public void setTaskID(String taskID) {
            this.mTaskID = taskID;
        }
    }

    public enum Status {
        SUCCESS("SUCCESS"),
        ERROR("ERROR");
        
        private final String mStatus;

        private Status(String status) {
            this.mStatus = status;
        }

        public String toString() {
            return this.mStatus;
        }
    }

    public Response(Header header, Data data) {
        super(header, data);
    }

    public Header getHeader() {
        return (Header) this.mHeader;
    }

    public Data getData() {
        return (Data) this.mData;
    }
}
