package refactor.bisecur._1_APP.components.popups.group
{
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.renderer.LearnPortRenderer;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayList;
   import mx.core.ClassFactory;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.ScenarioDAO;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.events.IndexChangeEvent;
   import spark.layouts.HorizontalAlign;
   
   public class RemovePortsBox extends Popup
   {
      
      public static const TIMEOUT_DELAY:int = 40000;
       
      
      private var lblPorts:Label;
      
      private var lstPorts:List;
      
      private var grpButtons:HGroup;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var portProvider:ArrayList;
      
      private var group:Object;
      
      private var context:ConnectionContext;
      
      private var loadBox:LoadBox;
      
      private var timeoutTimer:Timer;
      
      public function RemovePortsBox(param1:Object, param2:ConnectionContext)
      {
         var _loc3_:Object = null;
         super();
         this.loadBox = LoadBox.sharedBox;
         this.title = Lang.getString("REMOVE_PORTS");
         this.group = param1;
         this.context = param2;
         if(!this.group.ports)
         {
            this.group.ports = [];
         }
         this.portProvider = new ArrayList();
         if(!param1.ports)
         {
            param1.ports = [];
         }
         for each(_loc3_ in param1.ports)
         {
            this.portProvider.addItem({
               "type":_loc3_.type,
               "name":PortTypes.NAMES[_loc3_.type],
               "id":_loc3_.id
            });
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblPorts = new Label();
         this.lblPorts.text = Lang.getString("REMOVE_PORTS_CONTENT");
         this.addElement(this.lblPorts);
         this.lstPorts = new List();
         this.lstPorts.dataProvider = this.portProvider;
         this.lstPorts.allowMultipleSelection = false;
         this.lstPorts.addEventListener(IndexChangeEvent.CHANGING,this.onListChanging);
         this.lstPorts.itemRenderer = new ClassFactory(LearnPortRenderer);
         this.lstPorts.labelFunction = this.portLabels;
         this.addElement(this.lstPorts);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.RIGHT;
         this.addElement(this.grpButtons);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.btnCancel.visible = false;
         this.grpButtons.addElement(this.btnCancel);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.grpButtons.addElement(this.btnSubmit);
      }
      
      private function portLabels(param1:Object) : String
      {
         return Lang.getString("CHANNEL_" + param1.name);
      }
      
      protected function onListChanging(param1:IndexChangeEvent) : void
      {
         var event:IndexChangeEvent = param1;
         this.loadBox.title = Lang.getString("REMOVING_PROCESS");
         this.loadBox.contentText = Lang.getString("REMOVING_PROCESS_CONTENT");
         this.loadBox.open(null);
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         new MCPLoader(this.context).load(MCPBuilder.createRemovePort(this.lstPorts.selectedItem.id),function(param1:MCPLoader):void
         {
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            if(param1.response == null)
            {
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               _loc2_ = MCPErrors.getErrorFromPackage(param1.response);
               InfoCenter.onMCPError(param1.response,_loc2_);
               if(_loc2_ < 0)
               {
                  Log.warning("[RemovePortsBox] received invalid mcp error (" + _loc2_ + ")! Package:\n" + param1.response);
                  return;
               }
               if(_loc2_ == MCPErrors.PORT_NOT_FOUND)
               {
                  if(lstPorts.selectedItem)
                  {
                     new ArrayList(group.ports).removeItem(lstPorts.selectedItem.id);
                     portProvider.removeItem(lstPorts.selectedItem);
                  }
                  lstPorts.selectedItem = null;
                  LoadBox.sharedBox.close();
                  loadBox.close();
               }
            }
            else if(param1.response.command == MCPCommands.REMOVE_PORT)
            {
               LoadBox.sharedBox.close();
               timeoutTimer.reset();
               if(lstPorts.selectedItem)
               {
                  _loc3_ = -1;
                  _loc4_ = 0;
                  while(_loc4_ < group.ports.length)
                  {
                     if(lstPorts.selectedItem.id == group.ports[_loc4_].id)
                     {
                        _loc3_ = _loc4_;
                        break;
                     }
                     _loc4_++;
                  }
                  if(_loc3_ >= 0)
                  {
                     group.ports.splice(_loc3_,1);
                  }
                  updateScenarios(lstPorts.selectedItem.id);
                  portProvider.removeItem(lstPorts.selectedItem);
                  GatewayPorts.instance.invalidateCache();
                  GatewayPorts.instance.getPortCount();
                  loadBox.close();
               }
            }
            else
            {
               Log.warning("[RemovePortsBox] unexpected mcp:\n" + param1.response);
            }
         });
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         (param1.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         var _loc2_:ErrorBox = ErrorBox.sharedBox;
         _loc2_.title = Lang.getString("ERROR_TIMEOUT");
         _loc2_.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         _loc2_.closeable = true;
         _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc2_.open(null);
         this.lstPorts.selectedItem = null;
         this.loadBox.close();
      }
      
      protected function updateScenarios(param1:int) : void
      {
         var _loc2_:ScenarioDAO = DAOFactory.getScenarioDAO();
         _loc2_.removeActionFromAll(param1);
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         this.setGroupedPorts();
         this.close(true,this.group);
      }
      
      private function setGroupedPorts() : void
      {
         var port:Object = null;
         var portIds:Array = [];
         for each(port in this.group.ports)
         {
            portIds.push(port.id);
         }
         new MCPLoader(this.context).load(MCPBuilder.createSetGroupedPorts(this.group.id,portIds),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               Log.warning("[LearnPortsBox] failed to update group! (NetTimeout)");
               InfoCenter.onNetTimeout();
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
            }
         });
      }
      
      protected function onCancel(param1:MouseEvent) : void
      {
         this.close();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.lblPorts.percentWidth = 100;
         this.lstPorts.percentWidth = 100;
         this.lstPorts.height = param2 / 3;
         this.grpButtons.percentWidth = 100;
         this.btnCancel.percentWidth = 50;
         this.btnSubmit.percentWidth = 50;
      }
   }
}
