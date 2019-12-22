package com.isisic.remote.hoermann.components
{
   import avmplus.getQualifiedClassName;
   import com.isisic.remote.hoermann.global.UserDataStorage;
   import mx.core.mx_internal;
   import spark.components.ViewNavigator;
   import spark.components.supportClasses.ViewDescriptor;
   import spark.transitions.ViewTransitionBase;
   
   use namespace mx_internal;
   
   public class BiSecurViewNavigator extends ViewNavigator
   {
       
      
      public function BiSecurViewNavigator()
      {
         super();
      }
      
      override public function popAll(param1:ViewTransitionBase = null) : void
      {
         var _loc2_:ViewDescriptor = null;
         for each(_loc2_ in navigationStack.source)
         {
            UserDataStorage.currentStorage.viewClosed(getQualifiedClassName(_loc2_.viewClass));
         }
         super.popAll(param1);
      }
      
      override public function popView(param1:ViewTransitionBase = null) : void
      {
         UserDataStorage.currentStorage.viewClosed(getQualifiedClassName(activeView));
         if(navigationStack.source.length > 1)
         {
            UserDataStorage.currentStorage.viewOpened(getQualifiedClassName(navigationStack.source[navigationStack.source.length - 2].viewClass));
         }
         super.popView(param1);
      }
      
      override public function popToFirstView(param1:ViewTransitionBase = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < navigationStack.source.length - 1)
         {
            if(_loc2_ != 0)
            {
               UserDataStorage.currentStorage.viewClosed(getQualifiedClassName(navigationStack.source[_loc2_].viewClass));
            }
            _loc2_++;
         }
         UserDataStorage.currentStorage.viewOpened(getQualifiedClassName(navigationStack.source[0].viewClass));
         super.popToFirstView(param1);
      }
      
      override public function pushView(param1:Class, param2:Object = null, param3:Object = null, param4:ViewTransitionBase = null) : void
      {
         UserDataStorage.currentStorage.viewClosed(getQualifiedClassName(navigationStack.topView.viewClass));
         UserDataStorage.currentStorage.viewOpened(getQualifiedClassName(param1));
         super.pushView(param1,param2,param3,param4);
      }
      
      override public function replaceView(param1:Class, param2:Object = null, param3:Object = null, param4:ViewTransitionBase = null) : void
      {
         UserDataStorage.currentStorage.viewClosed(getQualifiedClassName(navigationStack.topView.viewClass));
         UserDataStorage.currentStorage.viewOpened(getQualifiedClassName(param1));
         super.replaceView(param1,param2,param3,param4);
      }
   }
}
