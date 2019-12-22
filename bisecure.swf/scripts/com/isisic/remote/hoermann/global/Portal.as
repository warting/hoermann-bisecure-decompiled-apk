package com.isisic.remote.hoermann.global
{
   public class Portal
   {
      
      public static const HOST_META:String = "sslbisecapp.itbcloud.de/m2mcloud/gw_list";
      
      public static const DEV_HOST_META:String = "devbisecapp.itbcloud.de/m2mcloud/gw_list";
      
      public static const HOST_COMMUNICATION:String = "sslbisecapp.itbcloud.de/m2mcloud/gw_command";
      
      public static const DEV_HOST_COMMUNICATION:String = "devbisecapp.itbcloud.de/m2mcloud/gw_command";
      
      public static const HOST_STATUS:String = "sslbisecapp.itbcloud.de/m2mcloud/gw_onlinestatus";
      
      public static const DEV_HOST_STATUS:String = "devbisecapp.itbcloud.de/m2mcloud/gw_onlinestatus";
      
      public static const VAR_DEVICE_ID:String = "id";
      
      public static const VAR_COMMAND:String = "cmd";
      
      public static const COMMAND_VALIDATE_DATA:String = "validateDeviceId";
      
      public static const COMMAND_GET_GATEWAYS:String = "getGateways";
       
      
      public function Portal()
      {
         super();
      }
   }
}
