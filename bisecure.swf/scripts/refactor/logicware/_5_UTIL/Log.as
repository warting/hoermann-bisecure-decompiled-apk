package refactor.logicware._5_UTIL
{
   import com.isisic.remote.hoermann.components.popups.SetDebugInfoBox;
   import com.isisic.remote.lw.mcp.Commands;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.globalization.DateTimeFormatter;
   import flash.globalization.LocaleID;
   import flash.net.Socket;
   import flash.utils.Timer;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._4_HAL.network.Timings;
   
   public class Log
   {
      
      public static var TRACE_INPUT:Boolean = false;
      
      public static var TRACE_OUTPUT:Boolean = false;
      
      public static var WRITE_DEBUG:Boolean = true;
      
      public static var WRITE_INFO:Boolean = true;
      
      public static var WRITE_WARNING:Boolean = true;
      
      public static var WRITE_ERROR:Boolean = true;
      
      private static var netDebug_socket:Socket;
      
      private static var netDebug_flusher:Timer;
      
      private static var netDebug_cache:Vector.<String> = new Vector.<String>();
       
      
      public function Log()
      {
         super();
      }
      
      public static function debug(param1:String) : Boolean
      {
         return Log.write("DEBUG",param1);
      }
      
      public static function info(param1:String) : Boolean
      {
         return Log.write("INFO",param1);
      }
      
      public static function warning(param1:String) : Boolean
      {
         return Log.write("WARNING",param1);
      }
      
      public static function error(param1:String) : Boolean
      {
         return Log.write("ERROR",param1);
      }
      
      private static function write(param1:String, param2:String) : Boolean
      {
         if(param1)
         {
            switch(param1.toUpperCase())
            {
               case "DEBUG":
                  if(!WRITE_DEBUG)
                  {
                     return false;
                  }
                  break;
               case "INFO":
                  if(!WRITE_INFO)
                  {
                     return false;
                  }
                  break;
               case "WARNING":
                  if(!WRITE_WARNING)
                  {
                     return false;
                  }
                  break;
               case "ERROR":
                  if(!WRITE_ERROR)
                  {
                     return false;
                  }
                  break;
            }
         }
         var _loc3_:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
         _loc3_.setDateTimePattern("HH:mm:ss");
         var _loc4_:Date = new Date();
         var _loc5_:String = "";
         if(param1)
         {
            _loc5_ = " " + _loc3_.format(_loc4_) + ":" + StringHelper.fillWith(_loc4_.milliseconds.toString(),"0",3) + " [" + param1 + "] " + param2;
         }
         else
         {
            _loc5_ = " " + _loc3_.format(_loc4_) + ":" + StringHelper.fillWith(_loc4_.milliseconds.toString(),"0",3) + " " + param2;
         }
         netDebug_trace(_loc5_);
         return true;
      }
      
      public static function inPackage(param1:MCPPackage, param2:String = null, param3:String = null, param4:String = null) : Boolean
      {
         if(TRACE_INPUT)
         {
            writeMCP("RECEIVED",param1,"<",param2,param3,param4);
            return true;
         }
         return false;
      }
      
      public static function outPackage(param1:MCPPackage, param2:String = null, param3:String = null, param4:String = null) : Boolean
      {
         if(TRACE_OUTPUT)
         {
            writeMCP("SEND",param1,">",param2,param3,param4);
            return true;
         }
         return false;
      }
      
      private static function writeMCP(param1:String, param2:MCPPackage, param3:String, param4:String = null, param5:String = null, param6:String = null) : void
      {
         var _loc9_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc7_:* = "\n";
         var _loc8_:int = 50;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ = _loc7_ + param3;
            _loc9_++;
         }
         _loc7_ = _loc7_ + ("\n" + param3 + " " + param1);
         _loc7_ = _loc7_ + ("\n" + param3);
         if(param6)
         {
            _loc7_ = _loc7_ + ("\n" + param3 + "\tConnectionType: " + param6);
            _loc7_ = _loc7_ + ("\n" + param3);
         }
         if(param4)
         {
            _loc7_ = _loc7_ + ("\n" + param3 + "\tTMCP-src: " + param4);
         }
         if(param5)
         {
            _loc7_ = _loc7_ + ("\n" + param3 + "\tTMCP-dst: " + param5);
         }
         if(param4 || param5)
         {
            _loc7_ = _loc7_ + ("\n" + param3);
         }
         var _loc10_:String = param2.tag.toString(16).toUpperCase();
         while(_loc10_.length < 2)
         {
            _loc10_ = "0" + _loc10_;
         }
         _loc10_ = "0x" + _loc10_;
         var _loc11_:String = param2.token.toString(16).toUpperCase();
         while(_loc11_.length < 8)
         {
            _loc11_ = "0" + _loc11_;
         }
         _loc11_ = "0x" + _loc11_;
         var _loc12_:String = param2.command.toString(16).toUpperCase();
         while(_loc12_.length < 2)
         {
            _loc12_ = "0" + _loc12_;
         }
         _loc12_ = "0x" + _loc12_;
         var _loc13_:* = "";
         if(param2.payload)
         {
            if(param2.command == MCPCommands.JMCP)
            {
               param2.payload.position = 0;
               _loc13_ = param2.payload.readUTFBytes(param2.payload.bytesAvailable);
               param2.payload.position = 0;
               _loc13_ = _loc13_ + (" (" + param2.payload.length + " Bytes)");
            }
            else if(param2.command == MCPCommands.ERROR)
            {
               _loc14_ = MCPErrors.getErrorFromPackage(param2);
               _loc13_ = "0x" + StringHelper.int2hex(_loc14_).toUpperCase() + " (" + MCPErrors.NAMES[_loc14_] + ")";
            }
            else
            {
               param2.payload.position = 0;
               while(param2.payload.bytesAvailable)
               {
                  _loc15_ = param2.payload.readUnsignedByte().toString(16).toUpperCase();
                  _loc13_ = _loc13_ + ("0x" + (_loc15_.length < 2?"0" + _loc15_:_loc15_) + " ");
               }
               param2.payload.position = 0;
               _loc13_ = _loc13_ + (" (" + param2.payload.length + " Bytes)");
            }
         }
         else
         {
            _loc13_ = "NULL";
         }
         _loc7_ = _loc7_ + ("\n" + param3 + "\tTag: " + _loc10_ + " (" + param2.tag + ")");
         _loc7_ = _loc7_ + ("\n" + param3 + "\tvalidToken: " + (!!param2.validToken?"true":"false"));
         _loc7_ = _loc7_ + ("\n" + param3 + "\tToken: " + _loc11_ + " (" + param2.token + ")");
         _loc7_ = _loc7_ + ("\n" + param3 + "\tCommand: " + Commands.NAMES[param2.command] + " (" + _loc12_ + ")");
         _loc7_ = _loc7_ + ("\n" + param3 + "\tResponse: " + (!!param2.response?"true":"false"));
         _loc7_ = _loc7_ + ("\n" + param3 + "\tPayload: " + _loc13_);
         _loc7_ = _loc7_ + "\n";
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ = _loc7_ + param3;
            _loc9_++;
         }
         _loc7_ = _loc7_ + "\n";
         write(null,_loc7_);
         write("RAW","MCPPackage: " + param2.serialize());
      }
      
      public static function netDebug_connect() : void
      {
         var socketConnect:Function = null;
         var flusherFunc:Function = null;
         if(!netDebug_socket)
         {
            netDebug_socket = new Socket();
         }
         if(netDebug_socket.connected)
         {
            return;
         }
         var dbgCfg:Object = SetDebugInfoBox.readConfigData();
         if(dbgCfg && dbgCfg.host != null && dbgCfg.host != "" && dbgCfg.port > 0)
         {
            socketConnect = function(param1:Event):void
            {
               netDebug_socket.removeEventListener(Event.CONNECT,socketConnect);
               Log.info("[Log] netDebug connected");
            };
            netDebug_socket.connect(dbgCfg.host,int(dbgCfg.port));
         }
         if(netDebug_flusher == null)
         {
            netDebug_flusher = new Timer(Timings.NET_DEBUG_FLUSH_INTERVAL);
            flusherFunc = function(param1:Event):void
            {
               if(!netDebug_socket || !netDebug_socket.connected)
               {
                  netDebug_flusher.reset();
                  netDebug_flusher.removeEventListener(TimerEvent.TIMER,flusherFunc);
                  netDebug_flusher = null;
                  return;
               }
               netDebug_socket.flush();
            };
            netDebug_flusher.addEventListener(TimerEvent.TIMER,flusherFunc);
            netDebug_flusher.start();
         }
      }
      
      private static function netDebug_trace(param1:String) : void
      {
         if(netDebug_socket && netDebug_socket.connected)
         {
            while(netDebug_cache.length > 0)
            {
               netDebug_socket.writeUTFBytes(netDebug_cache.shift() + "\n\r");
            }
            netDebug_socket.writeUTFBytes(param1 + "\n\r");
         }
         else
         {
            if(netDebug_cache.length > 50)
            {
               netDebug_cache.shift();
            }
            netDebug_cache.push(param1);
            netDebug_connect();
         }
      }
   }
}
