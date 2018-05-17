package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class main extends MovieClip {
		public var sdk;
		// please read http://docs.y8.com/docs/actionscript/ for details about this example
		private var appID = 'YOUR APP ID'; // your application id
		private var verbose = true; // display sdk messages
		private var showPreloader = false; // Display Traffic Flux preloader ad
		
		private var gameSave1 = {
			level: 31,
			health: 66,
			inventory: [
				['healthpotion', 9],
				['sword', 'beastmode']
			]
		};

		// Event listener to handle the buttons in the example
		private function handleDemoClicks(e:MouseEvent) {
			if (sdk) {
				// main buttons
				if (e.target.name == 'loginBut') {
					sdk.toggleInterface();
				}
				if (e.target.name == 'regBut') {
					sdk.toggleInterface('registration');
				}
				// Logout is for testing only, please do Not use it in games. Logout is handled through account.y8.com.
				if (e.target.name == 'logoutBut') {
					sdk.logout();
				}		
				// data save buttons
				if (e.target.name == 'setBut') {
					sdk.submitUserData('gameSave1', JSON.stringify(gameSave1));
				}
				if (e.target.name == 'getBut') {
					sdk.retrieveUserData('gameSave1');
				}
				if (e.target.name == 'deleteBut') {
					sdk.removeUserData('gameSave1');
				}
				// score buttons
				if(e.target.name == 'advancedScoreListBut'){
					sdk.advancedScoreList('Table Name');
				}
				var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
				if(e.target.name == 'advancedScoreSubmitBut'){
					sdk.advancedScoreSubmit(randScore, 'Table Name');
				}
				if(e.target.name == 'advancedScoreSubmitListBut'){
					sdk.advancedScoreSubmitList(randScore, 'Table Name');
				}
				if(e.target.name == 'advancedScoreListPlayerBut'){
					sdk.advancedScoreListPlayer('Table Name');
				}
				// achievements
				if(e.target.name == 'achievementListBut'){
					sdk.toggleInterface('achievements');
				}
				if(e.target.name == 'unlockBut'){
					sdk.achievementsSave('achievement name', 'achievementkey');
				}
				// player maps
				if(e.target.name == 'mapListBut'){
					sdk.toggleInterface('playerMaps');
				}
				if(e.target.name == 'mapSaveBut'){
					sdk.mapSave('Test Map', '{"testmap": [[0, 1],[1,0]]}');
				}
				if(e.target.name == 'mapLoadBut'){
					sdk.mapLoad('12312342sdfsdf');
				}
				if(e.target.name == 'mapRateBut'){
					sdk.mapRate('12312342sdfsdf', 10);
				}
				
				if(e.target.name == 'profileBut'){
					sdk.openProfile();
				}
			} else {
				log('Interface not loaded yet.');
			}
		}
		// handleSDK is where you will want to edit to send data to the rest of your application. 
		private function handleSDK(e:Event) {
			if (sdk.type == 'login') {
				log('hello '+sdk.userData.nickname+' your pid is '+sdk.userData.pid);
			}
			if (sdk.type == 'submit') {
				log('data submitted. status is '+sdk.data.status);
			}
			if (sdk.type == 'retrieve') {
				if (sdk.data.hasOwnProperty('error') === false) {
					log('LOG: data retrieved. key is '+sdk.data.key+' data is '+sdk.data.jsondata);
				} else {
					log('Error: '+sdk.data.error);
				}
			}
			if (sdk.type == 'delete'){
				log('deleted data '+sdk.data);
			}
	
			if (sdk.type == 'advancedScoreListPlayer'){
				log('player score: '+sdk.data.scores[0].points);
			}
			if (sdk.type == 'achievementsSave'){
				if(sdk.data.errorcode == 0){
					log('achievement unlocked');
				}
			}
			if (sdk.type == 'mapSave'){
				log('map saved. levelid is '+sdk.data.level.levelid);
			}
			if (sdk.type == 'mapLoad'){
				log(sdk.data.level.name+' loaded');
			}
			if (sdk.type == 'mapRate'){
				log('rating added');
			}
		}
		
		private function log(message){
			trace('LOG: '+message);
		}

		// Below is the loader for the Y8 interface. Do Not edit below.
		public function main() {
			Security.allowInsecureDomain('*');
			Security.allowDomain('*');
			addEventListener(MouseEvent.CLICK, handleDemoClicks);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onStage(e:Event):void {
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			if (Security.sandboxType != "localTrusted") {
				loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security 
			}
			var sdk_url:String = 'https://cdn.y8.com/swf/idnet-client.swc';
			var urlRequest:URLRequest = new URLRequest(sdk_url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
			loader.load(urlRequest, loaderContext);
		}

		function loadComplete(e:Event):void {
			sdk = e.currentTarget.content;
			sdk.addEventListener('IDNET', handleSDK);
			stage.addChild(sdk);
			sdk.init(stage, appID, '', verbose, showPreloader);
		}
	}
}