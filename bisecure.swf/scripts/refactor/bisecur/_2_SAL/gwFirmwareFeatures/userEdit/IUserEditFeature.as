package refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   import refactor.bisecur._2_SAL.gatewayData.User;
   
   public interface IUserEditFeature
   {
       
      
      function getIcon() : IVisualElement;
      
      function onClick(param1:Event, param2:User) : void;
      
      function set toggleEditCallback(param1:Function) : void;
      
      function set loadUsersCallback(param1:Function) : void;
   }
}
