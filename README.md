# react-native-tmap-navi


![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-brightgreen.svg?style=flat-square&colorB=191A17)
[![npm](https://img.shields.io/npm/v/react-native-tmap-navi.svg?style=flat-square)](https://www.npmjs.com/package/react-native-tmap-navi)
[![npm](https://img.shields.io/npm/dm/react-native-tmap-navi.svg?style=flat-square&colorB=007ec6)](https://www.npmjs.com/package/react-native-tmap-navi)
[![github issues](https://img.shields.io/github/issues/Kwon-Bum-Kyu/react-native-tmap-navi.svg?style=flat-square)](https://github.com/Kwon-Bum-Kyu/react-native-tmap-navi/issues)
[![github closed issues](https://img.shields.io/github/issues-closed/Kwon-Bum-Kyu/react-native-tmap-navi.svg?style=flat-square&colorB=44cc11)](https://github.com/Kwon-Bum-Kyu/react-native-tmap-navi/issues?q=is%3Aissue+is%3Aclosed)

## Getting started
`$ npm install react-native-tmapsdk --save --legacy-peer-deps`

`$ npm install @vestellalab/react-native-tmap-navi --save --legacy-peer-deps`

### iOS

`reference`

[Tmap iOS Preferences](https://tmapapi.sktelecom.com/main.html#iosv2/guide/iosGuide.sample4)

`info.plist`

```
+ <key>TMAP_API_KEY</key>
+ <string>{tmap_app_key}</string>
  <key>LSApplicationQueriesSchemes</key>
	<array>
+		<string>tmap</string>
	</array>
```





### Android

Project/android/app/src/main/res/values/strings.xml

```xml
<resources>
	<string name="app_name">app_name</string>
	<string name="tmap_app_key">tmap_app_key</string> <!--Enter key value -->
	
</resources>
```
`reference`

 If your gradle version is 7 or higher, you need to lower it to version 6 and build it.

Project/android/gradle/wrapper/gradle-wrapper.properties
```
Chnage

distributionUrl=https\://services.gradle.org/distributions/gradle-7.*-all.zip

to

distributionUrl=https\://services.gradle.org/distributions/gradle-6.9-all.zip

```

### Mostly automatic installation (RN <= 0.61)

`$ react-native link react-native-launch-tmap-navi`

## Usage
```typescript
import TmapNavi from 'react-native-tmap-navi';

 const tmapNavigate = () => {
    let arrData = { destName: "서울특별시 광진구 광장동 248-2", destX: 127.103432, destY: 37.546394 };
    TmapNavi.navigate(arrData.destName, arrData.destY, arrData.destX).then(async (res) => {
      if (res == "02") {
        alert("설치된 내비가 없거나 내비 초기설정을\n완료하지 않았습니다.내비를 먼저 설치\n하시고 설정을 완료하여 주십시오.");

      }
      else if (res == "03") {
        alert("경로를 탑색할수 없습니다. 좌표를 확인하여 주십시오.");
      }
    }
    )
  }
```

## Reference link
https://www.npmjs.com/package/react-native-tmapsdk

https://www.npmjs.com/package/react-native-launch-tmap-navi