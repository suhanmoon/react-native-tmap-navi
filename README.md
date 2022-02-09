# react-native-launch-tmap-navi

## Getting started

`$ npm install react-native-tmap-navi --save`

### Mostly automatic installation

`$ react-native link react-native-launch-tmap-navi`

## Usage
```javascript
import LaunchTmapNavi from 'react-native-launch-tmap-navi';


let arrData = { destName : "서울특별시 광진구 광장동 248-2", destX : 127.103432, destY: 37.546394};
LaunchTmapNavi.navigate(arrData.destName, arrData.destY, arrData.destX).then(async(res) => {
		if(res == "02")
		{
			alert("설치된 내비가 없거나 내비 초기설정을\n완료하지 않았습니다.내비를 먼저 설치\n하시고 설정을 완료하여 주십시오.");

		}
		else if(res == "03")
		{
			alert("경로를 탑색할수 없습니다. 좌표를 확인하여 주십시오.");
		}	
	}
)
.catch(e => {
	alert("내비에 오류가 있어 사용할수 없습니다. 잠시후 다시 시도하여 주십시오.");
	console.log(e.message, e.code)
});	
