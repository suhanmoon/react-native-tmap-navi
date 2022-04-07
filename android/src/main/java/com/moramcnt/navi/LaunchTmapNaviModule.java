package com.moramcnt.navi;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.skt.Tmap.TMapTapi;

import java.util.HashMap;
import java.util.Map;

public class LaunchTmapNaviModule extends ReactContextBaseJavaModule {
    public static final String NAVI_RETURN_CODE_SUCCESS = "01";
    public static final String NAVI_RETURN_CODE_NOT_INSTALLED = "02";
    public static final String NAVI_RETURN_CODE_NOT_INVOKE = "03";


    private final ReactApplicationContext reactContext;

    private TMapTapi mTmapApi;

    public LaunchTmapNaviModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        String strApiKey = getApiKey(reactContext);
        mTmapApi = new TMapTapi(reactContext);
        if (strApiKey != null) {
            mTmapApi.setSKTMapAuthentication(strApiKey);
        }
    }

    public static String getApiKey(ReactApplicationContext context) {
        String strApiKey = null;
        try {
            ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
            strApiKey = appInfo.metaData.getString("com.skt.tmap.ApiKey");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return strApiKey;
    }

    @Override
    public String getName() {
        return "LaunchTmapNavi";
    }

    @ReactMethod
    public void isInstalled(final Promise promise) {

        boolean rett = mTmapApi.isTmapApplicationInstalled();
        Log.d("LaunchMapNavi", "-------------------------------------");
        Log.d("LaunchMapNavi", "*isInstalled()");
        Log.d("LaunchMapNavi", "-------------------------------------");
        if (rett) {
            Log.d("LaunchMapNavi", "good");
        } else {
            Log.d("LaunchMapNavi", "bad");
        }
        promise.resolve(mTmapApi.isTmapApplicationInstalled());
    }

    @ReactMethod
    public void getDownloadUrl(final Promise promise) {
        Log.d("LaunchMapNavi", "-------------------------------------");
        Log.d("LaunchMapNavi", "*getDownloadUrl()");
        Log.d("LaunchMapNavi", "-------------------------------------");
        String strUrl = null;
        java.util.ArrayList arlResult = mTmapApi.getTMapDownUrl();
        if (arlResult.size() > 0) {
            strUrl = (String) arlResult.get(0);
            if (strUrl != null) strUrl = strUrl.trim();
        }
        promise.resolve(strUrl);
    }

    @ReactMethod
    public void navigate(String strName, float fltLatitude, float fltLongitude, final Promise promise) {
        Log.d("LaunchMapNavi", "-------------------------------------");
        Log.d("LaunchMapNavi", "*navigate()");
        Log.d("LaunchMapNavi", " -Name:" + strName);
        Log.d("LaunchMapNavi", " -CoordX:" + fltLongitude + ", CoordY:" + fltLatitude);
        Log.d("LaunchMapNavi", "-------------------------------------");


        if (mTmapApi.isTmapApplicationInstalled() == true) {
            boolean boolInvoke = mTmapApi.invokeRoute(strName, fltLongitude, fltLatitude);
            if (boolInvoke == true) {
                promise.resolve(LaunchTmapNaviModule.NAVI_RETURN_CODE_SUCCESS);
            } else {
                promise.resolve(LaunchTmapNaviModule.NAVI_RETURN_CODE_NOT_INVOKE);
            }
        } else {
            promise.resolve(LaunchTmapNaviModule.NAVI_RETURN_CODE_NOT_INSTALLED);
        }
    }

    @ReactMethod
    public void invokeRoute(ReadableMap map, final Promise promise) {
        Log.d("LaunchMapNavi", "-------------------------------------");
        Log.d("LaunchMapNavi", "*invokeRoute()");
        Log.d("LaunchMapNavi", map.toString());
        Log.d("LaunchMapNavi", "-------------------------------------");


        if (mTmapApi.isTmapApplicationInstalled() == true) {

            HashMap pathInfo = new HashMap();
			ReadableMapKeySetIterator iterator = map.keySetIterator();
			while(iterator.hasNextKey()) {
				String key = iterator.nextKey();
				pathInfo.put(key, map.getString(key));
				System.out.println("pathInfo " + key + " : " + map.getString(key));
			}
            boolean boolInvoke = mTmapApi.invokeRoute(pathInfo);

            if (boolInvoke == true) {
                promise.resolve(LaunchTmapNaviModule.NAVI_RETURN_CODE_SUCCESS);
            } else {
                promise.resolve(LaunchTmapNaviModule.NAVI_RETURN_CODE_NOT_INVOKE);
            }
        } else {
            promise.resolve(LaunchTmapNaviModule.NAVI_RETURN_CODE_NOT_INSTALLED);
        }
    }
}
