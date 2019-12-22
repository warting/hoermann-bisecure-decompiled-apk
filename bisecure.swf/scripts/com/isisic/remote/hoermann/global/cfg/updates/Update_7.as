package com.isisic.remote.hoermann.global.cfg.updates
{
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.ConfigUpdate;
   import com.isisic.remote.lw.Debug;
   
   public class Update_7 implements ConfigUpdate
   {
       
      
      public function Update_7()
      {
         super();
      }
      
      public function runUpdate(param1:AsConfig) : void
      {
         Debug.info("Updating Config to Version 7");
         param1.setProperty(AsConfig.TERMS_OF_USE_ACCEPTED,false);
         param1.setProperty(AsConfig.TERMS_OF_PRIVACY_ACCEPTED,false);
      }
   }
}
