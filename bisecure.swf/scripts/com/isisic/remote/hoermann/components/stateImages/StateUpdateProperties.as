package com.isisic.remote.hoermann.components.stateImages
{
   import com.isisic.remote.hoermann.net.HmTransition;
   import mx.core.IVisualElement;
   
   public class StateUpdateProperties
   {
       
      
      public var transition:HmTransition;
      
      public var collectingActive:Boolean;
      
      public var requestable:Boolean;
      
      public var additionalIcon:IVisualElement;
      
      public var showState:Boolean;
      
      public var actorState:String;
      
      public var showDrivingDirection:Boolean;
      
      public function StateUpdateProperties(param1:HmTransition = null, param2:Boolean = false, param3:Boolean = false, param4:IVisualElement = null, param5:Boolean = true, param6:String = "closed", param7:Boolean = true)
      {
         super();
         this.transition = param1;
         this.collectingActive = param2;
         this.requestable = param3;
         this.additionalIcon = param4;
         this.showState = param5;
         this.actorState = param6;
         this.showDrivingDirection = param7;
      }
   }
}
