package mx.core
{
   import flash.display.InteractiveObject;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerContainer;
   
   public class ContainerGlobals
   {
      
      public static var focusedContainer:InteractiveObject;
       
      
      public function ContainerGlobals()
      {
         super();
      }
      
      public static function checkFocus(param1:InteractiveObject, param2:InteractiveObject) : void
      {
         var _loc6_:IFocusManager = null;
         var _loc7_:IButton = null;
         var _loc3_:InteractiveObject = param2;
         var _loc4_:InteractiveObject = param2;
         var _loc5_:IUIComponent = null;
         if(param2 != null && param1 == param2)
         {
            return;
         }
         while(_loc4_)
         {
            if(_loc4_.parent)
            {
               _loc3_ = _loc4_.parent;
            }
            else
            {
               _loc3_ = null;
            }
            if(_loc4_ is IUIComponent)
            {
               _loc5_ = IUIComponent(_loc4_);
            }
            _loc4_ = _loc3_;
            if(_loc4_ && _loc4_ is IFocusManagerContainer && IFocusManagerContainer(_loc4_).defaultButton)
            {
               break;
            }
         }
         if(ContainerGlobals.focusedContainer != _loc4_ || ContainerGlobals.focusedContainer == null && _loc4_ == null)
         {
            if(!_loc4_)
            {
               _loc4_ = InteractiveObject(_loc5_);
            }
            if(_loc4_ && _loc4_ is IFocusManagerContainer)
            {
               _loc6_ = IFocusManagerContainer(_loc4_).focusManager;
               if(!_loc6_)
               {
                  return;
               }
               _loc7_ = IFocusManagerContainer(_loc4_).defaultButton as IButton;
               if(_loc7_)
               {
                  ContainerGlobals.focusedContainer = InteractiveObject(_loc4_);
                  _loc6_.defaultButton = _loc7_ as IButton;
               }
               else
               {
                  ContainerGlobals.focusedContainer = InteractiveObject(_loc4_);
                  _loc6_.defaultButton = null;
               }
            }
         }
      }
   }
}
