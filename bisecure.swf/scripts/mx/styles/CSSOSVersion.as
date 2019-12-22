package mx.styles
{
   public class CSSOSVersion
   {
      
      private static const SEPARATOR:String = ".";
       
      
      public var major:int = 0;
      
      public var minor:int = 0;
      
      public var revision:int = 0;
      
      public function CSSOSVersion(param1:String = "")
      {
         super();
         var _loc2_:Array = param1.split(SEPARATOR);
         var _loc3_:int = _loc2_.length;
         if(_loc3_ >= 1)
         {
            this.major = Number(_loc2_[0]);
         }
         if(_loc3_ >= 2)
         {
            this.minor = Number(_loc2_[1]);
         }
         if(_loc3_ >= 3)
         {
            this.revision = Number(_loc2_[2]);
         }
      }
      
      public function compareTo(param1:CSSOSVersion) : int
      {
         if(this.major > param1.major)
         {
            return 1;
         }
         if(this.major < param1.major)
         {
            return -1;
         }
         if(this.minor > param1.minor)
         {
            return 1;
         }
         if(this.minor < param1.minor)
         {
            return -1;
         }
         if(this.revision > param1.revision)
         {
            return 1;
         }
         if(this.revision < param1.revision)
         {
            return -1;
         }
         return 0;
      }
      
      public function toString() : String
      {
         return this.major.toString() + SEPARATOR + this.minor.toString() + SEPARATOR + this.revision.toString();
      }
   }
}
