package com.github.airext.permissions.functions;

import android.app.Activity;
import android.content.pm.PackageManager;
import com.adobe.fre.*;
import com.github.airext.permissions.PermissionManager;

public class CheckPermissionFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        if (args.length == 0) {
            return null;
        }

        Activity activity = context.getActivity();

        try {
            String permission = args[0].getAsString();
            return FREObject.newObject(PermissionManager.getPermissionStatus(activity, permission));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
