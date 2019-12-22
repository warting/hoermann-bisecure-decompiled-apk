package com.isisic.remote.hoermann.views.notifications
{
   import flash.geom.Point;
   import flash.text.engine.FontWeight;
   import flashx.textLayout.formats.VerticalAlign;
   import mx.core.IVisualElement;
   import spark.components.Group;
   import spark.components.Label;
   import spark.primitives.Graphic;
   
   public class NotificationIcon extends Group
   {
       
      
      private var _baseIcon:IVisualElement;
      
      private var infoDisplay:Graphic;
      
      private var infoLabel:Label;
      
      private var _info:String;
      
      private var displayType:String;
      
      public function NotificationIcon(param1:IVisualElement, param2:String = "circle")
      {
         super();
         this.baseIcon = param1;
         this.displayType = param2;
         this.infoDisplay = new Graphic();
         this.infoDisplay.depth = 1;
         addElement(this.infoDisplay);
         this.infoLabel = new Label();
         this.infoLabel.depth = 2;
         if(param2 == "circle")
         {
            this.infoLabel.right = -4;
            this.infoLabel.top = -4;
         }
         else
         {
            this.infoLabel.right = 0;
            this.infoLabel.top = 0;
            this.infoLabel.bottom = 0;
            this.infoLabel.setStyle("paddingLeft",5);
            this.infoLabel.setStyle("paddingRight",5);
            this.infoLabel.setStyle("verticalAlign",VerticalAlign.MIDDLE);
         }
         this.infoLabel.setStyle("paddingBottom",1);
         this.infoLabel.setStyle("paddingTop",5);
         this.infoLabel.setStyle("color",16777215);
         this.infoLabel.setStyle("fontWeight",FontWeight.BOLD);
         addElement(this.infoLabel);
      }
      
      public function set baseIcon(param1:IVisualElement) : void
      {
         if(this._baseIcon == param1)
         {
            return;
         }
         if(param1 == null)
         {
            if(this._baseIcon != null)
            {
               removeElement(this._baseIcon);
            }
            this._baseIcon = null;
            return;
         }
         this._baseIcon = param1;
         this._baseIcon.depth = 0;
         super.addElement(this._baseIcon);
      }
      
      public function get baseIcon() : IVisualElement
      {
         return this._baseIcon;
      }
      
      public function get info() : String
      {
         return this._info;
      }
      
      public function set info(param1:String) : void
      {
         if(param1 == this._info)
         {
            return;
         }
         this._info = param1;
         this.infoLabel.text = this.info;
         this.updateInfo();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.infoLabel.setStyle("fontSize",getStyle("circleFontSize"));
         this.updateInfo();
      }
      
      private function updateInfo() : void
      {
         this.infoDisplay.graphics.clear();
         if(this.info == null || this.info == "")
         {
            return;
         }
         switch(this.displayType)
         {
            case "circle":
               this.drawCircle();
               break;
            case "rect":
               this.drawRect();
         }
      }
      
      private function drawRect() : void
      {
         this.infoDisplay.graphics.beginFill(13382417);
         this.infoDisplay.graphics.drawRoundRect(this.infoLabel.x,this.infoLabel.y,this.infoLabel.width,this.infoLabel.height,10);
         this.infoDisplay.graphics.endFill();
      }
      
      private function drawCircle() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(this.infoLabel.width < this.infoLabel.height)
         {
            _loc1_ = new Point(this.infoLabel.x + this.infoLabel.width / 2,this.infoLabel.y + this.infoLabel.height / 2);
            this.infoDisplay.graphics.beginFill(13382417);
            this.infoDisplay.graphics.drawCircle(_loc1_.x,_loc1_.y,this.infoLabel.height / 2);
            this.infoDisplay.graphics.endFill();
         }
         else
         {
            _loc2_ = new Point(this.infoLabel.x + this.infoLabel.height * 0.25,this.infoLabel.y + this.infoLabel.height / 2);
            _loc3_ = new Point(this.infoLabel.x + this.infoLabel.width - this.infoLabel.height * 0.25,this.infoLabel.y + this.infoLabel.height / 2);
            this.infoDisplay.graphics.beginFill(13382417);
            this.infoDisplay.graphics.drawCircle(_loc2_.x,_loc2_.y,this.infoLabel.height / 2);
            this.infoDisplay.graphics.beginFill(13382417);
            this.infoDisplay.graphics.drawCircle(_loc3_.x,_loc3_.y,this.infoLabel.height / 2);
            this.infoDisplay.graphics.beginFill(13382417);
            this.infoDisplay.graphics.drawRect(_loc2_.x,this.infoLabel.y,_loc3_.x - _loc2_.x,this.infoLabel.height);
            this.infoDisplay.graphics.endFill();
         }
      }
   }
}
