package refactor.bisecur._1_APP.views.gateways
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import spark.components.Button;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalAlign;
   import spark.layouts.VerticalLayout;
   
   public class SearchGatewaysPopup extends LoadBox
   {
       
      
      public var gateways:Array;
      
      protected var gatewayDisplay:Label;
      
      protected var submitButton:Button;
      
      private var _operationState:String;
      
      public function SearchGatewaysPopup()
      {
         super();
         layout = new VerticalLayout();
         (layout as VerticalLayout).horizontalAlign = HorizontalAlign.CENTER;
         (layout as VerticalLayout).verticalAlign = VerticalAlign.MIDDLE;
         (layout as VerticalLayout).paddingTop = innerPadding;
         (layout as VerticalLayout).paddingBottom = innerPadding;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
      }
      
      public function presentScanFinidhed(param1:Array) : void
      {
         var _loc2_:Gateway = null;
         if(param1 == null)
         {
            param1 = [];
         }
         if(param1.length > 0)
         {
            this.operationState = "searchComplete";
            this.gatewayDisplay.text = "";
            for each(_loc2_ in param1)
            {
               this.gatewayDisplay.text = this.gatewayDisplay.text + (this.formatMac(_loc2_.mac) + "\n");
            }
         }
         else
         {
            param1 = null;
            this.operationState = "searchFailed";
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.gatewayDisplay = new Label();
         this.gatewayDisplay.setStyle("fontWeight","bold");
         this.gatewayDisplay.visible = false;
         this.gatewayDisplay.includeInLayout = false;
         this.submitButton = new Button();
         this.submitButton.label = Lang.getString("GENERAL_SUBMIT");
         this.submitButton.percentWidth = 50;
         this.submitButton.visible = false;
         this.submitButton.includeInLayout = false;
         this.submitButton.addEventListener(MouseEvent.CLICK,this.onSubmit);
         addElement(this.gatewayDisplay);
         addElement(this.submitButton);
         this.operationState = "searching";
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.gatewayDisplay.width = this.content.width - innerPadding * 4;
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         this.close(this.gateways != null,this.gateways);
      }
      
      protected function formatMac(param1:String) : String
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1.substr(_loc3_,2));
            _loc3_ = _loc3_ + 2;
         }
         return _loc2_.join(":");
      }
      
      public function get operationState() : String
      {
         return this._operationState;
      }
      
      public function set operationState(param1:String) : void
      {
         if(this.operationState == param1)
         {
            return;
         }
         this._operationState = param1;
         switch(this.operationState)
         {
            case "searching":
               this.title = Lang.getString("POPUP_SEARCH_TITLE");
               this.contentText = Lang.getString("POPUP_SEARCH_CONTENT");
               this.submitButton.visible = false;
               this.submitButton.includeInLayout = false;
               biContent.visible = true;
               biContent.includeInLayout = true;
               this.gatewayDisplay.visible = false;
               this.gatewayDisplay.includeInLayout = false;
               break;
            case "searchComplete":
               this.title = Lang.getString("POPUP_GATEWAY_FOUND_TITILE");
               this.contentText = Lang.getString("POPUP_GATEWAY_FOUND_CONTENT");
               this.submitButton.visible = true;
               this.submitButton.includeInLayout = true;
               biContent.visible = false;
               biContent.includeInLayout = false;
               this.gatewayDisplay.visible = true;
               this.gatewayDisplay.includeInLayout = true;
               break;
            case "searchFailed":
               this.title = Lang.getString("ADD_GATEWAY_NO_GATEWAYS_TITLE");
               this.contentText = Lang.getString("ADD_GATEWAY_NO_GATEWAYS_CONTENT");
               this.submitButton.visible = true;
               this.submitButton.includeInLayout = true;
               biContent.visible = false;
               biContent.includeInLayout = false;
               this.gatewayDisplay.visible = false;
               this.gatewayDisplay.includeInLayout = false;
         }
      }
   }
}
