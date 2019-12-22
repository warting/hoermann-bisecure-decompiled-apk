package spark.components.supportClasses
{
   import mx.core.ContainerGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.mx_internal;
   import mx.managers.IFocusManagerContainer;
   
   use namespace mx_internal;
   
   public class SkinnableContainerBase extends SkinnableComponent implements IFocusManagerContainer
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var _defaultButton:IFlexDisplayObject;
      
      public function SkinnableContainerBase()
      {
         super();
      }
      
      public function get defaultButton() : IFlexDisplayObject
      {
         return this._defaultButton;
      }
      
      public function set defaultButton(param1:IFlexDisplayObject) : void
      {
         this._defaultButton = param1;
         ContainerGlobals.focusedContainer = null;
      }
      
      override protected function getCurrentSkinState() : String
      {
         return !!enabled?"normal":"disabled";
      }
   }
}
