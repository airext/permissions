package com.github.airext.permissions.functions;

import android.app.Activity;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;
import com.github.airext.permissions.PermissionManager;

public class RequestPermissionFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        if (args.length == 0) {
            return null;
        }

        final Call call = Bridge.call(context);

        Activity activity = context.getActivity();

        try {
            String permission = args[0].getAsString();
            PermissionManager.requestPermissions(activity, new String[]{permission}, new PermissionManager.Listener() {
                @Override
                public void onPermissionsCheck(String[] grantedPermissions, String[] deniedPermissions) {
                    if (grantedPermissions.length > 0) {
                        call.result("granted");
                    } else if (deniedPermissions.length > 0) {
                        call.result("denied");
                    } else {
                        call.result("unknown");
                    }
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }

        return call.toFREObject();
    }
}
