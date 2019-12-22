package refactor.bisecur._5_UTIL
{
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.dao.AppSettingDAO;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import spark.events.PopUpEvent;
   
   public class InfoCenter extends EventDispatcher
   {
      
      public static const gateFilter:Array = [GroupTypes.SECTIONAL_DOOR,GroupTypes.HORIZONTAL_SECTIONAL_DOOR,GroupTypes.SWING_GATE_SINGLE,GroupTypes.SWING_GATE_DOUBLE,GroupTypes.SLIDING_GATE,GroupTypes.DOOR];
       
      
      public function InfoCenter()
      {
         super();
      }
      
      public static function channelScreen(param1:HmGroup) : Popup
      {
         var appSettings:AppSettingDAO = null;
         var closeEvent:Function = null;
         var grp:HmGroup = param1;
         if(!in_array(grp.type,gateFilter))
         {
            return null;
         }
         appSettings = DAOFactory.getAppSettingDAO();
         if(appSettings.getSuppressGateOutOfView())
         {
            return null;
         }
         var box:ErrorBox = createErrorBox("POPUP_WARNING","POPUP_GATE_OUT_OF_VIEW");
         box.addEventListener(PopUpEvent.CLOSE,closeEvent = function(param1:Event):void
         {
            var _loc2_:* = param1.currentTarget as ErrorBox;
            _loc2_.removeEventListener(PopUpEvent.CLOSE,closeEvent);
            appSettings.setSuppressGateOutOfView(_loc2_.isSuppressed);
         });
         box.open(null);
         return box;
      }
      
      public static function createGroup(param1:int, param2:Boolean) : Popup
      {
         var appSettings:AppSettingDAO = null;
         var closeEvent:Function = null;
         var type:int = param1;
         var responsable:Boolean = param2;
         if(responsable)
         {
            return null;
         }
         appSettings = DAOFactory.getAppSettingDAO();
         if(appSettings.getSuppressGateNotResponsible())
         {
            return null;
         }
         var box:ErrorBox = createErrorBox("POPUP_INFO","POPUP_GATE_NOT_RESPONSABLE");
         box.addEventListener(PopUpEvent.CLOSE,closeEvent = function(param1:Event):void
         {
            var _loc2_:* = param1.currentTarget as ErrorBox;
            _loc2_.removeEventListener(PopUpEvent.CLOSE,closeEvent);
            appSettings.setSuppressGateNotResponsible(_loc2_.isSuppressed);
         });
         box.open(null);
         return box;
      }
      
      public static function onNetTimeout() : void
      {
         var onClose:Function = null;
         var box:ErrorBox = null;
         box = createErrorBox("LOGIN_FAILED_TITLE","POPUP_INET_SPEED_LOW",false);
         box.addEventListener(PopUpEvent.CLOSE,onClose = function(param1:Event):void
         {
            box.removeEventListener(PopUpEvent.CLOSE,onClose);
            AppCache.sharedCache.logout();
         });
         if(HoermannRemote.appData && HoermannRemote.appData.userId >= 0)
         {
            box.open(null);
         }
      }
      
      public static function onMCPError(param1:MCPPackage, param2:int) : void
      {
         switch(param2)
         {
            case MCPErrors.PERMISSION_DENIED:
               if(AppCache.sharedCache.loggedInUser != null && AppCache.sharedCache.connectedGateway != null && AppCache.sharedCache.connection != null)
               {
                  AppCache.sharedCache.relogin();
               }
         }
      }
      
      public static function in_array(param1:int, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            if(param2[_loc3_] is Array)
            {
               return in_array(param1,param2[_loc3_]);
            }
            _loc3_++;
         }
         return false;
      }
      
      protected static function createErrorBox(param1:String, param2:String, param3:Boolean = true) : ErrorBox
      {
         var _loc4_:ErrorBox = new ErrorBox();
         _loc4_.title = Lang.getString(param1);
         _loc4_.contentText = Lang.getString(param2);
         _loc4_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc4_.closeable = true;
         _loc4_.isSuppressable = param3;
         return _loc4_;
      }
   }
}
