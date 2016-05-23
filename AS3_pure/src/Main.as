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

    public var idnet;
    // please read http://dev.id.net/docs/actionscript/ for details about this example
    private var appID = "57423eb4d559301ed10161f6"; // your application id
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

    private var savedLevelid:String = "";

    public function Main() {
        Security.allowInsecureDomain('*');
        Security.allowDomain('*');
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(event:Event):void {
        log("Loading idnet-client.swc ...");
        var loaderContext:LoaderContext = new LoaderContext();
        loaderContext.applicationDomain = ApplicationDomain.currentDomain;
        if (Security.sandboxType != "localTrusted") {
            loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security
        }
        var sdk_url:String = "https://www.id.net/swf/idnet-client.swc?=" + new Date().getTime();
        var urlRequest:URLRequest = new URLRequest(sdk_url);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSwcLoadCompleate, false, 0, true);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleSwcLoadFail);
        loader.load(urlRequest, loaderContext);
    }

    function handleSwcLoadCompleate(event:Event):void {
        log("... swc loaded!");
        idnet = event.currentTarget.content;
        idnet.addEventListener('IDNET', handleIDNET);
        stage.addChild(idnet);
        idnet.init(stage, appID, '', verbose, showPreloader);

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
        idnet.toggleInterface();
    }

    private function handleRegisterClick(event:MouseEvent) {
        idnet.toggleInterface('registration');
    }

    private function handleLogoutClick(event:MouseEvent) {
        idnet.logout();
    }


    private function handleSaveClick(event:MouseEvent) {
        idnet.submitUserData('gameSave1', JSON.stringify(gameSave1));
    }

    private function handleLoadClick(event:MouseEvent) {
        idnet.retrieveUserData('gameSave1');
    }

    private function handleDeleteSaveClick(event:MouseEvent) {
        idnet.removeUserData('gameSave1');
    }


    private function handleListScoresClick(event:MouseEvent) {
        idnet.advancedScoreList('Table Name');
    }

    private function handleSubmitScoreClick(event:MouseEvent) {
        var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
        idnet.advancedScoreSubmit(randScore, 'Table Name');
    }


    private function handleSumbitScoreAndListClick(event:MouseEvent) {
        var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
        idnet.advancedScoreSubmitList(randScore, 'Table Name');
    }

    private function handlePlayerListClick(event:MouseEvent) {
        idnet.advancedScoreListPlayer('Table Name');
    }


    private function handleListAchievementsClick(event:MouseEvent) {
        idnet.toggleInterface('achievements');
    }

    private function handleUnlockAchievementsClick(event:MouseEvent) {
        idnet.achievementsSave('achievement name', 'achievementkey');
    }


    private function handleListPlayerMapClick(event:MouseEvent) {
        idnet.toggleInterface('playerMaps');
    }

    private function handleSavePlayerMapClick(event:MouseEvent) {
        idnet.mapSave('Test Map3', '{"testmap": [[0, 1],[1,0]]}');
    }

    private function handleLoadPlayerMapClick(event:MouseEvent) {
        if (savedLevelid) {
            idnet.mapLoad(savedLevelid);
        } else {
            log("Please save level first.");
        }
    }

    private function handleRatePlayerListClick(event:MouseEvent) {
        if (savedLevelid) {
            idnet.mapRate(savedLevelid, 10);
        } else {
            log("Please save level first.");
        }
    }

    // handleIDNET is where you will want to edit to send data to the rest of your application.
    private function handleIDNET(event:Event) {
        if (idnet.type == 'login') {
            log('hello ' + idnet.userData.nickname + ' your pid is ' + idnet.userData.pid);
        }
        if (idnet.type == 'submit') {
            log('data submitted. status is ' + idnet.data.status);
        }
        if (idnet.type == 'retrieve') {
            if (idnet.data.hasOwnProperty('error') === false) {
                log('LOG: data retrieved. key is ' + idnet.data.key + ' data is ' + idnet.data.jsondata);
            } else {
                log('Error: ' + idnet.data.error);
            }
        }
        if (idnet.type == 'delete') {
            log('deleted data ' + idnet.data);
        }

        if (idnet.type == 'advancedScoreListPlayer') {
            log('player score: ' + idnet.data.scores[0].points);
        }
        if (idnet.type == 'achievementsSave') {
            if (idnet.data.errorcode == 0) {
                log('achievement unlocked');
            }
        }
        if (idnet.type == 'mapSave') {
            if (idnet.data.errorcode != 405) {
                savedLevelid = idnet.data.level.levelid;
                log('map saved. levelid is ' + idnet.data.level.levelid);
            } else {
                log("ERROR: level already exists.")
            }
        }
        if (idnet.type == 'mapLoad') {
            log(idnet.data.level.name + ' loaded');
        }
        if (idnet.type == 'mapRate') {
            log('rating added');
        }
    }

    private function log(message:String) {
        trace('LOG: ' + message);
    }

}
}