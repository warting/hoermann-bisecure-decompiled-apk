package spark.effects.supportClasses
{
   import flash.display.DisplayObject;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   import flash.geom.Transform;
   import flash.geom.Vector3D;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import spark.components.Group;
   import spark.effects.animation.Animation;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Linear;
   
   use namespace mx_internal;
   
   public class AnimateTransformInstance extends AnimateInstance
   {
      
      private static var TRANSFORM_PROPERTIES:Array = ["translationX","translationY","translationZ","rotationX","rotationY","rotationZ","scaleX","scaleY","scaleZ","postLayoutTranslationX","postLayoutTranslationY","postLayoutTranslationZ","postLayoutRotationX","postLayoutRotationY","postLayoutRotationZ","postLayoutScaleX","postLayoutScaleY","postLayoutScaleZ"];
      
      private static var scale:Vector3D = new Vector3D();
      
      private static var rotation:Vector3D = new Vector3D();
      
      private static var position:Vector3D = new Vector3D();
      
      private static var offsetRotation:Vector3D = new Vector3D();
      
      private static var offsetTranslation:Vector3D = new Vector3D();
      
      private static var offsetScale:Vector3D = new Vector3D();
       
      
      public var applyLocalProjection:Boolean = false;
      
      public var autoCenterProjection:Boolean = false;
      
      public var removeLocalProjectionWhenComplete:Boolean = false;
      
      public var fieldOfView:Number;
      
      public var focalLength:Number;
      
      public var projectionX:Number = 0;
      
      public var projectionY:Number = 0;
      
      public var removeLocalPerspectiveOnEnd:Boolean = false;
      
      protected var originalProjection:PerspectiveProjection;
      
      private var started:Boolean = false;
      
      private var instanceStartTime:Number = 0;
      
      private var currentValues:Object;
      
      private var prevWidth:Number;
      
      private var prevHeight:Number;
      
      mx_internal var layoutConstraints:Object;
      
      mx_internal var affectedProperties:Object;
      
      public var initialized:Boolean = false;
      
      public var transformCenter:Vector3D;
      
      public var autoCenterTransform:Boolean;
      
      public function AnimateTransformInstance(param1:Object)
      {
         this.currentValues = {
            "rotationX":NaN,
            "rotationY":NaN,
            "rotationZ":NaN,
            "scaleX":NaN,
            "scaleY":NaN,
            "scaleZ":NaN,
            "translationX":NaN,
            "translationY":NaN,
            "translationZ":NaN,
            "postLayoutRotationX":NaN,
            "postLayoutRotationY":NaN,
            "postLayoutRotationZ":NaN,
            "postLayoutScaleX":NaN,
            "postLayoutScaleY":NaN,
            "postLayoutScaleZ":NaN,
            "postLayoutTranslationX":NaN,
            "postLayoutTranslationY":NaN,
            "postLayoutTranslationZ":NaN
         };
         this.layoutConstraints = {};
         this.affectedProperties = {};
         super(param1);
      }
      
      override public function startEffect() : void
      {
         if(!this.started)
         {
            this.started = true;
            super.startEffect();
         }
      }
      
      private function isValidValue(param1:Object) : Boolean
      {
         return param1 is Number && !isNaN(Number(param1)) || !(param1 is Number) && param1 !== null;
      }
      
      private function insertKeyframe(param1:Vector.<Keyframe>, param2:Keyframe, param3:Number = 0, param4:Boolean = false) : void
      {
         param2.time = param2.time + param3;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_].time >= param2.time)
            {
               if(param1[_loc5_].time == param2.time)
               {
                  if(param4)
                  {
                     param2.time = param2.time + 0.01;
                     param1.splice(_loc5_ + 1,0,param2);
                  }
                  else
                  {
                     param2.time = param2.time - 0.01;
                     param1.splice(_loc5_,0,param2);
                  }
               }
               else
               {
                  param1.splice(_loc5_,0,param2);
               }
               return;
            }
            _loc5_++;
         }
         param1.push(param2);
      }
      
      public function addMotionPath(param1:MotionPath, param2:Number = 0) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MotionPath = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Keyframe = null;
         var _loc3_:Boolean = false;
         if(motionPaths)
         {
            _loc7_ = motionPaths.length;
            if(param2 < this.instanceStartTime)
            {
               _loc8_ = this.instanceStartTime - param2;
               _loc4_ = 0;
               while(_loc4_ < _loc7_)
               {
                  _loc6_ = MotionPath(motionPaths[_loc4_]);
                  _loc5_ = 0;
                  while(_loc5_ < _loc6_.keyframes.length)
                  {
                     _loc6_.keyframes[_loc5_].time = _loc6_.keyframes[_loc5_].time + _loc8_;
                     _loc5_++;
                  }
                  _loc4_++;
               }
               this.instanceStartTime = param2;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               _loc6_ = MotionPath(motionPaths[_loc4_]);
               if(_loc6_.property == param1.property)
               {
                  _loc5_ = 0;
                  while(_loc5_ < param1.keyframes.length)
                  {
                     this.insertKeyframe(_loc6_.keyframes,param1.keyframes[_loc5_],param2 - this.instanceStartTime,_loc5_ == 0);
                     _loc5_++;
                  }
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         else
         {
            motionPaths = new Vector.<MotionPath>();
            this.instanceStartTime = param2;
         }
         if(!_loc3_)
         {
            if(param2 > this.instanceStartTime)
            {
               _loc5_ = 0;
               while(_loc5_ < param1.keyframes.length)
               {
                  param1.keyframes[_loc5_].time = param1.keyframes[_loc5_].time + (param2 - this.instanceStartTime);
                  _loc5_++;
               }
            }
            motionPaths.push(param1);
         }
         _loc7_ = motionPaths.length;
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc6_ = MotionPath(motionPaths[_loc4_]);
            _loc9_ = _loc6_.keyframes[_loc6_.keyframes.length - 1];
            if(!isNaN(_loc9_.time))
            {
               duration = Math.max(duration,_loc9_.time);
            }
            _loc4_++;
         }
      }
      
      private function initProjection() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Transform = null;
         var _loc3_:PerspectiveProjection = null;
         var _loc4_:Point = null;
         if(this.applyLocalProjection)
         {
            _loc1_ = target.parent;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_ is UIComponent?UIComponent(_loc1_).$transform:_loc1_.transform;
               this.originalProjection = _loc2_.perspectiveProjection;
               _loc3_ = new PerspectiveProjection();
               if(!isNaN(this.fieldOfView))
               {
                  _loc3_.fieldOfView = this.fieldOfView;
               }
               if(!isNaN(this.focalLength))
               {
                  _loc3_.focalLength = this.focalLength;
               }
               if(this.autoCenterProjection)
               {
                  _loc4_ = new Point(target.getLayoutBoundsWidth(false) / 2,target.getLayoutBoundsHeight(false) / 2);
               }
               else
               {
                  _loc4_ = new Point(this.projectionX,this.projectionY);
               }
               _loc4_ = target.localToGlobal(_loc4_);
               _loc3_.projectionCenter = _loc1_.globalToLocal(_loc4_);
               _loc2_.perspectiveProjection = _loc3_;
            }
         }
      }
      
      private function removeProjection() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Transform = null;
         if(this.applyLocalProjection && this.removeLocalProjectionWhenComplete)
         {
            _loc1_ = target.parent as DisplayObject;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_ is UIComponent?UIComponent(_loc1_).$transform:_loc1_.transform;
               _loc2_.perspectiveProjection = this.originalProjection;
            }
         }
      }
      
      override public function play() : void
      {
         var _loc2_:* = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:MotionPath = null;
         var _loc11_:Keyframe = null;
         var _loc12_:IEaser = null;
         var _loc13_:MotionPath = null;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:MotionPath = null;
         var _loc18_:int = 0;
         var _loc1_:Object = {};
         if(propertyChanges)
         {
            for(_loc2_ in propertyChanges.end)
            {
               if(this.affectedProperties[_loc2_] !== undefined && propertyChanges.end[_loc2_] !== undefined && propertyChanges.start[_loc2_] !== undefined)
               {
                  if(_loc2_ != "width" && _loc2_ != "height" && (_loc2_ == "postLayoutTranslationX" || _loc2_ == "postLayoutTranslationY" || _loc2_ == "postLayoutTranslationZ" || propertyChanges.start[_loc2_] != propertyChanges.end[_loc2_]))
                  {
                     _loc1_[_loc2_] = _loc2_;
                  }
               }
            }
            if(_loc1_["postLayoutTranslationZ"] === undefined && motionPaths != null)
            {
               _loc3_ = false;
               _loc4_ = false;
               _loc5_ = 0;
               while(_loc5_ < motionPaths.length)
               {
                  _loc6_ = motionPaths[_loc5_].property;
                  if(!_loc3_ && (_loc6_ == "postLayoutRotationX" || _loc6_ == "postLayoutRotationY"))
                  {
                     _loc3_ = true;
                     if(_loc4_)
                     {
                        break;
                     }
                  }
                  else if(!_loc4_ && (_loc6_ == "translationX" || _loc6_ == "translationY"))
                  {
                     _loc4_ = true;
                     if(_loc3_)
                     {
                        break;
                     }
                  }
                  _loc5_++;
               }
               if(_loc3_ && _loc4_)
               {
                  _loc1_["postLayoutTranslationZ"] = "postLayoutTranslationZ";
               }
            }
         }
         if(motionPaths)
         {
            this.updateTransformCenter();
            _loc9_ = this.transformCenter.x != 0 || this.transformCenter.y != 0;
            _loc7_ = 0;
            while(_loc7_ < motionPaths.length)
            {
               _loc10_ = motionPaths[_loc7_];
               delete _loc1_[_loc10_.property];
               if(_loc9_ && (_loc10_.property == "translationX" || _loc10_.property == "translationY" || _loc10_.property == "postLayoutTranslationX" || _loc10_.property == "postLayoutTranslationY"))
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc10_.keyframes.length)
                  {
                     _loc11_ = _loc10_.keyframes[_loc8_];
                     if(this.isValidValue(_loc11_.value))
                     {
                        if(_loc10_.property == "translationX" || _loc10_.property == "postLayoutTranslationX")
                        {
                           _loc11_.value = _loc11_.value + this.transformCenter.x;
                        }
                        else
                        {
                           _loc11_.value = _loc11_.value + this.transformCenter.y;
                        }
                     }
                     _loc8_++;
                  }
               }
               _loc7_++;
            }
         }
         for(_loc2_ in _loc1_)
         {
            if(!motionPaths)
            {
               motionPaths = new Vector.<MotionPath>();
            }
            if(!_loc12_)
            {
               if(motionPaths.length > 0 && motionPaths[0] && motionPaths[0].keyframes && motionPaths[0].keyframes.length > 0 && motionPaths[0].keyframes[motionPaths[0].keyframes.length - 1])
               {
                  _loc12_ = motionPaths[0].keyframes[motionPaths[0].keyframes.length - 1].easer;
               }
               else
               {
                  _loc12_ = new Linear();
               }
            }
            _loc13_ = new MotionPath(_loc2_);
            _loc14_ = false;
            if(_loc2_.indexOf("postLayoutTranslation") == 0)
            {
               _loc15_ = _loc2_ == "postLayoutTranslationX"?"translationX":_loc2_ == "postLayoutTranslationY"?"translationY":"translationZ";
               _loc16_ = 0;
               while(_loc16_ < motionPaths.length)
               {
                  _loc17_ = motionPaths[_loc16_];
                  if(_loc17_.property == _loc15_)
                  {
                     _loc13_.keyframes = new Vector.<Keyframe>(_loc17_.keyframes.length);
                     _loc18_ = 0;
                     while(_loc18_ < _loc13_.keyframes.length)
                     {
                        _loc13_.keyframes[_loc18_] = _loc17_.keyframes[_loc18_].clone();
                        _loc18_++;
                     }
                     _loc14_ = true;
                     break;
                  }
                  _loc16_++;
               }
            }
            if(!_loc14_)
            {
               _loc13_.keyframes = new <Keyframe>[new Keyframe(0,null),new Keyframe(duration,null)];
               _loc13_.keyframes[1].easer = _loc12_;
               _loc13_.scaleKeyframes(duration);
            }
            motionPaths.push(_loc13_);
         }
         if(propertyChanges && !disableLayout)
         {
            for(_loc2_ in this.layoutConstraints)
            {
               setupConstraintAnimation(_loc2_);
            }
         }
         super.play();
      }
      
      override public function animationStart(param1:Animation) : void
      {
         this.initProjection();
         super.animationStart(param1);
      }
      
      override public function animationEnd(param1:Animation) : void
      {
         this.started = false;
         this.removeProjection();
         super.animationEnd(param1);
      }
      
      private function updateTransformCenter() : void
      {
         if(!this.transformCenter)
         {
            this.transformCenter = new Vector3D(target.transformX,target.transformY,target.transformZ);
         }
         if(this.autoCenterTransform)
         {
            this.transformCenter.x = target.width / 2;
            this.transformCenter.y = target.height / 2;
            this.transformCenter.z = 0;
         }
      }
      
      override protected function getCurrentValue(param1:String) : *
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         switch(param1)
         {
            case "translationX":
            case "translationY":
            case "translationZ":
               _loc2_ = new Vector3D();
               this.updateTransformCenter();
               target.transformPointToParent(this.transformCenter,_loc2_,null);
               if(param1 == "translationX")
               {
                  return _loc2_.x;
               }
               if(param1 == "translationY")
               {
                  return _loc2_.y;
               }
               if(param1 == "translationZ")
               {
                  return _loc2_.z;
               }
               break;
            case "postLayoutTranslationX":
            case "postLayoutTranslationY":
            case "postLayoutTranslationZ":
               _loc3_ = new Vector3D();
               this.updateTransformCenter();
               target.transformPointToParent(this.transformCenter,null,_loc3_);
               if(param1 == "postLayoutTranslationX")
               {
                  return _loc3_.x;
               }
               if(param1 == "postLayoutTranslationY")
               {
                  return _loc3_.y;
               }
               if(param1 == "postLayoutTranslationZ")
               {
                  return _loc3_.z;
               }
               break;
            case "postLayoutRotationX":
               return target.postLayoutTransformOffsets == null?0:target.postLayoutTransformOffsets.rotationX;
            case "postLayoutRotationY":
               return target.postLayoutTransformOffsets == null?0:target.postLayoutTransformOffsets.rotationY;
            case "postLayoutRotationZ":
               return target.postLayoutTransformOffsets == null?0:target.postLayoutTransformOffsets.rotationZ;
            case "postLayoutScaleX":
               return target.postLayoutTransformOffsets == null?1:target.postLayoutTransformOffsets.scaleX;
            case "postLayoutScaleY":
               return target.postLayoutTransformOffsets == null?1:target.postLayoutTransformOffsets.scaleY;
            case "postLayoutScaleZ":
               return target.postLayoutTransformOffsets == null?1:target.postLayoutTransformOffsets.scaleZ;
            default:
               return super.getCurrentValue(param1);
         }
      }
      
      override protected function applyValues(param1:Animation) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc7_:Vector3D = null;
         var _loc8_:int = 0;
         while(_loc8_ < motionPaths.length)
         {
            if(this.currentValues[motionPaths[_loc8_].property] !== undefined)
            {
               this.currentValues[motionPaths[_loc8_].property] = param1.currentValue[motionPaths[_loc8_].property];
            }
            else
            {
               setValue(motionPaths[_loc8_].property,param1.currentValue[motionPaths[_loc8_].property]);
            }
            _loc8_++;
         }
         if(this.autoCenterTransform)
         {
            if(!disableLayout && target.parent is Group)
            {
               target.parent.validateNow();
            }
            if(target.width != this.prevWidth || target.height != this.prevHeight)
            {
               this.prevWidth = target.width;
               this.prevHeight = target.height;
               this.updateTransformCenter();
            }
         }
         if(!isNaN(this.currentValues.scaleX) || !isNaN(this.currentValues.scaleY) || !isNaN(this.currentValues.scaleZ))
         {
            scale.x = !isNaN(this.currentValues.scaleX)?Number(this.currentValues.scaleX):Number(target["scaleX"]);
            scale.y = !isNaN(this.currentValues.scaleY)?Number(this.currentValues.scaleY):Number(target["scaleY"]);
            scale.z = !isNaN(this.currentValues.scaleZ)?Number(this.currentValues.scaleZ):Number(target["scaleZ"]);
            _loc2_ = scale;
         }
         if(!isNaN(this.currentValues.rotationX) || !isNaN(this.currentValues.rotationY) || !isNaN(this.currentValues.rotationZ))
         {
            rotation.x = !isNaN(this.currentValues.rotationX)?Number(this.currentValues.rotationX):Number(this.getCurrentValue("rotationX"));
            rotation.y = !isNaN(this.currentValues.rotationY)?Number(this.currentValues.rotationY):Number(this.getCurrentValue("rotationY"));
            rotation.z = !isNaN(this.currentValues.rotationZ)?Number(this.currentValues.rotationZ):Number(this.getCurrentValue("rotationZ"));
            _loc4_ = rotation;
         }
         position.x = !isNaN(this.currentValues.translationX)?Number(this.currentValues.translationX):Number(this.getCurrentValue("translationX"));
         position.y = !isNaN(this.currentValues.translationY)?Number(this.currentValues.translationY):Number(this.getCurrentValue("translationY"));
         position.z = !isNaN(this.currentValues.translationZ)?Number(this.currentValues.translationZ):Number(this.getCurrentValue("translationZ"));
         _loc3_ = position;
         if(target.postLayoutTransformOffsets != null)
         {
            if(!isNaN(this.currentValues.postLayoutRotationX) || !isNaN(this.currentValues.postLayoutRotationY) || !isNaN(this.currentValues.postLayoutRotationZ))
            {
               offsetRotation.x = !isNaN(this.currentValues.postLayoutRotationX)?Number(this.currentValues.postLayoutRotationX):Number(this.getCurrentValue("postLayoutRotationX"));
               offsetRotation.y = !isNaN(this.currentValues.postLayoutRotationY)?Number(this.currentValues.postLayoutRotationY):Number(this.getCurrentValue("postLayoutRotationY"));
               offsetRotation.z = !isNaN(this.currentValues.postLayoutRotationZ)?Number(this.currentValues.postLayoutRotationZ):Number(this.getCurrentValue("postLayoutRotationZ"));
               _loc6_ = offsetRotation;
            }
            if(!isNaN(this.currentValues.postLayoutScaleX) || !isNaN(this.currentValues.postLayoutScaleY) || !isNaN(this.currentValues.postLayoutScaleZ))
            {
               offsetScale.x = !isNaN(this.currentValues.postLayoutScaleX)?Number(this.currentValues.postLayoutScaleX):Number(this.getCurrentValue("postLayoutScaleX"));
               offsetScale.y = !isNaN(this.currentValues.postLayoutScaleY)?Number(this.currentValues.postLayoutScaleY):Number(this.getCurrentValue("postLayoutScaleY"));
               offsetScale.z = !isNaN(this.currentValues.postLayoutScaleZ)?Number(this.currentValues.postLayoutScaleZ):Number(this.getCurrentValue("postLayoutScaleZ"));
               _loc7_ = offsetScale;
            }
            if(!isNaN(this.currentValues.postLayoutTranslationX) || !isNaN(this.currentValues.postLayoutTranslationY) || !isNaN(this.currentValues.postLayoutTranslationZ))
            {
               offsetTranslation.x = !isNaN(this.currentValues.postLayoutTranslationX)?Number(this.currentValues.postLayoutTranslationX):Number(this.getCurrentValue("postLayoutTranslationX"));
               offsetTranslation.y = !isNaN(this.currentValues.postLayoutTranslationY)?Number(this.currentValues.postLayoutTranslationY):Number(this.getCurrentValue("postLayoutTranslationY"));
               offsetTranslation.z = !isNaN(this.currentValues.postLayoutTranslationZ)?Number(this.currentValues.postLayoutTranslationZ):Number(this.getCurrentValue("postLayoutTranslationZ"));
               _loc5_ = offsetTranslation;
            }
            else
            {
               _loc5_ = _loc3_;
            }
         }
         target.transformAround(this.transformCenter,_loc2_,_loc4_,_loc3_,_loc7_,_loc6_,_loc5_);
      }
   }
}
