package flashx.textLayout.elements
{
   import flash.display.Sprite;
   
   public class CellContainer extends Sprite
   {
       
      
      private var _imeMode:String;
      
      private var _enableIME:Boolean;
      
      public var element:TableCellElement;
      
      public function CellContainer(param1:Boolean = true)
      {
         super();
         this._enableIME = param1;
      }
      
      public function get enableIME() : Boolean
      {
         return false;
      }
      
      public function set enableIME(param1:Boolean) : void
      {
         this._enableIME = param1;
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         this._imeMode = param1;
      }
   }
}
