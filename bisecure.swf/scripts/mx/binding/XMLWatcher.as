package mx.binding
{
   import mx.core.mx_internal;
   import mx.utils.IXMLNotifiable;
   import mx.utils.XMLNotifier;
   
   use namespace mx_internal;
   
   public class XMLWatcher extends Watcher implements IXMLNotifiable
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var parentObj:Object;
      
      private var _propertyName:String;
      
      public function XMLWatcher(param1:String, param2:Array)
      {
         super(param2);
         this._propertyName = param1;
      }
      
      public function get propertyName() : String
      {
         return this._propertyName;
      }
      
      override public function updateParent(param1:Object) : void
      {
         if(this.parentObj && (this.parentObj is XML || this.parentObj is XMLList))
         {
            XMLNotifier.getInstance().unwatchXML(this.parentObj,this);
         }
         if(param1 is Watcher)
         {
            this.parentObj = param1.value;
         }
         else
         {
            this.parentObj = param1;
         }
         if(this.parentObj && (this.parentObj is XML || this.parentObj is XMLList))
         {
            XMLNotifier.getInstance().watchXML(this.parentObj,this);
         }
         wrapUpdate(this.updateProperty);
      }
      
      override protected function shallowClone() : Watcher
      {
         return new XMLWatcher(this._propertyName,listeners);
      }
      
      private function updateProperty() : void
      {
         if(this.parentObj)
         {
            if(this._propertyName == "this")
            {
               value = this.parentObj;
            }
            else
            {
               value = this.parentObj[this._propertyName];
            }
         }
         else
         {
            value = null;
         }
         updateChildren();
      }
      
      public function xmlNotification(param1:Object, param2:String, param3:Object, param4:Object, param5:Object) : void
      {
         this.updateProperty();
         notifyListeners(true);
      }
   }
}
