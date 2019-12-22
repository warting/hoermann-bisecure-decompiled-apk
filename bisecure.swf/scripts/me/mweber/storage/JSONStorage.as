package me.mweber.storage
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import me.mweber.basic.Debug;
   import mx.utils.ObjectUtil;
   
   public class JSONStorage implements iStorage
   {
      
      public static const EXTENSIONS:Array = ["json","jfile","jcfg","jstr","jcache"];
       
      
      protected var file:File;
      
      protected var data:Object;
      
      public function JSONStorage()
      {
         super();
      }
      
      public function getProperty(param1:String) : *
      {
         return this.getPropertyForKey(param1);
      }
      
      public function setProperty(param1:String, param2:*) : void
      {
         this.setPropertyForKey(param1,param2);
      }
      
      public function getString(param1:String) : String
      {
         return this.getProperty(param1) as String;
      }
      
      public function setString(param1:String, param2:String) : void
      {
         this.setProperty(param1,param2);
      }
      
      public function getNumber(param1:String) : Number
      {
         return this.getProperty(param1) as Number;
      }
      
      public function setNumber(param1:String, param2:Number) : void
      {
         this.setProperty(param1,param2);
      }
      
      public function getInt(param1:String) : int
      {
         return this.getProperty(param1) as int;
      }
      
      public function setInt(param1:String, param2:int) : void
      {
         this.setProperty(param1,param2);
      }
      
      public function getBoolean(param1:String) : Boolean
      {
         return this.getProperty(param1) as Boolean;
      }
      
      public function setBoolean(param1:String, param2:Boolean) : void
      {
         this.setProperty(param1,param2);
      }
      
      public function getArray(param1:String) : Array
      {
         return this.getProperty(param1) as Array;
      }
      
      public function setArray(param1:String, param2:Array) : void
      {
         this.setProperty(param1,param2);
      }
      
      public function getDate(param1:String) : Date
      {
         return new Date(this.getNumber(param1));
      }
      
      public function setDate(param1:String, param2:Date) : void
      {
         this.setNumber(param1,param2.time);
      }
      
      protected function getPropertyForKey(param1:String, param2:Object = null) : *
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = this.data;
         }
         if(param2 == null)
         {
            return null;
         }
         if(param1.indexOf(".") < 0)
         {
            return param2[param1];
         }
         _loc3_ = param1.substr(0,param1.indexOf("."));
         return this.getPropertyForKey(param1.substr(param1.indexOf(".") + 1),param2[_loc3_]);
      }
      
      protected function setPropertyForKey(param1:String, param2:*, param3:Object = null) : void
      {
         var _loc4_:String = null;
         if(param3 == null)
         {
            param3 = this.data;
         }
         if(param3 == null)
         {
            return;
         }
         if(param1.indexOf(".") < 0)
         {
            if(param2 == null)
            {
               delete param3[param1];
            }
            else
            {
               param3[param1] = param2;
            }
         }
         else
         {
            _loc4_ = param1.substr(0,param1.indexOf("."));
            if(!ObjectUtil.isDynamicObject(param3[_loc4_]))
            {
               param3[_loc4_] = new Object();
            }
            this.setPropertyForKey(param1.substr(param1.indexOf(".") + 1),param2,param3[_loc4_]);
         }
      }
      
      public function open(param1:File) : void
      {
         this.file = param1;
         if(!param1.exists)
         {
            this.data = new Object();
            this.save();
         }
         else
         {
            this.load();
         }
      }
      
      public function close() : void
      {
         this.save();
         this.data = null;
         this.file = null;
      }
      
      public function load() : void
      {
         var stream:FileStream = null;
         try
         {
            stream = new FileStream();
            stream.open(this.file,FileMode.READ);
            this.data = JSON.parse(stream.readUTFBytes(stream.bytesAvailable));
            stream.close();
            return;
         }
         catch(error:Error)
         {
            try
            {
               Debug.error("[JSONStorage] loading file \'" + file.name + "\' failed (file is corrupted)!\n" + "[" + error.errorID + "] " + error.message);
               file.deleteFile();
               this.open(file);
            }
            catch(error2:Error)
            {
               Debug.error("[JSONStorage] exception in exception handling:" + "[" + error2.errorID + "]" + error2.message);
               if(file.exists)
               {
                  file.deleteFile();
               }
               this.open(file);
            }
            return;
         }
      }
      
      public function save() : void
      {
         var _loc1_:FileStream = new FileStream();
         _loc1_.open(this.file,FileMode.WRITE);
         _loc1_.writeUTFBytes(JSON.stringify(this.data,null,4));
         _loc1_.close();
      }
   }
}
