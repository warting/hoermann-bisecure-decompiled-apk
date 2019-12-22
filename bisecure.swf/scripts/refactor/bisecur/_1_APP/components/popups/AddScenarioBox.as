package refactor.bisecur._1_APP.components.popups
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import mx.collections.ArrayList;
   import mx.events.FlexEvent;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.gatewayData.Scenario;
   import refactor.bisecur._2_SAL.gatewayData.ScenarioAction;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.TextInput;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   public class AddScenarioBox extends Popup
   {
      
      public static const NONE:String = "NONE";
      
      public static const ADD:String = "ADD";
      
      public static const DELETE:String = "DELETE";
      
      public static const EDIT:String = "EDIT";
       
      
      private var lblName:Label;
      
      private var txtName:TextInput;
      
      private var lstActions:List;
      
      private var channelGroup:HGroup;
      
      private var btnAdd:Button;
      
      private var btnRemove:Button;
      
      private var controlGroup:HGroup;
      
      private var btnDelete:Button;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var editMode:Boolean;
      
      private var actionProvider:ArrayList;
      
      private var actionProviderBackup:Array;
      
      private var groups:Array;
      
      private var scenario:Scenario;
      
      private var activeAction:ScenarioAction;
      
      public var action:String = "NONE";
      
      public function AddScenarioBox(param1:Array, param2:Scenario = null)
      {
         super();
         this.editMode = true;
         if(!param2)
         {
            param2 = new Scenario(AppCache.sharedCache.loggedInUser.id,AppCache.sharedCache.connectedGateway.gateway.mac);
            param2.actions = [];
            this.editMode = false;
         }
         this.groups = param1;
         this.scenario = param2;
         this.actionProvider = new ArrayList(param2.actions);
         this.actionProviderBackup = this.actionProvider.toArray();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblName = new Label();
         this.lblName.text = Lang.getString("ADD_SCENARIO_NAME");
         this.addElement(this.lblName);
         this.txtName = new TextInput();
         this.txtName.addEventListener(FlexEvent.CREATION_COMPLETE,this.onTxtNameComplete);
         this.txtName.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtName.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.addElement(this.txtName);
         this.lstActions = new List();
         this.lstActions.dataProvider = this.actionProvider;
         this.lstActions.labelFunction = this.labelActionList;
         this.lstActions.addEventListener(IndexChangeEvent.CHANGE,this.onListChange);
         this.addElement(this.lstActions);
         this.channelGroup = new HGroup();
         this.addElement(this.channelGroup);
         this.btnAdd = new Button();
         this.btnAdd.label = Lang.getString("GENERAL_ADD");
         this.btnAdd.addEventListener(MouseEvent.CLICK,this.onAddClick);
         this.channelGroup.addElement(this.btnAdd);
         this.btnRemove = new Button();
         this.btnRemove.label = Lang.getString("GENERAL_REMOVE");
         this.btnRemove.enabled = false;
         this.btnRemove.addEventListener(MouseEvent.CLICK,this.onRemoveClick);
         this.channelGroup.addElement(this.btnRemove);
         this.controlGroup = new HGroup();
         this.addElement(this.controlGroup);
         this.btnDelete = new Button();
         this.btnDelete.label = Lang.getString("GENERAL_DELETE");
         this.btnDelete.visible = this.editMode;
         this.btnDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
         this.controlGroup.addElement(this.btnDelete);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.controlGroup.addElement(this.btnCancel);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmitClick);
         this.controlGroup.addElement(this.btnSubmit);
      }
      
      protected function onKeyboardEnter(param1:Event) : void
      {
         stage.focus = null;
      }
      
      private function onListChange(param1:IndexChangeEvent) : void
      {
         if(this.lstActions.selectedItem)
         {
            this.btnRemove.enabled = true;
         }
         else
         {
            this.btnRemove.enabled = false;
         }
      }
      
      protected function onTxtNameComplete(param1:FlexEvent) : void
      {
         if(this.scenario.name)
         {
            this.txtName.text = this.scenario.name;
         }
      }
      
      protected function onDeleteClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         this.action = DELETE;
         this.close(true,this.scenario);
      }
      
      private function labelActionList(param1:ScenarioAction) : String
      {
         var _loc3_:HmGroup = null;
         var _loc2_:HmGroup = null;
         for each(_loc3_ in this.groups)
         {
            if(param1.groupId == _loc3_.id)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(!_loc3_)
         {
            return Lang.getString("ERROR_NO_GROUP_FOUND") + " (" + param1.groupId + ")";
         }
         return _loc3_.name + " - " + Lang.getString("CHANNEL_" + PortTypes.NAMES[param1.actionType]);
      }
      
      protected function onCancelClick(param1:MouseEvent) : void
      {
         this.action = NONE;
         this.scenario.actions = this.actionProviderBackup;
         this.close();
      }
      
      protected function onSubmitClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         this.action = !!this.editMode?EDIT:ADD;
         this.scenario.name = this.txtName.text;
         this.close(true,this.scenario);
      }
      
      private function onAddClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         this.activeAction = new ScenarioAction();
         var _loc2_:SelectBox = new SelectBox(this.groups);
         _loc2_.title = Lang.getString("GENERAL_SELECT");
         _loc2_.labelField = "name";
         _loc2_.itemDisabledFunction = this.isGroupDisabled;
         _loc2_.addEventListener(PopUpEvent.CLOSE,this.onSelectActorComplete);
         _loc2_.open(null);
      }
      
      protected function isGroupDisabled(param1:Object, param2:int) : Boolean
      {
         var _loc3_:Object = null;
         for each(_loc3_ in this.actionProvider.toArray())
         {
            if(_loc3_.groupId == param1.id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onRemoveClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(!this.lstActions.selectedItem)
         {
            return;
         }
         this.actionProvider.removeItem(this.lstActions.selectedItem);
         this.btnRemove.enabled = false;
      }
      
      private function onSelectActorComplete(param1:PopUpEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:SelectBox = null;
         if(param1)
         {
            (param1.currentTarget as SelectBox).removeEventListener(PopUpEvent.CLOSE,this.onSelectActorComplete);
         }
         if(!param1.commit)
         {
            return;
         }
         this.activeAction.groupId = param1.data.id;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.data.ports)
         {
            _loc2_.push(_loc3_);
         }
         _loc4_ = new SelectBox(_loc2_);
         _loc4_.title = Lang.getString("GENERAL_SELECT");
         _loc4_.labelFunction = this.labelSelectChannel;
         _loc4_.itemDisabledFunction = this.isChannelDisabled;
         _loc4_.addEventListener(PopUpEvent.CLOSE,this.onSelectChannelComplete);
         _loc4_.open(null);
      }
      
      protected function isChannelDisabled(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc3_:Object = null;
         for each(_loc4_ in this.groups)
         {
            if(_loc4_.id == this.activeAction.groupId)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_ == null)
         {
            return true;
         }
         for each(_loc5_ in this.actionProvider.toArray())
         {
            if(_loc5_.groupId == _loc3_.id && _loc5_.portId == param1.id)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function labelSelectChannel(param1:Object) : String
      {
         if(!param1)
         {
            return "";
         }
         return Lang.getString("CHANNEL_" + PortTypes.NAMES[param1.type]);
      }
      
      protected function onSelectChannelComplete(param1:PopUpEvent) : void
      {
         if(param1.data == null)
         {
            return;
         }
         this.activeAction.deviceAction = param1.data.id;
         this.activeAction.actionType = param1.data.type;
         this.actionProvider.addItem(this.activeAction);
         this.activeAction = null;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this.txtName.width = _loc3_;
         this.lstActions.width = _loc3_;
         this.lstActions.height = param2 * 0.333;
         this.channelGroup.width = _loc3_;
         this.btnAdd.percentWidth = 50;
         this.btnRemove.percentWidth = 50;
         this.controlGroup.width = _loc3_;
         this.btnDelete.percentWidth = 33.3333;
         this.btnCancel.percentWidth = 40.3333;
         this.btnSubmit.percentWidth = 33.3333;
      }
   }
}
