package com.isisic.remote.lw
{
   import com.isisic.remote.lw.mcp.MCPProcessor;
   import flash.net.URLRequestHeader;
   
   public class ConnectionContext implements IDisposable
   {
       
      
      public var httpAutentication:URLRequestHeader = null;
      
      protected var _processor:MCPProcessor;
      
      protected var _connectionType:String;
      
      protected var _host:String;
      
      protected var _port:int;
      
      protected var _mac:String;
      
      public var clientId:String;
      
      protected var _remoteId:String;
      
      public function ConnectionContext(param1:MCPProcessor, param2:String, param3:String, param4:int, param5:String, param6:String, param7:String)
      {
         super();
         this._processor = param1;
         this._connectionType = param2;
         this._host = param3;
         this._port = param4;
         this.clientId = param5;
         this._remoteId = param6;
         this._mac = param7;
      }
      
      public function get connected() : Boolean
      {
         return this.processor.connected;
      }
      
      [Bindable(event="wontChange")]
      public function get processor() : MCPProcessor
      {
         return this._processor;
      }
      
      public function get connectionType() : String
      {
         return this._connectionType;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function get mac() : String
      {
         return this._mac;
      }
      
      public function get remoteId() : String
      {
         return this._remoteId;
      }
      
      public function dispose() : void
      {
         this.processor.dispose();
         this._connectionType = null;
         this._host = null;
         this._port = 0;
         this._mac = null;
         this.clientId = null;
         this._remoteId = null;
      }
      
      public function toString() : String
      {
         return "[ConnectionContext: processor=\'" + this.processor + "\' connectionType=\'" + this.connectionType + "\' host=\'" + this.host + "\' port=\'" + this.port + "\' mac=\'" + this.mac + "\' clientId=\'" + this.clientId + "\' remoteId=\'" + this.remoteId + "\']";
      }
   }
}
