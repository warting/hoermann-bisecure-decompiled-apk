package mx.utils
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   use namespace object_proxy;
   
   public dynamic class OrderedObject extends Proxy
   {
       
      
      object_proxy var propertyList:Array;
      
      private var _item:Object;
      
      public function OrderedObject(param1:Object = null)
      {
         super();
         if(!param1)
         {
            param1 = {};
         }
         this._item = param1;
         this.propertyList = [];
      }
      
      object_proxy function getObjectProperty(param1:*) : *
      {
         return this.getProperty(param1);
      }
      
      object_proxy function setObjectProperty(param1:*, param2:*) : void
      {
         this.setProperty(param1,param2);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:Object = null;
         _loc2_ = this._item[param1];
         return _loc2_;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return this._item[param1].apply(this._item,rest);
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         var _loc2_:Object = this._item[param1];
         var _loc3_:* = delete this._item[param1];
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < this.propertyList.length)
         {
            if(this.propertyList[_loc5_] == param1)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         if(_loc4_ > -1)
         {
            this.propertyList.splice(_loc4_,1);
         }
         return _loc3_;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this._item;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this.propertyList[param1 - 1];
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 < this.propertyList.length)
         {
            return param1 + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this._item[this.propertyList[param1 - 1]];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = this._item[param1];
         if(_loc3_ !== param2)
         {
            this._item[param1] = param2;
            _loc4_ = 0;
            while(_loc4_ < this.propertyList.length)
            {
               if(this.propertyList[_loc4_] == param1)
               {
                  return;
               }
               _loc4_++;
            }
            this.propertyList.push(param1);
         }
      }
   }
}
