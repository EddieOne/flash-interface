package view {
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class MiniLabel extends MovieClip {
    public function MiniLabel(container:DisplayObjectContainer, startX:int, startY:int, text:String) {

        this.mouseEnabled = false;
        this.mouseChildren = false;

        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 10;
        myFormat.align = TextFormatAlign.CENTER;
        myFormat.font = "Verdana";

        var myText:TextField = new TextField();
        myText.defaultTextFormat = myFormat;
        myText.antiAliasType = AntiAliasType.ADVANCED;
        myText.text = text;
        addChild(myText);

        myText.width = 130;
        myText.height = 25;

        myText.x = startX;
        myText.y = startY;

        container.addChild(this);
    }
}
}
