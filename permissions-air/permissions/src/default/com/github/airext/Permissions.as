/**
 * Created by max.rozdobudko@gmail.com on 5/26/18.
 */
package com.github.airext {
import com.github.airext.core.permissions;
import com.github.airext.permissions.AuthorisationStatus;
import com.github.airext.permissions.Permission;

import flash.system.Capabilities;

use namespace permissions;

public class Permissions {

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return false;
    }

    //-------------------------------------
    //  sharedInstance
    //-------------------------------------

    private static var instance: Permissions;

    public static function get shared(): Permissions {
        if (instance == null) {
            new Permissions();
        }
        return instance;
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    public static function get extensionVersion(): String {
        trace("Permissions extension is not supported for " + Capabilities.os);
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Permissions() {
        super();
        instance = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function check(permission: Permission): AuthorisationStatus {
        trace("Permissions extension is not supported for " + Capabilities.os);
        return null;
    }

    public function request(permission: Permission, handler: Function): void {
        trace("Permissions extension is not supported for " + Capabilities.os);
    }

    public function openSettings(): void {
        trace("Permissions extension is not supported for " + Capabilities.os);
    }
}
}
