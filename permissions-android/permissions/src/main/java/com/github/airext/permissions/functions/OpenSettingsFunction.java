package com.github.airext.permissions.functions;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class OpenSettingsFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        Activity activity = context.getActivity();
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", activity.getPackageName(), null);
        intent.setData(uri);
        activity.startActivity(intent);
        return null;
    }

}
