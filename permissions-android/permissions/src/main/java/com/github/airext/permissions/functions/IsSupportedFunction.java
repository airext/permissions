package com.github.airext.permissions.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class IsSupportedFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        try {
            return FREObject.newObject(true);
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }
        return null;
    }
}
