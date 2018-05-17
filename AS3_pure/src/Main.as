package {

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;

import view.MiniLabel;
import view.MiniPushButton;

[SWF(backgroundColor="#FEFEFE", width="800", height="600", frameRate="30")]

public class Main extends Sprite {

    public var sdk;
    // please read http://docs.y8.com/docs/actionscript/ for details about this example
    private var appID = ""; // your application id, can by found at https://account.y8.com/applications
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

    private var savedLevelid:String = "";

    public function Main() {
        if (appID == "") {
            throw Error("Please enter your appId. Example will not work without it.");
        }
        Security.allowInsecureDomain('*');
        Security.allowDomain('*');
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(event:Event):void {
        log("Loading sdk-client ...");
        var loaderContext:LoaderContext = new LoaderContext();
        loaderContext.applicationDomain = ApplicationDomain.currentDomain;
        if (Security.sandboxType != "localTrusted") {
            loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security
        }
        var sdk_url:String = "https://cdn.y8.com/swf/idnet-client.swc?=" + new Date().getTime();
        var urlRequest:URLRequest = new URLRequest(sdk_url);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSwcLoadCompleate, false, 0, true);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleSwcLoadFail);
        loader.load(urlRequest, loaderContext);
    }

    function handleSwcLoadCompleate(event:Event):void {
        log("... swc loaded!");
        sdk = event.currentTarget.content;
        sdk.addEventListener('IDNET', handleSDK);
        stage.addChild(sdk);
        sdk.init(stage, appID, '', verbose, showPreloader);

        // init test buttons.
        initView();
    }

    private function handleSwcLoadFail(event:IOErrorEvent):void {
        log("... swc load fail: " + event.text);
    }

    private function initView():void {
        // main buttons
        new MiniPushButton(this, 10, 10, "LOGIN", handleLoginClick);
        new MiniPushButton(this, 160, 10, "REGISTER", handleRegisterClick);
        // Logout is for testing only, please do Not use it in games. Logout is handled through id.net.
        new MiniPushButton(this, 650, 10, "LOGOUT", handleLogoutClick);

        // data save buttons
        new MiniLabel(this, 10, 65, "Data save:");
        new MiniPushButton(this, 10, 100, "Save data", handleSaveClick);
        new MiniPushButton(this, 10, 150, "Load data", handleLoadClick);
        new MiniPushButton(this, 10, 200, "Delete saved data", handleDeleteSaveClick);

        // score buttons
        new MiniLabel(this, 180, 65, "Advanced Scores:");
        new MiniPushButton(this, 180, 100, "List scores", handleListScoresClick);
        new MiniPushButton(this, 180, 150, "Submit score", handleSubmitScoreClick);
        new MiniPushButton(this, 180, 200, "Submit score & list", handleSumbitScoreAndListClick);
        new MiniPushButton(this, 180, 250, "Player list", handlePlayerListClick);

        // achievements
        new MiniLabel(this, 350, 65, "Achievements:");
        new MiniPushButton(this, 350, 100, "List achievements", handleListAchievementsClick);
        new MiniPushButton(this, 350, 150, "Unlock achievements", handleUnlockAchievementsClick);

        // player maps
        new MiniLabel(this, 520, 65, "Player Maps:");
        new MiniPushButton(this, 520, 100, "List player maps", handleListPlayerMapClick);
        new MiniPushButton(this, 520, 150, "Save map", handleSavePlayerMapClick);
        new MiniPushButton(this, 520, 200, "Load map", handleLoadPlayerMapClick);
        new MiniPushButton(this, 520, 250, "Rate map", handleRatePlayerListClick);
    }

    private function handleLoginClick(event:MouseEvent) {
        sdk.toggleInterface();
    }

    private function handleRegisterClick(event:MouseEvent) {
        sdk.toggleInterface('registration');
    }

    private function handleLogoutClick(event:MouseEvent) {
        sdk.logout();
    }


    private function handleSaveClick(event:MouseEvent) {
        sdk.submitUserData('gameSave1', JSON.stringify(gameSave1));
    }

    private function handleLoadClick(event:MouseEvent) {
        sdk.retrieveUserData('gameSave1');
    }

    private function handleDeleteSaveClick(event:MouseEvent) {
        sdk.removeUserData('gameSave1');
    }


    private function handleListScoresClick(event:MouseEvent) {
        sdk.advancedScoreList('Table Name');
    }

    private function handleSubmitScoreClick(event:MouseEvent) {
        var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
        sdk.advancedScoreSubmit(randScore, 'Table Name');
    }


    private function handleSumbitScoreAndListClick(event:MouseEvent) {
        var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
        sdk.advancedScoreSubmitList(randScore, 'Table Name');
    }

    private function handlePlayerListClick(event:MouseEvent) {
        sdk.advancedScoreListPlayer('Table Name');
    }


    private function handleListAchievementsClick(event:MouseEvent) {
        sdk.toggleInterface('achievements');
    }

    private function handleUnlockAchievementsClick(event:MouseEvent) {
        sdk.achievementsSave('achievement name', 'achievementkey');
    }


    private function handleListPlayerMapClick(event:MouseEvent) {
        sdk.toggleInterface('playerMaps');
    }

    private function handleSavePlayerMapClick(event:MouseEvent) {
        sdk.mapSave('Test Map3', '{"testmap": [[0, 1],[1,0]]}');
    }

    private function handleLoadPlayerMapClick(event:MouseEvent) {
        if (savedLevelid) {
            sdk.mapLoad(savedLevelid);
        } else {
            log("Please save level first.");
        }
    }

    private function handleRatePlayerListClick(event:MouseEvent) {
        if (savedLevelid) {
            sdk.mapRate(savedLevelid, 10);
        } else {
            log("Please save level first.");
        }
    }

    // handleSDK is where you will want to edit to send data to the rest of your application.
    private function handleSDK(event:Event) {
        if (sdk.type == 'login') {
            log('hello ' + sdk.userData.nickname + ' your pid is ' + sdk.userData.pid);
        }
        if (sdk.type == 'submit') {
            log('data submitted. status is ' + sdk.data.status);
        }
        if (sdk.type == 'retrieve') {
            if (sdk.data.hasOwnProperty('error') === false) {
                log('LOG: data retrieved. key is ' + sdk.data.key + ' data is ' + sdk.data.jsondata);
            } else {
                log('Error: ' + sdk.data.error);
            }
        }
        if (sdk.type == 'delete') {
            log('deleted data ' + sdk.data);
        }

        if (sdk.type == 'advancedScoreListPlayer') {
            log('player score: ' + sdk.data.scores[0].points);
        }
        if (sdk.type == 'achievementsSave') {
            if (sdk.data.errorcode == 0) {
                log('achievement unlocked');
            }
        }
        if (sdk.type == 'mapSave') {
            if (sdk.data.errorcode != 405) {
                savedLevelid = sdk.data.level.levelid;
                log('map saved. levelid is ' + sdk.data.level.levelid);
            } else {
                log("ERROR: level already exists.")
            }
        }
        if (sdk.type == 'mapLoad') {
            log(sdk.data.level.name + ' loaded');
        }
        if (sdk.type == 'mapRate') {
            log('rating added');
        }
    }

    private function log(message:String) {
        trace('LOG: ' + message);
    }

}
}