package com.isisic.remote.hoermann.components.popups.group
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.popups.LoadBox;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.renderer.LearnPortRenderer;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayList;
   import mx.core.ClassFactory;
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
         var _loc4_:Object = null;
         super();
         this.loadBox = new LoadBox();
         this.title = Lang.getString("REMOVE_PORTS");
         this.group = param1;
         this.context = param2;
         if(!this.group.ports)
         {
            this.group.ports = new Array();
         }
         this.portProvider = new ArrayList();
         if(!param1.ports)
         {
            param1.ports = new Array();
         }
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1.ports)
         {
            this.portProvider.addItem({
               "type":_loc4_.type,
               "name":PortTypes.NAMES[_loc4_.type],
               "id":_loc4_.id
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
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:IndexChangeEvent = param1;
         this.loadBox.title = Lang.getString("REMOVING_PROCESS");
         this.loadBox.contentText = Lang.getString("REMOVING_PROCESS_CONTENT");
         this.loadBox.open(null);
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            if(loader.data.command == Commands.ERROR)
            {
               if(!loader.data.payload)
               {
                  Debug.warning("[RemovePortsBox] received mcp error without payload! mcp:\n" + loader.data);
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               loader.data.payload.position = 0;
               _loc2_ = loader.data.payload.readUnsignedByte();
               HoermannRemote.errorBox.contentText = HoermannRemote.errorBox.contentText + ("(" + _loc2_ + ")");
               if(_loc2_ == Errors.PORT_NOT_FOUND)
               {
                  if(lstPorts.selectedItem)
                  {
                     new ArrayList(group.ports).removeItem(lstPorts.selectedItem.id);
                     portProvider.removeItem(lstPorts.selectedItem);
                  }
                  lstPorts.selectedItem = null;
                  HoermannRemote.loadBox.close();
                  loadBox.close();
               }
            }
            else if(loader.data.command == Commands.REMOVE_PORT)
            {
               HoermannRemote.loadBox.close();
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
                  HoermannRemote.gatewayData.portCount--;
                  HoermannRemote.gatewayData.dispatchEvent(new Event(GatewayData.PORT_COUNT_CHANGED));
                  loadBox.close();
               }
            }
            else
            {
               Debug.warning("[RemovePortsBox] unexpected mcp:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.REMOVE_PORT,MCPBuilder.payloadRemovePort(this.lstPorts.selectedItem.id)));
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
      
      protected function updateScenarios(param1:int) : void
      {
         var _loc3_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc2_:Array = HoermannRemote.appData.scenarios;
         Debug.debug("Updateing Scenarios for " + param1);
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc5_];
            for each(_loc7_ in _loc3_.actions)
            {
               if(_loc7_.portId == param1)
               {
                  _loc4_.push(_loc5_);
               }
            }
            _loc5_++;
         }
         for each(_loc6_ in _loc4_)
         {
            Debug.debug("removing Scenario: " + _loc2_[_loc6_].name + " (" + _loc6_ + ")");
            _loc2_.splice(_loc6_,1);
         }
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         this.setGroupedPorts();
         this.close(true,this.group);
      }
      
      private function setGroupedPorts() : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var port:Object = null;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
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
