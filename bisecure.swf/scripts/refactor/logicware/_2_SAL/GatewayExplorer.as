package refactor.logicware._2_SAL
{
   import refactor.logicware._3_PAL.GatewayDiscover.GatewayCollector;
   import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;
   
   public class GatewayExplorer
   {
      
      private static var singleton:GatewayExplorer;
       
      
      private var _clientId:String;
      
      private var _clientPassword:String;
      
      public function GatewayExplorer(param1:ConstructorLock#113)
      {
         super();
      }
      
      public static function get sharedExplorer() : GatewayExplorer
      {
         if(singleton == null)
         {
            singleton = new GatewayExplorer(null);
         }
         return singleton;
      }
      
      public function get clientId() : String
      {
         return this._clientId;
      }
      
      public function get clientPassword() : String
      {
         return this._clientPassword;
      }
      
      public function configureRemote(param1:String, param2:String) : void
      {
         this._clientId = param1;
         this._clientPassword = param2;
      }
      
      public function findGateways(param1:String, param2:String, param3:Function = null) : void
      {
         var self:GatewayExplorer = null;
         var clientId:String = param1;
         var clientPassword:String = param2;
         var callback:Function = param3;
         this.configureRemote(clientId,clientPassword);
         self = this;
         GatewayCollector.collector.findGateways(clientId,clientPassword,function(param1:GatewayCollector):void
         {
            var sender:GatewayCollector = param1;
            new GatewayNameLoader().loadNames(clientId,clientPassword,sender.getVector(),function(param1:Vector.<GatewayInfos>):void
            {
               callback(self,param1);
            });
         });
      }
   }
}

class ConstructorLock#113
{
    
   
   function ConstructorLock#113()
   {
      super();
   }
}

import flash.utils.ByteArray;
import refactor.logicware._2_SAL.ConnectionContext;
import refactor.logicware._2_SAL.LocalConnectionContext;
import refactor.logicware._2_SAL.RemoteConnectionContext;
import refactor.logicware._2_SAL.mcp.MCPBuilder;
import refactor.logicware._2_SAL.mcp.MCPLoader;
import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;
import refactor.logicware._5_UTIL.Log;
import refactor.logicware._5_UTIL.LogicwareSettings;
import refactor.logicware._5_UTIL.StringHelper;

class GatewayNameLoader
{
    
   
   private var clientId:String;
   
   private var clientPassword:String;
   
   private var entryQueue:Vector.<GatewayInfos>;
   
   private var resolvedNames:Vector.<GatewayInfos>;
   
   private var toResolveCount:int;
   
   private var callback:Function;
   
   function GatewayNameLoader()
   {
      super();
   }
   
   public function loadNames(param1:String, param2:String, param3:Vector.<GatewayInfos>, param4:Function = null) : void
   {
      this.clientId = param1;
      this.clientPassword = param2;
      this.entryQueue = param3;
      this.resolvedNames = new Vector.<GatewayInfos>(0);
      this.toResolveCount = this.entryQueue.length;
      if(this.toResolveCount <= 0)
      {
         param4(this.resolvedNames);
         return;
      }
      this.callback = param4;
      this._processQueue();
   }
   
   private function _processQueue() : void
   {
      var activeEntry:GatewayInfos = null;
      var loader:MCPLoader = null;
      if(this.entryQueue.length <= 0)
      {
         return;
      }
      activeEntry = this.entryQueue.shift();
      if(activeEntry.gateway.name != null)
      {
         this.resolvedNames.push(activeEntry);
         this._processQueue();
      }
      else
      {
         loader = new MCPLoader(this._createContext(activeEntry));
         loader.load(MCPBuilder.createGetName(),function(param1:MCPLoader):void
         {
            var _loc2_:ByteArray = null;
            if(param1.response == null)
            {
               Log.info("[GatewayExplorer] name request failed for: " + activeEntry.gateway.mac);
               activeEntry.isAvailable = false;
               resolvedNames.push(activeEntry);
            }
            else
            {
               _loc2_ = param1.response.payload;
               _loc2_.position = 0;
               activeEntry.gateway.name = _loc2_.readUTFBytes(_loc2_.bytesAvailable);
               resolvedNames.push(activeEntry);
            }
            if(StringHelper.IsNullOrEmpty(activeEntry.gateway.name))
            {
               Log.error("[GatewayExplorer] Loading Gateway-Name failed!");
            }
            toResolveCount--;
            if(param1.context != null)
            {
               param1.context.dispose();
            }
            if(toResolveCount <= 0)
            {
               if(callback != null)
               {
                  callback(resolvedNames);
               }
            }
         });
         this._processQueue();
      }
   }
   
   private function _createContext(param1:GatewayInfos) : ConnectionContext
   {
      if(param1.isRemote)
      {
         return new RemoteConnectionContext(this.clientId,this.clientPassword,param1.gateway.mac);
      }
      return new LocalConnectionContext(param1.address,LogicwareSettings.LOCAL_CONNECTION_PORT,param1.gateway.mac);
   }
}
