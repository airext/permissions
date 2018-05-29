package com.github.airext.permissions;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Process;
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

    public static String getPermissionStatus(Context context, String permission) {
        Log.d(TAG, "getPermissionStatus");
        switch (context.checkSelfPermission(permission)) {
            case PackageManager.PERMISSION_GRANTED: return "granted";
            case PackageManager.PERMISSION_DENIED:  return "denied";
            default: return "unknown";
        }
    }

    // Check permission

    private static Boolean checkIfPermissionsGranted(Context context, String permission) {
        Log.d(TAG, "checkIfPermissionsGranted");
        int status = context.checkSelfPermission(permission);
        Log.d(TAG, "Permission " + permission + " status: " + status);
        return status == PackageManager.PERMISSION_GRANTED;
    }

    private static Boolean checkIfPermissionsGranted(Context context, String[] permissions) {
        Log.d(TAG, "checkIfPermissionsGranted");
        for (String permission: permissions) {
            if (!checkIfPermissionsGranted(context, permission)) {
                return false;
            }
        }
        return true;
    }

    // Request permissions

    private static Listener _listener;

    public static void requestPermissions(Context context, String[] permissions, Listener listener) {
        Log.d(TAG, "requestPermissions");

        if (checkIfPermissionsGranted(context, permissions)) {
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

    // Listener

    public interface Listener {
        void onPermissionsCheck(String[] grantedPermissions, String[] deniedPermissions);
    }
}