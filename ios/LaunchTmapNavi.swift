//
//  LaunchTmapNavi.swift
//
//  Created by yomile on 2020/11/06.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import TMapSDK;
import MapKit;
import CoreLocation
import UserNotifications


@objc(LaunchTmapNavi)
class LaunchTmapNavi: NSObject, TMapTapiDelegate, CLLocationManagerDelegate
{
	static let NAVI_RETURN_CODE_SUCCESS = "01";
	static let NAVI_RETURN_CODE_NOT_INSTALLED = "02";
	static let NAVI_RETURN_CODE_NOT_INVOKE = "03";
	var destinationString = "목적지";

	public override init()
	{
		print("------------------------------");
		print("*LaunchTmapNavi.init()");
		print("------------------------------");
		super.init();
		
		// info.plist 에 추가
		let strApiKey = Bundle.main.object(forInfoDictionaryKey: "TMAP_API_KEY") as? String;
		print(" -strApiKey:\(strApiKey ?? "")");
		TMapApi.setSKTMapAuthenticationWithDelegate(self, apiKey: strApiKey ?? "");

	}

	func SKTMapApikeySucceed()
	{
		print("sktMapApi Success");
	}
	
	func SKTMapApikeyFailed(error: NSError?)
	{
		print("sktMApApi Fail")
		print(error ?? "");
	}


	@objc func isInstalled(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
		print("=============================");
		print("*isInstalled");
		print("=============================");
		DispatchQueue.main.async {
			let boolInstalled:Bool = TMapApi.isTmapApplicationInstalled();
			print(" - installed:\(boolInstalled)");
			resolve(boolInstalled);
		}
	}
		
	@objc func getDownloadUrl(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
		print("=============================");
		print("*getDownloadUrl");
		print("=============================");
		DispatchQueue.main.async {
			let strUrl:String = TMapApi.getTMapDownUrl();
			print(" - strUrl:\(strUrl)");
			resolve(strUrl);
		}
	}

   
	@objc func navigate(_ strName : String, _ dblLatitude: NSNumber, _ dblLongitude : NSNumber,
			resolver resolve: @escaping RCTPromiseResolveBlock,
			rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
		print("=============================");
		print("*navigate");
		print("=============================");
		print(" - strName:\(strName)");
		print(" - dblLatitude:\(dblLatitude)");
		print(" - dblLongitude:\(dblLongitude)");
		
		DispatchQueue.main.async {
			
			let boolInstalled:Bool = TMapApi.isTmapApplicationInstalled();
			print(" - installed:\(boolInstalled)");
			if(boolInstalled == true)
			{
				var clsCoord = CLLocationCoordinate2D();
				
				clsCoord.latitude = CLLocationDegrees(dblLatitude);
				clsCoord.longitude = CLLocationDegrees(dblLongitude);
				
				let boolInvoke:Bool = TMapApi.invokeRoute(strName, coordinate: clsCoord);
				if(boolInvoke == true)
				{
		                    self.destinationString = strName
					resolve(LaunchTmapNavi.NAVI_RETURN_CODE_SUCCESS);
				}
				else
				{
					resolve(LaunchTmapNavi.NAVI_RETURN_CODE_NOT_INVOKE);
				}
			}
			else
			{
				resolve(LaunchTmapNavi.NAVI_RETURN_CODE_NOT_INSTALLED);
			}
		}
	}
	
	@objc func invokeRoute(_ dicRoute : NSDictionary,
			resolver resolve: @escaping RCTPromiseResolveBlock,
			rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
		print("=============================");
		print("*invokeRoute");
		print("=============================");
		print(" - dicRoute:\(dicRoute)");
		
		DispatchQueue.main.async {
			let dicRouteInfo = dicRoute as? Dictionary<String,Any> ?? [:];
			let boolInstalled:Bool = TMapApi.isTmapApplicationInstalled();
			print(" - installed:\(boolInstalled)");
			if(boolInstalled == true)
			{
				let boolInvoke:Bool = TMapApi.invokeRoute(dicRouteInfo);
				if(boolInvoke == true)
				{
					resolve(LaunchTmapNavi.NAVI_RETURN_CODE_SUCCESS);
				}
				else
				{
					resolve(LaunchTmapNavi.NAVI_RETURN_CODE_NOT_INVOKE);
				}
			}
			else
			{
				resolve(LaunchTmapNavi.NAVI_RETURN_CODE_NOT_INSTALLED);
			}
		}
	}
	
	/*
	@objc func navigateTMap(_ strApiKey: String, _ strName: String, _ dicRoute : NSDictionary,
			resolver resolve: @escaping RCTPromiseResolveBlock,
			rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
	}
	*/

    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }

    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }

    func getDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double, unit: String) -> Double {

        let theta = lon1 - lon2;
        var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
        
        dist = acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;

        if (unit == "kilometer") {
           dist = dist * 1.609344;
        } else if(unit == "meter"){
            dist = dist * 1609.344;
        }

        return dist
    }

}
