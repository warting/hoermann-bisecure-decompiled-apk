package spark.effects
{
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import mx.core.ILayoutElement;
   import mx.core.mx_internal;
   import mx.effects.CompositeEffect;
   import mx.effects.Effect;
   import mx.effects.IEffectInstance;
   import mx.effects.Parallel;
   import mx.effects.Sequence;
   import mx.events.EffectEvent;
   import mx.geom.TransformOffsets;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.easing.Linear;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   use namespace mx_internal;
   
   public class AnimateTransform extends Animate
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var AFFECTED_PROPERTIES:Array = ["translationX","translationY","translationZ","rotationX","rotationY","rotationZ","scaleX","scaleY","scaleZ","postLayoutTranslationX","postLayoutTranslationY","postLayoutTranslationZ","postLayoutRotationX","postLayoutRotationY","postLayoutRotationZ","postLayoutScaleX","postLayoutScaleY","postLayoutScaleZ","left","right","top","bottom","horizontalCenter","verticalCenter","baseline","width","height"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","horizontalCenter","verticalCenter","baseline"];
      
      private static var linearEaser:Linear = new Linear();
      
      private static var appliedStartValuesPerTarget:Dictionary = new Dictionary(true);
      
      private static var appliedEndValuesPerTarget:Dictionary = new Dictionary(true);
      
      private static var sharedObjectDepot:SharedObjectDepot = new SharedObjectDepot();
      
      private static var scale:Vector3D = new Vector3D();
      
      private static var rotation:Vector3D = new Vector3D();
      
      private static var position:Vector3D = new Vector3D();
      
      private static var offsetRotation:Vector3D = new Vector3D();
      
      private static var offsetTranslation:Vector3D = new Vector3D();
      
      private static var offsetScale:Vector3D = new Vector3D();
      
      private static var xformPosition:Vector3D = new Vector3D();
      
      private static var postLayoutPosition:Vector3D = new Vector3D();
       
      
      mx_internal var transformEffectSubclass:Boolean = false;
      
      private var _applyChangesPostLayout:Boolean = false;
      
      public var autoCenterTransform:Boolean = false;
      
      public var transformX:Number;
      
      public var transformY:Number;
      
      public var transformZ:Number;
      
      public function AnimateTransform(param1:Object = null)
      {
         super(param1);
         instanceClass = AnimateTransformInstance;
      }
      
      public function get applyChangesPostLayout() : Boolean
      {
         return this._applyChangesPostLayout;
      }
      
      public function set applyChangesPostLayout(param1:Boolean) : void
      {
         this._applyChangesPostLayout = param1;
      }
      
      private function getOwningParallelEffect() : Parallel
      {
         var _loc1_:Parallel = null;
         var _loc2_:Effect = parentCompositeEffect;
         while(_loc2_)
         {
            if(_loc2_ is Sequence)
            {
               break;
            }
            _loc1_ = Parallel(_loc2_);
            _loc2_ = _loc2_.parentCompositeEffect;
         }
         return _loc1_;
      }
      
      override public function createInstance(param1:Object = null) : IEffectInstance
      {
         var _loc5_:IEffectInstance = null;
         if(!param1)
         {
            param1 = this.target;
         }
         var _loc2_:Effect = parentCompositeEffect;
         var _loc3_:IEffectInstance = null;
         var _loc4_:Parallel = this.getOwningParallelEffect();
         if(_loc4_ != null)
         {
            _loc3_ = IEffectInstance(sharedObjectDepot.getSharedObject(_loc4_,param1));
         }
         if(!_loc3_)
         {
            _loc5_ = super.createInstance(param1);
            if(_loc4_)
            {
               sharedObjectDepot.storeSharedObject(_loc4_,param1,_loc5_);
            }
            return _loc5_;
         }
         this.initInstance(_loc3_);
         return null;
      }
      
      override protected function effectStartHandler(param1:EffectEvent) : void
      {
         super.effectStartHandler(param1);
         var _loc2_:Parallel = this.getOwningParallelEffect();
         if(_loc2_ != null)
         {
            sharedObjectDepot.removeSharedObject(_loc2_,param1.effectInstance.target);
         }
         delete appliedStartValuesPerTarget[param1.effectInstance.target];
         delete appliedEndValuesPerTarget[param1.effectInstance.target];
      }
      
      override mx_internal function captureValues(param1:Array, param2:Boolean, param3:Array = null) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Vector3D = null;
         var _loc9_:TransformOffsets = null;
         param1 = super.captureValues(param1,param2,param3);
         _loc6_ = param1.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param1[_loc5_].target;
            if(param3 == null || param3.length == 0 || param3.indexOf(_loc7_) >= 0)
            {
               if(!(!(_loc7_ is ILayoutElement) || !_loc7_.parent && param2))
               {
                  _loc4_ = !!param2?param1[_loc5_].start:param1[_loc5_].end;
                  _loc8_ = this.computeTransformCenterForTarget(_loc7_,_loc4_);
                  if(_loc4_.translationX === undefined || _loc4_.translationY === undefined || _loc4_.translationZ === undefined)
                  {
                     param1[_loc5_].stripUnchangedValues = false;
                     _loc7_.transformPointToParent(_loc8_,xformPosition,null);
                     _loc4_.translationX = xformPosition.x;
                     _loc4_.translationY = xformPosition.y;
                     _loc4_.translationZ = xformPosition.z;
                  }
                  if((this.applyChangesPostLayout || this.postLayoutTransformPropertiesSet) && _loc7_.postLayoutTransformOffsets == null)
                  {
                     _loc7_.postLayoutTransformOffsets = new TransformOffsets();
                  }
                  if(_loc7_.postLayoutTransformOffsets != null)
                  {
                     _loc9_ = _loc7_.postLayoutTransformOffsets;
                     _loc4_.postLayoutRotationX = _loc9_.rotationX;
                     _loc4_.postLayoutRotationY = _loc9_.rotationY;
                     _loc4_.postLayoutRotationZ = _loc9_.rotationZ;
                     _loc4_.postLayoutScaleX = _loc9_.scaleX;
                     _loc4_.postLayoutScaleY = _loc9_.scaleY;
                     _loc4_.postLayoutScaleZ = _loc9_.scaleZ;
                     if(_loc4_.postLayoutTranslationX === undefined || _loc4_.postLayoutTranslationY === undefined || _loc4_.postLayoutTranslationZ === undefined)
                     {
                        param1[_loc5_].stripUnchangedValues = false;
                        _loc7_.transformPointToParent(_loc8_,null,postLayoutPosition);
                        _loc4_.postLayoutTranslationX = postLayoutPosition.x;
                        _loc4_.postLayoutTranslationY = postLayoutPosition.y;
                        _loc4_.postLayoutTranslationZ = postLayoutPosition.z;
                     }
                  }
               }
            }
            _loc5_++;
         }
         return param1;
      }
      
      private function computeTransformCenterForTarget(param1:Object, param2:Object = null) : Vector3D
      {
         var _loc3_:Vector3D = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.autoCenterTransform)
         {
            _loc4_ = param2 != null && param2["width"] !== undefined?Number(param2["width"]):Number(param1.width);
            _loc5_ = param2 != null && param2["height"] !== undefined?Number(param2["height"]):Number(param1.height);
            _loc3_ = new Vector3D(_loc4_ / 2,_loc5_ / 2,0);
         }
         else
         {
            _loc3_ = new Vector3D(param1.transformX,param1.transformY,param1.transformZ);
            if(!isNaN(this.transformX))
            {
               _loc3_.x = this.transformX;
            }
            if(!isNaN(this.transformY))
            {
               _loc3_.y = this.transformY;
            }
            if(!isNaN(this.transformZ))
            {
               _loc3_.z = this.transformZ;
            }
         }
         return _loc3_;
      }
      
      private function applyValues(param1:Array, param2:Array, param3:Boolean) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Boolean = false;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Vector3D = null;
         var _loc16_:Vector3D = null;
         var _loc17_:Vector3D = null;
         var _loc18_:Vector3D = null;
         var _loc19_:Vector3D = null;
         var _loc20_:Vector3D = null;
         var _loc21_:Vector3D = null;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         var _loc4_:Dictionary = !!param3?appliedStartValuesPerTarget:appliedEndValuesPerTarget;
         var _loc5_:int = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = param1[_loc6_].target;
            _loc10_ = false;
            if(!_loc4_[_loc9_])
            {
               _loc7_ = param2.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(param2[_loc8_] == _loc9_)
                  {
                     _loc10_ = filterInstance(param1,_loc9_);
                     break;
                  }
                  _loc8_++;
               }
               if(_loc10_)
               {
                  _loc11_ = AFFECTED_PROPERTIES;
                  _loc12_ = !!param3?param1[_loc6_].start:param1[_loc6_].end;
                  _loc13_ = !!param3?param1[_loc6_].end:param1[_loc6_].start;
                  _loc14_ = {
                     "rotationX":NaN,
                     "rotationY":NaN,
                     "rotation":NaN,
                     "scaleX":NaN,
                     "scaleY":NaN,
                     "scaleZ":NaN,
                     "translationX":NaN,
                     "translationY":NaN,
                     "translationZ":NaN
                  };
                  _loc7_ = _loc11_.length;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_)
                  {
                     _loc23_ = _loc11_[_loc8_];
                     if(_loc23_ in _loc12_ && (_loc23_ == "translationX" || _loc23_ == "translationY" || _loc23_.indexOf("postLayout") == 0 || _loc12_[_loc23_] != _loc13_[_loc23_]))
                     {
                        _loc14_[_loc23_] = _loc12_[_loc23_];
                     }
                     _loc8_++;
                  }
                  _loc15_ = this.computeTransformCenterForTarget(_loc9_,_loc12_);
                  _loc16_ = null;
                  _loc17_ = null;
                  _loc18_ = null;
                  _loc19_ = null;
                  _loc20_ = null;
                  _loc21_ = null;
                  _loc22_ = false;
                  if(!isNaN(_loc14_.scaleX) || !isNaN(_loc14_.scaleY) || !isNaN(_loc14_.scaleZ))
                  {
                     scale.x = !isNaN(_loc14_.scaleX)?Number(_loc14_.scaleX):Number(_loc9_["scaleX"]);
                     scale.y = !isNaN(_loc14_.scaleY)?Number(_loc14_.scaleY):Number(_loc9_["scaleY"]);
                     scale.z = !isNaN(_loc14_.scaleZ)?Number(_loc14_.scaleZ):Number(_loc9_["scaleZ"]);
                     _loc16_ = scale;
                  }
                  if(!isNaN(_loc14_.rotationX) || !isNaN(_loc14_.rotationY) || !isNaN(_loc14_.rotationZ))
                  {
                     rotation.x = !isNaN(_loc14_.rotationX)?Number(_loc14_.rotationX):Number(_loc9_["rotationX"]);
                     rotation.y = !isNaN(_loc14_.rotationY)?Number(_loc14_.rotationY):Number(_loc9_["rotationY"]);
                     rotation.z = !isNaN(_loc14_.rotationZ)?Number(_loc14_.rotationZ):Number(_loc9_["rotationZ"]);
                     _loc18_ = rotation;
                  }
                  position.x = _loc14_.translationX;
                  position.y = _loc14_.translationY;
                  position.z = _loc14_.translationZ;
                  if(isNaN(position.x) || isNaN(position.y) || isNaN(position.z))
                  {
                     _loc9_.transformPointToParent(_loc15_,xformPosition,postLayoutPosition);
                     _loc22_ = true;
                     if(isNaN(position.x))
                     {
                        position.x = xformPosition.x;
                     }
                     if(isNaN(position.y))
                     {
                        position.y = xformPosition.y;
                     }
                     if(isNaN(position.z))
                     {
                        position.z = xformPosition.z;
                     }
                  }
                  if(_loc9_.postLayoutTransformOffsets != null)
                  {
                     offsetRotation.x = !isNaN(_loc14_.postLayoutRotationX)?Number(_loc14_.postLayoutRotationX):Number(0);
                     offsetRotation.y = !isNaN(_loc14_.postLayoutRotationY)?Number(_loc14_.postLayoutRotationY):Number(0);
                     offsetRotation.z = !isNaN(_loc14_.postLayoutRotationZ)?Number(_loc14_.postLayoutRotationZ):Number(0);
                     _loc20_ = offsetRotation;
                     offsetScale.x = !isNaN(_loc14_.postLayoutScaleX)?Number(_loc14_.postLayoutScaleX):Number(1);
                     offsetScale.y = !isNaN(_loc14_.postLayoutScaleY)?Number(_loc14_.postLayoutScaleY):Number(1);
                     offsetScale.z = !isNaN(_loc14_.postLayoutScaleZ)?Number(_loc14_.postLayoutScaleZ):Number(1);
                     _loc21_ = offsetScale;
                     offsetTranslation.x = _loc14_.postLayoutTranslationX;
                     offsetTranslation.y = _loc14_.postLayoutTranslationY;
                     offsetTranslation.z = _loc14_.postLayoutTranslationZ;
                     if(isNaN(offsetTranslation.x) || isNaN(offsetTranslation.y) || isNaN(offsetTranslation.z))
                     {
                        if(_loc22_ == false)
                        {
                           _loc9_.transformPointToParent(_loc15_,xformPosition,postLayoutPosition);
                           _loc22_ = true;
                        }
                        if(isNaN(offsetTranslation.x))
                        {
                           offsetTranslation.x = postLayoutPosition.x;
                        }
                        if(isNaN(offsetTranslation.y))
                        {
                           offsetTranslation.y = postLayoutPosition.y;
                        }
                        if(isNaN(offsetTranslation.z))
                        {
                           offsetTranslation.z = postLayoutPosition.z;
                        }
                     }
                     _loc19_ = offsetTranslation;
                  }
                  _loc9_.transformAround(_loc15_,_loc16_,_loc18_,position,_loc21_,_loc20_,_loc19_);
                  _loc4_[_loc9_] = true;
               }
            }
            _loc6_++;
         }
      }
      
      override mx_internal function applyStartValues(param1:Array, param2:Array) : void
      {
         this.applyValues(param1,param2,true);
         super.applyStartValues(param1,param2);
      }
      
      override mx_internal function applyEndValues(param1:Array, param2:Array) : void
      {
         if(applyTransitionEndProperties)
         {
            this.applyValues(param1,param2,false);
            super.applyEndValues(param1,param2);
         }
      }
      
      override protected function applyValueToTarget(param1:Object, param2:String, param3:*, param4:Object) : void
      {
         if(param2 == "translationX" || param2 == "translationY" || param2 == "translationZ" || param2 == "rotationX" || param2 == "rotationY" || param2 == "rotationZ" || param2 == "scaleX" || param2 == "scaleY" || param2 == "scaleZ" || param2 == "postLayoutTranslationX" || param2 == "postLayoutTranslationY" || param2 == "postLayoutTranslationZ" || param2 == "postLayoutRotationX" || param2 == "postLayoutRotationY" || param2 == "postLayoutRotationZ" || param2 == "postLayoutScaleX" || param2 == "postLayoutScaleY" || param2 == "postLayoutScaleZ" || param2 == "width" || param2 == "height")
         {
            return;
         }
         super.applyValueToTarget(param1,param2,param3,param4);
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
      }
      
      private function insertKeyframe(param1:Vector.<Keyframe>, param2:Keyframe) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].time > param2.time)
            {
               param1.splice(_loc3_,0,param2);
               return;
            }
            _loc3_++;
         }
         param1.push(param2);
      }
      
      mx_internal function addMotionPath(param1:String, param2:Number = NaN, param3:Number = NaN, param4:Number = NaN) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:MotionPath = null;
         var _loc9_:int = 0;
         if(isNaN(param2))
         {
            if(!isNaN(param3) && !isNaN(param4))
            {
               param2 = param3 - param4;
            }
         }
         var _loc5_:MotionPath = new MotionPath(param1);
         _loc5_.keyframes = new <Keyframe>[new Keyframe(0,param2),new Keyframe(duration,param3,param4)];
         _loc5_.keyframes[1].easer = easer;
         if(motionPaths)
         {
            _loc6_ = motionPaths.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = MotionPath(motionPaths[_loc7_]);
               if(_loc8_.property == _loc5_.property)
               {
                  _loc9_ = 0;
                  while(_loc9_ < _loc5_.keyframes.length)
                  {
                     this.insertKeyframe(_loc8_.keyframes,_loc5_.keyframes[_loc9_]);
                     _loc9_++;
                  }
                  return;
               }
               _loc7_++;
            }
         }
         else
         {
            motionPaths = new Vector.<MotionPath>();
         }
         motionPaths.push(_loc5_);
      }
      
      private function isValidValue(param1:Object) : Boolean
      {
         return param1 is Number && !isNaN(Number(param1)) || !(param1 is Number) && param1 !== null;
      }
      
      private function get postLayoutTransformPropertiesSet() : Boolean
      {
         var _loc1_:int = 0;
         if(motionPaths)
         {
            _loc1_ = 0;
            while(_loc1_ < motionPaths.length)
            {
               if(motionPaths[_loc1_].property.indexOf("postLayout",0) == 0)
               {
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         var _loc2_:int = 0;
         var _loc6_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:MotionPath = null;
         var _loc12_:int = 0;
         var _loc13_:Keyframe = null;
         var _loc3_:Number = duration;
         var _loc4_:Object = param1.target;
         var _loc5_:AnimateTransformInstance = AnimateTransformInstance(param1);
         if(this.postLayoutTransformPropertiesSet)
         {
            if(_loc4_.postLayoutTransformOffsets == null)
            {
               _loc4_.postLayoutTransformOffsets = new TransformOffsets();
            }
         }
         if(motionPaths)
         {
            _loc9_ = [];
            _loc2_ = 0;
            while(_loc2_ < motionPaths.length)
            {
               _loc9_[_loc2_] = motionPaths[_loc2_].clone();
               _loc11_ = MotionPath(_loc9_[_loc2_]);
               if(_loc11_.keyframes)
               {
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_.keyframes.length)
                  {
                     _loc13_ = Keyframe(_loc11_.keyframes[_loc12_]);
                     if(isNaN(_loc13_.time))
                     {
                        _loc13_.time = duration;
                     }
                     if(startDelay != 0)
                     {
                        _loc13_.time = _loc13_.time + startDelay;
                     }
                     _loc12_++;
                  }
                  _loc3_ = Math.max(_loc3_,_loc11_.keyframes[_loc11_.keyframes.length - 1].time);
               }
               _loc2_++;
            }
            _loc10_ = this.getGlobalStartTime();
            _loc2_ = 0;
            while(_loc2_ < _loc9_.length)
            {
               _loc5_.addMotionPath(_loc9_[_loc2_],_loc10_);
               _loc2_++;
            }
         }
         for each(_loc6_ in this.getAffectedProperties())
         {
            if(this.relevantStyles.indexOf(_loc6_) < 0)
            {
               _loc5_.affectedProperties[_loc6_] = _loc6_;
            }
         }
         for each(_loc6_ in this.relevantStyles)
         {
            _loc5_.layoutConstraints[_loc6_] = _loc6_;
         }
         if(_loc5_.initialized)
         {
            return;
         }
         _loc5_.initialized = true;
         if(!this.autoCenterTransform)
         {
            _loc5_.transformCenter = this.computeTransformCenterForTarget(param1.target);
         }
         _loc5_.autoCenterTransform = this.autoCenterTransform;
         var _loc7_:Number = startDelay;
         startDelay = 0;
         var _loc8_:Vector.<MotionPath> = motionPaths;
         motionPaths = null;
         super.initInstance(param1);
         startDelay = _loc7_;
         motionPaths = _loc8_;
         _loc5_.duration = Math.max(duration,_loc3_);
         if(this.transformEffectSubclass)
         {
            _loc5_.easer = linearEaser;
         }
      }
      
      private function getGlobalStartTime() : Number
      {
         var _loc3_:Sequence = null;
         var _loc4_:int = 0;
         var _loc5_:Effect = null;
         var _loc1_:Number = 0;
         var _loc2_:Effect = parentCompositeEffect;
         while(_loc2_)
         {
            _loc1_ = _loc1_ + _loc2_.startDelay;
            if(_loc2_ is Sequence)
            {
               _loc3_ = Sequence(_loc2_);
               _loc4_ = 0;
               while(_loc4_ < _loc3_.children.length)
               {
                  _loc5_ = _loc3_.children[_loc4_];
                  if(_loc5_ == this)
                  {
                     break;
                  }
                  if(_loc5_ is CompositeEffect)
                  {
                     _loc1_ = _loc1_ + CompositeEffect(_loc5_).compositeDuration;
                  }
                  else
                  {
                     _loc1_ = _loc1_ + (_loc5_.startDelay + _loc5_.duration * _loc5_.repeatCount + (_loc5_.repeatDelay + (_loc5_.repeatCount - 1)));
                  }
                  _loc4_++;
               }
            }
            _loc2_ = _loc2_.parentCompositeEffect;
         }
         return _loc1_;
      }
   }
}
