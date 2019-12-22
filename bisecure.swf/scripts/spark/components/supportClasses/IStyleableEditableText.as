package spark.components.supportClasses
{
   import mx.core.IUIComponent;
   import spark.core.IEditableText;
   
   public interface IStyleableEditableText extends IEditableText, IUIComponent
   {
       
      
      function set styleName(param1:Object) : void;
      
      function commitStyles() : void;
   }
}
