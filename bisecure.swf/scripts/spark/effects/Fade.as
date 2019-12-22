package spark.effects
{
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.mx_internal;
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.FadeInstance;
   
   use namespace mx_internal;
   
   public class Fade extends Animate
   {
       
      
      public var alphaFrom:Number;
      
      public var alphaTo:Number;
      
      public function Fade(param1:Object = null)
      {
         super(param1);
         instanceClass = FadeInstance;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
         var _loc2_:FadeInstance = FadeInstance(param1);
         _loc2_.alphaFrom = this.alphaFrom;
         _loc2_.alphaTo = this.alphaTo;
      }
      
      override public function getAffectedProperties() : Array
      {
         return ["alpha","visible","parent","index"];
      }
      
      override protected function getValueFromTarget(param1:Object, param2:String) : *
      {
         var _loc3_:* = undefined;
         if(param2 == "index" && "parent" in param1)
         {
            _loc3_ = param1.parent;
            if(_loc3_ === undefined || _loc3_ === null || "mask" in _loc3_ && _loc3_.mask == param1)
            {
               return undefined;
            }
            if(_loc3_ is IVisualElementContainer)
            {
               return IVisualElementContainer(_loc3_).getElementIndex(param1 as IVisualElement);
            }
            if("getChildIndex" in _loc3_)
            {
               return _loc3_.getChildIndex(param1);
            }
         }
         return super.getValueFromTarget(param1,param2);
      }
      
      override mx_internal function applyEndValues(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         super.applyEndValues(param1,param2);
         if(transitionInterruption && param1)
         {
            _loc3_ = param1.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = param1[_loc4_].target;
               if(this.targets.indexOf(_loc5_) >= 0 && (param1[_loc4_].start["parent"] !== undefined && param1[_loc4_].end["parent"] !== undefined && param1[_loc4_].start["parent"] != param1[_loc4_].end["parent"]) || param1[_loc4_].start["visible"] !== undefined && param1[_loc4_].end["visible"] !== undefined && param1[_loc4_].start["visible"] != param1[_loc4_].end["visible"])
               {
                  _loc5_.alpha = param1[_loc4_].end["alpha"] !== undefined?param1[_loc4_].end["alpha"]:1;
               }
               _loc4_++;
            }
         }
      }
      
      override protected function applyValueToTarget(param1:Object, param2:String, param3:*, param4:Object) : void
      {
         if(param2 == "parent" || param2 == "index")
         {
            return;
         }
         super.applyValueToTarget(param1,param2,param3,param4);
      }
      
      override mx_internal function captureValues(param1:Array, param2:Boolean, param3:Array = null) : Array
      {
         var _loc4_:Array = super.captureValues(param1,param2,param3);
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_[_loc6_].stripUnchangedValues != false)
            {
               if(_loc4_[_loc6_].start.hasOwnProperty("alpha"))
               {
                  if(_loc4_[_loc6_].start["alpha"] == _loc4_[_loc6_].end["alpha"] && this.alphaTo != _loc4_[_loc6_].end["alpha"])
                  {
                     _loc4_[_loc6_].stripUnchangedValues = false;
                  }
               }
            }
            _loc6_++;
         }
         return _loc4_;
      }
   }
}
