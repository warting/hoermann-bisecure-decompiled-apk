package com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit_White;
   import com.isisic.remote.hoermann.components.popups.users.EditUserBox;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import mx.core.IVisualElement;
   import spark.events.PopUpEvent;
   
   public class UserCRUDFeature implements IUserEditFeature
   {
       
      
      private var _toggleEditCallback:Function;
      
      private var _loadUsersCallback:Function;
      
      public function UserCRUDFeature()
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
         return new ImgEdit_White();
      }
      
      public function onClick(param1:Event) : void
      {
         var _loc2_:EditUserBox = null;
         if(param1.target.data.id > 0)
         {
            _loc2_ = new EditUserBox();
            _loc2_.user = param1.target.data;
            _loc2_.addEventListener(PopUpEvent.CLOSE,this.onClose);
            _loc2_.open(null);
         }
         else
         {
            HoermannRemote.errorBox.title = Lang.getString("ERROR_EDIT_ADMIN");
            HoermannRemote.errorBox.contentText = Lang.getString("ERROR_EDIT_ADMIN_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
         }
      }
      
      private function onClose(param1:PopUpEvent) : void
      {
         param1.target.removeEventListener(PopUpEvent.CLOSE,this.onClose);
         this._toggleEditCallback();
         if(!param1.commit)
         {
            return;
         }
         this._loadUsersCallback();
      }
   }
}
