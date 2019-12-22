package com.isisic.remote.hoermann.global.cfg.updates
{
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.ConfigUpdate;
   import com.isisic.remote.lw.Debug;
   
   public class Update_5 implements ConfigUpdate
   {
       
      
      public function Update_5()
      {
         super();
      }
      
      public function runUpdate(param1:AsConfig) : void
      {
         Debug.info("Updating Config to Version 5");
         param1.setProperty(AsConfig.SHOW_ADMIN_CHPWD,true);
      }
   }
}
