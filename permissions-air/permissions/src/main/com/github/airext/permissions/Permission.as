/**
 * Created by max.rozdobudko@gmail.com on 5/26/18.
 */
package com.github.airext.permissions {
import com.github.airext.Permissions;

import flash.system.Capabilities;

public class Permission {

    // Predefined permissions

    public static const camera: Permission   = new Permission("camera", "android.permission.CAMERA");
    public static const location: Permission = new Permission("location", "android.permission.ACCESS_COARSE_LOCATION");

    // Constructor

    public function Permission(name: String, androidId: String) {
        super();
        _name = name;
        _androidId = androidId;
    }

    // Variables

    private var _name: String;
    private var _androidId: String;

    // id

    public function get id(): String {
        switch (Capabilities.version.substr(0, 3)) {
            case "IOS": return _name;
            case "AND": return _androidId;
            default: return null;
        }
    }

    // isSupported

    public function get isSupported(): Boolean {
        switch (Capabilities.version.substr(0, 3)) {
            case "IOS": return Boolean(_name);
            case "AND": return Boolean(_androidId);
            default: return null;
        }
    }

    // isServiceEnabled

    public function get isFeatureEnabled(): Boolean {
        return Permissions.shared.checkFeatureEnabled(this);
    }

    // enableFeatureIfPossible

    public function enableFeatureIfPossible(): void {
        Permissions.shared.enableFeatureIfPossible(this);
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

    public function request(handler: Function): void {
        Permissions.shared.request(this, handler);
    }

    // Debug description

    public function toString(): String {
        return "[Permission(id=\""+id+"\")]";
    }
}
}
