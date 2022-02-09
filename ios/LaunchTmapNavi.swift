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
	
	//var mDicRouteInfo : Dictionary<String, Any> = Dictionary<String, Any>();

    let locationManager = CLLocationManager()
	var destinationString = "목적지";
    // var userNotificationCenter;
    // let userNotificationCenter = UNUserNotificationCenter.current()
	
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


        print("티맵 내비 연동 성공111")
        // locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.1
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
		// userNotificationCenter = UNUserNotificationCenter.current()
		
        requestNotificationAuthorization() // 알림을 위한 준비
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
            		self.locationManager.startUpdatingLocation() // 백그라운드에서 로케이션 받아오기
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

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("티맵 locationManager 11111 ")
        if status == .authorizedAlways {
            print("티맵 you're good to go!")
        } else {
            print("티맵 you're not good to go!")
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("티맵 locationManager 22222 ")
        let lastLocation = locations.last
        let latitude = (lastLocation?.coordinate.latitude)!
        let longitude = (lastLocation?.coordinate.longitude)!
        print("티맵 locationManager latitude is \(latitude), longitude is \(longitude)")
        
        let returnValue = getDistance(lat1: latitude, lon1: longitude, lat2: 37.3750148, lon2: 126.9482640, unit: "kilometer")
        print("티맵 locationManager returnValue \(returnValue)")
        if (returnValue <= 0.1 && returnValue > 0.05) { // 키로미터 단위
            print("티맵 locationManager in destination")
            self.sendNotification(seconds: 1) // 1초 뒤에 알림 띄우기
        } else if (returnValue <= 0.05) { // 키로미터 단위
            print("티맵 locationManager in destination")
            self.locationManager.stopUpdatingLocation() // 백그라운드에서의 위치 탐색 중지
            self.sendNotification(seconds: 1) // 1초 뒤에 알림 띄우기
        }
        
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("티맵 GPS Error => \(error.localizedDescription)")
    }

    func requestNotificationAuthorization() {
		if #available(iOS 10.0, *) {
        	let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        	UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
        	    if let error = error {
        	        print("티맵 Error: \(error)")
        	    }
        	}
		} else {
			// iOS 9
    		let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
    		let setting = UIUserNotificationSettings(types: type, categories: nil)
    		UIApplication.shared.registerUserNotificationSettings(setting)
    		UIApplication.shared.registerForRemoteNotifications()
		}
    }

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

    func sendNotification(seconds: Double) {

		if #available(iOS 10.0, *) {
        	let notificationContent = UNMutableNotificationContent()
			
        	notificationContent.title = "목적지 도착 : \(destinationString)"
        	notificationContent.body = "알림을 클릭하여 워치마일을 실행해주세요."
			
        	let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        	let request = UNNotificationRequest(identifier: "testNotification",
        	                                    content: notificationContent,
        	                                    trigger: trigger)
												
        	UNUserNotificationCenter.current().add(request) { error in
        	    if let error = error {
        	        print("티맵 Notification Error: ", error)
        	    } else {
        	        print("티맵 Notification success")
        	    }
        	}
		} else {
    		let notification = UILocalNotification()
    		notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
    		notification.alertBody = "목적지에 도착하였습니다. 앱을 실행해주세요."
    		notification.alertAction = "확인"
    		notification.soundName = UILocalNotificationDefaultSoundName
    		UIApplication.shared.scheduleLocalNotification(notification)
		}
    }
}
