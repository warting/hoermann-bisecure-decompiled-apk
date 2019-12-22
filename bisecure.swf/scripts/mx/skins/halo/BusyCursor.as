package mx.skins.halo
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.events.Event;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.mx_internal;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class BusyCursor extends FlexSprite
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var minuteHand:Shape;
      
      private var hourHand:Shape;
      
      public function BusyCursor(param1:IStyleManager2 = null)
      {
         var _loc7_:Graphics = null;
         super();
         if(!param1)
         {
            param1 = StyleManager.getStyleManager(null);
         }
         var _loc2_:CSSStyleDeclaration = param1.getMergedStyleDeclaration("mx.managers.CursorManager");
         var _loc3_:Class = _loc2_.getStyle("busyCursorBackground");
         var _loc4_:DisplayObject = new _loc3_();
         if(_loc4_ is InteractiveObject)
         {
            InteractiveObject(_loc4_).mouseEnabled = false;
         }
         addChild(_loc4_);
         var _loc5_:Number = -0.5;
         var _loc6_:Number = -0.5;
         this.minuteHand = new FlexShape();
         this.minuteHand.name = "minuteHand";
         _loc7_ = this.minuteHand.graphics;
         _loc7_.beginFill(0);
         _loc7_.moveTo(_loc5_,_loc6_);
         _loc7_.lineTo(1 + _loc5_,0 + _loc6_);
         _loc7_.lineTo(1 + _loc5_,5 + _loc6_);
         _loc7_.lineTo(0 + _loc5_,5 + _loc6_);
         _loc7_.lineTo(0 + _loc5_,0 + _loc6_);
         _loc7_.endFill();
         addChild(this.minuteHand);
         this.hourHand = new FlexShape();
         this.hourHand.name = "hourHand";
         _loc7_ = this.hourHand.graphics;
         _loc7_.beginFill(0);
         _loc7_.moveTo(_loc5_,_loc6_);
         _loc7_.lineTo(4 + _loc5_,0 + _loc6_);
         _loc7_.lineTo(4 + _loc5_,1 + _loc6_);
         _loc7_.lineTo(0 + _loc5_,1 + _loc6_);
         _loc7_.lineTo(0 + _loc5_,0 + _loc6_);
         _loc7_.endFill();
         addChild(this.hourHand);
         addEventListener(Event.ADDED,this.handleAdded);
         addEventListener(Event.REMOVED,this.handleRemoved);
      }
      
      private function handleAdded(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function handleRemoved(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         this.minuteHand.rotation = this.minuteHand.rotation + 12;
         this.hourHand.rotation = this.hourHand.rotation + 1;
      }
   }
}
