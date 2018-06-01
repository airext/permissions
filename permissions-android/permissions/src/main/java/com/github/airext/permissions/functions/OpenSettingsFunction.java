package com.github.airext.permissions.functions;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;
import android.util.Log;
import com.adobe.fre.*;

public class OpenSettingsFunction implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        Activity activity = context.getActivity();

        String permission = null;

        try {
            permission = args.length > 0 ? args[0].getAsString() : null;
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("OpenSettingsFunction", "call");

        if (openFeatureSettings(activity, permission)) {
            Log.d("OpenSettingsFunction", "call1");
            return null;
        }

        Log.d("OpenSettingsFunction", "call2");

        openApplicationSettings(activity);

        return null;
    }

    void openApplicationSettings(Activity activity) {
        Log.d("OpenSettingsFunction", "openApplicationSettings");
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", activity.getPackageName(), null);
        intent.setData(uri);
        activity.startActivity(intent);
    }

    Boolean openFeatureSettings(Activity activity, String permission) {
        Log.d("OpenSettingsFunction", "openFeatureSettings");

        if (permission == null) {
            return false;
        }

        if (permission.equals(Manifest.permission.ACCESS_FINE_LOCATION) ||
            permission.equals(Manifest.permission.ACCESS_COARSE_LOCATION)) {
            Log.d("OpenSettingsFunction", "openFeatureSettings1");
            Intent intent = new Intent();
            intent.setAction(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
            activity.startActivity(intent);
            return true;
        }

        Log.d("OpenSettingsFunction", "openFeatureSettings2");

        return false;
    }
}
