package com.isisic.remote.lw.mcp
{
   public class Errors
   {
      
      public static const COMMAND_NOT_FOUND:int = 0;
      
      public static const INVALID_PROTOCOL:int = 1;
      
      public static const LOGIN_FAILED:int = 2;
      
      public static const INVALID_TOKEN:int = 3;
      
      public static const USER_ALREADY_EXISTS:int = 4;
      
      public static const NO_EMPTY_USER_SLOT:int = 5;
      
      public static const INVALID_PASSWORD:int = 6;
      
      public static const INVALID_USERNAME:int = 7;
      
      public static const USER_NOT_FOUND:int = 8;
      
      public static const PORT_NOT_FOUND:int = 9;
      
      public static const PORT_ERROR:int = 10;
      
      public static const GATEWAY_BUSY:int = 11;
      
      public static const PERMISSION_DENIED:int = 12;
      
      public static const NO_EMPTY_GROUP_SLOT:int = 13;
      
      public static const GROUP_NOT_FOUND:int = 14;
      
      public static const INVALID_PAYLOAD:int = 15;
      
      public static const OUT_OF_RANGE:int = 16;
      
      public static const ADD_PORT_ERROR:int = 17;
      
      public static const NO_EMPTY_PORT_SLOT:int = 18;
      
      public static const ADAPTER_BUSY:int = 19;
      
      public static const NAMES:Object = {
         0:"COMMAND_NOT_FOUND",
         1:"INVALID_PROTOCOL",
         2:"LOGIN_FAILED",
         3:"INVALID_TOKEN",
         4:"USER_ALREADY_EXISTS",
         5:"NO_EMPTY_USER_SLOT",
         6:"INVALID_PASSWORD",
         7:"INVALID_USERNAME",
         8:"USER_NOT_FOUND",
         9:"PORT_NOT_FOUND",
         10:"PORT_ERROR",
         11:"GATEWAY_BUSY",
         12:"PERMISSION_DENIED",
         13:"NO_EMPTY_GROUP_SLOT",
         14:"GROUP_NOT_FOUND",
         15:"INVALID_PAYLOAD",
         16:"OUT_OF_RANGE",
         17:"ADD_PORT_ERROR",
         18:"NO_EMPTY_PORT_SLOT",
         19:"ADAPTER_BUSY"
      };
       
      
      public function Errors()
      {
         super();
      }
   }
}
