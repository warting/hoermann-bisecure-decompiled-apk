package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.lw.Debug;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import me.mweber.storage.StorageFactory;
   import me.mweber.storage.iStorage;
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.TextInput;
   
   public class SetDebugInfoBox extends Popup
   {
      
      private static const CONFIG_FILE:File = File.applicationStorageDirectory.resolvePath("debug.jcfg");
       
      
      public var lblHost:Label;
      
      public var txtHost:TextInput;
      
      public var lblPort:Label;
      
      public var txtPort:TextInput;
      
      public var btnSave:Button;
      
      public var btnCancel:Button;
      
      public function SetDebugInfoBox()
      {
         super();
         this.title = "Net Log Infos";
      }
      
      public static function readConfigData() : Object
      {
         if(!CONFIG_FILE.exists)
         {
            return new Object();
         }
         var _loc1_:iStorage = StorageFactory.openStorage(CONFIG_FILE);
         var _loc2_:Object = {};
         _loc2_.host = _loc1_.getString("host");
         _loc2_.port = _loc1_.getNumber("port");
         return _loc2_;
      }
      
      public static function writeConfigData(param1:String, param2:uint) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.host = param1;
         _loc3_.port = param2;
         var _loc4_:iStorage = StorageFactory.openStorage(CONFIG_FILE);
         _loc4_.setString("host",param1);
         _loc4_.setNumber("port",param2);
         _loc4_.save();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:Object = readConfigData();
         this.lblHost = new Label();
         this.lblHost.text = "Host";
         this.addElement(this.lblHost);
         this.txtHost = new TextInput();
         this.txtHost.text = _loc1_.host != null?_loc1_.host:"";
         this.addElement(this.txtHost);
         this.lblPort = new Label();
         this.lblPort.text = "Port";
         this.addElement(this.lblPort);
         this.txtPort = new TextInput();
         this.txtPort.text = _loc1_.port != null?_loc1_.port:"";
         this.addElement(this.txtPort);
         this.btnSave = new Button();
         this.btnSave.label = "SAVE";
         this.btnSave.addEventListener(MouseEvent.CLICK,this.onSave);
         this.addElement(this.btnSave);
         this.btnCancel = new Button();
         this.btnCancel.label = "CANCEL";
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.addElement(this.btnCancel);
      }
      
      protected function onSave(param1:MouseEvent) : void
      {
         Debug.debug("[SetDebugInfoBox] Writing data");
         writeConfigData(this.txtHost.text,int(this.txtPort.text));
         if(this.txtHost.text != "" && int(this.txtPort.text) > 0)
         {
            Debug.netDebug_connect();
         }
         this.close(true);
      }
      
      protected function onCancel(param1:MouseEvent) : void
      {
         this.close();
      }
   }
}
