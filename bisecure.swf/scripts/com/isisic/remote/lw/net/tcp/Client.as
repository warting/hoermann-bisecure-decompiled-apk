package com.isisic.remote.lw.net.tcp
{
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.net.IClient;
   import com.isisic.remote.lw.net.lw_network;
   import com.isisic.remote.lw.net.tcp.extensions.ConnectionTimeoutExtension;
   import com.isisic.remote.lw.net.tcp.extensions.ExtensionActionNames;
   import com.isisic.remote.lw.net.tcp.extensions.IClientExtension;
   import com.isisic.remote.lw.net.tcp.extensions.MCPReaderExtension;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   use namespace lw_network;
   
   public class Client extends EventDispatcher implements IClient
   {
       
      
      lw_network var _socket:Socket;
      
      lw_network var buffer:ByteArray;
      
      protected var _connecting:Boolean;
      
      protected var extensions:Vector.<IClientExtension>;
      
      public function Client(param1:Socket = null)
      {
         super();
         if(param1 == null)
         {
            param1 = new Socket();
         }
         this.socket = param1;
         this.buffer = new ByteArray();
         this._connecting = false;
         this.extensions = new Vector.<IClientExtension>();
         this.addExtension(new MCPReaderExtension());
         this.addExtension(new ConnectionTimeoutExtension());
      }
      
      public function get connected() : Boolean
      {
         return this.socket.connected;
      }
      
      public function connect(param1:String, param2:int) : void
      {
         this.tryConnect(param1,param2);
      }
      
      public function send(param1:ByteArray) : void
      {
         if(param1 == null)
         {
            Debug.warning("Class Client expects a ByteArray as Parameter to Send Method!");
            return;
         }
         if(!this.callExtensionAction(ExtensionActionNames.BEFORE_SEND,true,[param1]))
         {
            Debug.info("[Client] extension canceled send execution!");
            return;
         }
         this.sendData(param1);
         this.callExtensionAction(ExtensionActionNames.AFTER_SEND,false,[param1]);
      }
      
      public function close() : void
      {
         if(!this.callExtensionAction(ExtensionActionNames.BEFORE_CLOSING,true))
         {
            Debug.info("[Client] extension canceled close execution!");
            return;
         }
         if(this.socket == null)
         {
            return;
         }
         this.socket.close();
         this.callExtensionAction(ExtensionActionNames.AFTER_CLOSING,false);
      }
      
      public function destruct() : void
      {
         if(!this.callExtensionAction(ExtensionActionNames.BEFORE_DESTRUCT,true))
         {
            Debug.info("[Client] extension canceled destruct execution!");
            return;
         }
         Debug.info("[Client] Destructing Client: " + this);
         if(!this.closeAndDestruct())
         {
            return;
         }
         this.removeAllExtensions();
         this.socket = null;
         this.buffer.clear();
         this.buffer = null;
      }
      
      public function addExtension(param1:IClientExtension) : void
      {
         this.extensions.push(param1);
         param1.initialize(this);
      }
      
      public function removeExtension(param1:IClientExtension) : void
      {
         param1.dispose();
         var _loc2_:int = this.extensions.indexOf(param1);
         this.extensions.splice(_loc2_,1);
      }
      
      public function removeAllExtensions() : void
      {
         var _loc1_:IClientExtension = null;
         for each(_loc1_ in this.extensions)
         {
            this.removeExtension(_loc1_);
         }
      }
      
      protected function callExtensionAction(param1:String, param2:Boolean, param3:Array = null) : Boolean
      {
         var _loc5_:IClientExtension = null;
         var _loc4_:Boolean = true;
         for each(_loc5_ in this.extensions)
         {
            if(!_loc5_.onAction(param1,param2,param3))
            {
               _loc4_ = false;
            }
         }
         return _loc4_;
      }
      
      public function get connecting() : Boolean
      {
         return this._connecting;
      }
      
      public function set socket(param1:Socket) : void
      {
         if(this._socket != null)
         {
            this._socket.removeEventListener(Event.CONNECT,this.onConnect);
            this._socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onReceive);
            this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._socket.removeEventListener(Event.CLOSE,this.onClose);
            this._socket = null;
         }
         this._socket = param1;
         if(param1 == null)
         {
            return;
         }
         this._socket.addEventListener(Event.CONNECT,this.onConnect);
         this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onReceive);
         this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this._socket.addEventListener(Event.CLOSE,this.onClose);
      }
      
      public function get socket() : Socket
      {
         return this._socket;
      }
      
      public function tryConnect(param1:String, param2:int) : Boolean
      {
         if(!this.callExtensionAction(ExtensionActionNames.BEFORE_CONNECTING,true,[param1,param2]))
         {
            Debug.info("[Client] extension canceled connect execution!");
            return false;
         }
         if(this.connected)
         {
            return false;
         }
         if(this._connecting)
         {
            return false;
         }
         this._connecting = true;
         this.socket.connect(param1,param2);
         this.callExtensionAction(ExtensionActionNames.AFTER_CONNECTING,false,[param1,param2]);
         return true;
      }
      
      lw_network function sendData(param1:ByteArray) : void
      {
         param1.position = 0;
         this.socket.writeBytes(param1);
         this.socket.flush();
      }
      
      protected function closeAndDestruct() : Boolean
      {
         if(this.socket != null && this.connecting)
         {
            this.addEventListener(Event.CONNECT,this.onConnectSocketDestruct);
            this.addEventListener(Event.CLOSE,this.onConnectSocketDestruct);
            this.addEventListener(IOErrorEvent.IO_ERROR,this.onConnectSocketDestruct);
            return false;
         }
         if(!this.socket || !this.socket.connected)
         {
            return true;
         }
         this.socket.close();
         return true;
      }
      
      protected function onConnectSocketDestruct(param1:Event) : void
      {
         this.destruct();
      }
      
      protected function onConnect(param1:Event) : void
      {
         this._connecting = false;
         this.dispatchEvent(new Event(param1.type));
         this.callExtensionAction(ExtensionActionNames.AFTER_CONNECT,false,[param1]);
      }
      
      protected function onClose(param1:Event) : void
      {
         this.dispatchEvent(new Event(param1.type));
         this.callExtensionAction(ExtensionActionNames.AFTER_CONNECT_FAIL,false,[param1]);
      }
      
      protected function onReceive(param1:ProgressEvent) : void
      {
         if(!this.callExtensionAction(ExtensionActionNames.BEFORE_RECEIVE,true,[param1]))
         {
            Debug.info("[Client] extension canceled receive execution!");
            return;
         }
         this.socket.readBytes(this.buffer,this.buffer.length);
         this.buffer.position = 0;
         this.callExtensionAction(ExtensionActionNames.AFTER_RECEIVE,false,[param1]);
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         this._connecting = false;
         this.dispatchEvent(param1);
         this.callExtensionAction(ExtensionActionNames.AFTER_CONNECT_FAIL,false,[param1]);
      }
   }
}
