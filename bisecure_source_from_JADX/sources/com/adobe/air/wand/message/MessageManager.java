package com.adobe.air.wand.message;

import com.adobe.air.wand.message.Response.Status;

public abstract class MessageManager {
    protected static final String NAME_ARGUMENTS = "arguments";
    protected static final String NAME_DATA = "data";
    public static final String NAME_ERROR_MESSAGE = "message";
    protected static final String NAME_HEADER = "header";
    protected static final String NAME_NOTIFICATION = "notification";
    protected static final String NAME_RESULT = "result";
    protected static final String NAME_STATUS = "status";
    protected static final String NAME_TASK_ID = "taskID";
    protected static final String NAME_TIMESTAMP = "timestamp";
    protected static final String NAME_TITLE = "title";
    protected static final String NAME_TYPE = "type";

    public abstract MessageDataArray createDataArray();

    public abstract MessageDataObject createDataObject();

    public abstract Notification createWandNotification(String str, MessageDataObject messageDataObject) throws Exception;

    public abstract Request createWandRequest(String str, String str2, MessageDataArray messageDataArray) throws Exception;

    public abstract Response createWandResponse(String str, String str2, MessageDataObject messageDataObject, Status status) throws Exception;

    public abstract Message deserializeWandMessage(String str) throws Exception;

    public abstract String serializeMessage(Message message) throws Exception;

    public Response createWandResponse(Request request, Status status, MessageDataObject result) throws Exception {
        return createWandResponse(request.getHeader().getTitle(), request.getHeader().getTaskID(), result, status);
    }

    public String createSerializedResponse(String title, String taskID, MessageDataObject result, Status status) throws Exception {
        return serializeMessage(createWandResponse(title, taskID, result, status));
    }

    public String createSerializedResponse(Request request, Status status, MessageDataObject result) throws Exception {
        return serializeMessage(createWandResponse(request, status, result));
    }

    public String createSerializedNotification(String title, MessageDataObject notification) throws Exception {
        return serializeMessage(createWandNotification(title, notification));
    }

    public String createSerializedSuccessResponse(String title, String taskID, MessageDataObject result) throws Exception {
        return serializeMessage(createWandResponse(title, taskID, result, Status.SUCCESS));
    }

    public String createSerializedErrorResponse(String title, String taskID, String errorMessage) throws Exception {
        MessageDataObject result = createDataObject();
        result.put(NAME_ERROR_MESSAGE, errorMessage);
        return serializeMessage(createWandResponse(title, taskID, result, Status.ERROR));
    }

    public String createSerializedSuccessResponse(Request request) throws Exception {
        return serializeMessage(createWandResponse(request, Status.SUCCESS, null));
    }

    public String createSerializedErrorResponse(Request request, String errorMessage) throws Exception {
        MessageDataObject result = createDataObject();
        result.put(NAME_ERROR_MESSAGE, errorMessage);
        return serializeMessage(createWandResponse(request, Status.ERROR, result));
    }

    public String createSerializedRequest(String title, String taskID, MessageDataArray args) throws Exception {
        return serializeMessage(createWandRequest(title, taskID, args));
    }
}
