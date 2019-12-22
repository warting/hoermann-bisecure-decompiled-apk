package me.mweber.basic
{
   import flash.sampler.getSavedThis;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class ObjectInfos
   {
       
      
      public function ObjectInfos()
      {
         super();
         Debug.warning("[ObjectInfos] Do not initialize the ObjectInfos");
      }
      
      public static function getMemoryHash(param1:Object) : String
      {
         var instance:Object = param1;
         var memoryHash:String = "";
         try
         {
            ObjectInfos(instance);
         }
         catch(e:Error)
         {
            memoryHash = String(e).replace(/.*([@|\$].*?) to .*$/gi,"$1");
         }
         return memoryHash;
      }
      
      public static function getClass(param1:Object) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(param1)));
      }
      
      public static function getSimpleClassName(param1:*) : String
      {
         var _loc2_:String = getQualifiedClassName(param1);
         return _loc2_.substr(_loc2_.indexOf("::") + 2);
      }
      
      public static function numProperties(param1:Object) : int
      {
         var _loc3_:* = null;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public static function getFunctionName(param1:Function) : String
      {
         var _loc4_:String = null;
         var _loc2_:Object = getSavedThis(param1);
         var _loc3_:XMLList = describeType(_loc2_)..method.@name;
         for each(_loc4_ in _loc3_)
         {
            if(_loc2_.hasOwnProperty(_loc4_) && _loc2_[_loc4_] != null && _loc2_[_loc4_] === param1)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function getCallee(param1:int = 2) : String
      {
         param1++;
         var _loc2_:Array = new Error().getStackTrace().split("\n",param1 + 1);
         if(param1 >= _loc2_.length)
         {
            return null;
         }
         var _loc3_:String = _loc2_[param1];
         var _loc4_:Array = _loc3_.match(/[<]*\w+[>]*\(\)/);
         var _loc5_:String = "NULL";
         if(_loc4_ && _loc4_.length > 0)
         {
            _loc5_ = _loc4_[0];
         }
         var _loc6_:Array = _loc3_.match(/\w+(?=\/[<]*\w+[>]*\(\))/);
         var _loc7_:String = "<static>";
         if(_loc6_ && _loc6_.length > 0)
         {
            _loc7_ = _loc6_[0];
         }
         var _loc8_:Array = _loc3_.match(/(?<=:)\d+/);
         var _loc9_:String = null;
         if(_loc8_ && _loc8_.length > 0)
         {
            _loc9_ = _loc8_[0];
         }
         return _loc7_ + "." + _loc5_ + (!!_loc9_?", line " + _loc9_:"");
      }
      
      public static function getCallStack() : Array
      {
         var _loc3_:String = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 2;
         while((_loc3_ = getCallee(_loc2_)) != null)
         {
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
