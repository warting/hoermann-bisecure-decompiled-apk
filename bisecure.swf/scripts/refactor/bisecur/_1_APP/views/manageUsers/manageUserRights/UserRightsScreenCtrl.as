package refactor.bisecur._1_APP.views.manageUsers.manageUserRights
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.SetUserRightsScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.keyValues.GatewayValues;
   import refactor.bisecur._2_SAL.net.cache.userRights.GatewayUserRights;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._5_UTIL.Log;
   
   public class UserRightsScreenCtrl implements IEventDispatcher
   {
      
      private static const GROUP_LOADING_TIMEOUT:int = 15000;
       
      
      private var _612038893Icon_Back:IVisualElement;
      
      private var _80818744Title:String;
      
      private var _965410127Text_Save:String;
      
      private var _96312495listProvider:ArrayCollection;
      
      public var view:UserRightsScreen;
      
      private var context:ConnectionContext;
      
      private var timeoutTimer:Timer;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function UserRightsScreenCtrl()
      {
         this._612038893Icon_Back = MultiDevice.getFxg(ImgBack);
         this._80818744Title = Lang.getString("OPTIONS_SET_USER_RIGHTS");
         this._965410127Text_Save = Lang.getString("GENERAL_SAVE");
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function onInit() : void
      {
         this.context = AppCache.sharedCache.connection;
         this.listProvider = new ArrayCollection();
      }
      
      public function onCreationComplete() : void
      {
         var loadBox:LoadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("LOADING_GROUPS_TITLE");
         loadBox.contentText = Lang.getString("LOADING_GROUPS_CONTENT");
         loadBox.open(null);
         this.timeoutTimer = new Timer(GROUP_LOADING_TIMEOUT,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         GatewayUserRights.instance.getRightsForUser(this.view.data as User,function(param1:Object, param2:Array, param3:User, param4:Error):void
         {
            var sender:Object = param1;
            var rights:Array = param2;
            var user:User = param3;
            var error:Error = param4;
            if(error != null)
            {
               Log.error("UserRightsScreenCtrl] loading user rights failed! " + error);
               return;
            }
            GatewayGroups.instance.getAll(function(param1:Object, param2:Array, param3:Error):void
            {
               var sender:Object = param1;
               var groups:Array = param2;
               var error:Error = param3;
               if(error != null)
               {
                  Log.error("UserRightsScreenCtrl] loading Groups failed! " + error);
                  return;
               }
               GatewayValues.instance.getValues(function(param1:Object, param2:Object, param3:Object, param4:Error):void
               {
                  var _loc5_:HmGroup = null;
                  var _loc7_:int = 0;
                  if(param4 != null)
                  {
                     Log.error("UserRightsScreenCtrl] loading Values failed! " + param4);
                     return;
                  }
                  for each(_loc5_ in groups)
                  {
                     if(!_loc5_.type || _loc5_.type < 0)
                     {
                        _loc5_.type = param2[_loc5_.id];
                     }
                  }
                  if(timeoutTimer)
                  {
                     timeoutTimer.reset();
                  }
                  var _loc6_:Array = [];
                  listProvider.removeAll();
                  for each(_loc5_ in groups)
                  {
                     listProvider.addItem(_loc5_);
                     for each(_loc7_ in rights)
                     {
                        if(_loc7_ == _loc5_.id)
                        {
                           _loc6_.push(_loc5_);
                        }
                     }
                  }
                  view.rightList.selectedItems = Vector.<Object>(_loc6_);
                  LoadBox.sharedBox.close();
               });
            });
         });
      }
      
      public function onSave_Click(param1:MouseEvent) : void
      {
         var group:HmGroup = null;
         var loadBox:LoadBox = null;
         var event:MouseEvent = param1;
         var groupIds:Array = [];
         for each(group in this.view.rightList.selectedItems)
         {
            groupIds.push(group.id);
         }
         loadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("SAVING_USER_RIGHTS");
         loadBox.contentText = Lang.getString("SAVING_USER_RIGHTS_CONTENT");
         loadBox.open(null);
         new MCPLoader(this.context).load(MCPBuilder.createSetUserRights(this.view.data.id,groupIds),function(param1:MCPLoader):void
         {
            var _loc2_:ErrorBox = null;
            if(param1.response == null)
            {
               Log.warning("[SetUserRightScreen] requesting SetUserRights failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.SET_USER_RIGHTS)
            {
               GatewayUserRights.instance.invalidateCache();
               LoadBox.sharedBox.close();
               view.navigator.popView();
            }
            else if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               _loc2_ = ErrorBox.sharedBox;
               _loc2_.title = Lang.getString("ERROR");
               _loc2_.contentText = Lang.getString("ERROR_SETTING_NAME");
               _loc2_.closeable = true;
               _loc2_.closeTitle = Lang.getString("GENERAL_CLOSE");
               _loc2_.open(null);
            }
            else
            {
               Log.warning("[SetUserRightScreen] unexpected response (for SetUserRights)! mcp:\n" + param1.response);
            }
         });
      }
      
      public function onHelp() : void
      {
         new SetUserRightsScreenOverlay(this.view.btnBack,this.view.btnSave,this.view.bbar.callout).open(null);
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         (param1.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         var _loc2_:LoadBox = LoadBox.sharedBox;
         if(!_loc2_.isOpen)
         {
            return;
         }
         _loc2_.close();
         var _loc3_:ErrorBox = ErrorBox.sharedBox;
         _loc3_.title = Lang.getString("ERROR_TIMEOUT");
         _loc3_.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         _loc3_.closeable = true;
         _loc3_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc3_.open(null);
         this.view.navigator.popView();
      }
      
      [Bindable(event="propertyChange")]
      public function get Icon_Back() : IVisualElement
      {
         return this._612038893Icon_Back;
      }
      
      public function set Icon_Back(param1:IVisualElement) : void
      {
         var _loc2_:Object = this._612038893Icon_Back;
         if(_loc2_ !== param1)
         {
            this._612038893Icon_Back = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Icon_Back",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get Title() : String
      {
         return this._80818744Title;
      }
      
      public function set Title(param1:String) : void
      {
         var _loc2_:Object = this._80818744Title;
         if(_loc2_ !== param1)
         {
            this._80818744Title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get Text_Save() : String
      {
         return this._965410127Text_Save;
      }
      
      public function set Text_Save(param1:String) : void
      {
         var _loc2_:Object = this._965410127Text_Save;
         if(_loc2_ !== param1)
         {
            this._965410127Text_Save = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Text_Save",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get listProvider() : ArrayCollection
      {
         return this._96312495listProvider;
      }
      
      public function set listProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._96312495listProvider;
         if(_loc2_ !== param1)
         {
            this._96312495listProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"listProvider",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}
