package refactor.bisecur._1_APP.views.viewActions.forward
{
   import refactor.bisecur._1_APP.views.viewActions.ViewActionBase;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.View;
   
   public class ForwardViewAction extends ViewActionBase
   {
       
      
      private var _viewPath:Vector.<ForwardViewActionItem>;
      
      public function ForwardViewAction()
      {
         super();
      }
      
      public function get isComplete() : *
      {
         return this._viewPath.length <= 0;
      }
      
      public function followPath(param1:Vector.<ForwardViewActionItem>) : ForwardViewAction
      {
         this._viewPath = param1;
         return this;
      }
      
      override public function execute(param1:View) : Boolean
      {
         var _loc2_:ForwardViewActionItem = this._viewPath.shift();
         if(_loc2_ == null)
         {
            return true;
         }
         var _loc3_:ForwardViewAction = null;
         if(!this.isComplete)
         {
            _loc3_ = this;
         }
         switch(_loc2_.forwardAction)
         {
            case ForwardViewActionItem.FORWARD_ACTION_PUSH:
               param1.navigator.pushView(_loc2_.destinationView,_loc3_);
               break;
            case ForwardViewActionItem.FORWARD_ACTION_REPLACE:
               param1.navigator.replaceView(_loc2_.destinationView,_loc3_);
               break;
            default:
               Log.error("ForwardAction not found! \'" + _loc2_.forwardAction + "\'");
         }
         return this.isComplete;
      }
   }
}
