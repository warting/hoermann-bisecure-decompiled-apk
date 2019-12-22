package com.isisic.remote.hoermann.global.cfg.updates
{
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.ConfigUpdate;
   import com.isisic.remote.lw.Debug;
   
   public class Update_3 implements ConfigUpdate
   {
       
      
      public function Update_3()
      {
         super();
      }
      
      public function runUpdate(param1:AsConfig) : void
      {
         Debug.info("Updating Config to Version 3");
         param1.setProperty(AsConfig.PORTAL_DATA,null);
         param1.setProperty(AsConfig.AUTO_LOGIN,null);
      }
   }
}
