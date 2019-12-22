package spark.managers
{
   import flash.net.SharedObject;
   
   public class PersistenceManager implements IPersistenceManager
   {
      
      private static const SHARED_OBJECT_NAME:String = "FXAppCache";
       
      
      private var initialized:Boolean = false;
      
      private var so:SharedObject;
      
      public function PersistenceManager()
      {
         super();
      }
      
      public function load() : Boolean
      {
         if(this.initialized)
         {
            return true;
         }
         try
         {
            this.so = SharedObject.getLocal(SHARED_OBJECT_NAME);
            this.initialized = true;
         }
         catch(e:Error)
         {
         }
         return this.initialized;
      }
      
      public function setProperty(param1:String, param2:Object) : void
      {
         if(!this.initialized)
         {
            this.load();
         }
         if(this.so != null)
         {
            this.so.data[param1] = param2;
         }
      }
      
      public function getProperty(param1:String) : Object
      {
         if(!this.initialized)
         {
            this.load();
         }
         if(this.so != null)
         {
            return this.so.data[param1];
         }
         return null;
      }
      
      public function clear() : void
      {
         if(!this.initialized)
         {
            this.load();
         }
         if(this.so != null)
         {
            this.so.clear();
         }
      }
      
      public function save() : Boolean
      {
         try
         {
            this.so.flush();
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
   }
}
