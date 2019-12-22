package com.adobe.air.wand;

public class Version {
    public static final String CURRENT = "1.1.0";
    public static final String V1_0_0 = "1.0.0";
    public static final String V1_1_0 = "1.1.0";

    public static boolean isGreaterThan(String v1, String v2) throws Exception {
        String[] vals1 = v1.split("\\.");
        String[] vals2 = v2.split("\\.");
        int i = 0;
        while (i < 2 && vals1[i].equals(vals2[i])) {
            i++;
        }
        return Integer.valueOf(vals1[i]).intValue() > Integer.valueOf(vals2[i]).intValue();
    }

    public static boolean isGreaterThanEqualTo(String v1, String v2) throws Exception {
        return isGreaterThan(v1, v2) || v1.equals(v2);
    }
}
