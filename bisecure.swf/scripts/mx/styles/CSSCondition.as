package mx.styles
{
   import mx.utils.StringUtil;
   
   public class CSSCondition
   {
       
      
      private var _kind:String;
      
      private var _value:String;
      
      public function CSSCondition(param1:String, param2:String)
      {
         super();
         this._kind = param1;
         this._value = param2;
      }
      
      public function get kind() : String
      {
         return this._kind;
      }
      
      public function get specificity() : int
      {
         if(this.kind == CSSConditionKind.ID)
         {
            return 100;
         }
         if(this.kind == CSSConditionKind.CLASS)
         {
            return 10;
         }
         if(this.kind == CSSConditionKind.PSEUDO)
         {
            return 10;
         }
         return 0;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function matchesStyleClient(param1:IAdvancedStyleClient) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.kind == CSSConditionKind.CLASS)
         {
            _loc2_ = param1.styleName as String;
            if(!_loc2_)
            {
               return false;
            }
            _loc3_ = _loc2_.indexOf(this.value);
            while(_loc3_ != -1)
            {
               _loc4_ = _loc3_ + this.value.length;
               if(_loc3_ == 0 || StringUtil.isWhitespace(_loc2_.charAt(_loc3_ - 1)))
               {
                  if(_loc4_ == _loc2_.length || StringUtil.isWhitespace(_loc2_.charAt(_loc4_)))
                  {
                     return true;
                  }
               }
               _loc3_ = _loc2_.indexOf(this.value,_loc4_);
            }
            return false;
         }
         if(this.kind == CSSConditionKind.ID)
         {
            return param1.id == this.value;
         }
         if(this.kind == CSSConditionKind.PSEUDO)
         {
            return param1.matchesCSSState(this.value);
         }
         return false;
      }
      
      public function toString() : String
      {
         var _loc1_:String = null;
         if(this.kind == CSSConditionKind.CLASS)
         {
            _loc1_ = "." + this.value;
         }
         else if(this.kind == CSSConditionKind.ID)
         {
            _loc1_ = "#" + this.value;
         }
         else if(this.kind == CSSConditionKind.PSEUDO)
         {
            _loc1_ = ":" + this.value;
         }
         else
         {
            _loc1_ = "";
         }
         return _loc1_;
      }
   }
}
