package com.adobe.air.wand.message.json;

import com.adobe.air.wand.message.Message;
import com.adobe.air.wand.message.Message.Type;
import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import com.adobe.air.wand.message.MessageManager;
import com.adobe.air.wand.message.Notification;
import com.adobe.air.wand.message.Request;
import com.adobe.air.wand.message.Request.Data;
import com.adobe.air.wand.message.Request.Header;
import com.adobe.air.wand.message.Response;
import com.adobe.air.wand.message.Response.Status;
import org.json.JSONObject;

public class JSONMessageManager extends MessageManager {
    public MessageDataObject createDataObject() {
        return new JSONMessageDataObject();
    }

    public MessageDataArray createDataArray() {
        return new JSONMessageDataArray();
    }

    public String serializeMessage(Message message) throws Exception {
        return createJSONMessage(message).toString();
    }

    public Message deserializeWandMessage(String wandMessage) throws Exception {
        return createWandMessage(new JSONObject(wandMessage));
    }

    public Request createWandRequest(String title, String taskID, MessageDataArray args) throws Exception {
        Header header = new Header(title, taskID, System.currentTimeMillis());
        if (args == null) {
            args = new JSONMessageDataArray();
        }
        return new Request(header, new Data(args));
    }

    public Response createWandResponse(String title, String taskID, MessageDataObject result, Status status) throws Exception {
        Response.Header header = new Response.Header(title, taskID, System.currentTimeMillis(), status);
        if (result == null) {
            result = new JSONMessageDataObject();
        }
        return new Response(header, new Response.Data(result));
    }

    public Notification createWandNotification(String title, MessageDataObject notification) throws Exception {
        Notification.Header header = new Notification.Header(title, System.currentTimeMillis());
        if (notification == null) {
            notification = new JSONMessageDataObject();
        }
        return new Notification(header, new Notification.Data(notification));
    }

    private static Message createWandMessage(JSONObject jsonMessage) throws Exception {
        Message message;
        synchronized (jsonMessage) {
            JSONObject jsonHeader = jsonMessage.getJSONObject("header");
            JSONObject jsonData = jsonMessage.getJSONObject("data");
            String msgTitle = jsonHeader.getString("title");
            String msgType = jsonHeader.getString("type");
            long msgTimestamp = jsonHeader.getLong("timestamp");
            message = null;
            if (msgType.equals(Type.REQUEST.toString())) {
                message = new Request(new Header(msgTitle, jsonHeader.getString("taskID"), msgTimestamp), new Data(new JSONMessageDataArray(jsonData.getJSONArray("arguments"))));
            } else if (msgType.equals(Type.RESPONSE.toString())) {
                Status msgStatus;
                String msgTaskID = jsonHeader.getString("taskID");
                String jsonStatus = jsonHeader.getString("status");
                if (jsonStatus.equals(Status.SUCCESS.toString())) {
                    msgStatus = Status.SUCCESS;
                } else if (jsonStatus.equals(Status.ERROR.toString())) {
                    msgStatus = Status.ERROR;
                } else {
                    throw new Exception("Unable to fetch Response status");
                }
                message = new Response(new Response.Header(msgTitle, msgTaskID, msgTimestamp, msgStatus), new Response.Data(new JSONMessageDataObject(jsonData.getJSONObject("result"))));
            } else if (msgType.equals(Type.NOTIFICATION.toString())) {
                message = new Notification(new Notification.Header(msgTitle, msgTimestamp), new Notification.Data(new JSONMessageDataObject(jsonData.getJSONObject("notification"))));
            }
        }
        return message;
    }

    private static JSONObject createJSONMessage(Message message) throws Exception {
        JSONObject jsonMessage;
        synchronized (message) {
            Message.Header header;
            Type msgType = message.getHeader().getType();
            JSONObject jsonHeader = new JSONObject();
            JSONObject jsonData = new JSONObject();
            switch (msgType) {
                case REQUEST:
                    Message.Header requestHeader = (Header) message.getHeader();
                    Data requestData = (Data) message.getData();
                    header = requestHeader;
                    jsonHeader.put("taskID", requestHeader.getTaskID());
                    jsonData.put("arguments", ((JSONMessageDataArray) requestData.getArguments()).mJSONArray);
                    break;
                case RESPONSE:
                    Message.Header responseHeader = (Response.Header) message.getHeader();
                    Response.Data responseData = (Response.Data) message.getData();
                    header = responseHeader;
                    jsonHeader.put("status", responseHeader.getStatus().toString());
                    jsonHeader.put("taskID", responseHeader.getTaskID());
                    jsonData.put("result", ((JSONMessageDataObject) responseData.getResult()).mJSONObject);
                    break;
                case NOTIFICATION:
                    header = (Notification.Header) message.getHeader();
                    jsonData.put("notification", ((JSONMessageDataObject) ((Notification.Data) message.getData()).getNotification()).mJSONObject);
                    break;
                default:
                    throw new Exception("Unsupported message type");
            }
            jsonHeader.put("title", header.getTitle());
            jsonHeader.put("type", header.getType().toString());
            jsonHeader.put("timestamp", header.getTimestamp());
            jsonMessage = new JSONObject();
            jsonMessage.put("header", jsonHeader);
            jsonMessage.put("data", jsonData);
        }
        return jsonMessage;
    }
}
