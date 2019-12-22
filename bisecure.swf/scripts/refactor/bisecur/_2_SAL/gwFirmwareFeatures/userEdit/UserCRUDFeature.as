package refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit_White;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.users.EditUserBox;
   import refactor.bisecur._2_SAL.gatewayData.User;
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
      
      public function onClick(param1:Event, param2:User) : void
      {
         var _loc3_:EditUserBox = null;
         var _loc4_:ErrorBox = null;
         if(param2.id > 0)
         {
            _loc3_ = new EditUserBox();
            _loc3_.user = param2;
            _loc3_.addEventListener(PopUpEvent.CLOSE,this.onClose);
            _loc3_.open(null);
         }
         else
         {
            _loc4_ = ErrorBox.sharedBox;
            _loc4_.title = Lang.getString("ERROR_EDIT_ADMIN");
            _loc4_.contentText = Lang.getString("ERROR_EDIT_ADMIN_CONTENT");
            _loc4_.closeable = true;
            _loc4_.closeTitle = Lang.getString("GENERAL_SUBMIT");
            _loc4_.open(null);
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
