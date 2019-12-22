package spark.effects
{
   import flash.utils.Dictionary;
   
   class SharedObjectDepot
   {
       
      
      private var sharedObjectMaps:Dictionary;
      
      private var sharedObjectRefcounts:Dictionary;
      
      function SharedObjectDepot()
      {
         this.sharedObjectMaps = new Dictionary(true);
         this.sharedObjectRefcounts = new Dictionary(true);
         super();
      }
      
      public function getSharedObject(param1:Object, param2:Object) : Object
      {
         var _loc3_:Dictionary = null;
         if(param1 != null)
         {
            _loc3_ = Dictionary(this.sharedObjectMaps[param1]);
            if(_loc3_ != null)
            {
               return _loc3_[param2];
            }
         }
         return null;
      }
      
      public function storeSharedObject(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:Dictionary = null;
         if(param1 != null)
         {
            _loc4_ = this.sharedObjectMaps[param1];
            if(!_loc4_)
            {
               _loc4_ = new Dictionary();
               this.sharedObjectMaps[param1] = _loc4_;
            }
            if(!_loc4_[param2])
            {
               if(!this.sharedObjectRefcounts[param1])
               {
                  this.sharedObjectRefcounts[param1] = 1;
               }
               else
               {
                  this.sharedObjectRefcounts[param1] = this.sharedObjectRefcounts[param1] + 1;
               }
            }
            _loc4_[param2] = param3;
         }
      }
      
      public function removeSharedObject(param1:Object, param2:Object) : void
      {
         var _loc3_:Dictionary = null;
         if(param1 != null)
         {
            _loc3_ = this.sharedObjectMaps[param1];
            if(!_loc3_)
            {
               return;
            }
            if(_loc3_[param2])
            {
               delete _loc3_[param2];
               this.sharedObjectRefcounts[param1] = this.sharedObjectRefcounts[param1] - 1;
               if(this.sharedObjectRefcounts[param1] <= 0)
               {
                  delete this.sharedObjectMaps[param1];
                  delete this.sharedObjectRefcounts[param1];
               }
            }
         }
      }
   }
}
