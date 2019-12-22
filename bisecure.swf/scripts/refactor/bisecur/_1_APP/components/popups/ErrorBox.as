package refactor.bisecur._1_APP.components.popups
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import mx.controls.Spacer;
   import mx.core.EventPriority;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   
   public class ErrorBox extends Popup
   {
      
      private static var singleton:ErrorBox;
       
      
      public var data:Object;
      
      protected var lblContent:Label;
      
      protected var sp1:Spacer;
      
      protected var chkSuppress:CheckBox;
      
      protected var sp2:Spacer;
      
      protected var grpButtons:HGroup;
      
      protected var btnClose:Button;
      
      private var tempContent:String;
      
      private var tempCloseTitle:String;
      
      private var tempCloseVisible:Boolean = false;
      
      private var tempSuppressVisible:Boolean = false;
      
      public function ErrorBox()
      {
         super();
      }
      
      public static function get sharedBox() : ErrorBox
      {
         if(singleton == null)
         {
            singleton = new ErrorBox();
         }
         return singleton;
      }
      
      public static function create(param1:String = "", param2:String = "", param3:Boolean = true, param4:String = "OK") : ErrorBox
      {
         var _loc5_:ErrorBox = new ErrorBox();
         _loc5_.title = param1;
         _loc5_.contentText = param2;
         _loc5_.closeable = param3;
         _loc5_.closeTitle = param4;
         return _loc5_;
      }
      
      public function set contentText(param1:String) : void
      {
         this.tempContent = param1;
         if(this.lblContent)
         {
            this.onContentReady(null);
         }
      }
      
      public function get contentText() : String
      {
         return this.tempContent;
      }
      
      public function set closeable(param1:Boolean) : void
      {
         this.tempCloseVisible = param1;
         if(this.btnClose)
         {
            this.onCloseReady(null);
         }
      }
      
      public function get closeable() : Boolean
      {
         return this.tempCloseVisible;
      }
      
      public function set closeTitle(param1:String) : void
      {
         this.tempCloseTitle = param1;
         if(this.btnClose)
         {
            this.onCloseReady(null);
         }
      }
      
      public function get closeTitle() : String
      {
         return this.tempCloseTitle;
      }
      
      public function set isSuppressable(param1:Boolean) : void
      {
         this.tempSuppressVisible = param1;
         if(this.chkSuppress)
         {
            this.onSuppressReady(null);
         }
      }
      
      public function get isSuppressable() : Boolean
      {
         return this.tempSuppressVisible;
      }
      
      public function get isSuppressed() : Boolean
      {
         if(this.chkSuppress)
         {
            return this.chkSuppress.selected;
         }
         return false;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblContent = new Label();
         this.lblContent.addEventListener(FlexEvent.CREATION_COMPLETE,this.onContentReady,false,EventPriority.EFFECT,true);
         this.addElement(this.lblContent);
         this.sp1 = new Spacer();
         this.addElement(this.sp1);
         this.chkSuppress = new CheckBox();
         this.chkSuppress.label = Lang.getString("POPUP_SUPPRESS");
         this.chkSuppress.selected = false;
         this.chkSuppress.addEventListener(FlexEvent.CREATION_COMPLETE,this.onSuppressReady,false,EventPriority.EFFECT,true);
         this.addElement(this.chkSuppress);
         this.sp2 = new Spacer();
         this.addElement(this.sp2);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.CENTER;
         this.addElement(this.grpButtons);
         this.btnClose = new Button();
         this.btnClose.addEventListener(FlexEvent.CREATION_COMPLETE,this.onCloseReady);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.grpButtons.addElement(this.btnClose);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.sp1.height = 10;
         this.lblContent.width = this.content.width - innerPadding * 2;
         this.chkSuppress.width = this.lblContent.width;
         this.sp1.height = 10;
         this.grpButtons.width = this.lblContent.width;
         this.btnClose.width = this.content.width / 2;
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.close(true,this.data);
      }
      
      override public function close(param1:Boolean = false, param2:* = null) : void
      {
         super.close(param1,param2);
      }
      
      private function onCloseReady(param1:FlexEvent) : void
      {
         this.btnClose.label = this.tempCloseTitle;
         this.btnClose.visible = this.tempCloseVisible;
      }
      
      private function onContentReady(param1:FlexEvent) : void
      {
         this.lblContent.text = this.tempContent;
      }
      
      private function onSuppressReady(param1:FlexEvent) : void
      {
         this.chkSuppress.visible = this.tempSuppressVisible;
      }
   }
}
