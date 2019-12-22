package refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgDelete;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.popups.ConfirmBox;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.net.cache.users.GatewayUsers;
   import spark.events.PopUpEvent;
   
   class SimpleDeleteFeature extends EventDispatcher implements IUserEditFeature
   {
       
      
      private var _toggleEditCallback:Function;
      
      private var _loadUsersCallback:Function;
      
      function SimpleDeleteFeature()
      {
         super();
      }
      
      public function set toggleEditCallback(param1:Function) : void
      {
         this._toggleEditCallback = param1;
      }
      
      public function set loadUsersCallback(param1:Function) : void
      {
         this._loadUsersCallback = param1;
      }
      
      public function getIcon() : IVisualElement
      {
         return new ImgDelete();
      }
      
      public function onClick(param1:Event, param2:User) : void
      {
         var _loc3_:ConfirmBox = null;
         var _loc4_:ErrorBox = null;
         if(param2.id > 0)
         {
            _loc3_ = ConfirmBox.sharedBox;
            _loc3_.title = Lang.getString("CONFIRM_DELETE_USER");
            _loc3_.contentText = Lang.getString("CONFIRM_DELETE_USER_CONTENT");
            _loc3_.submitTitle = Lang.getString("GENERAL_YES");
            _loc3_.cancelTitle = Lang.getString("GENERAL_NO");
            _loc3_.data = param2;
            _loc3_.addEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
            _loc3_.open(null);
         }
         else
         {
            _loc4_ = ErrorBox.sharedBox;
            _loc4_.title = Lang.getString("ERROR_DELETE_ADMIN");
            _loc4_.contentText = Lang.getString("ERROR_DELETE_ADMIN_CONTENT");
            _loc4_.closeable = true;
            _loc4_.closeTitle = Lang.getString("GENERAL_SUBMIT");
            _loc4_.open(null);
         }
      }
      
      private function onDeleteCommit(param1:PopUpEvent) : void
      {
         var event:PopUpEvent = param1;
         var confirmBox:ConfirmBox = ConfirmBox.sharedBox;
         confirmBox.removeEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
         this._toggleEditCallback.call();
         if(!event.commit)
         {
            return;
         }
         if(!event.data)
         {
            return;
         }
         GatewayUsers.instance.deleteUser(event.data,function(param1:User, param2:Error):void
         {
            if(param2 == null)
            {
               _loadUsersCallback();
            }
         });
      }
   }
}
