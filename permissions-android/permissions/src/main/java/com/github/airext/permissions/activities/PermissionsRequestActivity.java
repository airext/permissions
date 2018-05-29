package com.github.airext.permissions.activities;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;
import com.github.airext.permissions.PermissionManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by max on 2/10/18.
 */

@TargetApi(Build.VERSION_CODES.M)
public class PermissionsRequestActivity extends Activity {

    @Override protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PermissionManager.onActivityReady(this);
        String[] permissions = getIntent().getExtras().getStringArray(PermissionManager.permissionsKey);
        requestPermissions(permissions, android.os.Process.myUid());
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
    }

    @Override protected void onDestroy() {
        super.onDestroy();
        PermissionManager.onActivityDestroyed();
    }

    @Override public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        List<String> grantedPermissions = new ArrayList<>();
        List<String> deniedPermissions = new ArrayList<>();

        if (isTargetSdkUnderAndroidM()) {
            deniedPermissions.addAll(Arrays.asList(permissions));
        } else {
            for (int i = 0; i < permissions.length; i++) {
                String permission = permissions[i];
                switch (grantResults[i]) {
                    case PackageManager.PERMISSION_DENIED:
                        deniedPermissions.add(permission);
                        break;
                    case PackageManager.PERMISSION_GRANTED:
                        grantedPermissions.add(permission);
                        break;
                    default:
                }
            }
        }

        PermissionManager.onPermissionsRequested(grantedPermissions.toArray(new String[grantedPermissions.size()]), deniedPermissions.toArray(new String[deniedPermissions.size()]));

        finish();
        overridePendingTransition(0,0);
    }

    private boolean isTargetSdkUnderAndroidM() {
        try {
            final PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), 0);
            int targetSdkVersion = info.applicationInfo.targetSdkVersion;
            return targetSdkVersion < Build.VERSION_CODES.M;
        } catch (PackageManager.NameNotFoundException ignored) {
            return false;
        }
    }
}
