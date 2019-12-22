package refactor.logicware._2_SAL.mcp
{
   import refactor.logicware._5_UTIL.Log;
   
   public class MCPPackageBuffer
   {
      
      private static var singleton:MCPPackageBuffer;
       
      
      private var packages:Object;
      
      private var extras:Object;
      
      public function MCPPackageBuffer(param1:ConstructorLock#169)
      {
         this.packages = {};
         this.extras = {};
         super();
      }
      
      public static function get sharedBuffer() : MCPPackageBuffer
      {
         if(singleton == null)
         {
            singleton = new MCPPackageBuffer(null);
         }
         return singleton;
      }
      
      public function insert(param1:MCPPackage, param2:Object = null) : MCPPackage
      {
         param1.tag = this.freeTag;
         if(param1.tag < 0)
         {
            Log.error("[MCPPackageBuffer] No free Tag to sign the MCP Package!");
            return null;
         }
         this.packages[param1.tag] = param1;
         this.extras[param1.tag] = param2;
         return param1;
      }
      
      public function read(param1:int) : MCPPackage
      {
         return this.packages[param1];
      }
      
      public function readExtra(param1:int) : Object
      {
         return this.extras[param1];
      }
      
      public function remove(param1:int) : MCPPackage
      {
         var _loc2_:MCPPackage = this.read(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         delete this.packages[param1];
         delete this.extras[param1];
         return _loc2_;
      }
      
      public function get freeTag() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < 128)
         {
            if(this.packages[_loc1_] == null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
   }
}

class ConstructorLock#169
{
    
   
   function ConstructorLock#169()
   {
      super();
   }
}
