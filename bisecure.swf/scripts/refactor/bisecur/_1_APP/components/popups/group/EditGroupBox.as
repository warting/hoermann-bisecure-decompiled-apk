package refactor.bisecur._1_APP.components.popups.group
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import mx.collections.ArrayList;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import refactor.bisecur._1_APP.components.popups.ConfirmBox;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.groups.PortRemover;
   import refactor.bisecur._2_SAL.net.cache.keyValues.GatewayValues;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.LogicwareSettings;
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
       
      
      private var group:HmGroup;
      
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
      
      private var _enabled:Boolean;
      
      public function EditGroupBox(param1:HmGroup, param2:ConnectionContext, param3:Array)
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
         GatewayValues.instance.getRequestablePort(this.group.id).then(function(param1:Object):void
         {
            chkRequestable.selected = param1.portId < 255;
         });
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
      
      override public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         if(this.txtName)
         {
            this.txtName.enabled = param1;
         }
         if(this.btnRemoveGroup)
         {
            this.btnRemoveGroup.enabled = param1;
         }
         if(this.chkRequestable)
         {
            this.chkRequestable.enabled = param1;
         }
         if(this.grpChannels)
         {
            this.grpChannels.enabled = param1;
         }
         if(this.grpCtrlButtons)
         {
            this.grpCtrlButtons.enabled = param1;
         }
      }
      
      [Bindable("enabledChanged")]
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      private function onCloseGroup(param1:MouseEvent) : void
      {
         var port:Object = null;
         var event:MouseEvent = param1;
         var errorBox:ErrorBox = ErrorBox.sharedBox;
         errorBox.title = Lang.getString("ERROR_ADD_GROUP");
         errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         errorBox.closeable = true;
         if(this.txtName.text == "")
         {
            errorBox.contentText = Lang.getString("ERROR_ADD_GROUP_NO_NAME");
            errorBox.open(null);
            return;
         }
         if(!StringValidator.checkGroupname(this.txtName.text))
         {
            errorBox.contentText = Lang.getString("ERROR_ADD_GROUP_NAME_LENGTH");
            errorBox.open(null);
            return;
         }
         this.enabled = false;
         this.setGroupName();
         if(this.chkRequestable.selected)
         {
            if(this.group.ports.length > 0)
            {
               port = this.group.ports[0];
               GatewayGroups.instance.setRequestablePort(this.group,port.id,function(param1:GatewayGroups, param2:HmGroup, param3:Error):void
               {
                  if(param3 != null)
                  {
                     Log.error("[EditGroupBox] setting requestable port failed! \n" + param3);
                  }
                  close(true,param2);
                  enabled = true;
               });
            }
         }
         else
         {
            GatewayGroups.instance.setRequestablePort(this.group,255,function(param1:GatewayGroups, param2:HmGroup, param3:Error):void
            {
               if(param3 != null)
               {
                  Log.error("[EditGroupBox] setting requestable port failed! \n" + param3);
               }
               close(true,param2);
               enabled = true;
            });
         }
      }
      
      private function setGroupName(param1:Function = null) : void
      {
         var callback:Function = param1;
         GatewayGroups.instance.updateName(this.group,function(param1:Object, param2:HmGroup, param3:Error):void
         {
            if(param3 != null)
            {
               InfoCenter.onNetTimeout();
               if(param2)
               {
                  Log.warning("[LearnPortsBox] setting group name to \'" + param2.name + "\' failed!\n" + param3);
               }
               else
               {
                  Log.warning("[LearnPortsBox] setting group name to \'" + param2 + "\' failed!\n" + param3);
               }
            }
            CallbackHelper.callCallback(callback,[]);
         });
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
         var _loc3_:Array = [];
         for each(_loc4_ in this.group.ports)
         {
            _loc3_.push(_loc4_.id);
         }
         _loc2_.remove(_loc3_);
      }
      
      private function onPortsRemoved(param1:Event) : void
      {
         var event:Event = param1;
         (event.currentTarget as PortRemover).removeEventListener(Event.COMPLETE,this.onPortsRemoved);
         GatewayGroups.instance.deleteGroup(this.group,function(param1:Object, param2:HmGroup, param3:Error):void
         {
            var sender:Object = param1;
            var group:HmGroup = param2;
            var error:Error = param3;
            if(error != null)
            {
               InfoCenter.onNetTimeout();
               this.close(false,this.group);
               return;
            }
            GatewayValues.instance.getValues(function(param1:Object, param2:Object, param3:Object, param4:Error):void
            {
               var _loc6_:String = null;
               var _loc7_:int = 0;
               if(param4 != null)
               {
                  Log.error("[EditGroupBox] loading key value pairs failed! \n" + param4);
                  return;
               }
               Log.debug("[EditGroupBox] updated requestable ports");
               var _loc5_:Object = {};
               for each(_loc7_ in userRights)
               {
                  _loc6_ = (_loc7_ + LogicwareSettings.MAX_PORTS).toString();
                  _loc5_[_loc7_] = param2[_loc6_];
               }
               AppCache.sharedCache.hmProcessor.requestablePorts = _loc5_;
               loadBox.close();
               close(false,group);
            });
         });
         new ArrayList(this.userRights).removeItem(this.group.id);
         GatewayGroups.instance.invalidateCache();
         GatewayGroups.instance.getAll();
         GatewayValues.instance.invalidateCache();
         GatewayValues.instance.getValues();
         GatewayPorts.instance.invalidateCache();
         GatewayPorts.instance.getPortCount();
      }
   }
}
