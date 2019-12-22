package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.lw.Debug;
   import mx.core.EventPriority;
   import mx.events.FlexEvent;
   import spark.components.BusyIndicator;
   import spark.components.Label;
   
   public class LoadBox extends Popup
   {
       
      
      protected var lblContent:Label;
      
      protected var biContent:BusyIndicator;
      
      private var tempContent:String;
      
      public function LoadBox()
      {
         super();
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblContent = new Label();
         this.lblContent.addEventListener(FlexEvent.CREATION_COMPLETE,this.onContentReady,false,EventPriority.EFFECT,true);
         this.addElement(this.lblContent);
         this.biContent = new BusyIndicator();
         this.titleBar.addElement(this.biContent);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.biContent.currentState != "rotatingState")
         {
            Debug.debug("[LoadBox] biState is " + this.biContent.currentState + " setting to rotatingState");
            this.biContent.setCurrentState("rotatingState");
         }
         this.lblContent.x = innerPadding;
         this.lblContent.y = innerPadding;
         this.lblContent.width = this.content.width - innerPadding * 2;
         this.biContent.y = innerPadding;
         this.biContent.x = this.content.width - (this.biContent.width + innerPadding);
      }
      
      private function onContentReady(param1:FlexEvent) : void
      {
         this.lblContent.text = this.tempContent;
      }
   }
}
