package com.isisic.remote.hoermann.views.gateways
{
   import com.isisic.remote.hoermann.components.popups.LoadBox;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.helper.GatewayScanner;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
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
         var _loc3_:GatewayScanner = new GatewayScanner();
         _loc3_.addEventListener(Event.COMPLETE,this.onScanComplete);
         _loc3_.scan(new Array(),true,false);
      }
      
      protected function onScanComplete(param1:Event) : void
      {
         var _loc3_:Object = null;
         var _loc2_:GatewayScanner = param1.currentTarget as GatewayScanner;
         if(_loc2_.gateways == null)
         {
            _loc2_.gateways = new Array();
         }
         for each(_loc3_ in HoermannRemote.appData.gateways)
         {
            if(!_loc3_.isPortal)
            {
               ArrayHelper.removeItemByProperty("mac",_loc3_.mac,_loc2_.gateways);
            }
         }
         if(_loc2_.gateways != null && _loc2_.gateways.length > 0)
         {
            this.operationState = "searchComplete";
            this.gatewayDisplay.text = "";
            for each(_loc3_ in _loc2_.gateways)
            {
               this.gatewayDisplay.text = this.gatewayDisplay.text + (this.formatMac(_loc3_.mac) + "\n");
            }
            this.gateways = _loc2_.gateways;
         }
         else
         {
            this.gateways = null;
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
         var _loc2_:Array = new Array();
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
