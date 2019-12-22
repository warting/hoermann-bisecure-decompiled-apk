package mx.binding.utils
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.utils.DescribeTypeCache;
   
   use namespace mx_internal;
   
   public class ChangeWatcher
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var host:Object;
      
      private var name:String;
      
      private var getter:Function;
      
      private var handler:Function;
      
      private var commitOnly:Boolean;
      
      private var next:ChangeWatcher;
      
      private var events:Object;
      
      private var isExecuting:Boolean;
      
      public var useWeakReference:Boolean;
      
      public function ChangeWatcher(param1:Object, param2:Function, param3:Boolean = false, param4:ChangeWatcher = null)
      {
         super();
         this.host = null;
         this.name = param1 is String?param1 as String:param1.name;
         this.getter = param1 is String?null:param1.getter;
         this.handler = param2;
         this.commitOnly = param3;
         this.next = param4;
         this.events = {};
         this.useWeakReference = false;
         this.isExecuting = false;
      }
      
      public static function watch(param1:Object, param2:Object, param3:Function, param4:Boolean = false, param5:Boolean = false) : ChangeWatcher
      {
         var _loc6_:ChangeWatcher = null;
         if(!(param2 is Array))
         {
            param2 = [param2];
         }
         if(param2.length > 0)
         {
            _loc6_ = new ChangeWatcher(param2[0],param3,param4,watch(null,param2.slice(1),param3,param4));
            _loc6_.useWeakReference = param5;
            _loc6_.reset(param1);
            return _loc6_;
         }
         return null;
      }
      
      public static function canWatch(param1:Object, param2:String, param3:Boolean = false) : Boolean
      {
         return !isEmpty(getEvents(param1,param2,param3));
      }
      
      public static function getEvents(param1:Object, param2:String, param3:Boolean = false) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         if(param1 is IEventDispatcher)
         {
            _loc4_ = DescribeTypeCache.describeType(param1).bindabilityInfo.getChangeEvents(param2);
            if(param3)
            {
               _loc5_ = {};
               for(_loc6_ in _loc4_)
               {
                  if(_loc4_[_loc6_])
                  {
                     _loc5_[_loc6_] = true;
                  }
               }
               return _loc5_;
            }
            return _loc4_;
         }
         return {};
      }
      
      private static function isEmpty(param1:Object) : Boolean
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            return false;
         }
         return true;
      }
      
      public function unwatch() : void
      {
         this.reset(null);
      }
      
      public function getValue() : Object
      {
         return this.host == null?null:this.next == null?this.getHostPropertyValue():this.next.getValue();
      }
      
      public function setHandler(param1:Function) : void
      {
         this.handler = param1;
         if(this.next)
         {
            this.next.setHandler(param1);
         }
      }
      
      public function isWatching() : Boolean
      {
         return !isEmpty(this.events) && (this.next == null || this.next.isWatching());
      }
      
      public function reset(param1:Object) : void
      {
         var _loc2_:* = null;
         if(this.host != null)
         {
            for(_loc2_ in this.events)
            {
               this.host.removeEventListener(_loc2_,this.wrapHandler);
            }
            this.events = {};
         }
         this.host = param1;
         if(this.host != null)
         {
            this.events = getEvents(this.host,this.name,this.commitOnly);
            for(_loc2_ in this.events)
            {
               this.host.addEventListener(_loc2_,this.wrapHandler,false,EventPriority.BINDING,this.useWeakReference);
            }
         }
         if(this.next)
         {
            this.next.reset(this.getHostPropertyValue());
         }
      }
      
      private function getHostPropertyValue() : Object
      {
         return this.host == null?null:this.getter != null?this.getter(this.host):this.host[this.name];
      }
      
      private function wrapHandler(param1:Event) : void
      {
         var event:Event = param1;
         if(!this.isExecuting)
         {
            try
            {
               this.isExecuting = true;
               if(this.next)
               {
                  this.next.reset(this.getHostPropertyValue());
               }
               if(event is PropertyChangeEvent)
               {
                  if((event as PropertyChangeEvent).property == this.name)
                  {
                     this.handler(event as PropertyChangeEvent);
                  }
               }
               else
               {
                  this.handler(event);
               }
               return;
            }
            finally
            {
               this.isExecuting = false;
            }
         }
      }
   }
}
