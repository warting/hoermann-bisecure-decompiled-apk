package com.adobe.air.location;

import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;

public class AIRLocationListener implements LocationListener {
    private static final int TIMEOUT_INTERVAL = 15000;
    private Geolocation m_geoObj;

    public AIRLocationListener(Geolocation geoObj) {
        this.m_geoObj = geoObj;
    }

    public void onLocationChanged(Location locData) {
        if (locData != null) {
            String provider = locData.getProvider();
            this.m_geoObj.m_currentTime.setToNow();
            double aLatitude = locData.getLatitude();
            double aLongitude = locData.getLongitude();
            double aAltitude = locData.getAltitude();
            float aHorizontalAaccuracy = locData.getAccuracy();
            float aVerticalAccuracy = locData.getAccuracy();
            float aSpeed = locData.getSpeed();
            long aTimestamp = this.m_geoObj.m_currentTime.toMillis(false);
            if (provider.compareTo("gps") == 0) {
                this.m_geoObj.m_ignoreLastGPSValue = false;
                this.m_geoObj.m_gpsLatitude = aLatitude;
                this.m_geoObj.m_gpsLongitude = aLongitude;
                this.m_geoObj.m_gpsAltitude = aAltitude;
                this.m_geoObj.m_gpsHorizontalAaccuracy = aHorizontalAaccuracy;
                this.m_geoObj.m_gpsVerticalAccuracy = aVerticalAccuracy;
                this.m_geoObj.m_gpsSpeed = aSpeed;
                this.m_geoObj.m_gpsTimestamp = this.m_geoObj.m_currentTime.toMillis(false);
            } else {
                if (provider.compareTo("network") == 0) {
                    this.m_geoObj.m_networkLatitude = aLatitude;
                    this.m_geoObj.m_networkLongitude = aLongitude;
                    this.m_geoObj.m_networkAltitude = aAltitude;
                    this.m_geoObj.m_networkHorizontalAaccuracy = aHorizontalAaccuracy;
                    this.m_geoObj.m_networkVerticalAccuracy = aVerticalAccuracy;
                    this.m_geoObj.m_networkSpeed = aSpeed;
                    this.m_geoObj.m_networkTimestamp = this.m_geoObj.m_currentTime.toMillis(false);
                    if (!this.m_geoObj.m_ignoreLastGPSValue && this.m_geoObj.m_networkTimestamp - this.m_geoObj.m_gpsTimestamp < 15000 && this.m_geoObj.m_networkHorizontalAaccuracy > this.m_geoObj.m_gpsHorizontalAaccuracy) {
                        if (isRegionFullyContained(this.m_geoObj.m_gpsLatitude, this.m_geoObj.m_gpsLongitude, this.m_geoObj.m_gpsHorizontalAaccuracy, this.m_geoObj.m_networkLatitude, this.m_geoObj.m_networkLongitude, this.m_geoObj.m_networkHorizontalAaccuracy)) {
                            return;
                        }
                    }
                    this.m_geoObj.m_ignoreLastGPSValue = true;
                }
            }
            this.m_geoObj.m_latitude = aLatitude;
            this.m_geoObj.m_longitude = aLongitude;
            this.m_geoObj.m_altitude = aAltitude;
            this.m_geoObj.m_horizontalAaccuracy = aHorizontalAaccuracy;
            this.m_geoObj.m_verticalAccuracy = aVerticalAccuracy;
            this.m_geoObj.m_speed = aSpeed;
            this.m_geoObj.m_timestamp = aTimestamp;
            if (this.m_geoObj.m_EventSourceExists) {
                this.m_geoObj.updateGeolocationCache(this.m_geoObj.m_objectPointer);
            }
        }
    }

    public void onProviderDisabled(String arg0) {
        boolean wasGPSEnabled = this.m_geoObj.m_isGPSProviderEnabled;
        boolean wasNetworkEnabled = this.m_geoObj.m_isNetworkProviderEnabled;
        if (arg0.compareTo("gps") == 0) {
            this.m_geoObj.m_isGPSProviderEnabled = false;
        } else if (arg0.compareTo("network") == 0) {
            this.m_geoObj.m_isNetworkProviderEnabled = false;
        }
        if ((wasGPSEnabled != this.m_geoObj.m_isGPSProviderEnabled || wasNetworkEnabled != this.m_geoObj.m_isNetworkProviderEnabled) && this.m_geoObj.m_EventSourceExists && !this.m_geoObj.m_isGPSProviderEnabled && !this.m_geoObj.m_isNetworkProviderEnabled) {
            this.m_geoObj.setGeolocationStatus(false, this.m_geoObj.m_objectPointer);
        }
    }

    public void onProviderEnabled(String arg0) {
        boolean wasGPSEnabled = this.m_geoObj.m_isGPSProviderEnabled;
        boolean wasNetworkEnabled = this.m_geoObj.m_isNetworkProviderEnabled;
        if (arg0.compareTo("gps") == 0) {
            this.m_geoObj.m_isGPSProviderEnabled = true;
            if (this.m_geoObj.m_EventSourceExists && !this.m_geoObj.m_isNetworkProviderEnabled && wasGPSEnabled != this.m_geoObj.m_isGPSProviderEnabled) {
                this.m_geoObj.setGeolocationStatus(true, this.m_geoObj.m_objectPointer);
            }
        } else if (arg0.compareTo("network") == 0) {
            this.m_geoObj.m_isNetworkProviderEnabled = true;
            if (this.m_geoObj.m_EventSourceExists && !this.m_geoObj.m_isGPSProviderEnabled && wasNetworkEnabled != this.m_geoObj.m_isNetworkProviderEnabled) {
                this.m_geoObj.setGeolocationStatus(true, this.m_geoObj.m_objectPointer);
            }
        }
    }

    public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
    }

    private boolean isRegionFullyContained(double lat1, double long1, float accuracy1, double lat2, double long2, float accuracy2) {
        float[] results = new float[5];
        Location.distanceBetween(lat1, long1, lat2, long2, results);
        if (results[0] <= Math.abs(accuracy2 - accuracy1)) {
            return true;
        }
        return false;
    }
}
