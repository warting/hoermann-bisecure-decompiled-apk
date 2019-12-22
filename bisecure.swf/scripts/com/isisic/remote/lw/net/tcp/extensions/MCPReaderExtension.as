package com.isisic.remote.lw.net.tcp.extensions
{
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.mcp.MCP;
   import com.isisic.remote.lw.net.RawDataEvent;
   import com.isisic.remote.lw.net.lw_network;
   import com.isisic.remote.lw.net.tcp.Client;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   use namespace lw_network;
   
   public class MCPReaderExtension implements IClientExtension
   {
       
      
      protected var client:Client;
      
      protected var completionDelay:int;
      
      protected var completionTimer:Timer;
      
      public function MCPReaderExtension(param1:int = 500)
      {
         super();
         this.completionDelay = param1;
      }
      
      public function initialize(param1:Client) : void
      {
         this.client = param1;
         this.setupCompletionTimer();
      }
      
      public function onAction(param1:String, param2:Boolean, param3:Array = null) : Boolean
      {
         if(param1 == ExtensionActionNames.AFTER_RECEIVE)
         {
            this.processBuffer();
         }
         return true;
      }
      
      public function dispose() : void
      {
         this.client = null;
         this.completionTimer.removeEventListener(TimerEvent.TIMER,this.onCompletionTimeout);
         this.completionTimer = null;
      }
      
      protected function setupCompletionTimer() : void
      {
         this.completionTimer = new Timer(this.completionDelay,1);
         this.completionTimer.addEventListener(TimerEvent.TIMER,this.onCompletionTimeout);
      }
      
      protected function processBuffer() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:ByteArray = null;
         var _loc1_:Boolean = true;
         while(_loc1_)
         {
            if(this.client.buffer.bytesAvailable < 1)
            {
               _loc1_ = false;
            }
            else if(this.client.buffer.bytesAvailable <= MCP.ADDRESS_SIZE * 2)
            {
               _loc1_ = false;
            }
            else
            {
               _loc2_ = this.client.buffer.readUTFBytes(MCP.ADDRESS_SIZE);
               _loc3_ = this.client.buffer.readUTFBytes(MCP.ADDRESS_SIZE);
               _loc4_ = int("0x" + this.client.buffer.readUTFBytes(MCP.LENGTH_SIZE));
               this.client.buffer.position = this.client.buffer.position - MCP.LENGTH_SIZE;
               if(this.client.buffer.bytesAvailable >= _loc4_ * MCP.BYTE_MULTIPLIER + 2)
               {
                  _loc5_ = new ByteArray();
                  _loc5_.writeUTFBytes(_loc2_);
                  _loc5_.writeUTFBytes(_loc3_);
                  _loc5_.writeBytes(this.client.buffer,MCP.ADDRESS_SIZE * 2,_loc4_ * MCP.BYTE_MULTIPLIER + 2);
                  _loc5_.position = 0;
                  this.client.dispatchEvent(new RawDataEvent(RawDataEvent.DATA,false,false,_loc5_));
                  _loc5_.position = 0;
                  if(this.client == null || this.client.buffer == null)
                  {
                     Debug.info("[MCPReaderExtension] Client seems to be disposed => leaving reader method");
                     return;
                  }
                  _loc6_ = new ByteArray();
                  _loc6_.writeBytes(this.client.buffer,_loc5_.length);
                  this.client.buffer = _loc6_;
                  this.client.buffer.position = 0;
               }
               else
               {
                  _loc1_ = false;
               }
            }
         }
         if(this.client.buffer.length < 1)
         {
            this.completionTimer.reset();
         }
         else if(this.completionTimer != null)
         {
            this.completionTimer.reset();
            this.completionTimer.start();
         }
      }
      
      protected function onCompletionTimeout(param1:TimerEvent) : void
      {
         Debug.warning("Data Completion timeout! (Client waits not longer for protocol completion => clearing receive buffer)");
         this.client.buffer.position = 0;
         Debug.debug("buffer:" + this.client.buffer.readUTFBytes(this.client.buffer.bytesAvailable));
         this.client.buffer.clear();
      }
   }
}
