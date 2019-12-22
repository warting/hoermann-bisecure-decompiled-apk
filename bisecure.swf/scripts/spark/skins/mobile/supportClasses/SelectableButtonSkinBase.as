package spark.skins.mobile.supportClasses
{
   import flash.display.DisplayObject;
   
   public class SelectableButtonSkinBase extends ButtonSkinBase
   {
      
      private static const symbols:Array = ["symbolIcon"];
       
      
      protected var upIconClass:Class;
      
      protected var upSelectedIconClass:Class;
      
      protected var downIconClass:Class;
      
      protected var downSelectedIconClass:Class;
      
      protected var upSymbolIconClass:Class;
      
      protected var upSymbolIconSelectedClass:Class;
      
      protected var downSymbolIconClass:Class;
      
      protected var downSymbolIconSelectedClass:Class;
      
      private var _symbolIcon:DisplayObject;
      
      public function SelectableButtonSkinBase()
      {
         super();
         layoutGap = 15;
         layoutPaddingLeft = 15;
         layoutPaddingRight = 15;
         layoutPaddingTop = 15;
         layoutPaddingBottom = 15;
         useIconStyle = false;
         useSymbolColor = true;
         useCenterAlignment = false;
      }
      
      public function get symbolIcon() : DisplayObject
      {
         return this._symbolIcon;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      override protected function get symbolItems() : Array
      {
         return symbols;
      }
      
      override protected function commitCurrentState() : void
      {
         var _loc1_:Class = null;
         var _loc2_:Class = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         super.commitCurrentState();
         if(currentState != null)
         {
            _loc1_ = this.upIconClass;
            _loc2_ = this.upSymbolIconClass;
            _loc3_ = false;
            if(currentState == "down")
            {
               _loc1_ = this.downIconClass;
               _loc2_ = this.downSymbolIconClass;
            }
            else if(currentState == "upAndSelected" || currentState == "disabledAndSelected")
            {
               _loc1_ = this.upSelectedIconClass;
               _loc2_ = this.upSymbolIconSelectedClass;
               _loc3_ = true;
            }
            else if(currentState == "downAndSelected")
            {
               _loc1_ = this.downSelectedIconClass;
               _loc2_ = this.downSymbolIconSelectedClass;
               _loc3_ = true;
            }
            setIcon(_loc1_);
            _loc4_ = this._symbolIcon && contains(this._symbolIcon);
            if(_loc4_)
            {
               if(_loc2_ == null || !(this._symbolIcon is _loc2_))
               {
                  removeChild(this._symbolIcon);
                  this._symbolIcon = null;
                  invalidateDisplayList();
               }
            }
            if(this._symbolIcon == null && _loc2_ != null)
            {
               _loc5_ = new _loc2_();
               if(_loc5_ is DisplayObject)
               {
                  this._symbolIcon = DisplayObject(_loc5_);
                  addChild(this._symbolIcon);
                  invalidateDisplayList();
               }
            }
         }
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc3_:DisplayObject = null;
         super.layoutContents(param1,param2);
         if(this._symbolIcon)
         {
            _loc3_ = getIconDisplay();
            setElementPosition(this._symbolIcon,_loc3_.x,_loc3_.y);
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
