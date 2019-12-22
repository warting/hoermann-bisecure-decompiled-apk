package refactor.bisecur._1_APP.components.popups.group
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import mx.utils.StringUtil;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._1_APP.components.popups.SelectBox;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.events.PopUpEvent;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   
   public class AddGroupBox extends Popup
   {
       
      
      private var lblName:Label;
      
      private var txtName:TextInput;
      
      private var lblType:Label;
      
      private var btnType:Button;
      
      private var sp:Spacer;
      
      private var chkRequestable:CheckBox;
      
      private var sp1:Spacer;
      
      private var grpButtons:HGroup;
      
      private var btnCancel:Button;
      
      private var btnConfirm:Button;
      
      private var type:int = 0;
      
      public function AddGroupBox()
      {
         super();
         this.title = Lang.getString("ADD_GROUP");
         (this.layout as VerticalLayout).gap = innerPadding;
      }
      
      public function get shouldRequest() : Boolean
      {
         if(!this.chkRequestable)
         {
            return false;
         }
         return this.chkRequestable.selected;
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
         this.addElement(this.txtName);
         this.lblType = new Label();
         this.lblType.text = Lang.getString("GENERAL_GROUP_TYPE");
         this.addElement(this.lblType);
         this.btnType = new Button();
         this.btnType.label = Lang.getString("GENERAL_SELECT");
         this.btnType.addEventListener(MouseEvent.CLICK,this.onSelectType);
         this.addElement(this.btnType);
         this.sp = new Spacer();
         this.addElement(this.sp);
         this.chkRequestable = new CheckBox();
         this.chkRequestable.label = Lang.getString("GROUP_REQUESTABLE");
         this.chkRequestable.selected = true;
         this.addElement(this.chkRequestable);
         this.sp1 = new Spacer();
         this.addElement(this.sp1);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.RIGHT;
         this.addElement(this.grpButtons);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.grpButtons.addElement(this.btnCancel);
         this.btnConfirm = new Button();
         this.btnConfirm.label = Lang.getString("GENERAL_NEXT");
         this.btnConfirm.addEventListener(MouseEvent.CLICK,this.onConfirm);
         this.grpButtons.addElement(this.btnConfirm);
      }
      
      protected function onKeyboardEnter(param1:Event) : void
      {
         stage.focus = null;
      }
      
      protected function onConfirm(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         var _loc2_:ErrorBox = new ErrorBox();
         _loc2_.title = Lang.getString("ERROR_ADD_GROUP");
         _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc2_.closeable = true;
         if(StringUtil.trim(this.txtName.text) == "")
         {
            _loc2_.contentText = Lang.getString("ERROR_ADD_GROUP_NO_NAME");
            _loc2_.open(null);
            return;
         }
         if(this.type == GroupTypes.NONE)
         {
            _loc2_.contentText = Lang.getString("ERROR_ADD_GROUP_NO_TYPE");
            _loc2_.open(null);
            return;
         }
         if(!StringValidator.checkGroupname(this.txtName.text))
         {
            _loc2_.contentText = Lang.getString("ERROR_ADD_GROUP_NAME_LENGTH");
            _loc2_.open(null);
            return;
         }
         var _loc3_:HmGroup = new HmGroup();
         _loc3_.name = this.txtName.text;
         _loc3_.type = this.type;
         this.close(true,_loc3_);
      }
      
      protected function onCancel(param1:MouseEvent) : void
      {
         this.close();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this.lblName.width = _loc3_;
         this.txtName.width = _loc3_;
         this.lblType.width = _loc3_;
         this.btnType.width = _loc3_;
         this.sp.height = innerPadding;
         this.sp1.height = innerPadding;
         this.grpButtons.width = _loc3_;
         this.btnCancel.percentWidth = 50;
         this.btnConfirm.percentWidth = 50;
      }
      
      private function onSelectType(param1:MouseEvent) : void
      {
         var _loc4_:* = null;
         var _loc5_:SelectBox = null;
         var _loc2_:Array = new Array();
         var _loc3_:Object = null;
         for(_loc4_ in GroupTypes.NAMES)
         {
            _loc2_.push({
               "id":_loc4_,
               "name":GroupTypes.NAMES[_loc4_]
            });
            if(_loc2_[_loc2_.length - 1].id == this.type)
            {
               _loc3_ = _loc2_[_loc2_.length - 1];
            }
         }
         _loc2_.sort(GroupTypes.groupArraySorting);
         _loc5_ = new SelectBox(_loc2_,_loc3_);
         _loc5_.title = Lang.getString("GENERAL_SELECT");
         _loc5_.labelFunction = this.gateLabel;
         _loc5_.addEventListener(PopUpEvent.CLOSE,this.onSectionFinished);
         _loc5_.open(null);
      }
      
      private function gateLabel(param1:Object) : String
      {
         return Lang.getString("GATE_" + param1.name.toUpperCase());
      }
      
      private function onSectionFinished(param1:PopUpEvent) : void
      {
         if(param1.commit)
         {
            this.btnType.label = this.gateLabel(param1.data);
            this.type = int(param1.data.id);
         }
      }
   }
}
