package com.isisic.remote.hoermann.components.popups.addGateway
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.Gateway;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.controls.Spacer;
   import org.osmf.layout.HorizontalAlign;
   import spark.components.BusyIndicator;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   
   public class AGSetAddress extends Popup
   {
      
      public static const CONNECTION_PORT:int = 4000;
      
      private static const TIMEOUT_DELAY:int = 15000;
       
      
      private var lblDns:Label;
      
      private var sp0:Spacer;
      
      private var txtDns:TextInput;
      
      private var indicator:BusyIndicator;
      
      private var sp1:Spacer;
      
      private var grpButtons:HGroup;
      
      private var btnSubmit:Button;
      
      private var sp2:Spacer;
      
      private var btnCancel:Button;
      
      private var timeout:Timer;
      
      public function AGSetAddress()
      {
         super();
         this.title = Lang.getString("POPUP_ADD_GATEWAY");
         this.timeout = new Timer(TIMEOUT_DELAY,1);
         this.timeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblDns = new Label();
         this.lblDns.text = Lang.getString("POPUP_ADD_GATEWAY_CONTENT");
         this.addElement(this.lblDns);
         this.sp0 = new Spacer();
         this.addElement(this.sp0);
         this.txtDns = new TextInput();
         this.addElement(this.txtDns);
         this.indicator = new BusyIndicator();
         this.indicator.visible = false;
         this.titleBar.addElement(this.indicator);
         this.sp1 = new Spacer();
         this.addElement(this.sp1);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.RIGHT;
         this.addElement(this.grpButtons);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.grpButtons.addElement(this.btnCancel);
         this.sp2 = new Spacer();
         this.grpButtons.addElement(this.sp2);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.grpButtons.addElement(this.btnSubmit);
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         var context:ConnectionContext = null;
         var tmpContext:ConnectionContext = null;
         var loader:MCPLoader = null;
         var loaderComplete:Function = null;
         var loaderFail:Function = null;
         var event:MouseEvent = param1;
         tmpContext = Logicware.API.createContext(this.txtDns.text,Logicware.TCP_PORT,Logicware.API.clientId,"000000000000",ConnectionTypes.LOCAL,"000000000000");
         Logicware.API.connect(tmpContext);
         loader = new MCPLoader(tmpContext);
         loader.addEventListener(Event.COMPLETE,loaderComplete = function(param1:Event):void
         {
            var mac:* = undefined;
            var tmr:* = undefined;
            var tmrComplete:* = undefined;
            var e:Event = param1;
            loader.removeEventListener(Event.COMPLETE,loaderComplete);
            loader.removeEventListener(ErrorEvent.ERROR,loaderFail);
            mac = "";
            var byte:* = "";
            loader.data.payload.position = 0;
            while(loader.data.payload.bytesAvailable)
            {
               byte = loader.data.payload.readUnsignedByte().toString(16);
               byte = (byte.length > 1?"":"0") + byte;
               mac = mac + byte;
            }
            Logicware.API.disconnect(tmpContext);
            tmpContext.dispose();
            tmr = new Timer(500,1);
            tmrComplete = function(param1:Event):void
            {
               tmr.removeEventListener(TimerEvent.TIMER_COMPLETE,tmrComplete);
               context = Logicware.API.createContext(txtDns.text,Logicware.TCP_PORT,Logicware.API.clientId,mac,ConnectionTypes.LOCAL,mac);
               loadName(context);
            };
            tmr.addEventListener(TimerEvent.TIMER_COMPLETE,tmrComplete);
            tmr.start();
         });
         loader.addEventListener(ErrorEvent.ERROR,loaderFail = function(param1:Event):void
         {
            loader.removeEventListener(Event.COMPLETE,loaderComplete);
            loader.removeEventListener(ErrorEvent.ERROR,loaderFail);
            Debug.warning("[AGSetAddress] MAC Requesting failed!");
            Logicware.API.disconnect(tmpContext);
            tmpContext.dispose();
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_MAC));
         this.indicator.visible = true;
         this.txtDns.enabled = false;
         this.btnCancel.enabled = false;
         this.btnSubmit.enabled = false;
         this.timeout.start();
      }
      
      protected function loadName(param1:ConnectionContext) : void
      {
         var loader:MCPLoader = null;
         var loaderComplete:Function = null;
         var loaderFail:Function = null;
         var context:ConnectionContext = param1;
         Logicware.API.connect(context);
         loader = new MCPLoader(context);
         loader.addEventListener(Event.COMPLETE,loaderComplete = function(param1:Event):void
         {
            var _loc5_:* = undefined;
            var _loc6_:* = undefined;
            loader.removeEventListener(Event.COMPLETE,loaderComplete);
            loader.removeEventListener(ErrorEvent.ERROR,loaderFail);
            loader.data.payload.position = 0;
            var _loc2_:* = loader.data.payload.readUTFBytes(loader.data.payload.bytesAvailable);
            var _loc3_:* = new Gateway();
            _loc3_.available = true;
            _loc3_.name = _loc2_;
            _loc3_.host = context.host;
            _loc3_.port = context.port;
            _loc3_.mac = context.mac.toUpperCase();
            _loc3_.isPortal = false;
            _loc3_.users = new Array();
            _loc3_.localIp = context.host;
            _loc3_.localPort = context.port;
            var _loc4_:* = ArrayHelper.indexOfByProperty("mac",_loc3_.mac,HoermannRemote.appData.gateways);
            if(_loc4_ >= 0)
            {
               _loc5_ = HoermannRemote.appData.gateways[_loc4_];
               _loc6_ = new Gateway();
               _loc6_.parseObject(_loc5_);
               _loc6_.copy(_loc3_,new <String>["available","name","isPoral","host","port","localIp","localPort"]);
               HoermannRemote.appData.gateways[_loc4_] = _loc3_;
            }
            else
            {
               HoermannRemote.appData.gateways.push(_loc3_);
            }
            HoermannRemote.appData.save();
            close(true,_loc3_);
            Logicware.API.disconnect(context);
            context.dispose();
         });
         loader.addEventListener(ErrorEvent.ERROR,loaderFail = function(param1:Event):void
         {
            loader.removeEventListener(Event.COMPLETE,loaderComplete);
            loader.removeEventListener(ErrorEvent.ERROR,loaderFail);
            Debug.warning("[AGSetAddress] Name Requesting failed!");
            Logicware.API.disconnect(context);
            context.dispose();
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_NAME));
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         this.timeout.reset();
         this.connectionFail();
      }
      
      private function connectionFail() : void
      {
         this.timeout.reset();
         this.indicator.visible = false;
         this.txtDns.enabled = true;
         this.btnCancel.enabled = true;
         this.btnSubmit.enabled = true;
         HoermannRemote.errorBox.title = Lang.getString("ERROR_INVALID_GATEWAY");
         HoermannRemote.errorBox.contentText = Lang.getString("ERROR_INVALID_GATEWAY_CONTENT");
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(HoermannRemote.app);
      }
      
      protected function onCancel(param1:MouseEvent) : void
      {
         this.close();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.txtDns.percentWidth = 100;
         this.txtDns.width = this.content.width - innerPadding * 2;
         this.indicator.y = innerPadding;
         this.indicator.x = this.content.width - (this.indicator.width + innerPadding);
         this.sp0.height = innerPadding;
         this.sp1.height = innerPadding;
         this.sp2.width = innerPadding;
         this.grpButtons.width = this.content.width - innerPadding * 2;
         this.btnCancel.width = (this.content.width - innerPadding * 4) / 2;
         this.btnSubmit.width = (this.content.width - innerPadding * 4) / 2;
      }
   }
}
