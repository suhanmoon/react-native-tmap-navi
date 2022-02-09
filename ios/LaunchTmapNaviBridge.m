#import "LaunchTmapNaviBridge.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LaunchTmapNavi, NSObject)


/*
 RCT_EXTERN_METHOD(
   methodName:         (paramType1)internalParamName1
   externalParamName2: (paramType2)internalParamName2
   externalParamName3: (paramType3)internalParamName3
   ...
 )
 */
RCT_EXTERN_METHOD(	
				isInstalled : (RCTPromiseResolveBlock *)resolve
				rejecter	: (RCTPromiseRejectBlock *)reject);


RCT_EXTERN_METHOD(
				getDownloadUrl : (RCTPromiseResolveBlock *)resolve
				rejecter	: (RCTPromiseRejectBlock)reject);

RCT_EXTERN_METHOD(
				navigate
							: (NSString *) strName
							: (nonnull NSNumber *) dblLatitude
							: (nonnull NSNumber *) dblLongitude
				  resolver	: (RCTPromiseResolveBlock *)resolve
				  rejecter	: (RCTPromiseRejectBlock *)reject);

RCT_EXTERN_METHOD(
				  invokeRoute
							: (NSDictionary *) dicRoute
				  resolver	: (RCTPromiseResolveBlock *)resolve
				  rejecter	: (RCTPromiseRejectBlock *)reject);

/*
RCT_EXTERN_METHOD(
					invokeRoute
							: (NSString *) strApiKey
							: (NSString *) strName
							: (NSDictionary *) dicRoute
				  resolver	: (RCTPromiseResolveBlock *)resolve
				  rejecter	: (RCTPromiseRejectBlock *)reject);
*/

@end
