package com.github.airext.permissions;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.provider.Settings;
import android.util.Log;
import com.github.airext.permissions.activities.PermissionsRequestActivity;

/**
 * Created by max on 2/10/18.
 */

public class PermissionManager {

    // Constants

    public static final String TAG = "ANXPermissionManager";

    public static final String permissionsKey = "com.github.airext.permissions.PermissionManager.permissions";

    // Authorization status

    public static String getPermissionsStatus(Context context, String[] permissions) {
        Log.d(TAG, "getPermissionsStatus");

        int grantedPermissions = 0;

        for (int i = 0; i < permissions.length; i++) {
            String permission = permissions[i];
            int result = context.checkSelfPermission(permission);
            if (result == PackageManager.PERMISSION_GRANTED) {
                grantedPermissions++;
            }
        }

        if (grantedPermissions == permissions.length) {
            return "granted";
        }

        SharedPreferences preferences = context.getSharedPreferences("com.github.airext.permissions.preferences", Context.MODE_PRIVATE);

        int deniedPermissions = 0;

        for (int i = 0; i < permissions.length; i++) {
            String permission = permissions[i];
            if (preferences.getBoolean(permission, false)) {
                deniedPermissions++;
            } else {
                SharedPreferences.Editor editor = preferences.edit();
                editor.putBoolean(permission, true);
                editor.apply();
            }
        }

        if (deniedPermissions == permissions.length) {
            return "denied";
        }

        return "unknown";
    }

    public static String getPermissionStatus(Context context, String permission) {
        Log.d(TAG, "getPermissionStatus");

        return getPermissionsStatus(context, new String[]{permission});
    }

    // Check permission

    private static Boolean checkIfPermissionGranted(Context context, String permission) {
        Log.d(TAG, "checkIfPermissionGranted");
        int status = context.checkSelfPermission(permission);
        Log.d(TAG, "Permission " + permission + " status: " + status);
        return status == PackageManager.PERMISSION_GRANTED;
    }

    private static Boolean checkIfPermissionGranted(Context context, String[] permissions) {
        Log.d(TAG, "checkIfPermissionGranted");
        for (String permission: permissions) {
            if (!checkIfPermissionGranted(context, permission)) {
                return false;
            }
        }
        return true;
    }

    // Request permissions

    private static Listener _listener;

    public static void requestPermissions(Context context, String[] permissions, Listener listener) {
        Log.d(TAG, "requestPermissions" + permissions);

        if (checkIfPermissionGranted(context, permissions)) {
            Log.d(TAG, "All permissions granted");
            if (listener != null) {
                listener.onPermissionsCheck(permissions, new String[]{});
            }
            return;
        }

        _listener = listener;

        startTransparentActivityIfNeeded(context, permissions);
    }

    // Start helper Activity

    private static void startTransparentActivityIfNeeded(Context context, String[] permissions) {
        Log.d(TAG, "startTransparentActivityIfNeeded");

        if (context == null) {
            return;
        }

        Intent intent = new Intent(context, PermissionsRequestActivity.class);
        intent.putExtra(permissionsKey, permissions);

        if (context instanceof Application) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }

        context.startActivity(intent);

        if (context instanceof Activity) {
            ((Activity) context).overridePendingTransition(0, 0);
        }
    }

    // Activity handlers

    public static void onActivityReady(PermissionsRequestActivity activity) {
        Log.d(TAG, "onActivityReady");
    }

    public static void onActivityDestroyed() {
        Log.d(TAG, "onActivityDestroyed");

        if (_listener != null) {
            _listener.onPermissionsCheck(new String[0], new String[0]);
            _listener = null;
        }
    }

    public static void onPermissionsRequested(String[] grantedPermissions, String[] deniedPermissions) {
        Log.d(TAG, "onPermissionsRequested");

        if (_listener != null) {
            _listener.onPermissionsCheck(grantedPermissions, deniedPermissions);
            _listener = null;
        }
    }

    public static boolean checkPermissionsFeatureEnabled(Activity activity, String[] permissions) {
        Boolean result = true;
        for (String permission : permissions) {
            result = result && checkPermissionFeatureEnabled(activity, permission);
        }
        return result;
    }

    public static boolean checkPermissionFeatureEnabled(Activity activity, String permission) {
        switch (permission) {
            case Manifest.permission.ACCESS_FINE_LOCATION:
            case Manifest.permission.ACCESS_COARSE_LOCATION:
                LocationManager lm = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
                return lm != null && (lm.isProviderEnabled(LocationManager.GPS_PROVIDER) || lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
            default:
                return true;
        }
    }

    public static void enableFeatureIfPossible(Activity activity, String[] permissions) {
        for (String permission : permissions) {
            if (canEnablePermissionFeature(permission)) {
                enableFeatureIfPossible(activity, permission);
                return;
            }
        }
    }

    public static void enableFeatureIfPossible(Activity activity, String permission) {
        switch (permission) {
            case Manifest.permission.ACCESS_FINE_LOCATION:
            case Manifest.permission.ACCESS_COARSE_LOCATION:
                Intent locationSettingsIntent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                activity.startActivity(locationSettingsIntent);
                break;
        }
    }

    protected static boolean canEnablePermissionFeature(String permission) {
        switch (permission) {
            case Manifest.permission.ACCESS_FINE_LOCATION:
            case Manifest.permission.ACCESS_COARSE_LOCATION:
                return true;
            default:
                return false;
        }
    }

    // Listener

    public interface Listener {
        void onPermissionsCheck(String[] grantedPermissions, String[] deniedPermissions);
    }
}
