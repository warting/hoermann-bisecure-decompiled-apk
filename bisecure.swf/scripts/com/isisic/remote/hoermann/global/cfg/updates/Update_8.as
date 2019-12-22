package com.isisic.remote.hoermann.global.cfg.updates
{
   import com.isisic.remote.hoermann.global.Portal;
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.ConfigUpdate;
   import com.isisic.remote.lw.Debug;
   
   public class Update_8 implements ConfigUpdate
   {
       
      
      public function Update_8()
      {
         super();
      }
      
      public function runUpdate(param1:AsConfig) : void
      {
         var _loc2_:Object = null;
         Debug.info("Updating Config to Version 8");
         param1.setProperty(AsConfig.SHOW_ADMIN_CHPWD,null);
         param1.setProperty(AsConfig.SCENARIOS,null);
         for each(_loc2_ in param1.getProperty(AsConfig.GATEWAYS))
         {
            delete _loc2_.isDDns;
            if(_loc2_.host != Portal.HOST_COMMUNICATION && _loc2_.host != Portal.DEV_HOST_COMMUNICATION)
            {
               _loc2_.mac = _loc2_.mac.toUpperCase();
               _loc2_.localIp = _loc2_.host;
               _loc2_.localPort = _loc2_.port;
            }
         }
      }
   }
}
