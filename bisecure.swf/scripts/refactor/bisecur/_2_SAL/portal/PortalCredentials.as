package refactor.bisecur._2_SAL.portal
{
   public class PortalCredentials
   {
       
      
      public var clientId:String;
      
      public var password:String;
      
      public function PortalCredentials()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[PortalCredentials: clientId=\'" + this.clientId + "\' password=\'" + this.password + "\']";
      }
   }
}
