package refactor.logicware._1_APP.commands
{
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class LoginCommand implements IDisposable
   {
       
      
      private var _response:MCPPackage = null;
      
      private var user:User;
      
      private var context:ConnectionContext;
      
      public function LoginCommand(param1:User, param2:ConnectionContext)
      {
         super();
         this.user = param1;
         this.context = param2;
      }
      
      public function get response() : MCPPackage
      {
         return this._response;
      }
      
      public function execute(param1:Function) : void
      {
         var callback:Function = param1;
         var loader:MCPLoader = new MCPLoader(this.context);
         loader.load(MCPBuilder.createLogin(this.user.name,this.user.password),function(param1:MCPLoader):void
         {
            var _loc2_:ByteArray = null;
            _response = param1.response;
            if(param1.response == null)
            {
               callCallback(callback,CommunicationResult.TIMEOUT);
            }
            else if(param1.response.command == MCPCommands.ERROR)
            {
               callCallback(callback,CommunicationResult.ERROR);
            }
            else if(param1.response.command == MCPCommands.LOGIN && param1.response.response)
            {
               _loc2_ = param1.response.payload;
               if(_loc2_ != null && _loc2_.length > 0)
               {
                  user.id = _loc2_.readUnsignedByte();
               }
               callCallback(callback,CommunicationResult.SUCCESS);
            }
            else
            {
               callCallback(callback,CommunicationResult.UNEXPECTED);
            }
         });
      }
      
      private function callCallback(param1:Function, param2:String) : void
      {
         if(param1 != null)
         {
            param1(this,param2);
         }
      }
      
      public function dispose() : void
      {
         this.user = null;
         this.context = null;
      }
   }
}
