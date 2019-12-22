package com.isisic.remote.hoermann.components.popups.group
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.popups.ConfirmBox;
   import com.isisic.remote.hoermann.components.popups.ErrorBox;
   import com.isisic.remote.hoermann.components.popups.LoadBox;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.PortRemover;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import mx.collections.ArrayList;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.events.PopUpEvent;
   import spark.events.TextOperationEvent;
   import spark.layouts.VerticalLayout;
   
   public class EditGroupBox extends Popup
   {
       
      
      private var group:Object;
      
      private var context:ConnectionContext;
      
      private var userRights:Array;
      
      private var tmpName:String;
      
      private var loadBox:LoadBox;
      
      private var lblName:Label;
      
      private var txtName:TextInput;
      
      private var btnRemoveGroup:Button;
      
      private var sp:Spacer;
      
      private var chkRequestable:CheckBox;
      
      private var sp1:Spacer;
      
      private var lblChannels:Label;
      
      private var grpChannels:HGroup;
      
      private var btnLearnChannel:Button;
      
      private var btnRemoveChannel:Button;
      
      private var sp2:Spacer;
      
      private var grpCtrlButtons:HGroup;
      
      private var btnCancelEdit:Button;
      
      private var btnCloseGroup:Button;
      
      public function EditGroupBox(param1:Object, param2:ConnectionContext, param3:Array)
      {
         super();
         this.group = param1;
         this.context = param2;
         this.userRights = param3;
         this.groupName = param1.name;
         this.title = Lang.getString("EDIT_GROUP");
         (this.layout as VerticalLayout).gap = innerPadding;
      }
      
      public function set groupName(param1:String) : void
      {
         this.tmpName = param1;
         if(this.txtName)
         {
            this.onNameComplete(null);
         }
      }
      
      public function get groupName() : String
      {
         return this.tmpName;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblName = new Label();
         this.lblName.text = Lang.getString("GENERAL_GROUP_NAME");
         this.addElement(this.lblName);
         this.txtName = new TextInput();
         this.txtName.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtName.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.txtName.addEventListener(FlexEvent.CREATION_COMPLETE,this.onNameComplete);
         this.txtName.addEventListener(TextOperationEvent.CHANGE,this.onNameChanged);
         this.addElement(this.txtName);
         this.btnRemoveGroup = new Button();
         this.btnRemoveGroup.addEventListener(MouseEvent.CLICK,this.onRemoveGroup);
         this.btnRemoveGroup.label = Lang.getString("GENERAL_DELETE");
         this.addElement(this.btnRemoveGroup);
         this.sp = new Spacer();
         this.addElement(this.sp);
         this.chkRequestable = new CheckBox();
         this.chkRequestable.label = Lang.getString("GROUP_REQUESTABLE");
         var _loc1_:Object = HmProcessor.defaultProcessor.requestablePorts;
         if(_loc1_)
         {
            this.chkRequestable.selected = _loc1_[this.group.id] != null && _loc1_[this.group.id] < 255;
         }
         this.addElement(this.chkRequestable);
         this.sp1 = new Spacer();
         this.addElement(this.sp1);
         this.lblChannels = new Label();
         this.lblChannels.text = Lang.getString("GENERAL_PORTS");
         this.addElement(this.lblChannels);
         this.grpChannels = new HGroup();
         this.btnLearnChannel = new Button();
         this.btnLearnChannel.label = Lang.getString("GENERAL_ADD");
         this.btnLearnChannel.addEventListener(MouseEvent.CLICK,this.onLearnChannel);
         this.btnRemoveChannel = new Button();
         this.btnRemoveChannel.label = Lang.getString("GENERAL_REMOVE");
         this.btnRemoveChannel.addEventListener(MouseEvent.CLICK,this.onRemoveChannel);
         this.grpChannels.addElement(this.btnLearnChannel);
         this.grpChannels.addElement(this.btnRemoveChannel);
         this.addElement(this.grpChannels);
         this.sp2 = new Spacer();
         this.addElement(this.sp2);
         this.grpCtrlButtons = new HGroup();
         this.btnCancelEdit = new Button();
         this.btnCancelEdit.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancelEdit.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.btnCloseGroup = new Button();
         this.btnCloseGroup.label = Lang.getString("GENERAL_SUBMIT");
         this.btnCloseGroup.addEventListener(MouseEvent.CLICK,this.onCloseGroup);
         this.grpCtrlButtons.addElement(this.btnCancelEdit);
         this.grpCtrlButtons.addElement(this.btnCloseGroup);
         this.addElement(this.grpCtrlButtons);
      }
      
      protected function onKeyboardEnter(param1:Event) : void
      {
         stage.focus = null;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this.lblName.width = _loc3_;
         this.txtName.width = _loc3_;
         this.btnRemoveGroup.percentWidth = 100;
         this.sp.height = innerPadding;
         this.sp1.height = innerPadding;
         this.grpChannels.width = _loc3_;
         this.btnLearnChannel.percentWidth = 100;
         this.btnRemoveChannel.percentWidth = 100;
         this.sp2.height = innerPadding;
         this.grpCtrlButtons.width = _loc3_;
         this.btnCancelEdit.percentWidth = 50;
         this.btnCloseGroup.percentWidth = 50;
      }
      
      private function onNameComplete(param1:FlexEvent) : void
      {
         if(this.tmpName)
         {
            this.txtName.text = this.tmpName;
         }
      }
      
      protected function onNameChanged(param1:TextOperationEvent) : void
      {
         this.group.name = this.txtName.text;
      }
      
      private function onLearnChannel(param1:MouseEvent) : void
      {
         var _loc2_:LearnPortsBox = new LearnPortsBox(this.group,this.context);
         _loc2_.open(null);
      }
      
      private function onRemoveChannel(param1:MouseEvent) : void
      {
         var _loc2_:RemovePortsBox = new RemovePortsBox(this.group,this.context);
         _loc2_.open(null);
      }
      
      private function onCancel(param1:Event) : void
      {
         this.close(false);
      }
      
      private function onCloseGroup(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:ErrorBox = new ErrorBox();
         _loc2_.title = Lang.getString("ERROR_ADD_GROUP");
         _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc2_.closeable = true;
         if(this.txtName.text == "")
         {
            _loc2_.contentText = Lang.getString("ERROR_ADD_GROUP_NO_NAME");
            _loc2_.open(null);
            return;
         }
         if(!StringValidator.checkGroupname(this.txtName.text))
         {
            _loc2_.contentText = Lang.getString("ERROR_ADD_GROUP_NAME_LENGTH");
            _loc2_.open(null);
            return;
         }
         this.setGroupName();
         if(this.chkRequestable.selected)
         {
            if(this.group.ports.length > 0)
            {
               _loc3_ = this.group.ports[0];
               HmProcessor.defaultProcessor.setRequestable(this.group.id,_loc3_.id);
            }
         }
         else
         {
            HmProcessor.defaultProcessor.setRequestable(this.group.id,255);
         }
         this.close(true,this.group);
      }
      
      private function setGroupName(param1:Function = null) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var callback:Function = param1;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(callback != null)
            {
               callback.call();
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            InfoCenter.onNetTimeout();
            Debug.warning("[LearnPortsBox] setting group name to \'" + name + "\' failed!\n" + param1);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_GROUP_NAME,MCPBuilder.payloadSetGroupName(this.group.id,this.group.name)));
      }
      
      private function onRemoveGroup(param1:MouseEvent) : void
      {
         var _loc2_:ConfirmBox = new ConfirmBox();
         _loc2_.title = Lang.getString("CONFIRM_DELETE_GROUP");
         _loc2_.contentText = Lang.getString("CONFIRM_DELETE_GROUP_CONTENT");
         _loc2_.submitTitle = Lang.getString("GENERAL_YES");
         _loc2_.cancelTitle = Lang.getString("GENERAL_NO");
         _loc2_.addEventListener(PopUpEvent.CLOSE,this.onConfirmRemoveGroup);
         _loc2_.open(null);
      }
      
      private function onConfirmRemoveGroup(param1:PopUpEvent) : void
      {
         var _loc4_:Object = null;
         if(!param1.commit)
         {
            return;
         }
         this.loadBox = new LoadBox();
         this.loadBox.title = Lang.getString("REMOVE_GROUP_PROCESS");
         this.loadBox.contentText = Lang.getString("REMOVE_GROUP_PROCESS_CONTENT");
         this.loadBox.open(null);
         var _loc2_:PortRemover = new PortRemover(this.context);
         _loc2_.addEventListener(Event.COMPLETE,this.onPortsRemoved);
         var _loc3_:Array = new Array();
         for each(_loc4_ in this.group.ports)
         {
            _loc3_.push(_loc4_.id);
         }
         _loc2_.remove(_loc3_);
      }
      
      private function onPortsRemoved(param1:Event) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:Event = param1;
         (event.currentTarget as PortRemover).removeEventListener(Event.COMPLETE,this.onPortsRemoved);
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            var onValuesChanged:* = undefined;
            var e:Event = param1;
            HoermannRemote.gatewayData.addEventListener(GatewayData.VALUES_CHANGED,onValuesChanged = function(param1:Event):void
            {
               var _loc3_:* = undefined;
               var _loc4_:* = undefined;
               HoermannRemote.gatewayData.removeEventListener(GatewayData.VALUES_CHANGED,onValuesChanged);
               Debug.debug("[EditGroupBox] updated requestable ports");
               var _loc2_:* = new Object();
               for each(_loc4_ in userRights)
               {
                  _loc3_ = (_loc4_ + AppData.MAX_PORTS).toString();
                  while(_loc3_.length < 2)
                  {
                     _loc3_ = "0" + _loc3_;
                  }
                  _loc2_[_loc4_] = HoermannRemote.gatewayData.values[_loc3_];
               }
               HmProcessor.defaultProcessor.requestablePorts = _loc2_;
               loadBox.close();
               close(false,group);
            });
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            InfoCenter.onNetTimeout();
            this.close(false,this.group);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.REMOVE_GROUP,MCPBuilder.payloadRemoveGroup(this.group.id)));
         new ArrayList(this.userRights).removeItem(this.group.id);
         HoermannRemote.gatewayData.updateGroups(this.context,HoermannRemote.appData.userId);
         HoermannRemote.gatewayData.updateValues(this.context);
         HoermannRemote.gatewayData.updatePortCount(this.context);
      }
   }
}
