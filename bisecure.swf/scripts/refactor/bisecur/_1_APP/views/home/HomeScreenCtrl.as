package refactor.bisecur._1_APP.views.home
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.HomeScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ChangePwdBox;
   import refactor.bisecur._1_APP.views.manageUsers.ManageUsersScreen;
   import refactor.bisecur._1_APP.views.viewActions.ViewActionBase;
   import refactor.bisecur._1_APP.views.viewActions.forward.ForwardViewAction;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.GatewaySettingsDAO;
   import spark.components.List;
   import spark.events.IndexChangeEvent;
   
   public class HomeScreenCtrl implements IEventDispatcher
   {
       
      
      private var _80818744Title:String;
      
      private var _670919563ActorsText:String;
      
      private var _360726896ScenariosText:String;
      
      private var _1326934219OptionsText:String;
      
      private var _1494734327LogoutText:String;
      
      private var executeOnComplete:Boolean = true;
      
      private var gatewaySettingDAO:GatewaySettingsDAO;
      
      public const Locales:Object = {};
      
      public var view:HomeScreen;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function HomeScreenCtrl()
      {
         this._80818744Title = Lang.getString("HOME_TITLE");
         this._670919563ActorsText = Lang.getString("ACTORS");
         this._360726896ScenariosText = Lang.getString("SCENARIOS");
         this._1326934219OptionsText = Lang.getString("OPTIONS");
         this._1494734327LogoutText = Lang.getString("LOGOUT");
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this.gatewaySettingDAO = DAOFactory.getGatewaySettingsDAO();
      }
      
      public function onInit() : void
      {
         GatewayDisplay.description = "";
         this.view.bbar.addEventListener(BottomBarEvent.HELP,this.onHelp);
         if(AppCache.sharedCache.loggedInUser.isAdmin)
         {
            this.view.homeList.dataProvider.addItem({
               "name":Lang.getString("OPTIONS_EDIT_USERS"),
               "view":ManageUsersScreen
            });
         }
         if(this.view.data && this.view.data is ViewActionBase)
         {
            (this.view.data as ViewActionBase).execute(this.view);
            if(this.view.data is ForwardViewAction)
            {
               this.executeOnComplete = false;
            }
         }
      }
      
      public function onCreationComplete() : void
      {
         if(!this.executeOnComplete)
         {
            return;
         }
         var _loc1_:AppCache = AppCache.sharedCache;
         if(_loc1_.loggedInUser.isDefaultLogin)
         {
            if(!this.gatewaySettingDAO.getDefaultLoginChanged(_loc1_.connectedGateway.gateway))
            {
               new ChangePwdBox().open(null);
               this.gatewaySettingDAO.setDefaultLoginChanged(_loc1_.connectedGateway.gateway);
            }
         }
      }
      
      public function onItemSelected(param1:IndexChangeEvent) : void
      {
         var _loc2_:Object = (param1.currentTarget as List).selectedItem;
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.view)
         {
            return;
         }
         this.view.navigator.pushView(_loc2_.view);
      }
      
      public function onLogout() : void
      {
         AppCache.sharedCache.logout();
      }
      
      private function onHelp(param1:BottomBarEvent) : void
      {
         var _loc7_:Object = null;
         var _loc2_:IVisualElement = null;
         var _loc3_:IVisualElement = null;
         var _loc4_:IVisualElement = null;
         var _loc5_:IVisualElement = null;
         var _loc6_:int = 0;
         while(_loc6_ < this.view.homeList.dataGroup.numElements)
         {
            _loc7_ = this.view.homeList.dataGroup.getElementAt(_loc6_);
            switch(_loc6_ % 4)
            {
               case 0:
                  _loc2_ = _loc7_.lblTitle as IVisualElement;
                  break;
               case 1:
                  _loc3_ = _loc7_.lblTitle as IVisualElement;
                  break;
               case 2:
                  _loc4_ = _loc7_.lblTitle as IVisualElement;
                  break;
               case 3:
                  _loc5_ = _loc7_.lblTitle as IVisualElement;
            }
            _loc6_++;
         }
         new HomeScreenOverlay(_loc2_,_loc3_,_loc4_,_loc5_,this.view.bbar.callout).open(null);
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
      public function get ActorsText() : String
      {
         return this._670919563ActorsText;
      }
      
      public function set ActorsText(param1:String) : void
      {
         var _loc2_:Object = this._670919563ActorsText;
         if(_loc2_ !== param1)
         {
            this._670919563ActorsText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ActorsText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ScenariosText() : String
      {
         return this._360726896ScenariosText;
      }
      
      public function set ScenariosText(param1:String) : void
      {
         var _loc2_:Object = this._360726896ScenariosText;
         if(_loc2_ !== param1)
         {
            this._360726896ScenariosText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ScenariosText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get OptionsText() : String
      {
         return this._1326934219OptionsText;
      }
      
      public function set OptionsText(param1:String) : void
      {
         var _loc2_:Object = this._1326934219OptionsText;
         if(_loc2_ !== param1)
         {
            this._1326934219OptionsText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"OptionsText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get LogoutText() : String
      {
         return this._1494734327LogoutText;
      }
      
      public function set LogoutText(param1:String) : void
      {
         var _loc2_:Object = this._1494734327LogoutText;
         if(_loc2_ !== param1)
         {
            this._1494734327LogoutText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"LogoutText",_loc2_,param1));
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
