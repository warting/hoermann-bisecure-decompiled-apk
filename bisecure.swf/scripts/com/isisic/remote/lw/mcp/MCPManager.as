package com.isisic.remote.lw.mcp
{
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   
   public class MCPManager
   {
      
      protected static var singleton:MCPManager;
       
      
      public var token:uint;
      
      protected var protocols:Object;
      
      public function MCPManager(param1:SingletonEnforcer#101)
      {
         super();
         this.protocols = new Object();
         this.token = 0;
      }
      
      public static function get defaultManager() : MCPManager
      {
         if(!singleton)
         {
            singleton = new MCPManager(null);
         }
         return singleton;
      }
      
      public function wrapTP(param1:ConnectionContext, param2:String) : String
      {
         var _loc5_:int = 0;
         var _loc3_:String = param1.clientId + param1.remoteId + param2;
         _loc3_ = _loc3_.toUpperCase();
         var _loc4_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = int(_loc4_ + _loc3_.charCodeAt(_loc5_));
            _loc5_++;
         }
         _loc4_ = _loc4_ & 255;
         _loc3_ = _loc3_ + (_loc4_.toString(16).length < 2?"0" + _loc4_.toString(16).toUpperCase():_loc4_.toString(16).toUpperCase());
         return _loc3_;
      }
      
      public function unwrapTP(param1:String) : String
      {
         if(param1.length < MCP.TMCP_MIN_SIZE)
         {
            Debug.warning("[MCPManager] invalid tmcp size (" + param1.length + " < " + MCP.TMCP_MIN_SIZE);
            return null;
         }
         param1 = param1.substring(MCP.ADDRESS_SIZE * 2,param1.length - 2);
         return param1;
      }
      
      public function destruct() : void
      {
         this.protocols = null;
         this.token = 0;
      }
      
      public function get freeTag() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < 128)
         {
            if(this.protocols[_loc1_] == null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function addProtocol(param1:MCP) : MCP
      {
         if(this.protocols == null)
         {
            this.protocols = new Object();
         }
         param1.token = this.token;
         param1.tag = this.freeTag;
         if(param1.tag == -1)
         {
            Debug.error("no free tag to sign the MCP Data!");
            return null;
         }
         this.protocols[param1.tag] = param1;
         return param1;
      }
      
      public function getProtocol(param1:int) : MCP
      {
         return this.protocols[param1];
      }
      
      public function remProtocol(param1:int) : Boolean
      {
         if(this.protocols[param1] == null)
         {
            return false;
         }
         return delete this.protocols[param1];
      }
   }
}

class SingletonEnforcer#101
{
    
   
   function SingletonEnforcer#101()
   {
      super();
   }
}
