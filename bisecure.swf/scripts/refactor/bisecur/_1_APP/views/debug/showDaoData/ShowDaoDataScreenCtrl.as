package refactor.bisecur._1_APP.views.debug.showDaoData
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._2_SAL.dao.AppSettingDAO;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.GatewayDAO;
   import refactor.bisecur._2_SAL.dao.GatewaySettingsDAO;
   import refactor.bisecur._2_SAL.dao.ScenarioDAO;
   import refactor.bisecur._2_SAL.dao.UserLoginDAO;
   import refactor.bisecur._2_SAL.gatewayData.Scenario;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class ShowDaoDataScreenCtrl implements IEventDispatcher
   {
       
      
      public var Icon_Back:IVisualElement;
      
      public var Icon_Edit:IVisualElement;
      
      public var Icon_Add:IVisualElement;
      
      private var _859627842txtOut:String = "";
      
      public var view:ShowDaoDataScreen;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function ShowDaoDataScreenCtrl()
      {
         this.Icon_Back = MultiDevice.getFxg(ImgBack);
         this.Icon_Edit = MultiDevice.getFxg(ImgEdit);
         this.Icon_Add = MultiDevice.getFxg(ImgAdd);
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function onShowAppSettings() : void
      {
         var _loc1_:AppSettingDAO = DAOFactory.getAppSettingDAO();
         this.onClear();
         this.txtOut = this.txtOut + _loc1_.getPortalCredentials();
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + ("Terms Accepted: " + _loc1_.getTermsAccepted());
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + ("Default GW: " + _loc1_.getDefaultGateway());
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + ("Suppress Out of View: " + _loc1_.getSuppressGateOutOfView());
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + ("Suppress not responsible: " + _loc1_.getSuppressGateNotResponsible());
         this.txtOut = this.txtOut + "\n";
         this.txtOut = this.txtOut + "\n";
      }
      
      public function onShowGateways() : void
      {
         var _loc3_:Gateway = null;
         var _loc1_:GatewayDAO = DAOFactory.getGatewayDAO();
         this.onClear();
         var _loc2_:Array = _loc1_.getGateways();
         this.txtOut = this.txtOut + "------- Gateways -------\n\n";
         for each(_loc3_ in _loc2_)
         {
            this.txtOut = this.txtOut + _loc3_;
            this.txtOut = this.txtOut + "\n";
            this.txtOut = this.txtOut + "\n";
         }
         this.txtOut = this.txtOut + "------------------------";
      }
      
      public function onShowGatewaySettings() : void
      {
         var _loc1_:GatewaySettingsDAO = DAOFactory.getGatewaySettingsDAO();
         this.onClear();
         this.txtOut = this.txtOut + "------- Settings -------\n\n";
         this.txtOut = this.txtOut + _loc1_.dump();
         this.txtOut = this.txtOut + "------------------------";
      }
      
      public function onShowScenarios() : void
      {
         var _loc2_:Scenario = null;
         var _loc1_:ScenarioDAO = DAOFactory.getScenarioDAO();
         this.onClear();
         this.txtOut = this.txtOut + "------- Scenarios -------\n\n";
         for each(_loc2_ in _loc1_.getScenarios())
         {
            this.txtOut = this.txtOut + _loc2_;
            this.txtOut = this.txtOut + "\n";
            this.txtOut = this.txtOut + "\n";
         }
         this.txtOut = this.txtOut + "-------------------------";
      }
      
      public function onShowUserLogins() : void
      {
         var _loc2_:User = null;
         var _loc1_:UserLoginDAO = DAOFactory.getUserLoginDAO();
         this.onClear();
         this.txtOut = this.txtOut + "------- Scenarios -------\n\n";
         for each(_loc2_ in _loc1_.getUsers())
         {
            this.txtOut = this.txtOut + _loc2_;
            this.txtOut = this.txtOut + "\n";
            this.txtOut = this.txtOut + "\n";
         }
         this.txtOut = this.txtOut + "-------------------------";
      }
      
      public function onClear() : void
      {
         this.txtOut = "";
      }
      
      [Bindable(event="propertyChange")]
      public function get txtOut() : String
      {
         return this._859627842txtOut;
      }
      
      public function set txtOut(param1:String) : void
      {
         var _loc2_:Object = this._859627842txtOut;
         if(_loc2_ !== param1)
         {
            this._859627842txtOut = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtOut",_loc2_,param1));
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
