package com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   
   public interface IUserEditFeature
   {
       
      
      function getIcon() : IVisualElement;
      
      function onClick(param1:Event) : void;
      
      function set toggleEditCallback(param1:Function) : void;
      
      function set loadUsersCallback(param1:Function) : void;
   }
}
