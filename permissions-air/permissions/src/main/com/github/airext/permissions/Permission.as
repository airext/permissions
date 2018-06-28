/**
 * Created by max.rozdobudko@gmail.com on 5/26/18.
 */
package com.github.airext.permissions {
import com.github.airext.Permissions;

import flash.system.Capabilities;

public class Permission {

    // Predefined permissions

    public static const camera: Permission   = new Permission("camera", new <String>["android.permission.CAMERA"]);
    public static const location: Permission = new Permission("location", new <String>["android.permission.ACCESS_COARSE_LOCATION"]);

    // Android permissions

    public static const fineLocation: Permission = new Permission(null, new <String>["android.permission.ACCESS_COARSE_LOCATION", "android.permission.ACCESS_FINE_LOCATION"]);

    // Constructor

    public function Permission(id: String, androidPermissions: Vector.<String>) {
        super();
        _id = id;
        _androidPermissions = androidPermissions;
    }

    // Variables

    protected var _id: String;

    protected var _androidPermissions: Vector.<String>;

    // rawValue

    public function get rawValue(): Object {
        switch (Capabilities.version.substr(0, 3)) {
            case "IOS": return _id;
            case "AND": return _androidPermissions;
            default: return null;
        }
    }

    // isSupported

    public function get isSupported(): Boolean {
        switch (Capabilities.version.substr(0, 3)) {
            case "IOS": return Boolean(_id);
            case "AND": return _androidPermissions && _androidPermissions.length > 0;
            default: return false;
        }
    }

    // isServiceEnabled

    public function get isFeatureEnabled(): Boolean {
        return Permissions.shared.checkFeatureEnabled(this);
    }

    // status

    public function get status(): AuthorisationStatus {
        return Permissions.shared.check(this);
    }

    // isGranted

    public function get isGranted(): Boolean {
        return status == AuthorisationStatus.granted;
    }

    // isDenied

    public function get isDenied(): Boolean {
        return status == AuthorisationStatus.denied;
    }

    // Methods

    public function enableFeatureIfPossible(): void {
        Permissions.shared.enableFeatureIfPossible(this);
    }

    public function request(handler: Function): void {
        Permissions.shared.request(this, handler);
    }

    public function settings(): void {
        Permissions.shared.openFeatureSettings(this);
    }

    // Debug description

    public function toString(): String {
        return "[Permission(rawValue=\""+rawValue+"\")]";
    }
}
}
