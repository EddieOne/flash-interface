package view {
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

public class MiniPushButton extends MovieClip {

    private var lable:MiniLabel;

    public function MiniPushButton(container:DisplayObjectContainer, startX:int, startY:int, labelText:String, handlerFunction:Function) {

        this.graphics.beginFill(0xEEEEEE);
        this.graphics.lineStyle(2, 0x0);
        this.graphics.moveTo(0, 0);
        this.graphics.lineTo(130, 0);
        this.graphics.lineTo(130, 25);
        this.graphics.lineTo(0, 25);
        this.graphics.lineTo(0, 0);
        this.graphics.endFill();

        this.x = startX;
        this.y = startY;

        this.addEventListener(MouseEvent.CLICK, handlerFunction);

        lable = new MiniLabel(this, 0, 4, labelText);

        container.addChild(this);

    }
}
}
