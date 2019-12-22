package refactor.logicware._2_SAL.mcp
{
   public final class MCPCommands
   {
      
      public static const JMCP_GET_VALUES:String = "{\"cmd\":\"GET_VALUES\"}";
      
      public static const JMCP_GET_GROUPS:String = "{\"cmd\":\"GET_GROUPS\"}";
      
      public static const JMCP_GET_GROUPS_FOR_USER:String = "{\"cmd\":\"GET_GROUPS\", \"forUser\":{0}}";
      
      public static const JMCP_GET_USERS:String = "{\"cmd\":\"GET_USERS\"}";
      
      public static const PING:int = 0;
      
      public static const ERROR:int = 1;
      
      public static const GET_MAC:int = 2;
      
      public static const SET_VALUE:int = 3;
      
      public static const GET_VALUE:int = 4;
      
      public static const DEBUG:int = 5;
      
      public static const JMCP:int = 6;
      
      public static const GET_GW_VERSION:int = 7;
      
      public static const LOGIN:int = 16;
      
      public static const LOGOUT:int = 17;
      
      public static const GET_USER_IDS:int = 32;
      
      public static const GET_USER_NAME:int = 33;
      
      public static const ADD_USER:int = 34;
      
      public static const CHANGE_PASSWD:int = 35;
      
      public static const REMOVE_USER:int = 36;
      
      public static const SET_USER_RIGHTS:int = 37;
      
      public static const GET_NAME:int = 38;
      
      public static const SET_NAME:int = 39;
      
      public static const GET_USER_RIGHTS:int = 40;
      
      public static const ADD_PORT:int = 41;
      
      public static const ADD_GROUP:int = 42;
      
      public static const REMOVE_GROUP:int = 43;
      
      public static const SET_GROUP_NAME:int = 44;
      
      public static const GET_GROUP_NAME:int = 45;
      
      public static const SET_GROUPED_PORTS:int = 46;
      
      public static const GET_GROUPED_PORTS:int = 47;
      
      public static const GET_GROUP_IDS:int = 64;
      
      public static const INHERIT_PORT:int = 65;
      
      public static const REMOVE_PORT:int = 66;
      
      public static const CHANGE_USER_NAME:int = 67;
      
      public static const CHANGE_USER_NAME_OF_USER:int = 68;
      
      public static const CHANGE_PASSWORD_OF_USER:int = 69;
      
      public static const GET_PORTS:int = 48;
      
      public static const GET_TYPE:int = 49;
      
      public static const GET_STATE:int = 50;
      
      public static const SET_STATE:int = 51;
      
      public static const GET_PORT_NAME:int = 52;
      
      public static const SET_PORT_NAME:int = 53;
      
      public static const SET_TYPE:int = 54;
      
      public static const SET_SSL:int = 80;
      
      public static const SCAN_WIFI:int = 81;
      
      public static const WIFI_FOUND:int = 82;
      
      public static const GET_WIFI_STATE:int = 83;
      
      public static const HM_GET_TRANSITION:int = 112;
      
      public static const NAMES:Object = {
         0:"PING",
         1:"ERROR",
         2:"GET_MAC",
         3:"SET_VALUE",
         4:"GET_VALUE",
         5:"DEBUG",
         6:"JMCP",
         7:"GET_GW_VERSION",
         16:"LOGIN",
         17:"LOGOUT",
         32:"GET_USER_IDS",
         33:"GET_USER_NAME",
         34:"ADD_USER",
         35:"CHANGE_PASSWD",
         36:"REMOVE_USER",
         37:"SET_USER_RIGHTS",
         38:"GET_NAME",
         39:"SET_NAME",
         40:"GET_USER_RIGHTS",
         41:"ADD_PORT",
         42:"ADD_GROUP",
         43:"REMOVE_GROUP",
         44:"SET_GROUP_NAME",
         45:"GET_GROUP_NAME",
         46:"SET_GROUPED_PORTS",
         47:"GET_GROUPED_PORTS",
         64:"GET_GROUP_IDS",
         65:"INHERIT_PORT",
         66:"REMOVE_PORT",
         48:"GET_PORTS",
         49:"GET_TYPE",
         50:"GET_STATE",
         51:"SET_STATE",
         52:"GET_PORT_NAME",
         53:"SET_PORT_NAME",
         54:"SET_TYPE",
         80:"SET_SSL",
         81:"SCAN_WIFI",
         82:"WIFI_FOUND",
         83:"GET_WIFI_STATE",
         112:"GET_TRANSITION"
      };
       
      
      public function MCPCommands()
      {
         super();
      }
   }
}
