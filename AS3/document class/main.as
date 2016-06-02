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
		public var idnet;
		// please read http://dev.id.net/docs/actionscript/ for details about this example
		private var appID = 'YOUR APP ID'; // your application id
		private var verbose = true; // display idnet messages
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
			if (idnet) {
				// main buttons
				if (e.target.name == 'loginBut') {
					idnet.toggleInterface();
				}
				if (e.target.name == 'regBut') {
					idnet.toggleInterface('registration');
				}
				// Logout is for testing only, please do Not use it in games. Logout is handled through id.net.
				if (e.target.name == 'logoutBut') {
					idnet.logout();
				}		
				// data save buttons
				if (e.target.name == 'setBut') {
					idnet.submitUserData('gameSave1', JSON.stringify(gameSave1));
				}
				if (e.target.name == 'getBut') {
					idnet.retrieveUserData('gameSave1');
				}
				if (e.target.name == 'deleteBut') {
					idnet.removeUserData('gameSave1');
				}
				// score buttons
				if(e.target.name == 'advancedScoreListBut'){
					idnet.advancedScoreList('Table Name');
				}
				var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
				if(e.target.name == 'advancedScoreSubmitBut'){
					idnet.advancedScoreSubmit(randScore, 'Table Name');
				}
				if(e.target.name == 'advancedScoreSubmitListBut'){
					idnet.advancedScoreSubmitList(randScore, 'Table Name');
				}
				if(e.target.name == 'advancedScoreListPlayerBut'){
					idnet.advancedScoreListPlayer('Table Name');
				}
				// achievements
				if(e.target.name == 'achievementListBut'){
					idnet.toggleInterface('achievements');
				}
				if(e.target.name == 'unlockBut'){
					idnet.achievementsSave('achievement name', 'achievementkey');
				}
				// player maps
				if(e.target.name == 'mapListBut'){
					idnet.toggleInterface('playerMaps');
				}
				if(e.target.name == 'mapSaveBut'){
					idnet.mapSave('Test Map', '{"testmap": [[0, 1],[1,0]]}');
				}
				if(e.target.name == 'mapLoadBut'){
					idnet.mapLoad('12312342sdfsdf');
				}
				if(e.target.name == 'mapRateBut'){
					idnet.mapRate('12312342sdfsdf', 10);
				}
			} else {
				log('Interface not loaded yet.');
			}
		}
		// handleIDNET is where you will want to edit to send data to the rest of your application. 
		private function handleIDNET(e:Event) {
			if (idnet.type == 'login') {
				log('hello '+idnet.userData.nickname+' your pid is '+idnet.userData.pid);
			}
			if (idnet.type == 'submit') {
				log('data submitted. status is '+idnet.data.status);
			}
			if (idnet.type == 'retrieve') {
				if (idnet.data.hasOwnProperty('error') === false) {
					log('LOG: data retrieved. key is '+idnet.data.key+' data is '+idnet.data.jsondata);
				} else {
					log('Error: '+idnet.data.error);
				}
			}
			if (idnet.type == 'delete'){
				log('deleted data '+idnet.data);
			}
	
			if (idnet.type == 'advancedScoreListPlayer'){
				log('player score: '+idnet.data.scores[0].points);
			}
			if (idnet.type == 'achievementsSave'){
				if(idnet.data.errorcode == 0){
					log('achievement unlocked');
				}
			}
			if (idnet.type == 'mapSave'){
				log('map saved. levelid is '+idnet.data.level.levelid);
			}
			if (idnet.type == 'mapLoad'){
				log(idnet.data.level.name+' loaded');
			}
			if (idnet.type == 'mapRate'){
				log('rating added');
			}
		}
		
		private function log(message){
			trace('LOG: '+message);
		}

		// Below is the loader for the id.net interface. Do Not edit below.
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
			var sdk_url:String = 'https://scdn.id.net/swf/idnet-client.swc';
			var urlRequest:URLRequest = new URLRequest(sdk_url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
			loader.load(urlRequest, loaderContext);
		}

		function loadComplete(e:Event):void {
			idnet = e.currentTarget.content;
			idnet.addEventListener('IDNET', handleIDNET);
			stage.addChild(idnet);
			idnet.init(stage, appID, '', verbose, showPreloader);
		}
	}
}