package com.github.airext.permissions;

import com.adobe.fre.FREFunction;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.exceptions.BridgeInstantiationException;
import com.github.airext.bridge.exceptions.BridgeNotFoundException;
import com.github.airext.permissions.functions.*;

import java.util.HashMap;
import java.util.Map;

public class ExtensionContext extends com.adobe.fre.FREContext {

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<>();
        functions.put("isSupported", new IsSupportedFunction());
        functions.put("check", new CheckPermissionFunction());
        functions.put("request", new RequestPermissionFunction());
        functions.put("enabled", new CheckPermissionFeatureEnabledFunction());
        functions.put("enable", new EnablePermissionFeatureFunction());
        functions.put("openSettings", new OpenSettingsFunction());

        try {
            Bridge.setup(functions);
        } catch (BridgeNotFoundException e) {
            e.printStackTrace();
        } catch (BridgeInstantiationException e) {
            e.printStackTrace();
        }

        return functions;
    }

    @Override
    public void dispose() {

    }
}
