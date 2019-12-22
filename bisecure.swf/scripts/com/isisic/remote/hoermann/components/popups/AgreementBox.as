package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import mx.controls.Spacer;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalAlign;
   
   public class AgreementBox extends Popup implements IDisposable
   {
      
      private static var OPENED:Boolean = false;
       
      
      private var lblContent:Label;
      
      private var grpTerms:VGroup;
      
      private var btnOpenUse:Button;
      
      private var btnOpenPrivacy:Button;
      
      private var grpUse:HGroup;
      
      private var chkUse:CheckBox;
      
      private var lblUse:Label;
      
      private var grpPrivacy:HGroup;
      
      private var chkPrivacy:CheckBox;
      
      private var lblPrivacy:Label;
      
      private var sp3:Spacer;
      
      private var grpControls:HGroup;
      
      private var btnSubmit:Button;
      
      private var _autoDispose:Boolean;
      
      public function AgreementBox(param1:Boolean = false)
      {
         super();
         this.title = Lang.getString("POPUP_AGREEMENT");
         this._autoDispose = param1;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(OPENED)
         {
            Debug.warning("[AgreementBox] open() called but popup is already shown!");
            return;
         }
         super.open(param1,param2);
         OPENED = true;
      }
      
      override public function close(param1:Boolean = false, param2:* = null) : void
      {
         super.close(param1,param2);
         OPENED = false;
         if(this._autoDispose)
         {
            this.dispose();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblContent = new Label();
         this.lblContent.text = Lang.getString("POPUP_AGREEMENT_CONTENT");
         this.lblContent.percentWidth = 100;
         addElement(this.lblContent);
         this.grpTerms = new VGroup();
         this.grpTerms.horizontalAlign = HorizontalAlign.CENTER;
         this.grpTerms.paddingTop = 20;
         this.grpTerms.paddingBottom = 20;
         this.grpTerms.percentWidth = 100;
         addElement(this.grpTerms);
         this.btnOpenUse = new Button();
         this.btnOpenUse.label = Lang.getString("POPUP_AGREEMENT_TERMS_OF_USE");
         this.btnOpenUse.percentWidth = 100;
         this.btnOpenUse.addEventListener(MouseEvent.CLICK,this.onOpenClick);
         this.grpTerms.addElement(this.btnOpenUse);
         this.btnOpenPrivacy = new Button();
         this.btnOpenPrivacy.label = Lang.getString("POPUP_AGREEMENT_TERMS_OF_PRIVACY");
         this.btnOpenPrivacy.percentWidth = 100;
         this.btnOpenPrivacy.addEventListener(MouseEvent.CLICK,this.onOpenClick);
         this.grpTerms.addElement(this.btnOpenPrivacy);
         this.grpUse = new HGroup();
         this.grpUse.percentWidth = 100;
         this.grpUse.verticalAlign = VerticalAlign.MIDDLE;
         addElement(this.grpUse);
         this.chkUse = new CheckBox();
         this.chkUse.addEventListener(Event.CHANGE,this.onChkChange);
         this.chkUse.selected = HoermannRemote.appData.acceptedTermsOfUse;
         this.grpUse.addElement(this.chkUse);
         this.lblUse = new Label();
         this.lblUse.text = Lang.getString("POPUP_AGREEMENT_ACCEPT_USE");
         this.lblUse.percentWidth = 100;
         this.lblUse.addEventListener(MouseEvent.CLICK,this.onTermLabelClick);
         this.grpUse.addElement(this.lblUse);
         this.grpPrivacy = new HGroup();
         this.grpPrivacy.percentWidth = 100;
         this.grpPrivacy.verticalAlign = VerticalAlign.MIDDLE;
         addElement(this.grpPrivacy);
         this.chkPrivacy = new CheckBox();
         this.chkPrivacy.selected = HoermannRemote.appData.acceptedTermsOfPrivacy;
         this.chkPrivacy.addEventListener(Event.CHANGE,this.onChkChange);
         this.grpPrivacy.addElement(this.chkPrivacy);
         this.lblPrivacy = new Label();
         this.lblPrivacy.text = Lang.getString("POPUP_AGREEMENT_ACCEPT_PRIVACY");
         this.lblPrivacy.percentWidth = 100;
         this.lblPrivacy.addEventListener(MouseEvent.CLICK,this.onTermLabelClick);
         this.grpPrivacy.addElement(this.lblPrivacy);
         this.sp3 = new Spacer();
         this.sp3.height = 20;
         addElement(this.sp3);
         this.grpControls = new HGroup();
         this.grpControls.horizontalAlign = HorizontalAlign.CENTER;
         this.grpControls.percentWidth = 100;
         addElement(this.grpControls);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.enabled = this.chkUse.selected && this.chkPrivacy.selected;
         this.btnSubmit.percentWidth = 50;
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.grpControls.addElement(this.btnSubmit);
      }
      
      protected function onOpenClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(param1.currentTarget == this.btnOpenUse)
         {
            _loc2_ = new URLRequest(Lang.getString("LINK_TERMS_OF_USE"));
         }
         else if(param1.currentTarget == this.btnOpenPrivacy)
         {
            _loc2_ = new URLRequest(Lang.getString("LINK_TERMS_OF_PRIVACY"));
         }
         else
         {
            Debug.warning("[AgreementBox] no link for target: " + param1.currentTarget);
         }
         navigateToURL(_loc2_);
      }
      
      protected function onTermLabelClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this.lblUse)
         {
            this.chkUse.selected = !this.chkUse.selected;
         }
         else if(param1.currentTarget == this.lblPrivacy)
         {
            this.chkPrivacy.selected = !this.chkPrivacy.selected;
         }
         else
         {
            Debug.warning("[AgreementBox] no checkbox for target: " + param1.currentTarget);
         }
         this.onChkChange();
      }
      
      protected function onChkChange(param1:Event = null) : void
      {
         HoermannRemote.appData.acceptedTermsOfUse = this.chkUse.selected;
         HoermannRemote.appData.acceptedTermsOfPrivacy = this.chkPrivacy.selected;
         if(this.chkUse.selected && this.chkPrivacy.selected)
         {
            this.btnSubmit.enabled = true;
         }
         else
         {
            this.btnSubmit.enabled = false;
         }
      }
      
      protected function onSubmit(param1:Event) : void
      {
         this.close();
         this.dispose();
      }
      
      public function dispose() : void
      {
         if(this.btnOpenPrivacy)
         {
            this.btnOpenPrivacy.removeEventListener(MouseEvent.CLICK,this.onOpenClick);
            this.btnOpenPrivacy = null;
         }
         if(this.btnOpenUse)
         {
            this.btnOpenUse.removeEventListener(MouseEvent.CLICK,this.onOpenClick);
            this.btnOpenUse = null;
         }
         if(this.chkUse)
         {
            this.chkUse.removeEventListener(Event.CHANGE,this.onChkChange);
            this.chkUse = null;
         }
         if(this.chkPrivacy)
         {
            this.chkPrivacy.removeEventListener(Event.CHANGE,this.onChkChange);
            this.chkPrivacy = null;
         }
         if(this.lblUse)
         {
            this.lblUse.removeEventListener(MouseEvent.CLICK,this.onTermLabelClick);
            this.lblUse = null;
         }
         if(this.lblPrivacy)
         {
            this.lblPrivacy.removeEventListener(MouseEvent.CLICK,this.onTermLabelClick);
            this.lblPrivacy = null;
         }
         if(this.btnSubmit)
         {
            this.btnSubmit.removeEventListener(MouseEvent.CLICK,this.onSubmit);
            this.btnSubmit = null;
         }
      }
   }
}
