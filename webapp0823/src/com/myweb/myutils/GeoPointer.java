package com.myweb.myutils;

import java.text.DecimalFormat;

public class GeoPointer {

    private static final double EARTH_RADIUS = 6378.137;//地球直径 单位：km

    static DecimalFormat df = new DecimalFormat("0.000000");
    double longitude;
    double latitude;

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    @Override
    public boolean equals(Object other) {
        if (other == this) {
            return true;
        } else {
            if (other instanceof GeoPointer) {
                GeoPointer otherPointer = (GeoPointer) other;
                return df.format(latitude).equals(df.format(otherPointer.latitude))
                        && df.format(longitude).equals(df.format(otherPointer.longitude));
            } else {
                return false;
            }
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("latitude:" + latitude);
        sb.append(" longitude:" + longitude);
        return sb.toString();
    }

    /**
     * 利用Haversine公式计算球面两点间距离
     * 单位：km
     * @param target
     * @return
     */
    public double distance(GeoPointer target) {

        //将经纬度转换为弧度
        this.latitude = ConvertDegrees2Radians(this.latitude);
        this.longitude = ConvertDegrees2Radians(this.longitude);
        double targetlatitude = ConvertDegrees2Radians(target.latitude);
        double targetlongitude = ConvertDegrees2Radians(target.longitude);
        //差值
        double vLng = Math.abs(this.longitude - targetlongitude);
        double vLat = Math.abs(this.latitude - targetlatitude);

        //Haversine公式计算距离
        double h = Haversine(vLat) + Math.cos(this.latitude) * Math.cos(targetlatitude) * Haversine(vLng);
        double distance = 2 * EARTH_RADIUS * Math.asin(Math.sqrt(h));

        return distance;
    }

    private static double Haversine(double theta){
        double v = Math.sin(theta / 2);
        return v * v;
    }

    /**
     * 角度转换为弧度
     * @param degrees
     * @return
     */
    private static double ConvertDegrees2Radians(double degrees)
    {
        return degrees * Math.PI / 180;
    }

    private static double ConvertRadians2Degrees(double radian)
    {
        return radian * 180.0 / Math.PI;
    }

}
