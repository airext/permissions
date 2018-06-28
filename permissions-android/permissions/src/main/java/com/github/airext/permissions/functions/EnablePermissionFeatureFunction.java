package com.github.airext.permissions.functions;

import android.app.Activity;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.github.airext.permissions.PermissionManager;
import com.github.airext.permissions.utils.ConversionRoutines;

public class EnablePermissionFeatureFunction implements com.adobe.fre.FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        if (args.length == 0) {
            return null;
        }

        Activity activity = context.getActivity();

        try {
            String[] permissions = ConversionRoutines.convertFREArrayToStrings(args[0]);
            PermissionManager.enableFeatureIfPossible(activity, permissions);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
