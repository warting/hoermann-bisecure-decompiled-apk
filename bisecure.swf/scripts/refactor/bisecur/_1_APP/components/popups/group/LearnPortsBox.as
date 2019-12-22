package refactor.bisecur._1_APP.components.popups.group
{
   import com.isisic.remote.hoermann.components.SelectBoxList;
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmPort;
   import com.isisic.remote.hoermann.renderer.LearnPortRenderer;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayList;
   import mx.core.ClassFactory;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.keyValues.GatewayValues;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.ArrayHelper;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.LogicwareSettings;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.events.IndexChangeEvent;
   import spark.layouts.HorizontalAlign;
   
   public class LearnPortsBox extends Popup
   {
      
      public static const TIMEOUT_DELAY:int = 40000;
       
      
      private var lblPorts:Label;
      
      private var chkLearn:CheckBox;
      
      private var chkCopy:CheckBox;
      
      private var lstPorts:SelectBoxList;
      
      private var grpButtons:HGroup;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var groupRequestable:Boolean;
      
      private var portProvider:ArrayList;
      
      private var group:HmGroup;
      
      private var context:ConnectionContext;
      
      private var loadBox:LoadBox;
      
      private var editMode:Boolean;
      
      private var responsePort:int = 255;
      
      private var timeoutTimer:Timer;
      
      public function LearnPortsBox(param1:HmGroup, param2:ConnectionContext, param3:Boolean = false)
      {
         var _loc5_:HmPort = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         super();
         this.editMode = param1.id >= 0;
         GatewayPorts.instance.getPortCount();
         this.groupRequestable = param3;
         this.loadBox = new LoadBox();
         this.title = Lang.getString("LEARN_PORTS_TITLE");
         this.group = param1;
         this.context = param2;
         if(!this.group.ports)
         {
            this.group.ports = [];
         }
         var _loc4_:ArrayList = new ArrayList();
         if(!param1.ports)
         {
            param1.ports = [];
         }
         for each(_loc5_ in param1.ports)
         {
            _loc4_.addItem(_loc5_.type);
         }
         this.portProvider = new ArrayList();
         for each(_loc6_ in GroupTypes.PORTS[param1.type])
         {
            _loc7_ = _loc4_.getItemIndex(int(_loc6_));
            if(_loc4_.getItemIndex(int(_loc6_)) < 0)
            {
               this.portProvider.addItem({
                  "type":_loc6_,
                  "name":PortTypes.NAMES[_loc6_]
               });
            }
         }
         this.portProvider.source.sort(PortTypes.portArraySorting);
      }
      
      public function get shouldCopy() : Boolean
      {
         if(!this.chkCopy)
         {
            return false;
         }
         return this.chkCopy.selected;
      }
      
      override protected function createChildren() : void
      {
         var self:LearnPortsBox = null;
         super.createChildren();
         this.chkCopy = new CheckBox();
         this.chkCopy.label = Lang.getString("COPY_PORTS");
         this.chkCopy.selected = true;
         this.chkCopy.enabled = this.group.hasFeature(HmGroup.FEATURE_ADD_PORT);
         this.addElement(this.chkCopy);
         this.chkLearn = new CheckBox();
         this.chkLearn.label = Lang.getString("LEARN_PORTS");
         this.chkLearn.selected = false;
         this.chkLearn.enabled = this.group.hasFeature(HmGroup.FEATURE_INHERIT_PORT);
         this.addElement(this.chkLearn);
         if(this.chkCopy.enabled)
         {
            this.chkCopy.selected = true;
         }
         else if(this.chkLearn.enabled)
         {
            this.chkLearn.selected = true;
         }
         self = this;
         ChangeWatcher.watch(this.chkLearn,["selected"],function(param1:PropertyChangeEvent):void
         {
            if(chkCopy.enabled)
            {
               self.chkCopy.selected = !param1.newValue;
            }
            else if(chkLearn.enabled)
            {
               chkLearn.selected = true;
            }
            if(param1.newValue)
            {
               lblPorts.text = Lang.getString("LERAN_PORTS_CONTENT");
            }
         });
         ChangeWatcher.watch(this.chkCopy,["selected"],function(param1:PropertyChangeEvent):void
         {
            if(chkLearn.enabled)
            {
               self.chkLearn.selected = !param1.newValue;
            }
            else if(chkCopy.enabled)
            {
               chkCopy.selected = true;
            }
            if(param1.newValue)
            {
               lblPorts.text = Lang.getString("COPY_PORTS_CONTENT");
            }
         });
         this.lblPorts = new Label();
         this.lblPorts.text = Lang.getString("COPY_PORTS_CONTENT");
         this.addElement(this.lblPorts);
         this.lstPorts = new SelectBoxList();
         this.lstPorts.dataProvider = this.portProvider;
         this.lstPorts.allowMultipleSelection = false;
         this.lstPorts.addEventListener(IndexChangeEvent.CHANGE,this.onListChanging);
         this.lstPorts.itemRenderer = new ClassFactory(LearnPortRenderer);
         this.lstPorts.labelFunction = this.portLabels;
         this.lstPorts.itemDisabledFunction = this.isListItemDisabled;
         this.addElement(this.lstPorts);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.RIGHT;
         this.addElement(this.grpButtons);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.btnCancel.visible = !this.editMode;
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
         GatewayPorts.instance.getPortCount(function(param1:GatewayPorts, param2:int, param3:Error):void
         {
            var _loc4_:ErrorBox = null;
            if(param2 >= LogicwareSettings.MAX_PORTS)
            {
               _loc4_ = ErrorBox.sharedBox;
               _loc4_.title = Lang.getString("MAX_PORTS_REACHED");
               _loc4_.contentText = Lang.getString("MAX_PORTS_REACHED_CONTENT");
               _loc4_.closeable = true;
               _loc4_.closeTitle = Lang.getString("GENERAL_SUBMIT");
               _loc4_.open(null);
               event.preventDefault();
               return;
            }
            loadBox.title = Lang.getString("LEARNING_PROCESS");
            loadBox.contentText = Lang.getString("LEARNING_PROCESS_CONTENT");
            loadBox.open(null);
            timeoutTimer = new Timer(TIMEOUT_DELAY,1);
            timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
            timeoutTimer.start();
            if(shouldCopy)
            {
               createPort(MCPCommands.ADD_PORT);
            }
            else
            {
               createPort(MCPCommands.INHERIT_PORT);
            }
         });
      }
      
      protected function isListItemDisabled(param1:Object, param2:int) : Boolean
      {
         return ArrayHelper.property_in_array("type",param1.type,this.group.ports);
      }
      
      private function createPort(param1:int) : void
      {
         var cmd:int = param1;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createMCP(cmd,null,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               InfoCenter.onNetTimeout();
               Log.warning("[LearnPortsBox] creating port failed! (NetTimeout)");
               return;
            }
            Log.debug("[LearnPortsBox] Received createPort response:\n" + param1.response);
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               Log.debug("[LearnPortsBox] Received createPort error");
               onMcpError(param1.response);
            }
            else if(param1.response.command == MCPCommands.INHERIT_PORT)
            {
               Log.debug("[LearnPortsBox] Received createPort inherit");
               onPortCreated(param1.response);
            }
            else if(param1.response.command == MCPCommands.ADD_PORT)
            {
               Log.debug("[LearnPortsBox] Received createPort add");
               onPortCreated(param1.response);
            }
            else
            {
               Log.warning("[LearnPortsBox] unexpected response while crating port:\n" + param1.response);
            }
         });
      }
      
      private function onMcpError(param1:MCPPackage) : void
      {
         if(!param1.payload || param1.payload.length < 1)
         {
            Log.warning("[LearnPortsBox] Received error without payload!");
            return;
         }
         param1.payload.position = 0;
         var _loc2_:int = param1.payload.readUnsignedByte();
         var _loc3_:ErrorBox = ErrorBox.sharedBox;
         _loc3_.contentText = _loc3_.contentText + ("(" + _loc2_ + ")");
         if(_loc2_ == MCPErrors.ADD_PORT_ERROR || _loc2_ == MCPErrors.NO_EMPTY_PORT_SLOT)
         {
            this.timeoutTimer.reset();
            this.lstPorts.selectedItem = null;
            LoadBox.sharedBox.close();
            this.loadBox.close();
            _loc3_.title = Lang.getString("ERROR_LERNING_PORT");
            _loc3_.contentText = Lang.getString("ERROR_LERANIN_PORT_CONTENT");
            _loc3_.closeable = true;
            _loc3_.closeTitle = Lang.getString("GENERAL_SUBMIT");
            _loc3_.open(null);
         }
      }
      
      private function setPortType(param1:int, param2:int, param3:Function) : void
      {
         var portId:int = param1;
         var type:int = param2;
         var callback:Function = param3;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetType(portId,type,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               Log.warning("[LearnPortsBox] writing port type failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               Log.warning("[LearnPortsBox] writing port type failed! mcp:\n" + param1.response);
               CallbackHelper.callCallback(callback,[]);
            }
            else if(param1.response.command == MCPCommands.SET_TYPE)
            {
               CallbackHelper.callCallback(callback,[]);
            }
            else
            {
               Log.warning("[LearnPortsBox] unexprected MCP-Package while writing port type! mcp:\n" + param1.response);
            }
         });
      }
      
      private function onPortCreated(param1:MCPPackage) : void
      {
         var port:HmPort = null;
         var errorBox:ErrorBox = null;
         var mcp:MCPPackage = param1;
         Log.debug("[LearnPortsBox] port created");
         if(!mcp.payload || mcp.payload.length < 1)
         {
            Log.warning("[LearnPortsBox] Received creation response without payload!");
            return;
         }
         mcp.payload.position = 0;
         var newId:int = mcp.payload.readUnsignedByte();
         LoadBox.sharedBox.close();
         if(this.lstPorts.selectedItem)
         {
            if(newId < 0)
            {
               errorBox = ErrorBox.sharedBox;
               errorBox.title = Lang.getString("ERROR_LERNING_PORT");
               errorBox.contentText = Lang.getString("ERROR_LERANIN_PORT_CONTENT");
               errorBox.contentText = errorBox.contentText + ("(" + MCPErrors.INVALID_PROTOCOL + ")");
               errorBox.closeable = true;
               errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
               errorBox.open(null);
            }
            port = new HmPort();
            port.id = newId;
            this.setPortType(newId,int(this.lstPorts.selectedItem.type),function():void
            {
               timeoutTimer.reset();
               port.type = int(lstPorts.selectedItem.type);
               group.ports.push(port);
               GatewayPorts.instance.getPortCount();
               lstPorts.selectedItem = null;
               lstPorts.updateRendererEnabled();
               loadBox.close();
            });
            if(this.responsePort == 255)
            {
               this.responsePort = port.id;
            }
         }
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
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         var errorBox:ErrorBox = null;
         var self:LearnPortsBox = null;
         var event:MouseEvent = param1;
         if(this.group.ports == null || this.group.ports.length == 0)
         {
            errorBox = ErrorBox.sharedBox;
            errorBox.title = Lang.getString("ERROR_NO_PORTS_LEARNED");
            errorBox.contentText = Lang.getString("ERROR_NO_PORTS_LEARNED_CONTENT");
            errorBox.closeable = true;
            errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            errorBox.open(null);
            return;
         }
         if(this.editMode)
         {
            this.setGroupedPorts();
            this.close(true,this.group);
         }
         else
         {
            this.setUIEnabled(false);
            self = this;
            GatewayGroups.instance.createGroup(this.group.name,function(param1:GatewayGroups, param2:HmGroup, param3:Error):void
            {
               var sender:GatewayGroups = param1;
               var group:HmGroup = param2;
               var error:Error = param3;
               if(error != null)
               {
                  Log.error("[LearnPortsBox] creating group failed! " + error);
                  return;
               }
               self.group.id = group.id;
               self.group.name = group.name;
               setGroupedPorts(function():void
               {
                  onGroupAdded();
               });
            });
         }
      }
      
      private function setUIEnabled(param1:Boolean) : void
      {
         this.btnSubmit.enabled = param1;
         this.btnCancel.enabled = param1;
         this.lstPorts.enabled = param1;
         this.chkCopy.enabled = param1;
         this.chkLearn.enabled = param1;
      }
      
      private function setGroupName(param1:Function = null) : void
      {
         var callback:Function = param1;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetGroupName(this.group.id,this.group.name),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               Log.warning("[LearnPortsBox] setting group name to \'" + name + "\' failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
            }
            CallbackHelper.callCallback(callback,[]);
         });
      }
      
      private function setGroupedPorts(param1:Function = null) : void
      {
         var port:Object = null;
         var callback:Function = param1;
         var portIds:Array = [];
         for each(port in this.group.ports)
         {
            portIds.push(port.id);
         }
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetGroupedPorts(this.group.id,portIds),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               Log.warning("[LearnPortsBox] failed to update group! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
            }
            CallbackHelper.callCallback(callback,[]);
         });
      }
      
      private function setValue(param1:int, param2:int, param3:Function = null) : void
      {
         var address:int = param1;
         var value:int = param2;
         var callback:Function = param3;
         GatewayValues.instance.setValue(address,value,function(param1:GatewayValues, param2:uint, param3:uint, param4:Error):*
         {
            if(param4 != null)
            {
               Log.warning("[LearnPortsBox] setting value \'" + param3 + "\' to address \'" + address + "\' failed!\n" + param4);
               InfoCenter.onNetTimeout();
               return;
            }
            CallbackHelper.callCallback(callback,[]);
         });
      }
      
      protected function onGroupAdded() : void
      {
         this.setValue(this.group.id,this.group.type,function():void
         {
            setValue(group.id + LogicwareSettings.MAX_PORTS,!!groupRequestable?int(responsePort):255,function():void
            {
               LoadBox.sharedBox.close();
               setUIEnabled(true);
               close(true,group);
            });
         });
         if(!AppCache.sharedCache.hmProcessor.requestablePorts)
         {
            AppCache.sharedCache.hmProcessor.requestablePorts = {};
         }
         AppCache.sharedCache.hmProcessor.requestablePorts[this.group.id] = !!this.groupRequestable?this.responsePort:255;
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
