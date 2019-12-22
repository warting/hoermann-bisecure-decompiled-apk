package flashx.textLayout.elements
{
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.IListMarkerFormat;
   import flashx.textLayout.tlf_internal;
   
   public final class ListItemElement extends ContainerFormattedElement
   {
       
      
      tlf_internal var _listNumberHint:int = 2147483647;
      
      public function ListItemElement()
      {
         super();
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "li";
      }
      
      tlf_internal function computedListMarkerFormat() : IListMarkerFormat
      {
         var _loc2_:TextFlow = null;
         var _loc1_:IListMarkerFormat = this.getUserStyleWorker(ListElement.LIST_MARKER_FORMAT_NAME) as IListMarkerFormat;
         if(_loc1_ == null)
         {
            _loc2_ = this.getTextFlow();
            if(_loc2_)
            {
               _loc1_ = _loc2_.configuration.defaultListMarkerFormat;
            }
         }
         return _loc1_;
      }
      
      tlf_internal function normalizeNeedsInitialParagraph() : Boolean
      {
         var _loc1_:FlowGroupElement = this;
         while(_loc1_)
         {
            _loc1_ = _loc1_.getChildAt(0) as FlowGroupElement;
            if(_loc1_ is ParagraphElement)
            {
               return false;
            }
            if(!(_loc1_ is DivElement))
            {
               return true;
            }
         }
         return true;
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
         var _loc3_:ParagraphElement = null;
         super.normalizeRange(param1,param2);
         this._listNumberHint = int.MAX_VALUE;
         if(this.normalizeNeedsInitialParagraph())
         {
            _loc3_ = new ParagraphElement();
            _loc3_.replaceChildren(0,0,new SpanElement());
            replaceChildren(0,0,_loc3_);
            _loc3_.normalizeRange(0,_loc3_.textLength);
         }
      }
      
      tlf_internal function getListItemNumber(param1:IListMarkerFormat = null) : int
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:ListItemElement = null;
         if(this._listNumberHint == int.MAX_VALUE)
         {
            if(param1 == null)
            {
               param1 = this.computedListMarkerFormat();
            }
            _loc2_ = param1.counterReset;
            if(_loc2_ && _loc2_.hasOwnProperty("ordered"))
            {
               this._listNumberHint = _loc2_.ordered;
            }
            else
            {
               _loc4_ = parent.getChildIndex(this);
               this._listNumberHint = 0;
               while(_loc4_ > 0)
               {
                  _loc4_--;
                  _loc5_ = parent.getChildAt(_loc4_) as ListItemElement;
                  if(_loc5_)
                  {
                     this._listNumberHint = _loc5_.getListItemNumber();
                     break;
                  }
               }
            }
            _loc3_ = param1.counterIncrement;
            this._listNumberHint = this._listNumberHint + (_loc3_ && _loc3_.hasOwnProperty("ordered")?_loc3_.ordered:1);
         }
         return this._listNumberHint;
      }
      
      override tlf_internal function getEffectivePaddingLeft() : Number
      {
         if(getTextFlow().computedFormat.blockProgression == BlockProgression.TB)
         {
            if(computedFormat.paddingLeft == FormatValue.AUTO)
            {
               if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
               {
                  return computedFormat.listMarkerFormat.paragraphStartIndent;
               }
               return 0;
            }
            if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
            {
               return computedFormat.paddingLeft + computedFormat.listMarkerFormat.paragraphStartIndent;
            }
            return computedFormat.paddingLeft;
         }
         return 0;
      }
      
      override tlf_internal function getEffectivePaddingTop() : Number
      {
         if(getTextFlow().computedFormat.blockProgression == BlockProgression.RL)
         {
            if(computedFormat.paddingTop == FormatValue.AUTO)
            {
               if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
               {
                  return computedFormat.listMarkerFormat.paragraphStartIndent;
               }
               return 0;
            }
            if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
            {
               return computedFormat.paddingTop + computedFormat.listMarkerFormat.paragraphStartIndent;
            }
            return computedFormat.paddingTop;
         }
         return 0;
      }
      
      override tlf_internal function getEffectivePaddingRight() : Number
      {
         if(getTextFlow().computedFormat.blockProgression == BlockProgression.TB)
         {
            if(computedFormat.paddingRight == FormatValue.AUTO)
            {
               if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
               {
                  return computedFormat.listMarkerFormat.paragraphStartIndent;
               }
               return 0;
            }
            if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
            {
               return computedFormat.paddingRight + computedFormat.listMarkerFormat.paragraphStartIndent;
            }
            return computedFormat.paddingRight;
         }
         return 0;
      }
      
      override tlf_internal function getEffectivePaddingBottom() : Number
      {
         if(getTextFlow().computedFormat.blockProgression == BlockProgression.RL)
         {
            if(computedFormat.paddingBottom == FormatValue.AUTO)
            {
               if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
               {
                  return computedFormat.listMarkerFormat.paragraphStartIndent;
               }
               return 0;
            }
            if(computedFormat.listMarkerFormat !== undefined && computedFormat.listMarkerFormat.paragraphStartIndent !== undefined)
            {
               return computedFormat.paddingBottom + computedFormat.listMarkerFormat.paragraphStartIndent;
            }
            return computedFormat.paddingBottom;
         }
         return 0;
      }
   }
}
