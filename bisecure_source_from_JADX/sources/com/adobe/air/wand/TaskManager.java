package com.adobe.air.wand;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build.VERSION;
import android.os.SystemClock;
import android.os.Vibrator;
import android.util.Base64;
import android.view.Display;
import com.adobe.air.TouchEventData;
import com.adobe.air.wand.message.Message;
import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import com.adobe.air.wand.message.MessageManager;
import com.adobe.air.wand.message.Notification;
import com.adobe.air.wand.message.Request;
import com.adobe.air.wand.message.Response;
import com.adobe.air.wand.message.Response.Status;
import com.adobe.air.wand.motionsensor.Accelerometer;
import com.adobe.air.wand.motionsensor.Gyroscope;
import com.adobe.air.wand.motionsensor.Magnetometer;
import com.adobe.air.wand.view.GestureEventData;
import com.adobe.air.wand.view.TouchSensor;
import com.adobe.air.wand.view.WandView.ScreenOrientation;
import java.util.ArrayList;
import java.util.Date;

public class TaskManager {
    protected static final String GESTURE_PHASE_ALL = "ALL";
    protected static final String GESTURE_PHASE_BEGIN = "BEGIN";
    protected static final String GESTURE_PHASE_END = "END";
    protected static final String GESTURE_PHASE_UPDATE = "UPDATE";
    protected static final String GESTURE_TYPE_PAN = "GESTURE_PAN";
    protected static final String GESTURE_TYPE_ROTATE = "GESTURE_ROTATE";
    protected static final String GESTURE_TYPE_SWIPE = "GESTURE_SWIPE";
    protected static final String GESTURE_TYPE_TWO_FINGER_TAP = "GESTURE_TWO_FINGER_TAP";
    protected static final String GESTURE_TYPE_ZOOM = "GESTURE_ZOOM";
    private static final String LOG_TAG = "TaskManager";
    protected static final int MOTION_SENSOR_MINIMUM_INTERVAL = 16;
    protected static final String NAME_NOTIFICATION_ACCELEROMETER = "accelerometer";
    protected static final String NAME_NOTIFICATION_ACCELEROMETER_DATA = "acc";
    protected static final String NAME_NOTIFICATION_DURATION = "duration";
    protected static final String NAME_NOTIFICATION_GYROSCOPE = "gyroscope";
    protected static final String NAME_NOTIFICATION_GYROSCOPE_DATA = "gyro";
    protected static final String NAME_NOTIFICATION_INTERVAL = "interval";
    protected static final String NAME_NOTIFICATION_IS_PRIMARY_TOUCH_POINT = "isPrimaryTouchPoint";
    protected static final String NAME_NOTIFICATION_IS_TRANSFORM = "isTransform";
    protected static final String NAME_NOTIFICATION_LOCAL_X = "localX";
    protected static final String NAME_NOTIFICATION_LOCAL_Y = "localY";
    protected static final String NAME_NOTIFICATION_MAGNETOMETER = "magnetometer";
    protected static final String NAME_NOTIFICATION_MAGNETOMETER_DATA = "mag";
    protected static final String NAME_NOTIFICATION_MESSAGE = "message";
    protected static final String NAME_NOTIFICATION_OFFSET_X = "offsetX";
    protected static final String NAME_NOTIFICATION_OFFSET_Y = "offsetY";
    protected static final String NAME_NOTIFICATION_PHASE = "phase";
    protected static final String NAME_NOTIFICATION_PRESSURE = "pressure";
    protected static final String NAME_NOTIFICATION_ROTATION = "rotation";
    protected static final String NAME_NOTIFICATION_SCALE_X = "scaleX";
    protected static final String NAME_NOTIFICATION_SCALE_Y = "scaleY";
    protected static final String NAME_NOTIFICATION_SCREEN_DIMENSIONS = "screenDimensions";
    protected static final String NAME_NOTIFICATION_SIZE_X = "sizeX";
    protected static final String NAME_NOTIFICATION_SIZE_Y = "sizeY";
    protected static final String NAME_NOTIFICATION_START = "start";
    protected static final String NAME_NOTIFICATION_TIMESTAMP = "timestamp";
    protected static final String NAME_NOTIFICATION_TOUCH_POINT_ID = "touchPointID";
    protected static final String NAME_NOTIFICATION_TYPE = "type";
    protected static final String NAME_NOTIFICATION_VIBRATOR = "vibrator";
    protected static final String SCREEN_DIMENSIONS_HEIGHT = "height";
    protected static final String SCREEN_DIMENSIONS_WIDTH = "width";
    protected static final String TOUCH_TYPE_BEGIN = "TOUCH_BEGIN";
    protected static final String TOUCH_TYPE_END = "TOUCH_END";
    protected static final String TOUCH_TYPE_MOVE = "TOUCH_MOVE";
    private final Accelerometer mAccelerometer;
    private final Display mDisplay;
    private final Gyroscope mGyroscope;
    private Listener mListener = null;
    private final Magnetometer mMagnetometer;
    private final MessageManager mMessageManager;
    private final TouchSensor mTouchSensor;
    private final Vibrator mVibrator;

    /* renamed from: com.adobe.air.wand.TaskManager$1 */
    class C00681 implements com.adobe.air.wand.view.TouchSensor.Listener {
        C00681() {
        }

        public void onTouchEvent(TouchEventData touchEvent) {
            TaskManager.this.sendTouchEventData(touchEvent);
        }

        public void onGestureEvent(GestureEventData gestureEvent) {
            TaskManager.this.sendGestureEventData(gestureEvent);
        }
    }

    /* renamed from: com.adobe.air.wand.TaskManager$2 */
    class C00692 implements com.adobe.air.wand.motionsensor.MotionSensor.Listener {
        C00692() {
        }

        public void onSensorChanged(float[] values, long timestamp) {
            TaskManager.this.sendMotionSensorData(values, timestamp, TaskManager.NAME_NOTIFICATION_ACCELEROMETER_DATA, MessageTitle.ACCELEROMETER_EVENT);
        }
    }

    /* renamed from: com.adobe.air.wand.TaskManager$3 */
    class C00703 implements com.adobe.air.wand.motionsensor.MotionSensor.Listener {
        C00703() {
        }

        public void onSensorChanged(float[] values, long timestamp) {
            TaskManager.this.sendMotionSensorData(values, timestamp, TaskManager.NAME_NOTIFICATION_MAGNETOMETER_DATA, MessageTitle.MAGNETOMETER_EVENT);
        }
    }

    /* renamed from: com.adobe.air.wand.TaskManager$4 */
    class C00714 implements com.adobe.air.wand.motionsensor.MotionSensor.Listener {
        C00714() {
        }

        public void onSensorChanged(float[] values, long timestamp) {
            TaskManager.this.sendMotionSensorData(values, timestamp, TaskManager.NAME_NOTIFICATION_GYROSCOPE_DATA, MessageTitle.GYROSCOPE_EVENT);
        }
    }

    public interface Listener {
        void drawImage(Bitmap bitmap) throws Exception;

        String getRequestedProtocolVerison() throws Exception;

        void sendConnectionMessage(String str) throws Exception;

        void setScreenOrientation(ScreenOrientation screenOrientation) throws Exception;
    }

    public enum MessageTitle {
        ACCELEROMETER_EVENT("ACCELEROMETER_EVENT"),
        MAGNETOMETER_EVENT("MAGNETOMETER_EVENT"),
        GYROSCOPE_EVENT("GYROSCOPE_EVENT"),
        TOUCH_EVENT("TOUCH_EVENT"),
        GESTURE_EVENT("GESTURE_EVENT"),
        VIBRATE("VIBRATE"),
        DRAW_IMAGE("DRAW_IMAGE"),
        HARDWARE_SPECIFICATIONS("HARDWARE_SPECIFICATIONS"),
        ERROR_LOG("ERROR_LOG");
        
        private final String mTitle;

        private MessageTitle(String title) {
            this.mTitle = title;
        }

        public String toString() {
            return this.mTitle;
        }
    }

    public TaskManager(MessageManager messageManager, Display display, TouchSensor touchSensor, Accelerometer accelerometer, Magnetometer magnetometer, Gyroscope gyroscope, Vibrator vibrator) throws Exception {
        if (messageManager == null) {
            throw new Exception("Invalid MessageManager");
        }
        this.mMessageManager = messageManager;
        if (accelerometer == null) {
            throw new Exception("Invalid Accelerometer");
        }
        this.mAccelerometer = accelerometer;
        if (magnetometer == null) {
            throw new Exception("Invalid Magnetometer");
        }
        this.mMagnetometer = magnetometer;
        if (gyroscope == null) {
            throw new Exception("Invalid Gyroscope");
        }
        this.mGyroscope = gyroscope;
        this.mVibrator = vibrator;
        if (display == null) {
            throw new Exception("Invalid Display");
        }
        this.mDisplay = display;
        if (touchSensor == null) {
            throw new Exception("Invalid TouchSensor");
        }
        this.mTouchSensor = touchSensor;
        this.mTouchSensor.setListener(new C00681());
        this.mAccelerometer.setListener(new C00692());
        this.mMagnetometer.setListener(new C00703());
        this.mGyroscope.setListener(new C00714());
    }

    private String[] getGesturePhases(int gesturePhase) {
        ArrayList<String> types = new ArrayList();
        if ((gesturePhase & 2) != 0) {
            types.add(GESTURE_PHASE_BEGIN);
        }
        if ((gesturePhase & 1) != 0) {
            types.add(GESTURE_PHASE_UPDATE);
        }
        if ((gesturePhase & 4) != 0) {
            types.add(GESTURE_PHASE_END);
        }
        if ((gesturePhase & 8) != 0) {
            types.add(GESTURE_PHASE_ALL);
        }
        return (String[]) types.toArray(new String[0]);
    }

    private void sendGestureEventData(GestureEventData gestureEvent) {
        String[] gesturePhases = getGesturePhases(gestureEvent.mPhase);
        for (String put : gesturePhases) {
            try {
                MessageDataObject gesture = this.mMessageManager.createDataObject();
                gesture.put(NAME_NOTIFICATION_PHASE, put);
                switch (gestureEvent.mType) {
                    case 0:
                        gesture.put(NAME_NOTIFICATION_TYPE, GESTURE_TYPE_ZOOM);
                        break;
                    case 1:
                        gesture.put(NAME_NOTIFICATION_TYPE, GESTURE_TYPE_PAN);
                        break;
                    case 2:
                        gesture.put(NAME_NOTIFICATION_TYPE, GESTURE_TYPE_ROTATE);
                        break;
                    case 3:
                        gesture.put(NAME_NOTIFICATION_TYPE, GESTURE_TYPE_TWO_FINGER_TAP);
                        break;
                    case 4:
                        gesture.put(NAME_NOTIFICATION_TYPE, GESTURE_TYPE_SWIPE);
                        break;
                }
                gesture.put(NAME_NOTIFICATION_IS_TRANSFORM, gestureEvent.mIsTransform);
                gesture.put(NAME_NOTIFICATION_LOCAL_X, (double) gestureEvent.mXCoord);
                gesture.put(NAME_NOTIFICATION_LOCAL_Y, (double) gestureEvent.mYCoord);
                gesture.put(NAME_NOTIFICATION_SCALE_X, (double) gestureEvent.mScaleX);
                gesture.put(NAME_NOTIFICATION_SCALE_Y, (double) gestureEvent.mScaleY);
                gesture.put(NAME_NOTIFICATION_ROTATION, (double) gestureEvent.mRotation);
                gesture.put(NAME_NOTIFICATION_OFFSET_X, (double) gestureEvent.mOffsetX);
                gesture.put(NAME_NOTIFICATION_OFFSET_Y, (double) gestureEvent.mOffsetY);
                gesture.put(NAME_NOTIFICATION_TIMESTAMP, new Date().getTime());
                String serializedNotification = this.mMessageManager.createSerializedNotification(MessageTitle.GESTURE_EVENT.toString(), gesture);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(serializedNotification);
                }
            } catch (Exception e) {
            }
        }
    }

    private String[] getTouchTypes(int touchType) {
        ArrayList<String> types = new ArrayList();
        if ((touchType & 2) != 0) {
            types.add(TOUCH_TYPE_BEGIN);
        }
        if ((touchType & 1) != 0) {
            types.add(TOUCH_TYPE_MOVE);
        }
        if ((touchType & 4) != 0) {
            types.add(TOUCH_TYPE_END);
        }
        return (String[]) types.toArray(new String[0]);
    }

    private void sendTouchEventData(TouchEventData touchEvent) {
        String[] touchTypes = getTouchTypes(touchEvent.mTouchEventType);
        for (String put : touchTypes) {
            try {
                MessageDataObject touch = this.mMessageManager.createDataObject();
                touch.put(NAME_NOTIFICATION_TYPE, put);
                touch.put(NAME_NOTIFICATION_IS_PRIMARY_TOUCH_POINT, touchEvent.mIsPrimaryPoint);
                touch.put(NAME_NOTIFICATION_LOCAL_X, (double) touchEvent.mXCoord);
                touch.put(NAME_NOTIFICATION_LOCAL_Y, (double) touchEvent.mYCoord);
                touch.put(NAME_NOTIFICATION_PRESSURE, (double) touchEvent.mPressure);
                touch.put(NAME_NOTIFICATION_SIZE_X, (double) touchEvent.mContactX);
                touch.put(NAME_NOTIFICATION_SIZE_Y, (double) touchEvent.mContactY);
                touch.put(NAME_NOTIFICATION_TOUCH_POINT_ID, touchEvent.mPointerID);
                touch.put(NAME_NOTIFICATION_TIMESTAMP, new Date().getTime());
                String serializedNotification = this.mMessageManager.createSerializedNotification(MessageTitle.TOUCH_EVENT.toString(), touch);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(serializedNotification);
                }
            } catch (Exception e) {
            }
        }
    }

    private void sendMotionSensorData(float[] values, long timestamp, String sensorDataFieldName, MessageTitle sensorTitle) {
        try {
            MessageDataObject notificationData = this.mMessageManager.createDataObject();
            long timeDiff = System.currentTimeMillis() - SystemClock.uptimeMillis();
            MessageDataArray sensorValues = this.mMessageManager.createDataArray();
            int valueItr = 0;
            while (valueItr < values.length) {
                sensorValues.put(valueItr, (double) values[valueItr]);
                valueItr++;
            }
            sensorValues.put(valueItr, (timestamp / 1000000) + timeDiff);
            notificationData.put(sensorDataFieldName, sensorValues);
            String serializedNotification = this.mMessageManager.createSerializedNotification(sensorTitle.toString(), notificationData);
            if (this.mListener != null) {
                this.mListener.sendConnectionMessage(serializedNotification);
            }
        } catch (Exception e) {
        }
    }

    public void registerListener(Listener listener) throws Exception {
        if (listener == null) {
            throw new Exception("Invalid listener");
        } else if (this.mListener != null) {
            throw new Exception("A listener is already registered");
        } else {
            this.mListener = listener;
        }
    }

    public void unregisterListener() {
        this.mListener = null;
    }

    private void sendLogNotification(String logMessage) {
        if (logMessage != null && !logMessage.equals("")) {
            MessageDataObject logMessageObject = this.mMessageManager.createDataObject();
            try {
                logMessageObject.put("message", logMessage);
                String serializedResponse = this.mMessageManager.createSerializedNotification(MessageTitle.ERROR_LOG.toString(), logMessageObject);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(serializedResponse);
                }
            } catch (Exception e) {
            }
        }
    }

    public void handleRemoteMessage(String message) {
        String m;
        try {
            Message wwMsg = this.mMessageManager.deserializeWandMessage(message);
            switch (wwMsg.getHeader().getType()) {
                case REQUEST:
                    handleRemoteRequest((Request) wwMsg);
                    return;
                case RESPONSE:
                    handleRemoteResponse((Response) wwMsg);
                    return;
                case NOTIFICATION:
                    handleRemoteNotification((Notification) wwMsg);
                    return;
                default:
                    return;
            }
        } catch (Exception e) {
            if (message != null) {
                m = message;
            } else {
                m = "null";
            }
            sendLogNotification("Invalid message : \"" + m + "\"");
        }
        if (message != null) {
            m = "null";
        } else {
            m = message;
        }
        sendLogNotification("Invalid message : \"" + m + "\"");
    }

    private void handleRemoteRequest(Request request) {
        String title = request.getHeader().getTitle();
        if (title.equals(MessageTitle.DRAW_IMAGE.toString())) {
            handleDrawImageRequest(request);
        } else if (title.equals(MessageTitle.HARDWARE_SPECIFICATIONS.toString())) {
            handleHardwareSpecsRequest(request);
        } else {
            sendLogNotification("Unsupported REQUEST title : " + title);
        }
    }

    private void handleRemoteResponse(Response response) {
        sendLogNotification("Unsupported RESPONSE title : " + response.getHeader().getTitle());
    }

    private boolean isOrAboveV1_1_0() throws Exception {
        return this.mListener != null && Version.isGreaterThanEqualTo(this.mListener.getRequestedProtocolVerison(), "1.1.0");
    }

    private void handleRemoteNotification(Notification notification) throws Exception {
        String title = notification.getHeader().getTitle();
        if (title.equals(MessageTitle.VIBRATE.toString())) {
            handleRemoteVibrateNotification(notification);
        } else if (title.equals(MessageTitle.ACCELEROMETER_EVENT.toString())) {
            handleRemoteAccelerometerEventNotification(notification);
        } else if (isOrAboveV1_1_0() && title.equals(MessageTitle.MAGNETOMETER_EVENT.toString())) {
            handleRemoteMagnetometerEventNotification(notification);
        } else if (isOrAboveV1_1_0() && title.equals(MessageTitle.GYROSCOPE_EVENT.toString())) {
            handleRemoteGyroscopeEventNotification(notification);
        } else if (title.equals(MessageTitle.TOUCH_EVENT.toString())) {
            handleRemoteTouchNotification(notification);
        } else if (title.equals(MessageTitle.GESTURE_EVENT.toString())) {
            handleRemoteGestureNotification(notification);
        } else {
            sendLogNotification("Unsupported NOTIFICATION title : " + title);
        }
    }

    void terminateRunningTasks() {
        if (this.mAccelerometer.active()) {
            this.mAccelerometer.stop();
        }
        if (this.mMagnetometer.active()) {
            this.mMagnetometer.stop();
        }
        if (this.mGyroscope.active()) {
            this.mGyroscope.stop();
        }
        if (this.mTouchSensor.activeTouchListening()) {
            this.mTouchSensor.stopTouchEventListening();
        }
        if (this.mTouchSensor.activeGestureListening()) {
            this.mTouchSensor.stopGestureEventListening();
        }
        if (this.mVibrator != null) {
            this.mVibrator.cancel();
        }
    }

    private void handleRemoteAccelerometerEventNotification(Notification notification) {
        try {
            if (this.mAccelerometer.available()) {
                MessageDataObject notificationData = (MessageDataObject) notification.getData().getNotification();
                if (notificationData.getBoolean(NAME_NOTIFICATION_START)) {
                    if (this.mAccelerometer.active()) {
                        sendLogNotification("Already started accelerometer event updates");
                        return;
                    }
                    int interval = notificationData.getInt(NAME_NOTIFICATION_INTERVAL);
                    if (interval < MOTION_SENSOR_MINIMUM_INTERVAL) {
                        interval = MOTION_SENSOR_MINIMUM_INTERVAL;
                    }
                    this.mAccelerometer.start(interval);
                    return;
                } else if (this.mAccelerometer.active()) {
                    this.mAccelerometer.stop();
                    return;
                } else {
                    sendLogNotification("Already stopped accelerometer event updates");
                    return;
                }
            }
            sendLogNotification("The device does not have an accelerometer");
        } catch (Exception e) {
            sendLogNotification("Invalid ACCELEROMETER_EVENT notification");
        }
    }

    private void handleRemoteMagnetometerEventNotification(Notification notification) {
        try {
            if (this.mMagnetometer.available()) {
                MessageDataObject notificationData = (MessageDataObject) notification.getData().getNotification();
                if (notificationData.getBoolean(NAME_NOTIFICATION_START)) {
                    if (this.mMagnetometer.active()) {
                        sendLogNotification("Already started magnetometer event updates");
                        return;
                    }
                    int interval = notificationData.getInt(NAME_NOTIFICATION_INTERVAL);
                    if (interval < MOTION_SENSOR_MINIMUM_INTERVAL) {
                        interval = MOTION_SENSOR_MINIMUM_INTERVAL;
                    }
                    this.mMagnetometer.start(interval);
                    return;
                } else if (this.mMagnetometer.active()) {
                    this.mMagnetometer.stop();
                    return;
                } else {
                    sendLogNotification("Already stopped magnetometer event updates");
                    return;
                }
            }
            sendLogNotification("The device does not have an magnetometer");
        } catch (Exception e) {
            sendLogNotification("Invalid MAGNETOMETER_EVENT notification");
        }
    }

    private void handleRemoteGyroscopeEventNotification(Notification notification) {
        try {
            if (this.mGyroscope.available()) {
                MessageDataObject notificationData = (MessageDataObject) notification.getData().getNotification();
                if (notificationData.getBoolean(NAME_NOTIFICATION_START)) {
                    if (this.mGyroscope.active()) {
                        sendLogNotification("Already started gyroscope event updates");
                        return;
                    }
                    int interval = notificationData.getInt(NAME_NOTIFICATION_INTERVAL);
                    if (interval < MOTION_SENSOR_MINIMUM_INTERVAL) {
                        interval = MOTION_SENSOR_MINIMUM_INTERVAL;
                    }
                    this.mGyroscope.start(interval);
                    return;
                } else if (this.mGyroscope.active()) {
                    this.mGyroscope.stop();
                    return;
                } else {
                    sendLogNotification("Already stopped gyroscope event updates");
                    return;
                }
            }
            sendLogNotification("The device does not have a gyroscope");
        } catch (Exception e) {
            sendLogNotification("Invalid GYROSCOPE_EVENT notification");
        }
    }

    private void handleRemoteTouchNotification(Notification notification) {
        try {
            if (((MessageDataObject) notification.getData().getNotification()).getBoolean(NAME_NOTIFICATION_START)) {
                if (this.mTouchSensor.activeTouchListening()) {
                    sendLogNotification("Already started touch event updates");
                } else {
                    this.mTouchSensor.startTouchEventListening();
                }
            } else if (this.mTouchSensor.activeTouchListening()) {
                this.mTouchSensor.stopTouchEventListening();
            } else {
                sendLogNotification("Already stopped touch event updates");
            }
        } catch (Exception e) {
            sendLogNotification("Invalid TOUCH_EVENT notification");
        }
    }

    private void handleRemoteGestureNotification(Notification notification) {
        try {
            if (((MessageDataObject) notification.getData().getNotification()).getBoolean(NAME_NOTIFICATION_START)) {
                if (this.mTouchSensor.activeGestureListening()) {
                    sendLogNotification("Already started gesture event updates");
                } else {
                    this.mTouchSensor.startGestureEventListening();
                }
            } else if (this.mTouchSensor.activeGestureListening()) {
                this.mTouchSensor.stopGestureEventListening();
            } else {
                sendLogNotification("Already stopped gesture event updates");
            }
        } catch (Exception e) {
            sendLogNotification("Invalid GESTURE_EVENT notification");
        }
    }

    private boolean hasVibrator() {
        if (this.mVibrator == null || VERSION.SDK_INT < 14) {
            return this.mVibrator != null;
        } else {
            return this.mVibrator.hasVibrator();
        }
    }

    private void handleHardwareSpecsRequest(Request request) {
        String serializedResponse;
        try {
            MessageDataObject hardwareSpecsData = this.mMessageManager.createDataObject();
            boolean hasAccelerometer = this.mAccelerometer.available();
            boolean hasMagnetometer = this.mMagnetometer.available();
            boolean hasGyroscope = this.mGyroscope.available();
            Display display = this.mDisplay;
            MessageDataObject dataObj = this.mMessageManager.createDataObject();
            int width = display.getWidth();
            int height = display.getHeight();
            dataObj.put(SCREEN_DIMENSIONS_WIDTH, width);
            dataObj.put(SCREEN_DIMENSIONS_HEIGHT, height);
            hardwareSpecsData.put(NAME_NOTIFICATION_SCREEN_DIMENSIONS, dataObj);
            hardwareSpecsData.put(NAME_NOTIFICATION_ACCELEROMETER, hasAccelerometer);
            hardwareSpecsData.put(NAME_NOTIFICATION_VIBRATOR, hasVibrator());
            if (isOrAboveV1_1_0()) {
                hardwareSpecsData.put(NAME_NOTIFICATION_MAGNETOMETER, hasMagnetometer);
                hardwareSpecsData.put(NAME_NOTIFICATION_GYROSCOPE, hasGyroscope);
            }
            serializedResponse = this.mMessageManager.createSerializedResponse(request, Status.SUCCESS, hardwareSpecsData);
            if (this.mListener != null) {
                this.mListener.sendConnectionMessage(serializedResponse);
            }
        } catch (Exception e) {
            try {
                serializedResponse = this.mMessageManager.createSerializedErrorResponse(request, e.getMessage());
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(serializedResponse);
                }
            } catch (Exception e2) {
                sendLogNotification("Invalid HARDWARE_SPECIFICATIONS request");
            }
        }
    }

    private void handleRemoteVibrateNotification(Notification notification) {
        try {
            long vibrateDuration = ((MessageDataObject) notification.getData().getNotification()).getLong(NAME_NOTIFICATION_DURATION);
            if (vibrateDuration <= 0) {
                sendLogNotification("Invalid vibrate duration.");
            } else if (hasVibrator()) {
                this.mVibrator.vibrate(vibrateDuration);
            } else {
                sendLogNotification("Device does not support vibration");
            }
        } catch (Exception e) {
            sendLogNotification("Invalid VIBRATE notification");
        }
    }

    private void handleDrawImageRequest(Request request) {
        String serializedResponse;
        try {
            byte[] imageData = Base64.decode(request.getData().getArguments().getString(0), 0);
            if (imageData.length >= 4 && imageData[0] == (byte) -1 && imageData[1] == (byte) -40 && imageData[2] == (byte) -1) {
                Bitmap image = BitmapFactory.decodeByteArray(imageData, 0, imageData.length);
                if (image == null) {
                    throw new Exception("Unable to decode the image");
                }
                if (this.mListener != null) {
                    this.mListener.drawImage(image);
                }
                serializedResponse = this.mMessageManager.createSerializedSuccessResponse(request);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(serializedResponse);
                    return;
                }
                return;
            }
            throw new Exception("Unsupported image format");
        } catch (Exception e) {
            try {
                serializedResponse = this.mMessageManager.createSerializedErrorResponse(request, e.getMessage());
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(serializedResponse);
                }
            } catch (Exception e2) {
                sendLogNotification("Invalid DRAW_IMAGE request");
            }
        }
    }
}
