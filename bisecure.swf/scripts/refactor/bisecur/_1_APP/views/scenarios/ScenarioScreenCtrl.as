package refactor.bisecur._1_APP.views.scenarios
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.collections.ArrayCollection;
   import mx.core.IFactory;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import org.apache.flex.collections.ArrayList;
   import refactor.bisecur._1_APP.components.overlays.screens.ScenarioScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.AddScenarioBox;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.views.deviceList.DeviceListScreen;
   import refactor.bisecur._1_APP.views.scenarios.renderer.ScenarioRendererItem;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.ScenarioDAO;
   import refactor.bisecur._2_SAL.gatewayData.Scenario;
   import refactor.bisecur._2_SAL.gatewayData.ScenarioAction;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._5_UTIL.Log;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   public class ScenarioScreenCtrl implements IEventDispatcher
   {
      
      private static const LOADING_BOX_DURATION:int = 3000;
       
      
      public var Icon_Back:IVisualElement;
      
      public var Icon_Edit:IVisualElement;
      
      public var Icon_Add:IVisualElement;
      
      private var _80818744Title:String;
      
      public var view:ScenarioScreen;
      
      private var _96312495listProvider:ArrayCollection;
      
      private var context:ConnectionContext;
      
      private var groups:Array;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function ScenarioScreenCtrl()
      {
         this.Icon_Back = MultiDevice.getFxg(ImgBack);
         this.Icon_Edit = MultiDevice.getFxg(ImgEdit);
         this.Icon_Add = MultiDevice.getFxg(ImgAdd);
         this._80818744Title = Lang.getString("SCENARIOS");
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function onInit() : void
      {
         this.context = AppCache.sharedCache.connection;
         GatewayPorts.instance.getPortCount();
      }
      
      public function onCreationComplete() : void
      {
         var self:ScenarioScreenCtrl = null;
         var loadBox:LoadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("LOADING_GROUPS_TITLE");
         loadBox.contentText = Lang.getString("LOADING_GROUPS_CONTENT");
         loadBox.open(null);
         self = this;
         GatewayGroups.instance.getAll(function(param1:Object, param2:Array, param3:Error):void
         {
            var _loc5_:HmGroup = null;
            var _loc6_:ScenarioDAO = null;
            var _loc7_:Array = null;
            var _loc8_:Scenario = null;
            var _loc9_:ScenarioAction = null;
            var _loc10_:int = 0;
            if(param3 != null)
            {
               Log.error("[ScenarioScreenCtrl] retrieving devices failed! \n" + param3);
               return;
            }
            var _loc4_:ArrayList = new ArrayList();
            for each(_loc5_ in param2)
            {
               _loc4_.addItem(_loc5_.id);
            }
            _loc6_ = DAOFactory.getScenarioDAO();
            _loc7_ = _loc6_.getScenariosForUser(AppCache.sharedCache.loggedInUser,AppCache.sharedCache.connectedGateway.gateway);
            listProvider = new ArrayCollection(ScenarioRendererItem.createArray(_loc7_));
            for each(_loc8_ in _loc7_)
            {
               for each(_loc9_ in _loc8_.actions)
               {
                  if(_loc4_.getItemIndex(_loc9_.groupId) < 0)
                  {
                     _loc10_ = providerIndexOfScenario(_loc8_);
                     if(_loc10_ < 0)
                     {
                        Log.warning("[ScenarioScreenCtrl] removing unauthorized scenario failed! (scenario not found in provider)");
                     }
                     else
                     {
                        listProvider.removeItemAt(_loc10_);
                     }
                  }
               }
            }
            self.groups = param2;
            LoadBox.sharedBox.close();
         });
      }
      
      private function providerIndexOfScenario(param1:Scenario) : int
      {
         var _loc3_:Scenario = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.listProvider.length)
         {
            _loc3_ = this.listProvider.getItemAt(_loc2_).scenario;
            if(param1.id == _loc3_.id)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function onToggleEdit_Click() : void
      {
         var _loc1_:Boolean = ScenarioRendererItem.toggleEditMode();
         if(_loc1_)
         {
            this.view.btnEdit.setStyle("chromeAlpha",1);
         }
         else
         {
            this.view.btnEdit.setStyle("chromeAlpha",0);
         }
      }
      
      public function onAdd_Click() : void
      {
         var _loc1_:AddScenarioBox = new AddScenarioBox(this.groups);
         _loc1_.title = Lang.getString("ADD_SCENARIO");
         _loc1_.addEventListener(PopUpEvent.CLOSE,this.onAdded);
         _loc1_.open(null);
      }
      
      private function onAdded(param1:PopUpEvent) : void
      {
         var _loc2_:Scenario = null;
         var _loc3_:ScenarioDAO = null;
         var _loc4_:Scenario = null;
         var _loc5_:ScenarioAction = null;
         if(!param1.commit)
         {
            return;
         }
         if(param1.data)
         {
            _loc2_ = param1.data as Scenario;
            switch(param1.currentTarget.action)
            {
               case AddScenarioBox.ADD:
                  _loc3_ = DAOFactory.getScenarioDAO();
                  _loc4_ = _loc3_.addScenario(AppCache.sharedCache.loggedInUser,AppCache.sharedCache.connectedGateway.gateway,_loc2_.name);
                  for each(_loc5_ in _loc2_.actions)
                  {
                     _loc3_.addAction(_loc4_,_loc5_.groupId,_loc5_.deviceAction,_loc5_.actionType);
                  }
                  this.listProvider.addItem(ScenarioRendererItem.create(param1.data));
                  break;
               case AddScenarioBox.EDIT:
                  break;
               case AddScenarioBox.DELETE:
            }
         }
      }
      
      public function onScenarioSelected(param1:IndexChangeEvent) : void
      {
         var editBox:AddScenarioBox = null;
         var event:IndexChangeEvent = param1;
         event.preventDefault();
         if(ScenarioRendererItem.getEditMode())
         {
            editBox = new AddScenarioBox(this.groups,this.view.scenarioList.selectedItem.scenario);
            editBox.title = Lang.getString("EDIT_GROUP");
            editBox.addEventListener(PopUpEvent.CLOSE,this.onEditFinished);
            editBox.open(null);
            return;
         }
         var loadBox:LoadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("POPUP_SCENARIO_DISPATCHING");
         loadBox.contentText = Lang.getString("POPUP_SCENARIO_DISPATCHING_CONTENT");
         loadBox.open(null);
         new AutoDisposeTimer(LOADING_BOX_DURATION,function(param1:TimerEvent):void
         {
            var _loc2_:* = undefined;
            LoadBox.sharedBox.close();
            if(view.navigator)
            {
               if(Features.scenarioHotfix)
               {
                  _loc2_ = ErrorBox.sharedBox;
                  _loc2_.title = "Das Szenario wurde ausgeführt.";
                  _loc2_.contentText = "Sie können sich den aktuellen Status anzeigen lassen, indem Sie die Geräteliste aktualisieren.";
                  _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
                  _loc2_.closeable = true;
                  _loc2_.open(null);
               }
               else
               {
                  AppCache.sharedCache.hmProcessor.requestTransition();
                  view.navigator.replaceView(DeviceListScreen);
               }
            }
         }).start();
         var setter:StateSetter = new StateSetter(this.context);
         setter.setScenarios(this.view.scenarioList.selectedItem.scenario.actions);
      }
      
      private function onEditFinished(param1:PopUpEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Scenario = null;
         var _loc7_:ScenarioAction = null;
         var _loc8_:IFactory = null;
         this.onToggleEdit_Click();
         if(!param1.commit)
         {
            return;
         }
         var _loc2_:AddScenarioBox = param1.currentTarget as AddScenarioBox;
         var _loc3_:ScenarioDAO = DAOFactory.getScenarioDAO();
         var _loc4_:Scenario = param1.data;
         switch(_loc2_.action)
         {
            case AddScenarioBox.ADD:
               Log.warning("ADD (WTF?!)");
               break;
            case AddScenarioBox.DELETE:
               _loc3_.removeScenario(_loc4_);
               _loc5_ = this.providerIndexOfScenario(_loc4_);
               if(_loc5_ < 0)
               {
                  Log.warning("[ScenarioScreenCtrl] removing deleted scenario failed! (not found)");
                  return;
               }
               this.listProvider.removeItemAt(_loc5_);
               break;
            case AddScenarioBox.EDIT:
               _loc3_.removeScenario(_loc4_);
               _loc6_ = _loc3_.addScenario(AppCache.sharedCache.loggedInUser,AppCache.sharedCache.connectedGateway.gateway,_loc4_.name);
               for each(_loc7_ in _loc4_.actions)
               {
                  _loc3_.addAction(_loc6_,_loc7_.groupId,_loc7_.deviceAction,_loc7_.actionType);
               }
               _loc8_ = this.view.scenarioList.itemRenderer;
               this.view.scenarioList.itemRenderer = null;
               this.view.scenarioList.itemRenderer = _loc8_;
               _loc4_ = _loc6_;
               break;
            case AddScenarioBox.NONE:
               Log.info("[ScenarioScreenCtrl] NOP");
         }
      }
      
      public function onHelp_Click() : void
      {
         new ScenarioScreenOverlay(this.view.btnBack,this.view.btnAdd,this.view.btnEdit,this.view.bbar.callout).open(null);
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
