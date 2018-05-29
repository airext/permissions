/**
 * Created by max.rozdobudko@gmail.com on 5/28/18.
 */
package com.github.airext.permissions {
public class AuthorisationStatus {

    public static const granted: AuthorisationStatus = new AuthorisationStatus("granted");
    public static const denied: AuthorisationStatus  = new AuthorisationStatus("denied");
    public static const unknown: AuthorisationStatus = new AuthorisationStatus("unknown");

    public static function fromRawValue(rawValue: String): AuthorisationStatus {
        switch (rawValue) {
            case granted.rawValue: return granted;
            case denied.rawValue: return denied;
            default: return unknown;
        }
    }

    public function AuthorisationStatus(rawValue: String) {
        super();
        _rawValue = rawValue;
    }

    private var _rawValue: String;
    public function get rawValue(): String {
        return _rawValue;
    }

    public function toString(): String {
        return "[AuthorisationStatus(\""+_rawValue+"\")]";
    }
}
}
