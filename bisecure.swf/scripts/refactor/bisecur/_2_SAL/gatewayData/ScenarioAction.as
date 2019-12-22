package refactor.bisecur._2_SAL.gatewayData
{
   public class ScenarioAction
   {
       
      
      public var groupId:int = -1;
      
      public var deviceAction:int = -1;
      
      public var actionType:int = -1;
      
      public function ScenarioAction()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[ScenarioAction: groupId=\'" + this.groupId + "\' deviceAction=\'" + this.deviceAction + "\' actionType=\'" + this.actionType + "\']";
      }
   }
}
