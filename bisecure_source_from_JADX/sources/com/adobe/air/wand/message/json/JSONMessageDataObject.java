package com.adobe.air.wand.message.json;

import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import org.json.JSONArray;
import org.json.JSONObject;

public class JSONMessageDataObject implements MessageDataObject {
    final JSONObject mJSONObject;

    public JSONMessageDataObject() {
        this.mJSONObject = new JSONObject();
    }

    public JSONMessageDataObject(JSONObject object) {
        this.mJSONObject = object;
    }

    public boolean getBoolean(String name) throws Exception {
        return this.mJSONObject.getBoolean(name);
    }

    public int getInt(String name) throws Exception {
        return this.mJSONObject.getInt(name);
    }

    public long getLong(String name) throws Exception {
        return this.mJSONObject.getLong(name);
    }

    public double getDouble(String name) throws Exception {
        return this.mJSONObject.getDouble(name);
    }

    public String getString(String name) throws Exception {
        return this.mJSONObject.getString(name);
    }

    public MessageDataObject getObject(String name) throws Exception {
        return new JSONMessageDataObject(this.mJSONObject.getJSONObject(name));
    }

    public MessageDataArray getArray(String name) throws Exception {
        return new JSONMessageDataArray(this.mJSONObject.getJSONArray(name));
    }

    public MessageDataObject put(String name, boolean value) throws Exception {
        this.mJSONObject.put(name, value);
        return this;
    }

    public MessageDataObject put(String name, int value) throws Exception {
        this.mJSONObject.put(name, value);
        return this;
    }

    public MessageDataObject put(String name, long value) throws Exception {
        this.mJSONObject.put(name, value);
        return this;
    }

    public MessageDataObject put(String name, double value) throws Exception {
        this.mJSONObject.put(name, value);
        return this;
    }

    public MessageDataObject put(String name, String value) throws Exception {
        this.mJSONObject.put(name, value);
        return this;
    }

    public MessageDataObject put(String name, MessageDataObject value) throws Exception {
        this.mJSONObject.put(name, ((JSONMessageDataObject) value).mJSONObject);
        return this;
    }

    public MessageDataObject put(String name, MessageDataArray value) throws Exception {
        this.mJSONObject.put(name, ((JSONMessageDataArray) value).mJSONArray);
        return this;
    }

    public boolean has(String name) {
        return this.mJSONObject.has(name);
    }

    public String[] getNames() {
        JSONArray jsonNames = this.mJSONObject.names();
        if (jsonNames == null) {
            return null;
        }
        String[] names = new String[this.mJSONObject.length()];
        for (int i = 0; i < names.length; i++) {
            try {
                names[i] = jsonNames.getString(i);
            } catch (Exception e) {
                names[i] = "";
            }
        }
        return names;
    }

    public boolean remove(String name) {
        return this.mJSONObject.remove(name) != null;
    }

    public int length() {
        return this.mJSONObject.length();
    }
}
