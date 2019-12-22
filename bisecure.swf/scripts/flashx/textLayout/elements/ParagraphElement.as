package flashx.textLayout.elements
{
   import flash.text.engine.ContentElement;
   import flash.text.engine.EastAsianJustifier;
   import flash.text.engine.GroupElement;
   import flash.text.engine.LineJustification;
   import flash.text.engine.SpaceJustifier;
   import flash.text.engine.TabAlignment;
   import flash.text.engine.TabStop;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.text.engine.TextRotation;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.JustificationRule;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextJustify;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.CharacterUtil;
   import flashx.textLayout.utils.LocaleUtil;
   
   use namespace tlf_internal;
   
   public final class ParagraphElement extends ParagraphFormattedElement
   {
      
      private static var _defaultTabStops:Vector.<TabStop>;
      
      private static const defaultTabWidth:int = 48;
      
      private static const defaultTabCount:int = 20;
       
      
      private var _terminatorSpan:SpanElement;
      
      private var _interactiveChildrenCount:int;
      
      private var _textBlocks:Vector.<TextBlock>;
      
      public function ParagraphElement()
      {
         super();
         this._terminatorSpan = null;
         this._interactiveChildrenCount = 0;
      }
      
      private static function initializeDefaultTabStops() : void
      {
         _defaultTabStops = new Vector.<TabStop>(defaultTabCount,true);
         var _loc1_:int = 0;
         while(_loc1_ < defaultTabCount)
         {
            _defaultTabStops[_loc1_] = new TabStop(TextAlign.START,defaultTabWidth * _loc1_);
            _loc1_++;
         }
      }
      
      tlf_internal static function getLeadingBasis(param1:String) : String
      {
         switch(param1)
         {
            default:
            case LeadingModel.ASCENT_DESCENT_UP:
            case LeadingModel.APPROXIMATE_TEXT_FIELD:
            case LeadingModel.BOX:
            case LeadingModel.ROMAN_UP:
               return TextBaseline.ROMAN;
            case LeadingModel.IDEOGRAPHIC_TOP_UP:
            case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
               return TextBaseline.IDEOGRAPHIC_TOP;
            case LeadingModel.IDEOGRAPHIC_CENTER_UP:
            case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
               return TextBaseline.IDEOGRAPHIC_CENTER;
         }
      }
      
      tlf_internal static function useUpLeadingDirection(param1:String) : Boolean
      {
         switch(param1)
         {
            default:
            case LeadingModel.ASCENT_DESCENT_UP:
            case LeadingModel.APPROXIMATE_TEXT_FIELD:
            case LeadingModel.BOX:
            case LeadingModel.ROMAN_UP:
            case LeadingModel.IDEOGRAPHIC_TOP_UP:
            case LeadingModel.IDEOGRAPHIC_CENTER_UP:
               return true;
            case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
            case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
               return false;
         }
      }
      
      tlf_internal function get interactiveChildrenCount() : int
      {
         return this._interactiveChildrenCount;
      }
      
      tlf_internal function createTextBlock() : void
      {
         var _loc4_:TextBlock = null;
         var _loc5_:FlowElement = null;
         this.computedFormat;
         var _loc1_:Vector.<TextBlock> = this.getTextBlocks();
         var _loc2_:int = 0;
         if(_loc1_.length == 0 && !(getChildAt(0) is TableElement))
         {
            _loc1_.push(new TextBlock());
         }
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc5_ = getChildAt(_loc3_);
            if(_loc5_ is TableElement)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         while(_loc2_ >= _loc1_.length)
         {
            _loc1_.push(new TextBlock());
         }
         _loc3_ = 0;
         while(_loc3_ < numChildren)
         {
            _loc5_ = getChildAt(_loc3_);
            _loc5_.createContentElement();
            _loc3_++;
         }
         _loc1_.length = _loc2_ + 1;
         for each(_loc4_ in _loc1_)
         {
            this.updateTextBlock(_loc4_);
         }
      }
      
      private function updateTextBlockRefs() : void
      {
         var _loc5_:FlowElement = null;
         var _loc1_:Vector.<TextBlock> = this.getTextBlocks();
         if(_loc1_.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:TextBlock = _loc1_[_loc2_];
         var _loc4_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < numChildren)
         {
            _loc5_ = getChildAt(_loc6_);
            if(_loc5_ is TableElement)
            {
               _loc3_.userData = _loc4_;
               if(++_loc2_ == _loc1_.length)
               {
                  return;
               }
               _loc3_ = _loc1_[_loc2_];
               _loc3_.userData = null;
               if(++_loc2_ == _loc1_.length)
               {
                  return;
               }
               _loc3_ = _loc1_[_loc2_];
               _loc4_ = [];
            }
            else
            {
               _loc4_.push(_loc5_);
            }
            _loc6_++;
         }
         _loc3_.userData = _loc4_;
      }
      
      private function removeTextBlock(param1:TextBlock) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<TextBlock> = this.getTextBlocks();
         if(_loc2_)
         {
            _loc3_ = this.getTextBlocks().indexOf(param1);
            if(_loc3_ > -1)
            {
               _loc2_.splice(_loc3_,1);
            }
         }
      }
      
      private function releaseTextBlockInternal(param1:TextBlock) : void
      {
         var _loc3_:TextLine = null;
         var _loc4_:TextFlowLine = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FlowElement = null;
         if(!param1)
         {
            return;
         }
         if(param1.firstLine)
         {
            _loc3_ = param1.firstLine;
            while(_loc3_ != null)
            {
               if(_loc3_.numChildren != 0)
               {
                  _loc4_ = _loc3_.userData as TextFlowLine;
                  if(_loc4_.adornCount != _loc3_.numChildren)
                  {
                     return;
                  }
               }
               _loc3_ = _loc3_.nextLine;
            }
            param1.releaseLines(param1.firstLine,param1.lastLine);
         }
         var _loc2_:Array = param1.userData;
         if(_loc2_)
         {
            _loc5_ = _loc2_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc2_[_loc6_];
               _loc7_.releaseContentElement();
               _loc6_++;
            }
            _loc2_.length = 0;
         }
         param1.content = null;
         this.removeTextBlock(param1);
      }
      
      tlf_internal function releaseTextBlock(param1:TextBlock = null) : void
      {
         var _loc3_:TextBlock = null;
         this.updateTextBlockRefs();
         if(param1)
         {
            this.releaseTextBlockInternal(param1);
            return;
         }
         var _loc2_:Vector.<TextBlock> = this.getTextBlocks();
         for each(_loc3_ in _loc2_)
         {
            this.releaseTextBlockInternal(_loc3_);
         }
         if(_computedFormat)
         {
            _computedFormat = null;
         }
      }
      
      tlf_internal function getTextBlocks() : Vector.<TextBlock>
      {
         if(this._textBlocks == null)
         {
            this._textBlocks = new Vector.<TextBlock>();
         }
         return this._textBlocks;
      }
      
      tlf_internal function getTextBlock() : TextBlock
      {
         if(!this.getTextBlocks().length)
         {
            this.createTextBlock();
         }
         return this.getTextBlocks()[0];
      }
      
      tlf_internal function getLastTextBlock() : TextBlock
      {
         var _loc1_:Vector.<TextBlock> = this.getTextBlocks();
         if(!_loc1_.length)
         {
            this.createTextBlock();
         }
         return _loc1_[_loc1_.length - 1];
      }
      
      tlf_internal function getTextBlockAtPosition(param1:int) : TextBlock
      {
         var _loc5_:TableElement = null;
         var _loc6_:Vector.<TextBlock> = null;
         var _loc7_:TextBlock = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TableElement> = this.getTables();
         if(!_loc4_.length)
         {
            return this.getTextBlock();
         }
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.getElementRelativeStart(this) < param1)
            {
               _loc3_++;
            }
         }
         _loc6_ = this.getTextBlocks();
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.content == null)
            {
               return _loc7_;
            }
            _loc2_ = _loc2_ + _loc7_.content.rawText.length;
            if(_loc2_ + _loc3_ > param1)
            {
               if(this.getTextBlockStart(_loc7_) > param1)
               {
                  return null;
               }
               return _loc7_;
            }
         }
         return null;
      }
      
      tlf_internal function getTextBlockAbsoluteStart(param1:TextBlock) : int
      {
         var _loc2_:int = this.getTextBlockStart(param1);
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         return getAbsoluteStart() + _loc2_;
      }
      
      tlf_internal function getTextBlockStart(param1:TextBlock) : int
      {
         var _loc2_:int = 0;
         var _loc6_:TextBlock = null;
         var _loc7_:TableElement = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TextBlock> = this.getTextBlocks();
         if(_loc4_.length == 0)
         {
            return -1;
         }
         var _loc5_:Vector.<TableElement> = this.getTables();
         for each(_loc6_ in _loc4_)
         {
            for each(_loc7_ in _loc5_)
            {
               if(_loc7_.getElementRelativeStart(this) <= _loc3_)
               {
                  _loc3_++;
                  _loc5_.splice(_loc5_.indexOf(_loc7_),1);
               }
            }
            if(param1 == _loc6_)
            {
               return _loc3_;
            }
            if(param1.content)
            {
               _loc3_ = _loc3_ + _loc6_.content.rawText.length;
            }
         }
         return -1;
      }
      
      private function getTables() : Vector.<TableElement>
      {
         var _loc3_:FlowElement = null;
         var _loc1_:Vector.<TableElement> = new Vector.<TableElement>();
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is TableElement)
            {
               _loc1_.push(_loc3_ as TableElement);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      tlf_internal function peekTextBlock() : TextBlock
      {
         return this.getTextBlocks().length == 0?null:this.getTextBlocks()[0];
      }
      
      tlf_internal function releaseLineCreationData() : void
      {
         var _loc2_:TextBlock = null;
         var _loc1_:Vector.<TextBlock> = this.getTextBlocks();
         for each(_loc2_ in _loc1_)
         {
            _loc2_["releaseLineCreationData"]();
         }
      }
      
      override tlf_internal function createContentAsGroup(param1:int = 0) : GroupElement
      {
         var _loc4_:ContentElement = null;
         var _loc5_:Vector.<ContentElement> = null;
         var _loc6_:TextFlow = null;
         var _loc2_:TextBlock = this.getTextBlockAtPosition(param1);
         if(!_loc2_)
         {
            _loc2_ = this.getTextBlockAtPosition(param1 - 1);
         }
         var _loc3_:GroupElement = _loc2_.content as GroupElement;
         if(!_loc3_)
         {
            _loc4_ = _loc2_.content;
            _loc3_ = new GroupElement();
            _loc2_.content = _loc3_;
            if(_loc4_)
            {
               _loc5_ = new Vector.<ContentElement>();
               _loc5_.push(_loc4_);
               _loc3_.replaceElements(0,0,_loc5_);
            }
            if(_loc2_.firstLine && textLength)
            {
               _loc6_ = getTextFlow();
               if(_loc6_)
               {
                  _loc6_.damage(getAbsoluteStart(),textLength,TextLineValidity.INVALID,false);
               }
            }
         }
         return _loc3_;
      }
      
      override tlf_internal function removeBlockElement(param1:FlowElement, param2:ContentElement) : void
      {
         var _loc5_:int = 0;
         var _loc6_:GroupElement = null;
         var _loc7_:ContentElement = null;
         var _loc3_:TextBlock = this.getTextBlockAtPosition(param1.getElementRelativeStart(this));
         if(!_loc3_)
         {
            _loc3_ = this.getTextBlock();
         }
         if(_loc3_.content == null)
         {
            return;
         }
         var _loc4_:int = param1.getElementRelativeStart(this);
         if(this.getChildrenInTextBlock(_loc4_).length < 2)
         {
            if(param2 is GroupElement)
            {
               GroupElement(_loc3_.content).replaceElements(0,1,null);
            }
            _loc3_.content = null;
         }
         else if(param2.groupElement)
         {
            _loc5_ = this.getChildIndexInBlock(param1);
            _loc6_ = GroupElement(_loc3_.content);
            _loc6_.replaceElements(_loc5_,_loc5_ + 1,null);
            if(_loc6_.elementCount == 0)
            {
               return;
            }
            if(numChildren == 2)
            {
               _loc7_ = _loc6_.getElementAt(0);
               if(!(_loc7_ is GroupElement))
               {
                  _loc6_.replaceElements(0,1,null);
                  _loc3_.content = _loc7_;
               }
            }
         }
      }
      
      override tlf_internal function hasBlockElement() : Boolean
      {
         return this.getTextBlocks().length > 0;
      }
      
      override tlf_internal function createContentElement() : void
      {
         this.createTextBlock();
      }
      
      private function getChildrenInTextBlock(param1:int) : Array
      {
         var _loc2_:Array = [];
         if(numChildren == 0)
         {
            return _loc2_;
         }
         if(numChildren == 1)
         {
            _loc2_.push(getChildAt(0));
            return _loc2_;
         }
         var _loc3_:Array = mxmlChildren.slice();
         var _loc4_:int = 0;
         for(; _loc4_ < _loc3_.length; _loc4_++)
         {
            if(_loc3_[_loc4_] is TableElement)
            {
               if(_loc3_[_loc4_].parentRelativeStart < param1)
               {
                  _loc2_.length = 0;
                  continue;
               }
               if(_loc3_[_loc4_].parentRelativeStart >= param1)
               {
                  break;
               }
            }
            _loc2_.push(_loc3_[_loc4_]);
         }
         return _loc2_;
      }
      
      override tlf_internal function insertBlockElement(param1:FlowElement, param2:ContentElement) : void
      {
         var _loc5_:Vector.<ContentElement> = null;
         var _loc6_:GroupElement = null;
         var _loc7_:int = 0;
         var _loc3_:int = param1.getElementRelativeStart(this);
         var _loc4_:TextBlock = this.getTextBlockAtPosition(_loc3_);
         if(!_loc4_)
         {
            _loc4_ = this.getTextBlockAtPosition(_loc3_ - 1);
         }
         if(!_loc4_)
         {
            param1.releaseContentElement();
            return;
         }
         if(this.getTextBlocks().length == 0)
         {
            param1.releaseContentElement();
            this.createTextBlock();
            return;
         }
         if(this.getChildrenInTextBlock(_loc3_).length < 2)
         {
            if(param2 is GroupElement)
            {
               _loc5_ = new Vector.<ContentElement>();
               _loc5_.push(param2);
               _loc6_ = new GroupElement(_loc5_);
               _loc4_.content = _loc6_;
            }
            else
            {
               if(param2.groupElement)
               {
                  param2.groupElement.elementCount;
               }
               _loc4_.content = param2;
            }
         }
         else
         {
            _loc6_ = this.createContentAsGroup(_loc3_);
            _loc7_ = this.getChildIndexInBlock(param1);
            _loc5_ = new Vector.<ContentElement>();
            _loc5_.push(param2);
            if(_loc7_ > _loc6_.elementCount)
            {
               _loc7_ = _loc6_.elementCount;
            }
            _loc6_.replaceElements(_loc7_,_loc7_,_loc5_);
         }
      }
      
      private function getChildIndexInBlock(param1:FlowElement) : int
      {
         var _loc4_:FlowElement = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            if(_loc4_ == param1)
            {
               return _loc2_;
            }
            _loc2_++;
            if(_loc4_ is TableElement)
            {
               _loc2_ = 0;
            }
            _loc3_++;
         }
         return -1;
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "p";
      }
      
      tlf_internal function removeEmptyTerminator() : void
      {
         if(numChildren == 1 && this._terminatorSpan && this._terminatorSpan.textLength == 1)
         {
            this._terminatorSpan.removeParaTerminator();
            super.replaceChildren(0,1);
            this._terminatorSpan = null;
         }
      }
      
      override public function replaceChildren(param1:int, param2:int, ... rest) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         do
         {
            if(this._terminatorSpan)
            {
               _loc5_ = getChildIndex(this._terminatorSpan);
               if(_loc5_ > 0 && _loc5_ < param1 && this._terminatorSpan.textLength == 1)
               {
                  super.replaceChildren(_loc5_,_loc5_ + 1);
                  this._terminatorSpan = null;
                  if(param1 >= _loc5_)
                  {
                     param1--;
                     if(rest.length == 0)
                     {
                        break;
                     }
                  }
                  if(param2 >= _loc5_ && param1 != param2)
                  {
                     param2--;
                  }
               }
            }
            if(rest.length == 1)
            {
               _loc4_ = [param1,param2,rest[0]];
            }
            else
            {
               _loc4_ = [param1,param2];
               if(rest.length != 0)
               {
                  _loc4_ = _loc4_.concat.apply(_loc4_,rest);
               }
            }
            super.replaceChildren.apply(this,_loc4_);
         }
         while(false);
         
         this.ensureTerminatorAfterReplace();
         this.createTextBlock();
      }
      
      override public function splitAtPosition(param1:int) : FlowElement
      {
         return super.splitAtPosition(param1);
      }
      
      tlf_internal function ensureTerminatorAfterReplace() : void
      {
         var _loc2_:int = 0;
         var _loc3_:SpanElement = null;
         var _loc4_:FlowLeafElement = null;
         if(this._terminatorSpan && this._terminatorSpan.parent != this)
         {
            this._terminatorSpan.removeParaTerminator();
            this._terminatorSpan = null;
         }
         var _loc1_:FlowLeafElement = getLastLeaf();
         if(this._terminatorSpan != _loc1_)
         {
            if(this._terminatorSpan)
            {
               this._terminatorSpan.removeParaTerminator();
            }
            if(_loc1_ && this._terminatorSpan)
            {
               if(this._terminatorSpan.textLength == 0 && !this._terminatorSpan.id)
               {
                  _loc2_ = getChildIndex(this._terminatorSpan);
                  super.replaceChildren(_loc2_,_loc2_ + 1);
               }
               this._terminatorSpan = null;
            }
            if(_loc1_)
            {
               if(_loc1_ is SpanElement)
               {
                  (_loc1_ as SpanElement).addParaTerminator();
                  this._terminatorSpan = _loc1_ as SpanElement;
               }
               else
               {
                  _loc3_ = new SpanElement();
                  super.replaceChildren(numChildren,numChildren,_loc3_);
                  _loc3_.format = !!_loc1_?_loc1_.format:this._terminatorSpan.format;
                  _loc3_.addParaTerminator();
                  this._terminatorSpan = _loc3_;
               }
            }
            else
            {
               this._terminatorSpan = null;
            }
         }
         if(this._terminatorSpan && this._terminatorSpan.textLength == 1)
         {
            _loc4_ = this._terminatorSpan.getPreviousLeaf(this);
            if(_loc4_ && _loc4_.parent == this && _loc4_ is SpanElement)
            {
               this._terminatorSpan.mergeToPreviousIfPossible();
            }
         }
      }
      
      tlf_internal function updateTerminatorSpan(param1:SpanElement, param2:SpanElement) : void
      {
         if(this._terminatorSpan == param1)
         {
            this._terminatorSpan = param2;
         }
      }
      
      override public function set mxmlChildren(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SpanElement = null;
         this.replaceChildren(0,numChildren);
         for each(_loc2_ in param1)
         {
            if(_loc2_ is FlowElement)
            {
               if(_loc2_ is SpanElement || _loc2_ is SubParagraphGroupElementBase)
               {
                  _loc2_.bindableElement = true;
               }
               super.replaceChildren(numChildren,numChildren,_loc2_ as FlowElement);
            }
            else if(_loc2_ is String)
            {
               _loc3_ = new SpanElement();
               _loc3_.text = String(_loc2_);
               _loc3_.bindableElement = true;
               super.replaceChildren(numChildren,numChildren,_loc3_);
            }
            else if(_loc2_ != null)
            {
               throw new TypeError(GlobalSettings.resourceStringFunction("badMXMLChildrenArgument",[getQualifiedClassName(_loc2_)]));
            }
         }
         this.ensureTerminatorAfterReplace();
         this.createTextBlock();
      }
      
      override public function getText(param1:int = 0, param2:int = -1, param3:String = "\n") : String
      {
         var _loc4_:TextBlock = null;
         var _loc5_:Vector.<TextBlock> = null;
         var _loc6_:String = null;
         if(param1 == 0 && (param2 == -1 || param2 >= textLength - 1) && this.getTextBlocks().length)
         {
            _loc5_ = this.getTextBlocks();
            _loc6_ = "";
            for each(_loc4_ in _loc5_)
            {
               _loc6_ = _loc6_ + this.getTextInBlock(_loc4_);
            }
            if(_loc4_.content && _loc4_.content.rawText)
            {
               return _loc6_.substring(0,_loc6_.length - 1);
            }
            return _loc6_;
         }
         return super.getText(param1,param2,param3);
      }
      
      private function getTextInBlock(param1:TextBlock) : String
      {
         if(!param1.content || !param1.content.rawText)
         {
            return "";
         }
         return param1.content.rawText;
      }
      
      public function getNextParagraph() : ParagraphElement
      {
         var _loc1_:FlowLeafElement = getLastLeaf().getNextLeaf();
         return !!_loc1_?_loc1_.getParagraph():null;
      }
      
      public function getPreviousParagraph() : ParagraphElement
      {
         var _loc1_:FlowLeafElement = getFirstLeaf().getPreviousLeaf();
         return !!_loc1_?_loc1_.getParagraph():null;
      }
      
      public function findPreviousAtomBoundary(param1:int) : int
      {
         var _loc7_:int = 0;
         var _loc8_:* = false;
         var _loc9_:int = 0;
         var _loc2_:TextBlock = this.getTextBlockAtPosition(param1);
         if(!_loc2_ || !_loc2_.content)
         {
            return param1 - 1;
         }
         var _loc3_:int = this.getTextBlockStart(_loc2_);
         var _loc4_:int = param1 - _loc3_;
         var _loc5_:TextLine = _loc2_.getTextLineAtCharIndex(_loc4_);
         if(ContainerController.usesDiscretionaryHyphens && _loc5_ != null)
         {
            _loc7_ = _loc5_.getAtomIndexAtCharIndex(_loc4_);
            _loc8_ = _loc5_.getAtomBidiLevel(_loc7_) == 1;
            if(_loc8_)
            {
               _loc9_ = _loc2_.findPreviousAtomBoundary(_loc4_);
               if(_loc7_ == 0)
               {
                  if(_loc5_.atomCount > 0)
                  {
                     while(--_loc4_)
                     {
                        param1--;
                        if(_loc5_.getAtomIndexAtCharIndex(_loc4_) != _loc7_)
                        {
                           break;
                        }
                     }
                  }
               }
               else
               {
                  while(--param1 && --_loc4_)
                  {
                     if(_loc5_.getAtomIndexAtCharIndex(_loc4_) != _loc7_)
                     {
                        break;
                     }
                  }
               }
               if(CharacterUtil.isLowSurrogate(this.getText(param1,param1 + 1).charCodeAt(0)))
               {
                  param1--;
                  _loc4_--;
               }
            }
            else
            {
               if(_loc7_ == 0)
               {
                  _loc5_ = _loc5_.previousLine;
                  if(!_loc5_)
                  {
                     if(_loc2_ != this._textBlocks[0])
                     {
                        return param1 - 1;
                     }
                     return -1;
                  }
                  if(_loc5_.textBlockBeginIndex + _loc5_.rawTextLength == _loc4_)
                  {
                     return _loc5_.textBlockBeginIndex + _loc5_.rawTextLength - 1 + _loc3_;
                  }
                  return _loc5_.textBlockBeginIndex + _loc5_.rawTextLength + _loc3_;
               }
               while(--param1 && --_loc4_)
               {
                  if(_loc5_.getAtomIndexAtCharIndex(_loc4_) < _loc7_)
                  {
                     break;
                  }
               }
               if(CharacterUtil.isLowSurrogate(this.getText(param1,param1 + 1).charCodeAt(0)))
               {
                  param1--;
                  _loc4_--;
               }
            }
            return param1;
         }
         var _loc6_:int = _loc2_.findPreviousAtomBoundary(_loc4_);
         if(_loc6_ >= 0)
         {
            _loc6_ = _loc6_ + _loc3_;
         }
         return _loc6_;
      }
      
      public function findNextAtomBoundary(param1:int) : int
      {
         var _loc7_:int = 0;
         var _loc8_:* = false;
         var _loc9_:int = 0;
         var _loc2_:TextBlock = this.getTextBlockAtPosition(param1);
         if(!_loc2_ || !_loc2_.content)
         {
            return param1 + 1;
         }
         var _loc3_:int = this.getTextBlockStart(_loc2_);
         var _loc4_:int = param1 - _loc3_;
         var _loc5_:TextLine = _loc2_.getTextLineAtCharIndex(_loc4_);
         if(ContainerController.usesDiscretionaryHyphens && _loc5_ != null)
         {
            _loc7_ = _loc5_.getAtomIndexAtCharIndex(_loc4_);
            _loc8_ = _loc5_.getAtomBidiLevel(_loc7_) == 1;
            if(_loc8_)
            {
               _loc9_ = _loc2_.findNextAtomBoundary(_loc4_);
               if(_loc7_ == 0)
               {
                  while(++_loc4_)
                  {
                     param1++;
                     if(_loc5_.getAtomIndexAtCharIndex(_loc4_) != _loc7_)
                     {
                        break;
                     }
                  }
               }
               else
               {
                  while(++_loc4_)
                  {
                     param1++;
                     if(_loc5_.getAtomIndexAtCharIndex(_loc4_) != _loc7_)
                     {
                        break;
                     }
                  }
               }
               if(CharacterUtil.isHighSurrogate(this.getText(param1,param1 + 1).charCodeAt(0)))
               {
                  param1++;
                  _loc4_++;
               }
            }
            else
            {
               if(_loc7_ == _loc5_.atomCount - 1)
               {
                  _loc5_ = _loc5_.nextLine;
                  if(!_loc5_)
                  {
                     if(_loc2_ != this._textBlocks[this._textBlocks.length - 1])
                     {
                        return param1 + 1;
                     }
                     return -1;
                  }
                  return _loc5_.textBlockBeginIndex + _loc3_;
               }
               while(++_loc4_)
               {
                  param1++;
                  if(_loc5_.getAtomIndexAtCharIndex(_loc4_) > _loc7_)
                  {
                     break;
                  }
               }
               if(CharacterUtil.isHighSurrogate(this.getText(param1,param1 + 1).charCodeAt(0)))
               {
                  param1++;
                  _loc4_++;
               }
            }
            return param1;
         }
         var _loc6_:int = _loc2_.findNextAtomBoundary(_loc4_);
         if(_loc6_ >= 0)
         {
            _loc6_ = _loc6_ + _loc3_;
         }
         return _loc6_;
      }
      
      override public function getCharAtPosition(param1:int) : String
      {
         var _loc5_:TableElement = null;
         var _loc6_:Vector.<TextBlock> = null;
         var _loc7_:TextBlock = null;
         var _loc2_:TextBlock = this.getTextBlockAtPosition(param1);
         if(!_loc2_)
         {
            return "\x16";
         }
         var _loc3_:Vector.<TableElement> = this.getTables();
         var _loc4_:int = param1;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.getElementRelativeStart(this) < _loc4_)
            {
               param1--;
            }
         }
         _loc6_ = this.getTextBlocks();
         for each(_loc7_ in _loc6_)
         {
            if(_loc2_ == _loc7_)
            {
               break;
            }
            if(_loc7_)
            {
               param1 = param1 - _loc7_.content.rawText.length;
            }
            else
            {
               param1--;
            }
            this.getText();
         }
         return _loc2_.content.rawText.charAt(param1);
      }
      
      public function findPreviousWordBoundary(param1:int) : int
      {
         if(param1 == 0)
         {
            return 0;
         }
         var _loc2_:int = getCharCodeAtPosition(param1 - 1);
         if(CharacterUtil.isWhitespace(_loc2_))
         {
            while(CharacterUtil.isWhitespace(_loc2_) && param1 - 1 > 0)
            {
               param1--;
               _loc2_ = getCharCodeAtPosition(param1 - 1);
            }
            return param1;
         }
         var _loc3_:TextBlock = this.getTextBlockAtPosition(param1);
         if(_loc3_ == null)
         {
            _loc3_ = this.getTextBlockAtPosition(--param1);
         }
         var _loc4_:int = this.getTextBlockStart(_loc3_);
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         return param1 == _loc4_?int(_loc4_):int(_loc4_ + _loc3_.findPreviousWordBoundary(param1 - _loc4_));
      }
      
      public function findNextWordBoundary(param1:int) : int
      {
         if(param1 == textLength)
         {
            return textLength;
         }
         var _loc2_:int = getCharCodeAtPosition(param1);
         if(CharacterUtil.isWhitespace(_loc2_))
         {
            while(CharacterUtil.isWhitespace(_loc2_) && param1 < textLength - 1)
            {
               param1++;
               _loc2_ = getCharCodeAtPosition(param1);
            }
            return param1;
         }
         var _loc3_:TextBlock = this.getTextBlockAtPosition(param1);
         if(_loc3_ == null)
         {
            _loc3_ = this.getTextBlockAtPosition(--param1);
         }
         var _loc4_:int = this.getTextBlockStart(_loc3_);
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         return _loc4_ + _loc3_.findNextWordBoundary(param1 - _loc4_);
      }
      
      private function updateTextBlock(param1:TextBlock = null) : void
      {
         var _loc4_:String = null;
         var _loc7_:SpaceJustifier = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc12_:Vector.<TabStop> = null;
         var _loc13_:TabStopFormat = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:TabStop = null;
         var _loc17_:String = null;
         if(!param1)
         {
            param1 = this.getTextBlock();
         }
         var _loc2_:ContainerFormattedElement = getAncestorWithContainer();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:ITextLayoutFormat = !!_loc2_?_loc2_.computedFormat:TextLayoutFormat.defaultFormat;
         if(this.computedFormat.textAlign == TextAlign.JUSTIFY)
         {
            _loc4_ = _computedFormat.textAlignLast == TextAlign.JUSTIFY?LineJustification.ALL_INCLUDING_LAST:LineJustification.ALL_BUT_LAST;
            if(_loc3_.lineBreak == LineBreak.EXPLICIT)
            {
               _loc4_ = LineJustification.UNJUSTIFIED;
            }
         }
         else
         {
            _loc4_ = LineJustification.UNJUSTIFIED;
         }
         var _loc5_:String = this.getEffectiveJustificationStyle();
         var _loc6_:String = this.getEffectiveJustificationRule();
         if(_loc6_ == JustificationRule.SPACE)
         {
            _loc7_ = new SpaceJustifier(_computedFormat.locale,_loc4_,false);
            _loc7_.letterSpacing = _computedFormat.textJustify == TextJustify.DISTRIBUTE?true:false;
            if(Configuration.playerEnablesArgoFeatures)
            {
               _loc8_ = Property.toNumberIfPercent(_computedFormat.wordSpacing.minimumSpacing) / 100;
               _loc9_ = Property.toNumberIfPercent(_computedFormat.wordSpacing.maximumSpacing) / 100;
               _loc10_ = Property.toNumberIfPercent(_computedFormat.wordSpacing.optimumSpacing) / 100;
               _loc7_["minimumSpacing"] = Math.min(_loc8_,_loc7_["minimumSpacing"]);
               _loc7_["maximumSpacing"] = Math.max(_loc9_,_loc7_["maximumSpacing"]);
               _loc7_["optimumSpacing"] = _loc10_;
               _loc7_["minimumSpacing"] = _loc8_;
               _loc7_["maximumSpacing"] = _loc9_;
            }
            param1.textJustifier = _loc7_;
            param1.baselineZero = getLeadingBasis(this.getEffectiveLeadingModel());
         }
         else
         {
            _loc11_ = new EastAsianJustifier(_computedFormat.locale,_loc4_,_loc5_);
            if(Configuration.versionIsAtLeast(10,3) && _loc11_.hasOwnProperty("composeTrailingIdeographicSpaces"))
            {
               _loc11_.composeTrailingIdeographicSpaces = true;
            }
            param1.textJustifier = _loc11_ as EastAsianJustifier;
            param1.baselineZero = getLeadingBasis(this.getEffectiveLeadingModel());
         }
         param1.bidiLevel = _computedFormat.direction == Direction.LTR?0:1;
         param1.lineRotation = _loc3_.blockProgression == BlockProgression.RL?TextRotation.ROTATE_90:TextRotation.ROTATE_0;
         if(_computedFormat.tabStops && _computedFormat.tabStops.length != 0)
         {
            _loc12_ = new Vector.<TabStop>();
            for each(_loc13_ in _computedFormat.tabStops)
            {
               _loc14_ = _loc13_.decimalAlignmentToken == null?"":_loc13_.decimalAlignmentToken;
               _loc15_ = _loc13_.alignment == null?TabAlignment.START:_loc13_.alignment;
               _loc16_ = new TabStop(_loc15_,Number(_loc13_.position),_loc14_);
               if(_loc13_.decimalAlignmentToken != null)
               {
                  _loc17_ = "x" + _loc16_.decimalAlignmentToken;
               }
               _loc12_.push(_loc16_);
            }
            param1.tabStops = _loc12_;
         }
         else if(GlobalSettings.enableDefaultTabStops && !Configuration.playerEnablesArgoFeatures)
         {
            if(_defaultTabStops == null)
            {
               initializeDefaultTabStops();
            }
            param1.tabStops = _defaultTabStops;
         }
         else
         {
            param1.tabStops = null;
         }
      }
      
      override public function get computedFormat() : ITextLayoutFormat
      {
         var _loc1_:Vector.<TextBlock> = null;
         var _loc2_:TextBlock = null;
         if(!_computedFormat)
         {
            super.computedFormat;
            _loc1_ = this.getTextBlocks();
            for each(_loc2_ in _loc1_)
            {
               this.updateTextBlock(_loc2_);
            }
         }
         return _computedFormat;
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         return param1 is FlowLeafElement || param1 is SubParagraphGroupElementBase || param1 is TableElement;
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
         var _loc4_:FlowElement = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FlowElement = null;
         var _loc8_:FlowElement = null;
         var _loc9_:SpanElement = null;
         var _loc3_:int = findChildIndexAtPosition(param1);
         if(_loc3_ != -1 && _loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            param1 = param1 - _loc4_.parentRelativeStart;
            while(true)
            {
               _loc5_ = _loc4_.parentRelativeStart + _loc4_.textLength;
               _loc4_.normalizeRange(param1,param2 - _loc4_.parentRelativeStart);
               _loc6_ = _loc4_.parentRelativeStart + _loc4_.textLength;
               param2 = param2 + (_loc6_ - _loc5_);
               if(_loc4_.textLength == 0 && !_loc4_.bindableElement)
               {
                  this.replaceChildren(_loc3_,_loc3_ + 1);
               }
               else if(_loc4_.mergeToPreviousIfPossible())
               {
                  _loc7_ = this.getChildAt(_loc3_ - 1);
                  _loc7_.normalizeRange(0,_loc7_.textLength);
               }
               else
               {
                  _loc3_++;
               }
               if(_loc3_ == numChildren)
               {
                  if(_loc3_ != 0)
                  {
                     _loc8_ = this.getChildAt(_loc3_ - 1);
                     if(_loc8_ is SubParagraphGroupElementBase && _loc8_.textLength == 1 && !_loc8_.bindableElement)
                     {
                        this.replaceChildren(_loc3_ - 1,_loc3_);
                     }
                  }
                  break;
               }
               _loc4_ = getChildAt(_loc3_);
               if(_loc4_.parentRelativeStart > param2)
               {
                  break;
               }
               param1 = 0;
            }
         }
         if(numChildren == 0 || textLength == 0)
         {
            _loc9_ = new SpanElement();
            this.replaceChildren(0,0,_loc9_);
            _loc9_.normalizeRange(0,_loc9_.textLength);
         }
      }
      
      tlf_internal function getEffectiveLeadingModel() : String
      {
         return this.computedFormat.leadingModel == LeadingModel.AUTO?LocaleUtil.leadingModel(this.computedFormat.locale):this.computedFormat.leadingModel;
      }
      
      tlf_internal function getEffectiveDominantBaseline() : String
      {
         return this.computedFormat.dominantBaseline == FormatValue.AUTO?LocaleUtil.dominantBaseline(this.computedFormat.locale):this.computedFormat.dominantBaseline;
      }
      
      tlf_internal function getEffectiveJustificationRule() : String
      {
         return this.computedFormat.justificationRule == FormatValue.AUTO?LocaleUtil.justificationRule(this.computedFormat.locale):this.computedFormat.justificationRule;
      }
      
      tlf_internal function getEffectiveJustificationStyle() : String
      {
         return this.computedFormat.justificationStyle == FormatValue.AUTO?LocaleUtil.justificationStyle(this.computedFormat.locale):this.computedFormat.justificationStyle;
      }
      
      tlf_internal function incInteractiveChildrenCount() : void
      {
         this._interactiveChildrenCount++;
      }
      
      tlf_internal function decInteractiveChildrenCount() : void
      {
         this._interactiveChildrenCount--;
      }
      
      tlf_internal function hasInteractiveChildren() : Boolean
      {
         return this._interactiveChildrenCount != 0;
      }
      
      tlf_internal function get terminatorSpan() : SpanElement
      {
         return this._terminatorSpan;
      }
   }
}
