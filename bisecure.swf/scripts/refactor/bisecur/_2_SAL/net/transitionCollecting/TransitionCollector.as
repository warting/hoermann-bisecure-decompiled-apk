package refactor.bisecur._2_SAL.net.transitionCollecting
{
   import com.codecatalyst.promise.Deferred;
   import com.codecatalyst.promise.Promise;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   
   public class TransitionCollector extends EventDispatcher implements IDisposable
   {
       
      
      private var stateContexts:ContextSet;
      
      private var activePromisses:PromiseSet;
      
      private var _transitions:Object;
      
      private var _isProcessing:Boolean = false;
      
      public function TransitionCollector()
      {
         this.stateContexts = new ContextSet();
         this.activePromisses = new PromiseSet();
         this._transitions = {};
         super();
      }
      
      [Bindable("processingChanged")]
      public function get processing() : Boolean
      {
         return this._isProcessing;
      }
      
      public function get transitions() : Object
      {
         return this._transitions;
      }
      
      public function dispose() : void
      {
         this.stateContexts.dispose();
      }
      
      public function collect(param1:int = -1, param2:Boolean = true) : void
      {
         var openPromisses:Array = null;
         var gid:int = param1;
         var clearOldTransitions:Boolean = param2;
         if(this._isProcessing == false)
         {
            this._isProcessing = true;
            dispatchEvent(new Event("processingChanged"));
         }
         if(clearOldTransitions)
         {
            if(gid == -1)
            {
               this._transitions = {};
            }
            else
            {
               delete this._transitions[gid];
            }
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,this.transitions));
         }
         openPromisses = [];
         if(gid < 0)
         {
            GatewayGroups.instance.getAll(function(param1:GatewayGroups, param2:Array, param3:Error):*
            {
               var _loc4_:HmGroup = null;
               if(param3 != null)
               {
                  Log.error("Loading actor States failed! (" + param3.message + ")");
               }
               else
               {
                  for each(_loc4_ in param2)
                  {
                     if(!activePromisses.hasPromiseForGroup(_loc4_.id))
                     {
                        openPromisses.push(requestGroup(_loc4_.id));
                     }
                  }
                  Promise.all(openPromisses).always(collectingCompleteHandler);
               }
            });
         }
         else if(!this.activePromisses.hasPromiseForGroup(gid))
         {
            this.requestGroup(gid).always(this.collectingCompleteHandler);
         }
      }
      
      private function collectingCompleteHandler() : void
      {
         this._isProcessing = false;
         dispatchEvent(new Event("processingChanged"));
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function cancelCollection() : void
      {
         this.stateContexts.cancelAll();
      }
      
      public function isGroupRequestable(param1:uint) : Boolean
      {
         return this.stateContexts.getContextForGroup(param1).isRequestable;
      }
      
      private function requestGroup(param1:int) : Promise
      {
         var deferred:Deferred = null;
         var groupId:int = param1;
         deferred = new Deferred();
         var promise:Promise = this.stateContexts.getContextForGroup(groupId).request().then(function(param1:Object):Object
         {
            var context:* = undefined;
            var response:Object = param1;
            context = response.context;
            var transition:* = response.transition;
            _transitions[context.groupId] = transition;
            if(transition.driveTime == 0 || transition.error || transition.autoClose)
            {
               deferred.resolve({});
               activePromisses.removePromiseForGroup(context.groupId);
            }
            else
            {
               new AutoDisposeTimer(transition.driveTime * 1000,function(param1:TimerEvent):void
               {
                  activePromisses.removePromiseForGroup(context.groupId);
                  collect(context.groupId,false);
               }).start();
            }
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,transitions));
            return response;
         },function(param1:Object):void
         {
            var _loc2_:* = param1.context;
            activePromisses.removePromiseForGroup(_loc2_.groupId);
            this._transitions[_loc2_.groupId] = null;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,transitions));
         });
         this.activePromisses.setPromiseForGroup(groupId,promise);
         return promise;
      }
   }
}

import refactor.bisecur._2_SAL.net.transitionCollecting.StateContext;
import refactor.logicware._5_UTIL.IDisposable;

class ContextSet implements IDisposable
{
    
   
   private var stateContexts:Object;
   
   function ContextSet()
   {
      this.stateContexts = {};
      super();
   }
   
   public function cancelAll() : void
   {
      var _loc1_:StateContext = null;
      for each(_loc1_ in this.stateContexts)
      {
         _loc1_.cancel();
      }
   }
   
   public function getContextForGroup(param1:int) : StateContext
   {
      if(!this.hasContextForGroup(param1))
      {
         this.stateContexts[param1] = this.createContextForGroup(param1);
      }
      return this.stateContexts[param1];
   }
   
   public function hasContextForGroup(param1:int) : Boolean
   {
      return this.stateContexts.hasOwnProperty(param1.toString());
   }
   
   public function dispose() : void
   {
      var _loc1_:StateContext = null;
      for each(_loc1_ in this.stateContexts)
      {
         _loc1_.dispose();
      }
      this.stateContexts = null;
   }
   
   private function createContextForGroup(param1:int) : StateContext
   {
      return new StateContext(param1);
   }
}

import com.codecatalyst.promise.Promise;
import refactor.logicware._5_UTIL.IDisposable;

class PromiseSet implements IDisposable
{
    
   
   private var promises;
   
   function PromiseSet()
   {
      this.promises = {};
      super();
   }
   
   public function getPromiseForGroup(param1:int) : Promise
   {
      return this.promises[param1];
   }
   
   public function setPromiseForGroup(param1:int, param2:Promise) : void
   {
      this.promises[param1] = param2;
   }
   
   public function hasPromiseForGroup(param1:int) : Boolean
   {
      return this.promises.hasOwnProperty(param1.toString());
   }
   
   public function removePromiseForGroup(param1:int) : void
   {
      delete this.promises[param1];
   }
   
   public function dispose() : void
   {
      this.promises = null;
   }
}
