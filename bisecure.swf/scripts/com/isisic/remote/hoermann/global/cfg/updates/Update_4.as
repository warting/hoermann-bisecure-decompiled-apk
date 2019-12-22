package com.isisic.remote.hoermann.global.cfg.updates
{
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.ConfigUpdate;
   import com.isisic.remote.lw.Debug;
   
   public class Update_4 implements ConfigUpdate
   {
       
      
      public function Update_4()
      {
         super();
      }
      
      public function runUpdate(param1:AsConfig) : void
      {
         Debug.info("Updating Config to Version 4");
         param1.setProperty(AsConfig.SUPPRESS_GATE_OUT_OF_VIEW,false);
         param1.setProperty(AsConfig.SUPPRESS_GATE_NOT_RESPONSABLE,false);
      }
   }
}
