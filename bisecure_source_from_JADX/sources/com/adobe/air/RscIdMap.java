package com.adobe.air;

import android.content.res.Resources.NotFoundException;
import java.lang.reflect.Field;
import java.util.Hashtable;

public class RscIdMap {
    private static Hashtable<String, Hashtable<String, Integer>> s_resourceMap;
    private Hashtable<String, Integer> m_resourceIds;

    public RscIdMap(String resourceClass) {
        if (s_resourceMap == null) {
            s_resourceMap = new Hashtable();
        }
        if (s_resourceMap.contains(resourceClass)) {
            this.m_resourceIds = (Hashtable) s_resourceMap.get(resourceClass);
            return;
        }
        this.m_resourceIds = new Hashtable();
        gatherResourceInfo(resourceClass, this.m_resourceIds);
        s_resourceMap.put(resourceClass, this.m_resourceIds);
    }

    private static void gatherResourceInfo(String resourceClass, Hashtable<String, Integer> resourceIds) {
        try {
            for (Class<?> cls : Class.forName(resourceClass).getClasses()) {
                String clsName = cls.getName();
                int indexOfDollarSign = clsName.lastIndexOf(36) + 1;
                if (indexOfDollarSign > 0) {
                    clsName = clsName.substring(indexOfDollarSign);
                }
                for (Field f : cls.getDeclaredFields()) {
                    try {
                        String rscKey = String.format("%s.%s", new Object[]{clsName, f.getName()}).intern();
                        if (resourceIds.containsKey(rscKey)) {
                            System.out.format("Did not add duplicate resource key %s", new Object[]{rscKey});
                        } else {
                            resourceIds.put(rscKey, Integer.valueOf(f.getInt(cls)));
                        }
                    } catch (IllegalArgumentException e) {
                        System.out.format("IllegalArgumentException", new Object[0]);
                    } catch (IllegalAccessException e2) {
                        System.out.format("IllegalAccessException", new Object[0]);
                    }
                }
            }
        } catch (ClassNotFoundException e3) {
            System.out.format("Class not found:  %s%n%n", new Object[]{resourceClass});
        }
    }

    public int getId(String resourceString) throws IllegalArgumentException, NotFoundException {
        if (resourceString == null) {
            throw new IllegalArgumentException();
        }
        String internedResourceString = resourceString.intern();
        if (this.m_resourceIds.containsKey(internedResourceString)) {
            return ((Integer) this.m_resourceIds.get(internedResourceString)).intValue();
        }
        throw new NotFoundException(internedResourceString);
    }
}
