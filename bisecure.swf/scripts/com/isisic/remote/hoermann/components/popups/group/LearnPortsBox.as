package com.isisic.remote.hoermann.components.popups.group
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.SelectBoxList;
   import com.isisic.remote.hoermann.components.popups.LoadBox;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.renderer.LearnPortRenderer;
   import com.isisic.remote.hoermann.views.actors.ActorScreen;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCP;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import me.mweber.basic.helper.StringHelper;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayList;
   import mx.core.ClassFactory;
   import mx.events.PropertyChangeEvent;
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
      
      private var group:Object;
      
      private var context:ConnectionContext;
      
      private var loadBox:LoadBox;
      
      private var editMode:Boolean;
      
      private var responsePort:int = 255;
      
      private var timeoutTimer:Timer;
      
      public function LearnPortsBox(param1:Object, param2:ConnectionContext, param3:Boolean = false)
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         super();
         this.editMode = param1.id >= 0;
         if(HoermannRemote.gatewayData.portCount < 0)
         {
            HoermannRemote.gatewayData.updatePortCount(param2);
         }
         this.groupRequestable = param3;
         this.loadBox = new LoadBox();
         this.title = Lang.getString("LEARN_PORTS_TITLE");
         this.group = param1;
         this.context = param2;
         if(!this.group.ports)
         {
            this.group.ports = new Array();
         }
         var _loc4_:ArrayList = new ArrayList();
         if(!param1.ports)
         {
            param1.ports = new Array();
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
         this.addElement(this.chkCopy);
         this.chkLearn = new CheckBox();
         this.chkLearn.label = Lang.getString("LEARN_PORTS");
         this.chkLearn.selected = false;
         this.addElement(this.chkLearn);
         self = this;
         ChangeWatcher.watch(this.chkLearn,["selected"],function(param1:PropertyChangeEvent):void
         {
            self.chkCopy.selected = !param1.newValue;
            if(param1.newValue)
            {
               lblPorts.text = Lang.getString("LERAN_PORTS_CONTENT");
            }
         });
         ChangeWatcher.watch(this.chkCopy,["selected"],function(param1:PropertyChangeEvent):void
         {
            self.chkLearn.selected = !param1.newValue;
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
      
      private function get portCount() : int
      {
         return HoermannRemote.gatewayData.portCount;
      }
      
      protected function onListChanging(param1:IndexChangeEvent) : void
      {
         if(this.portCount >= ActorScreen.MAX_CHANNELS)
         {
            HoermannRemote.errorBox.title = Lang.getString("MAX_PORTS_REACHED");
            HoermannRemote.errorBox.contentText = Lang.getString("MAX_PORTS_REACHED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            param1.preventDefault();
            return;
         }
         this.loadBox.title = Lang.getString("LEARNING_PROCESS");
         this.loadBox.contentText = Lang.getString("LEARNING_PROCESS_CONTENT");
         this.loadBox.open(null);
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         if(this.shouldCopy)
         {
            this.createPort(Commands.ADD_PORT);
         }
         else
         {
            this.createPort(Commands.INHERIT_PORT);
         }
      }
      
      protected function isListItemDisabled(param1:Object, param2:int) : Boolean
      {
         return ArrayHelper.property_in_array("type",param1.type,this.group.ports);
      }
      
      private function createPort(param1:int) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var cmd:int = param1;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            Debug.debug("[LearnPortsBox] Received createPort response:\n" + loader.data);
            if(loader.data.command == Commands.ERROR)
            {
               Debug.debug("[LearnPortsBox] Received createPort error");
               onMcpError(loader.data);
            }
            else if(loader.data.command == Commands.INHERIT_PORT)
            {
               Debug.debug("[LearnPortsBox] Received createPort inherit");
               onPortCreated(loader.data);
            }
            else if(loader.data.command == Commands.ADD_PORT)
            {
               Debug.debug("[LearnPortsBox] Received createPort add");
               onPortCreated(loader.data);
            }
            else
            {
               Debug.warning("[LearnPortsBox] unexpected response while crating port:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            InfoCenter.onNetTimeout();
            Debug.warning("[LearnPortsBox] creating port failed!\n" + param1);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(cmd));
      }
      
      private function validateInherit(param1:MCP) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var pkg:MCP = param1;
         if(!pkg.payload || pkg.payload.length < 1)
         {
            Debug.warning("[LearnPortsBox] Received creation response without payload!");
            return;
         }
         pkg.payload.position = 0;
         var newId:int = pkg.payload.readUnsignedByte();
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(loader.data.command == Commands.HM_GET_TRANSITION)
            {
               onPortCreated(pkg);
            }
            else if(loader.data.command == Commands.ERROR)
            {
               Debug.warning("[LearnPortsBox] validating port failed (MCP Error)! mcp:\n" + loader.data);
               HoermannRemote.loadBox.close();
               HoermannRemote.errorBox.title = Lang.getString("ERROR_LERNING_PORT");
               HoermannRemote.errorBox.contentText = Lang.getString("ERROR_LERANIN_PORT_CONTENT");
               HoermannRemote.errorBox.contentText = HoermannRemote.errorBox.contentText + (" (" + StringHelper.fillWith(Errors.PORT_NOT_FOUND.toString(16),"0") + ")");
               HoermannRemote.errorBox.closeable = true;
               HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
               HoermannRemote.errorBox.open(null);
            }
            else
            {
               Debug.warning("[LearnPortsBox] validating port failed (unexpected command)! mcp:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[LearnPortsBox] requesting transitionFailed!\n" + param1);
            HoermannRemote.loadBox.close();
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.HM_GET_TRANSITION,MCPBuilder.payloadGetTransition(newId)));
      }
      
      private function onMcpError(param1:MCP) : void
      {
         if(!param1.payload || param1.payload.length < 1)
         {
            Debug.warning("[LearnPortsBox] Received error without payload!");
            return;
         }
         param1.payload.position = 0;
         var _loc2_:int = param1.payload.readUnsignedByte();
         HoermannRemote.errorBox.contentText = HoermannRemote.errorBox.contentText + ("(" + _loc2_ + ")");
         if(_loc2_ == Errors.ADD_PORT_ERROR || _loc2_ == Errors.NO_EMPTY_PORT_SLOT)
         {
            this.timeoutTimer.reset();
            this.lstPorts.selectedItem = null;
            HoermannRemote.loadBox.close();
            this.loadBox.close();
            HoermannRemote.errorBox.title = Lang.getString("ERROR_LERNING_PORT");
            HoermannRemote.errorBox.contentText = Lang.getString("ERROR_LERANIN_PORT_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
         }
      }
      
      private function setPortType(param1:int, param2:int, param3:Function) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var portId:int = param1;
         var type:int = param2;
         var callback:Function = param3;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(loader.data.command == Commands.ERROR)
            {
               Debug.warning("[LearnPortsBox] writing port type failed! mcp:\n" + loader.data);
               if(callback != null)
               {
                  callback.call();
               }
            }
            else if(loader.data.command == Commands.SET_TYPE)
            {
               if(callback != null)
               {
                  callback.call();
               }
            }
            else
            {
               Debug.warning("[LearnPortsBox] unexprected MCP-Package while writing port type! mcp:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[LearnPortsBox] writing port type failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_TYPE,MCPBuilder.payloadSetType(portId,type)));
      }
      
      private function onPortCreated(param1:MCP) : void
      {
         var port:Object = null;
         var mcp:MCP = param1;
         Debug.debug("[LearnPortsBox] port created");
         if(!mcp.payload || mcp.payload.length < 1)
         {
            Debug.warning("[LearnPortsBox] Received creation response without payload!");
            return;
         }
         mcp.payload.position = 0;
         var newId:int = mcp.payload.readUnsignedByte();
         HoermannRemote.loadBox.close();
         if(this.lstPorts.selectedItem)
         {
            if(newId < 0)
            {
               HoermannRemote.errorBox.title = Lang.getString("ERROR_LERNING_PORT");
               HoermannRemote.errorBox.contentText = Lang.getString("ERROR_LERANIN_PORT_CONTENT");
               HoermannRemote.errorBox.contentText = HoermannRemote.errorBox.contentText + ("(" + Errors.INVALID_PROTOCOL + ")");
               HoermannRemote.errorBox.closeable = true;
               HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
               HoermannRemote.errorBox.open(null);
            }
            port = new Object();
            port.id = newId;
            this.setPortType(newId,int(this.lstPorts.selectedItem.type),function():void
            {
               timeoutTimer.reset();
               port.type = int(lstPorts.selectedItem.type);
               group.ports.push(port);
               HoermannRemote.gatewayData.updatePortCount(context);
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
         HoermannRemote.errorBox.title = Lang.getString("ERROR_TIMEOUT");
         HoermannRemote.errorBox.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
         this.lstPorts.selectedItem = null;
         this.loadBox.close();
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:MouseEvent = param1;
         if(this.group.ports == null || this.group.ports.length == 0)
         {
            HoermannRemote.errorBox.title = Lang.getString("ERROR_NO_PORTS_LEARNED");
            HoermannRemote.errorBox.contentText = Lang.getString("ERROR_NO_PORTS_LEARNED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
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
            loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
            {
               var e:Event = param1;
               if(loader.data.command == Commands.ERROR)
               {
                  onMcpError(loader.data);
               }
               else if(loader.data.command == Commands.ADD_GROUP)
               {
                  if(!loader.data.payload || loader.data.payload.length < 1)
                  {
                     Debug.warning("[LearnPortsBox] received ADD_PORT command without payload! mcp:\n" + loader.data);
                     Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                     return;
                  }
                  loader.data.payload.position = 0;
                  group.id = loader.data.payload.readUnsignedByte();
                  setGroupName(function():void
                  {
                     setGroupedPorts(function():void
                     {
                        onGroupAdded();
                     });
                  });
               }
               else
               {
                  Debug.warning("[LearnPortsBox] received unexpected mcp:\n" + loader.data);
               }
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
            },loaderFailed = function(param1:Event):void
            {
               Debug.warning("[LearnPortsBox] failed to add group!\n" + param1);
               InfoCenter.onNetTimeout();
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
            });
            loader.request(MCPBuilder.buildMCP(Commands.ADD_GROUP));
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
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var callback:Function = param1;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(callback != null)
            {
               callback.call();
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[LearnPortsBox] setting group name to \'" + name + "\' failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_GROUP_NAME,MCPBuilder.payloadSetGroupName(this.group.id,this.group.name)));
      }
      
      private function setGroupedPorts(param1:Function = null) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var port:Object = null;
         var callback:Function = param1;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(callback != null)
            {
               callback.call();
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[LearnPortsBox] failed to update group!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         var portIds:Array = new Array();
         for each(port in this.group.ports)
         {
            portIds.push(port.id);
         }
         loader.request(MCPBuilder.buildMCP(Commands.SET_GROUPED_PORTS,MCPBuilder.payloadSetGroupedPorts(this.group.id,portIds)));
      }
      
      private function setValue(param1:int, param2:int, param3:Function = null) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var address:int = param1;
         var value:int = param2;
         var callback:Function = param3;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(callback != null)
            {
               callback.call();
            }
            HoermannRemote.gatewayData.values[address] = value;
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[LearnPortsBox] setting value \'" + value + "\' to address \'" + address + "\' failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_VALUE,MCPBuilder.payloadSetValue(address,value)));
      }
      
      protected function onGroupAdded() : void
      {
         this.setValue(this.group.id,this.group.type,function():void
         {
            setValue(group.id + AppData.MAX_PORTS,!!groupRequestable?int(responsePort):255,function():void
            {
               HoermannRemote.loadBox.close();
               setUIEnabled(true);
               close(true,group);
            });
         });
         if(!HmProcessor.defaultProcessor.requestablePorts)
         {
            HmProcessor.defaultProcessor.requestablePorts = new Object();
         }
         HmProcessor.defaultProcessor.requestablePorts[this.group.id] = !!this.groupRequestable?this.responsePort:255;
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
