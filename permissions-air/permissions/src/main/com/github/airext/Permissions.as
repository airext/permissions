/**
 * Created by max.rozdobudko@gmail.com on 5/26/18.
 */
package com.github.airext {
import com.github.airext.bridge.bridge;
import com.github.airext.core.permissions;
import com.github.airext.permissions.AuthorisationStatus;
import com.github.airext.permissions.Permission;

import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

use namespace permissions;

public class Permissions {

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    permissions static const EXTENSION_ID:String = "com.github.airext.Permissions";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  context
    //-------------------------------------

    private static var _context: ExtensionContext;
    permissions static function get context(): ExtensionContext {
        if (_context == null) {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
        }
        return _context;
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public static function get isSupported(): Boolean {
        return context != null && context.call("isSupported");
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

    private static var _extensionVersion: String = null;

    /**
     * Returns version of extension
     * @return extension version
     */
    public static function get extensionVersion(): String
    {
        if (_extensionVersion == null) {
            try {
                var extension_xml: File = ExtensionContext.getExtensionDirectory(EXTENSION_ID).resolvePath("META-INF/ANE/extension.xml");
                if (extension_xml.exists) {
                    var stream:FileStream = new FileStream();
                    stream.open(extension_xml, FileMode.READ);

                    var extension:XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
                    stream.close();

                    var ns:Namespace = extension.namespace();

                    _extensionVersion = extension.ns::versionNumber;
                }
            } catch (error:Error) {
                // ignore
            }
        }

        return _extensionVersion;
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
        if (!permission.isSupported) {
            return AuthorisationStatus.unknown;
        }
        return AuthorisationStatus.fromRawValue(context.call("check", permission.id) as String);
    }

    public function request(permission: Permission, handler: Function): void {
        if (!permission.isSupported) {
            handler(AuthorisationStatus.unknown);
            return;
        }
        if (permission.isGranted) {
            handler(AuthorisationStatus.granted);
            return;
        }
        bridge(context).call("request", permission.id).callback(function (error: Error, value: String): void {
            handler(AuthorisationStatus.fromRawValue(value));
        });
    }

    public function checkFeatureEnabled(permission: Permission): Boolean {
        return context.call("enabled", permission.id) as Boolean;
    }

    public function enableFeatureIfPossible(permission: Permission): void {
        context.call("enable", permission.id);
    }

    public function openSettings(): void {
        context.call("openSettings");
    }
}
}
