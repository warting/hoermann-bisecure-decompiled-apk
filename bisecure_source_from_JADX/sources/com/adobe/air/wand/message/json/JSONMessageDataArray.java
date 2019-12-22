package com.adobe.air.wand.message.json;

import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import org.json.JSONArray;

public class JSONMessageDataArray implements MessageDataArray {
    final JSONArray mJSONArray;

    public JSONMessageDataArray() {
        this.mJSONArray = new JSONArray();
    }

    public JSONMessageDataArray(JSONArray array) {
        this.mJSONArray = array;
    }

    public boolean getBoolean(int index) throws Exception {
        return this.mJSONArray.getBoolean(index);
    }

    public int getInt(int index) throws Exception {
        return this.mJSONArray.getInt(index);
    }

    public long getLong(int index) throws Exception {
        return this.mJSONArray.getLong(index);
    }

    public double getDouble(int index) throws Exception {
        return this.mJSONArray.getDouble(index);
    }

    public String getString(int index) throws Exception {
        return this.mJSONArray.getString(index);
    }

    public MessageDataObject getObject(int index) throws Exception {
        return new JSONMessageDataObject(this.mJSONArray.getJSONObject(index));
    }

    public MessageDataArray getArray(int index) throws Exception {
        return new JSONMessageDataArray(this.mJSONArray.getJSONArray(index));
    }

    public MessageDataArray put(boolean value) throws Exception {
        this.mJSONArray.put(value);
        return this;
    }

    public MessageDataArray put(int value) throws Exception {
        this.mJSONArray.put(value);
        return this;
    }

    public MessageDataArray put(long value) throws Exception {
        this.mJSONArray.put(value);
        return this;
    }

    public MessageDataArray put(double value) throws Exception {
        this.mJSONArray.put(value);
        return this;
    }

    public MessageDataArray put(String value) throws Exception {
        this.mJSONArray.put(value);
        return this;
    }

    public MessageDataArray put(MessageDataObject value) throws Exception {
        this.mJSONArray.put(((JSONMessageDataObject) value).mJSONObject);
        return this;
    }

    public MessageDataArray put(MessageDataArray value) throws Exception {
        this.mJSONArray.put(((JSONMessageDataArray) value).mJSONArray);
        return this;
    }

    public MessageDataArray put(int index, boolean value) throws Exception {
        this.mJSONArray.put(index, value);
        return this;
    }

    public MessageDataArray put(int index, int value) throws Exception {
        this.mJSONArray.put(index, value);
        return this;
    }

    public MessageDataArray put(int index, long value) throws Exception {
        this.mJSONArray.put(index, value);
        return this;
    }

    public MessageDataArray put(int index, double value) throws Exception {
        this.mJSONArray.put(index, value);
        return this;
    }

    public MessageDataArray put(int index, String value) throws Exception {
        this.mJSONArray.put(index, value);
        return this;
    }

    public MessageDataArray put(int index, MessageDataObject value) throws Exception {
        this.mJSONArray.put(index, ((JSONMessageDataObject) value).mJSONObject);
        return this;
    }

    public MessageDataArray put(int index, MessageDataArray value) throws Exception {
        this.mJSONArray.put(index, ((JSONMessageDataArray) value).mJSONArray);
        return this;
    }

    public boolean remove(int index) {
        return false;
    }

    public int length() {
        return this.mJSONArray.length();
    }
}
