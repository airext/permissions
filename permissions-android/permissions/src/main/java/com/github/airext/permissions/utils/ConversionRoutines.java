package com.github.airext.permissions.utils;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREObject;

public class ConversionRoutines {

    public static String[] convertFREArrayToStrings(FREObject object) {
        try {
            FREArray array = (FREArray) object;
            String[] strings = new String[(int)array.getLength()];
            for (int i = 0; i < array.getLength(); i++) {
                strings[i] = array.getObjectAt(i).getAsString();
            }
            return strings;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new String[0];
    }
}
