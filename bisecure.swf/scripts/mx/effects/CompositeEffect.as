package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.CompositeEffectInstance;
   import mx.effects.effectClasses.PropertyChanges;
   
   use namespace mx_internal;
   
   public class CompositeEffect extends Effect
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var childTargets:Array;
      
      private var _affectedProperties:Array;
      
      private var _children:Array;
      
      public function CompositeEffect(param1:Object = null)
      {
         this._children = [];
         super(param1);
         instanceClass = CompositeEffectInstance;
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function set children(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(this._children)
         {
            _loc2_ = 0;
            while(_loc2_ < this._children.length)
            {
               if(this._children[_loc2_])
               {
                  Effect(this._children[_loc2_]).parentCompositeEffect = null;
               }
               _loc2_++;
            }
         }
         this._children = param1;
         if(this._children)
         {
            _loc2_ = 0;
            while(_loc2_ < this._children.length)
            {
               if(this._children[_loc2_])
               {
                  Effect(this._children[_loc2_]).parentCompositeEffect = this;
               }
               _loc2_++;
            }
         }
      }
      
      public function get compositeDuration() : Number
      {
         return duration;
      }
      
      override public function getAffectedProperties() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this._affectedProperties)
         {
            _loc1_ = [];
            _loc2_ = this.children.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = _loc1_.concat(this.children[_loc3_].getAffectedProperties());
               _loc3_++;
            }
            this._affectedProperties = _loc1_;
         }
         return this._affectedProperties;
      }
      
      override public function createInstance(param1:Object = null) : IEffectInstance
      {
         if(!this.childTargets)
         {
            this.childTargets = [param1];
         }
         var _loc2_:IEffectInstance = super.createInstance(param1);
         this.childTargets = null;
         return _loc2_;
      }
      
      override public function createInstances(param1:Array = null) : Array
      {
         if(!param1)
         {
            param1 = this.targets;
         }
         this.childTargets = param1;
         var _loc2_:IEffectInstance = this.createInstance();
         this.childTargets = null;
         return !!_loc2_?[_loc2_]:[];
      }
      
      override protected function filterInstance(param1:Array, param2:Object) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(filterObject)
         {
            _loc3_ = targets;
            if(_loc3_.length == 0)
            {
               _loc3_ = this.childTargets;
            }
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(filterObject.filterInstance(param1,effectTargetHost,_loc3_[_loc5_]))
               {
                  return true;
               }
               _loc5_++;
            }
            return false;
         }
         return true;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Effect = null;
         super.initInstance(param1);
         var _loc2_:CompositeEffectInstance = CompositeEffectInstance(param1);
         var _loc3_:Object = this.childTargets;
         if(!(_loc3_ is Array))
         {
            _loc3_ = [_loc3_];
         }
         if(this.children)
         {
            _loc4_ = this.children.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = this.children[_loc5_];
               if(propertyChangesArray != null)
               {
                  _loc6_.propertyChangesArray = propertyChangesArray;
               }
               if(_loc6_.filterObject == null && filterObject)
               {
                  _loc6_.filterObject = filterObject;
               }
               if(effectTargetHost)
               {
                  _loc6_.effectTargetHost = effectTargetHost;
               }
               if(_loc6_.targets.length == 0)
               {
                  _loc2_.addChildSet(this.children[_loc5_].createInstances(_loc3_));
               }
               else
               {
                  _loc2_.addChildSet(this.children[_loc5_].createInstances(_loc6_.targets));
               }
               _loc5_++;
            }
         }
      }
      
      override public function captureStartValues() : void
      {
         var _loc1_:Array = this.getChildrenTargets();
         propertyChangesArray = [];
         var _loc2_:int = _loc1_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            propertyChangesArray.push(new PropertyChanges(_loc1_[_loc3_]));
            _loc3_++;
         }
         propertyChangesArray = this.captureValues(propertyChangesArray,true);
         endValuesCaptured = false;
      }
      
      override mx_internal function captureValues(param1:Array, param2:Boolean, param3:Array = null) : Array
      {
         var _loc6_:Effect = null;
         var _loc4_:int = this.children.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.children[_loc5_];
            param1 = _loc6_.captureValues(param1,param2,_loc6_.targets && _loc6_.targets.length > 0?_loc6_.targets:param3);
            _loc5_++;
         }
         return param1;
      }
      
      override mx_internal function applyStartValues(param1:Array, param2:Array) : void
      {
         var _loc5_:Effect = null;
         var _loc6_:Array = null;
         var _loc3_:int = this.children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.children[_loc4_];
            _loc6_ = _loc5_.targets.length > 0?_loc5_.targets:param2;
            if(_loc5_.filterObject == null && filterObject)
            {
               _loc5_.filterObject = filterObject;
            }
            _loc5_.applyStartValues(param1,_loc6_);
            _loc4_++;
         }
      }
      
      override mx_internal function applyEndValues(param1:Array, param2:Array) : void
      {
         var _loc5_:Effect = null;
         var _loc6_:Array = null;
         var _loc3_:int = this.children.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.children[_loc4_];
            _loc6_ = _loc5_.targets.length > 0?_loc5_.targets:param2;
            if(_loc5_.filterObject == null && filterObject)
            {
               _loc5_.filterObject = filterObject;
            }
            _loc5_.applyEndValues(param1,_loc6_);
            _loc4_++;
         }
      }
      
      override mx_internal function set transitionInterruption(param1:Boolean) : void
      {
         var _loc4_:Effect = null;
         super.transitionInterruption = param1;
         var _loc2_:int = this.children.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.children[_loc3_];
            _loc4_.transitionInterruption = param1;
            _loc3_++;
         }
      }
      
      public function addChild(param1:IEffect) : void
      {
         this.children.push(param1);
         this._affectedProperties = null;
         Effect(param1).parentCompositeEffect = this;
      }
      
      private function getChildrenTargets() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Effect = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:Object = {};
         _loc5_ = this.children.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = this.children[_loc6_];
            if(_loc4_ is CompositeEffect)
            {
               _loc3_ = CompositeEffect(_loc4_).getChildrenTargets();
               _loc7_ = _loc3_.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(_loc3_[_loc8_] != null && _loc1_.indexOf(_loc3_[_loc8_]) < 0)
                  {
                     _loc1_.push(_loc3_[_loc8_]);
                  }
                  _loc8_++;
               }
            }
            else if(_loc4_.targets != null)
            {
               _loc7_ = _loc4_.targets.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(_loc4_.targets[_loc8_] != null && _loc1_.indexOf(_loc4_.targets[_loc8_]) < 0)
                  {
                     _loc1_.push(_loc4_.targets[_loc8_]);
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         _loc5_ = targets.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            if(targets[_loc6_] != null && _loc1_.indexOf(targets[_loc6_]) < 0)
            {
               _loc1_.push(targets[_loc6_]);
            }
            _loc6_++;
         }
         return _loc1_;
      }
   }
}
