package refactor.logicware._4_HAL.network.tcp.extensions
{
   import refactor.logicware._4_HAL.network.tcp.Client;
   
   public interface IClientExtension
   {
       
      
      function initialize(param1:Client) : void;
      
      function onAction(param1:String, param2:Boolean, param3:Array = null) : Boolean;
      
      function dispose() : void;
   }
}
