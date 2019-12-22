package spark.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class PlatformMobileHelper
   {
       
      
      public function PlatformMobileHelper()
      {
         super();
      }
      
      public static function computeOSVersionForAndroid() : String
      {
         var osVersionMatch:Array = null;
         var content:String = null;
         var version:String = "";
         var file:File = new File();
         var fs:FileStream = new FileStream();
         file.nativePath = "/system/build.prop";
         if(file.exists)
         {
            try
            {
               fs.open(file,FileMode.READ);
               content = fs.readUTFBytes(file.size);
               osVersionMatch = content.match(/ro.build.version.release=([\d\.]+)/);
               if(osVersionMatch && osVersionMatch.length == 2)
               {
                  version = osVersionMatch[1];
               }
            }
            catch(e:Error)
            {
               trace("Error while reading build.prop file:" + e.message);
            }
            finally
            {
               if(fs)
               {
                  fs.close();
               }
            }
         }
         return version;
      }
   }
}
