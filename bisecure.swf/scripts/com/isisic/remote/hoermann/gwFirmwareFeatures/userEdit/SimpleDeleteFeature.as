package com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgDelete;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import com.isisic.remote.hoermann.net.dao.users.GatewayUsers;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.IVisualElement;
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
      
      public function onClick(param1:Event) : void
      {
         if(param1.target.data.id > 0)
         {
            HoermannRemote.confirmBox.title = Lang.getString("CONFIRM_DELETE_USER");
            HoermannRemote.confirmBox.contentText = Lang.getString("CONFIRM_DELETE_USER_CONTENT");
            HoermannRemote.confirmBox.submitTitle = Lang.getString("GENERAL_YES");
            HoermannRemote.confirmBox.cancelTitle = Lang.getString("GENERAL_NO");
            HoermannRemote.confirmBox.data = param1.target.data;
            HoermannRemote.confirmBox.addEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
            HoermannRemote.confirmBox.open(null);
         }
         else
         {
            HoermannRemote.errorBox.title = Lang.getString("ERROR_DELETE_ADMIN");
            HoermannRemote.errorBox.contentText = Lang.getString("ERROR_DELETE_ADMIN_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
         }
      }
      
      private function onDeleteCommit(param1:PopUpEvent) : void
      {
         var event:PopUpEvent = param1;
         HoermannRemote.confirmBox.removeEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
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
