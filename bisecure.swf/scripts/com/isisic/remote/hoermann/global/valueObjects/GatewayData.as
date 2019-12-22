package com.isisic.remote.hoermann.global.valueObjects
{
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import me.mweber.basic.helper.StringHelper;
   import mx.events.PropertyChangeEvent;
   
   public class GatewayData extends EventDispatcher implements IDisposable
   {
      
      public static const PORT_COUNT_CHANGED:String = "portCountChanged";
      
      public static const GROUPS_CHANGED:String = "groupsChanged";
      
      public static const VALUES_CHANGED:String = "valuesChanged";
      
      public static const USERS_CHANGED:String = "usersChanged";
      
      public static const VERSION_CHANGED:String = "versionChanged";
       
      
      private var _1553012098userRights:Array = null;
      
      private var _softwareVersionName:String = null;
      
      private var _softwareVersionNumber:uint = 0;
      
      private var _values:Object = null;
      
      private var _groups:Array = null;
      
      private var _portCount:int = -1;
      
      private var _users:Array = null;
      
      public function GatewayData()
      {
         super();
      }
      
      [Bindable(event="versionChanged")]
      public function get softwareVersionName() : String
      {
         return this._softwareVersionName;
      }
      
      [Bindable(event="versionChanged")]
      public function get softwareVersionNumber() : uint
      {
         return this._softwareVersionNumber;
      }
      
      [Bindable(event="valuesChanged")]
      public function get values() : Object
      {
         return this._values;
      }
      
      public function set values(param1:Object) : void
      {
         if(this._values == param1)
         {
            return;
         }
         this._values = param1;
         dispatchEvent(new Event("valuesChanged"));
      }
      
      [Bindable(event="groupsChanged")]
      public function get groups() : Array
      {
         return this._groups;
      }
      
      public function set groups(param1:Array) : void
      {
         if(this._groups == param1)
         {
            return;
         }
         this._groups = param1;
         dispatchEvent(new Event("groupsChanged"));
      }
      
      [Bindable(event="portCountChanged")]
      public function get portCount() : int
      {
         return this._portCount;
      }
      
      public function set portCount(param1:int) : void
      {
         if(this._portCount == param1)
         {
            return;
         }
         this._portCount = param1;
         dispatchEvent(new Event("portCountChanged"));
      }
      
      [Bindable(event="usersChanged")]
      public function get users() : Array
      {
         return this._users;
      }
      
      public function set users(param1:Array) : void
      {
         if(this._users == param1)
         {
            return;
         }
         this._users = param1;
         dispatchEvent(new Event("usersChanged"));
      }
      
      public function updateSoftwareVersion(param1:ConnectionContext) : void
      {
         var self:GatewayData = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var context:ConnectionContext = param1;
         self = this;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            if(loader.data.command == Commands.ERROR)
            {
               loader.data.payload.position = 0;
               _loc2_ = loader.data.payload.readUnsignedByte();
               if(_loc2_ == Errors.COMMAND_NOT_FOUND)
               {
                  Debug.debug("[GatewayData] Firmware Version is <= EE001425-06");
               }
               else
               {
                  Debug.warning("[GatewayData] couldn\'t load Gateway-Firmware Version! (Error: 0x" + StringHelper.fillWith(_loc2_.toString(16),"0",2) + " = " + Errors.NAMES[_loc2_] + ")");
               }
               self._softwareVersionName = GatewayVersions.EE001425_06_OR_LOWER;
               self._softwareVersionNumber = GatewayVersions.NR_EE001425_06_OR_LOWER;
            }
            else if(loader.data.command == Commands.GET_GW_VERSION)
            {
               loader.data.payload.position = 0;
               self._softwareVersionName = loader.data.payload.readUTFBytes(loader.data.payload.bytesAvailable);
               if(self._softwareVersionName == null || self._softwareVersionName == "")
               {
                  Debug.warning("[GatewayData] couldn\'t load Gateway-Firmware Version! (Invalid Payload)");
               }
               else
               {
                  self._softwareVersionNumber = GatewayVersions.numberFromName(self._softwareVersionName);
               }
               self.dispatchEvent(new Event(GatewayData.VERSION_CHANGED));
            }
            else
            {
               Debug.warning("[GatewayData] couldn\'t load Gateway-Firmware Version! " + "(unexpected response from Gateway) MCP:\n" + loader.data.toString());
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.error("[GatewayData] couldn\'t load Gateway-Firmware Version! (Net Timeout)");
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_GW_VERSION));
      }
      
      public function updatePortCount(param1:ConnectionContext) : void
      {
         var self:GatewayData = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var context:ConnectionContext = param1;
         self = this;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            if(loader.data.command != Commands.GET_PORTS)
            {
               Debug.warning("[GatewayData] updating portCount failed!mcp:\n" + loader.data);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            portCount = loader.data.payload.length;
            self.dispatchEvent(new Event(GatewayData.PORT_COUNT_CHANGED));
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[GatewayData] updating portCount failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_PORTS));
      }
      
      public function updateGroups(param1:ConnectionContext, param2:int = -1) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var jStr:String = null;
         var jMCP:Object = null;
         var context:ConnectionContext = param1;
         var user:int = param2;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            var jData:* = undefined;
            var group:* = undefined;
            var e:Event = param1;
            if(loader.data.command != Commands.JMCP)
            {
               Debug.warning("[GatewayData] updating groups failed! mcp:\n" + loader.data);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var raw:* = loader.data.payload;
            raw.position = 0;
            var jStr:* = raw.readUTFBytes(raw.bytesAvailable);
            try
            {
               jData = JSON.parse(jStr);
            }
            catch(e:Error)
            {
               Debug.warning("[GatewayData] updating groups failed! (JMCP not parsable)\n" + e);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var jGroups:* = new Array();
            for each(group in jData)
            {
               jGroups.push(HmGroup.fromObject(group));
            }
            jGroups.sort(GroupTypes.groupIDSorting);
            groups = jGroups;
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[GatewayData] updating groups failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         if(user > 0)
         {
            jMCP = JSON.parse(Commands.JMCP_GET_GROUPS);
            jMCP[Commands.JMCP_KEY_FOR_USER] = user;
            jStr = JSON.stringify(jMCP);
         }
         else
         {
            jStr = Commands.JMCP_GET_GROUPS;
         }
         loader.request(MCPBuilder.buildMCP(Commands.JMCP,MCPBuilder.payloadJMCP(jStr)));
      }
      
      public function updateValues(param1:ConnectionContext) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var context:ConnectionContext = param1;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            var jData:* = undefined;
            var key:* = undefined;
            var e:Event = param1;
            if(loader.data.command != Commands.JMCP)
            {
               Debug.warning("[GatewayData] updating values failed! mcp:\n" + loader.data);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var raw:* = loader.data.payload;
            raw.position = 0;
            var jStr:* = raw.readUTFBytes(raw.bytesAvailable);
            try
            {
               jData = JSON.parse(jStr);
            }
            catch(e:Error)
            {
               Debug.warning("[GatewayData] updating values failed! (JMCP not parsable)\n" + e);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var jValues:* = new Object();
            for(key in jData)
            {
               jValues[int(key)] = jData[key];
            }
            values = jValues;
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[GatewayData] updating values failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.JMCP,MCPBuilder.payloadJMCP(Commands.JMCP_GET_VALUES)));
      }
      
      public function updateUsers(param1:ConnectionContext) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var context:ConnectionContext = param1;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            var jData:* = undefined;
            var e:Event = param1;
            if(loader.data.command != Commands.JMCP)
            {
               Debug.warning("[GatewayData] updating users failed! mcp:\n" + loader.data);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var raw:* = loader.data.payload;
            raw.position = 0;
            var jStr:* = raw.readUTFBytes(raw.bytesAvailable);
            try
            {
               jData = JSON.parse(jStr);
            }
            catch(e:Error)
            {
               Debug.warning("[GatewayData] updating users failed! (JMCP not parsable)\n" + e);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            users = jData as Array;
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[GatewayData] updating users failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.JMCP,MCPBuilder.payloadJMCP(Commands.JMCP_GET_USERS)));
      }
      
      public function dispose() : void
      {
         this.clear();
      }
      
      public function clear() : void
      {
         this.userRights = null;
         this._values = null;
         this._groups = null;
         this._portCount = -1;
      }
      
      [Bindable(event="propertyChange")]
      public function get userRights() : Array
      {
         return this._1553012098userRights;
      }
      
      public function set userRights(param1:Array) : void
      {
         var _loc2_:Object = this._1553012098userRights;
         if(_loc2_ !== param1)
         {
            this._1553012098userRights = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userRights",_loc2_,param1));
            }
         }
      }
   }
}
