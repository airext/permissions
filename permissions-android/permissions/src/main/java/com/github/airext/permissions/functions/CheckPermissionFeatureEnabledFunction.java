package com.github.airext.permissions.functions;

import android.app.Activity;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.github.airext.permissions.PermissionManager;

public class CheckPermissionFeatureEnabledFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        if (args.length == 0) {
            return null;
        }

        Activity activity = context.getActivity();

        try {
            String permission = args[0].getAsString();
            return FREObject.newObject(PermissionManager.checkPermissionFeatureEnabled(activity, permission));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
