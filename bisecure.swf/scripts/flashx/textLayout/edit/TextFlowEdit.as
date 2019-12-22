package flashx.textLayout.edit
{
   import flashx.textLayout.conversion.ConverterBase;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ListItemElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.SubParagraphGroupElementBase;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextFlowEdit
   {
       
      
      public function TextFlowEdit()
      {
         super();
      }
      
      tlf_internal static function deleteRange(param1:TextFlow, param2:int, param3:int) : ParagraphElement
      {
         var _loc4_:ParagraphElement = null;
         var _loc5_:FlowLeafElement = null;
         var _loc6_:FlowLeafElement = null;
         var _loc7_:ParagraphElement = null;
         var _loc8_:ParagraphElement = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = false;
         var _loc12_:FlowLeafElement = null;
         var _loc13_:FlowLeafElement = null;
         if(param3 > param2)
         {
            _loc5_ = param1.findLeaf(param2);
            _loc6_ = param1.findLeaf(param3 - 1);
            _loc7_ = _loc5_.getParagraph();
            _loc8_ = _loc6_.getParagraph();
            _loc9_ = _loc7_.getAbsoluteStart();
            _loc10_ = _loc8_.getAbsoluteStart() + _loc8_.textLength;
            _loc11_ = false;
            if(_loc7_ == _loc8_)
            {
               _loc11_ = Boolean(param3 == _loc10_ && param2 != _loc9_);
            }
            else
            {
               _loc11_ = param2 != _loc9_;
            }
            if(_loc11_)
            {
               _loc12_ = param1.findLeaf(param3);
               if(_loc12_)
               {
                  _loc4_ = _loc12_.getParagraph();
                  if(_loc4_.textLength == 1 && _loc4_.parent is ListItemElement && _loc4_.parent.numChildren > 1)
                  {
                     _loc4_ = null;
                  }
               }
            }
         }
         deleteRangeInternal(param1,param2,param3 - param2);
         if(_loc4_)
         {
            _loc13_ = _loc4_.getFirstLeaf().getPreviousLeaf();
            _loc4_ = !!_loc13_?_loc13_.getParagraph():null;
         }
         return _loc4_;
      }
      
      private static function deleteRangeInternal(param1:FlowGroupElement, param2:int, param3:int) : void
      {
         var _loc7_:FlowElement = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:SpanElement = null;
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         var _loc6_:int = param1.findChildIndexAtPosition(param2);
         while(param3 > 0 && _loc6_ < param1.numChildren)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            if(param2 <= _loc7_.parentRelativeStart && param3 >= _loc7_.textLength)
            {
               if(_loc4_ < 0)
               {
                  _loc4_ = _loc6_;
               }
               _loc5_++;
               param3 = param3 - _loc7_.textLength;
            }
            else
            {
               if(_loc4_ >= 0)
               {
                  param1.replaceChildren(_loc4_,_loc4_ + _loc5_);
                  _loc6_ = _loc6_ - _loc5_;
                  _loc4_ = -1;
                  _loc5_ = 0;
               }
               _loc8_ = _loc7_.parentRelativeStart;
               _loc9_ = Math.max(param2 - _loc8_,0);
               _loc10_ = Math.min(_loc7_.textLength - _loc9_,param3);
               if(_loc7_ is SpanElement)
               {
                  _loc11_ = _loc7_ as SpanElement;
                  _loc11_.replaceText(_loc9_,_loc9_ + _loc10_,"");
                  param3 = param3 - _loc10_;
               }
               else
               {
                  deleteRangeInternal(_loc7_ as FlowGroupElement,_loc9_,_loc10_);
                  param3 = param3 - _loc10_;
               }
            }
            _loc6_++;
         }
         if(_loc4_ >= 0)
         {
            param1.replaceChildren(_loc4_,_loc4_ + _loc5_);
         }
      }
      
      private static function findLowestPossibleParent(param1:FlowGroupElement, param2:FlowElement) : FlowGroupElement
      {
         while(param1 && !param1.canOwnFlowElement(param2))
         {
            param1 = param1.parent;
         }
         return param1;
      }
      
      private static function removePasteAttributes(param1:FlowElement) : void
      {
         var _loc2_:FlowGroupElement = null;
         if(!param1)
         {
            return;
         }
         if(param1 is FlowGroupElement && param1.format)
         {
            _loc2_ = FlowGroupElement(param1);
            if(param1.format.getStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE) !== undefined)
            {
               removePasteAttributes(_loc2_.getChildAt(_loc2_.numChildren - 1));
            }
         }
         param1.setStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE,undefined);
      }
      
      private static function applyFormatToElement(param1:FlowGroupElement, param2:int, param3:Object) : void
      {
         var _loc4_:FlowElement = null;
         var _loc5_:ITextLayoutFormat = null;
         var _loc6_:FlowElement = null;
         var _loc7_:TextLayoutFormat = null;
         var _loc8_:FlowElement = null;
         if(param2 > 0)
         {
            _loc4_ = param1.getChildAt(param2 - 1);
         }
         else
         {
            _loc4_ = param1.getChildAt(0);
         }
         if(_loc4_)
         {
            if(_loc4_ is FlowGroupElement)
            {
               _loc6_ = FlowGroupElement(_loc4_).getLastLeaf();
               while(_loc6_ != _loc4_.parent)
               {
                  if(_loc6_.format)
                  {
                     if(!_loc7_)
                     {
                        _loc7_ = new TextLayoutFormat(_loc6_.format);
                     }
                     else
                     {
                        _loc7_.concatInheritOnly(_loc6_.format);
                     }
                  }
                  _loc6_ = _loc6_.parent;
               }
               _loc5_ = _loc7_;
            }
            else
            {
               _loc5_ = _loc4_.format;
            }
            if(param3 is Array)
            {
               for each(_loc8_ in param3)
               {
                  if(_loc8_ is FlowLeafElement)
                  {
                     _loc8_.format = _loc5_;
                  }
                  else
                  {
                     _loc8_.format = _loc4_.format;
                  }
               }
            }
            else if(param3 is FlowLeafElement)
            {
               param3.format = _loc5_;
            }
            else
            {
               param3.format = _loc4_.format;
            }
         }
      }
      
      public static function insertTextScrap(param1:TextFlow, param2:int, param3:TextScrap, param4:Boolean) : int
      {
         var _loc11_:FlowElement = null;
         var _loc12_:ParagraphElement = null;
         var _loc13_:ParagraphElement = null;
         var _loc14_:FlowGroupElement = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:FlowGroupElement = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:FlowElement = null;
         var _loc21_:int = 0;
         if(!param3)
         {
            return param2;
         }
         var _loc5_:TextFlow = param3.textFlow.deepCopy() as TextFlow;
         var _loc6_:FlowLeafElement = _loc5_.getFirstLeaf();
         var _loc7_:FlowLeafElement = param1.findLeaf(param2);
         var _loc8_:int = param2;
         var _loc9_:Boolean = true;
         var _loc10_:Boolean = false;
         while(_loc6_)
         {
            removePasteAttributes(_loc6_);
            _loc11_ = _loc6_;
            _loc12_ = _loc6_.getParagraph();
            _loc13_ = !!_loc7_?_loc7_.getParagraph():_loc13_;
            if(_loc9_ && (_loc13_.textLength > 1 || param4))
            {
               if(!_loc12_.format || _loc12_.format.getStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE) === undefined)
               {
                  _loc10_ = true;
               }
               _loc11_ = _loc12_.getChildAt(0);
            }
            else
            {
               if(param4)
               {
                  _loc14_ = !!_loc7_?findLowestPossibleParent(_loc7_.parent,_loc11_):findLowestPossibleParent(_loc14_,_loc11_);
                  _loc16_ = _loc14_.findChildIndexAtPosition(_loc8_ - _loc14_.getAbsoluteStart());
                  applyFormatToElement(_loc14_,_loc16_,_loc11_);
               }
               while(_loc11_ && _loc11_.parent && (!_loc11_.parent.format || _loc11_.parent.format.getStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE) === undefined) && !(_loc11_.parent is TextFlow))
               {
                  _loc11_ = _loc11_.parent;
               }
            }
            _loc14_ = !!_loc7_?findLowestPossibleParent(_loc7_.parent,_loc11_):findLowestPossibleParent(_loc14_,_loc11_);
            while(!_loc14_)
            {
               _loc11_ = _loc11_.parent;
               _loc14_ = findLowestPossibleParent(_loc7_.parent,_loc11_);
            }
            removePasteAttributes(_loc11_);
            _loc15_ = _loc14_.getAbsoluteStart();
            if(_loc9_ && _loc10_)
            {
               ModelEdit.splitElement(param1,_loc14_,_loc8_ - _loc15_);
               _loc17_ = _loc11_.parent;
               _loc18_ = _loc17_.mxmlChildren;
               _loc17_.replaceChildren(0,_loc17_.numChildren);
               if(_loc17_.parent)
               {
                  _loc17_.parent.removeChild(_loc17_);
               }
               if(param4)
               {
                  applyFormatToElement(_loc14_,_loc14_.numChildren,_loc18_);
               }
               _loc14_.replaceChildren(_loc14_.numChildren,_loc14_.numChildren,_loc18_);
               _loc11_ = _loc14_.getChildAt(_loc14_.numChildren - 1);
               _loc9_ = false;
            }
            else
            {
               _loc19_ = _loc14_.findChildIndexAtPosition(_loc8_ - _loc14_.getAbsoluteStart());
               _loc20_ = _loc14_.getChildAt(_loc19_);
               _loc21_ = _loc20_.getAbsoluteStart();
               if(_loc8_ == _loc21_ + _loc20_.textLength)
               {
                  _loc19_++;
               }
               else if(_loc8_ > _loc21_)
               {
                  if(_loc20_ is FlowLeafElement)
                  {
                     _loc20_.splitAtPosition(_loc8_ - _loc21_);
                  }
                  else
                  {
                     ModelEdit.splitElement(param1,_loc20_ as FlowGroupElement,_loc8_ - _loc21_);
                  }
                  _loc19_++;
               }
               if(param4)
               {
                  applyFormatToElement(_loc14_,_loc19_,_loc11_);
               }
               _loc14_.replaceChildren(_loc19_,_loc19_,_loc11_);
            }
            _loc7_ = _loc11_ is FlowLeafElement?FlowLeafElement(_loc11_).getNextLeaf():FlowGroupElement(_loc11_).getLastLeaf().getNextLeaf();
            _loc8_ = !!_loc7_?int(_loc7_.getAbsoluteStart()):int(param1.textLength - 1);
            _loc6_ = _loc5_.getFirstLeaf();
            if(_loc7_ && _loc6_ && _loc6_.getParagraph() == _loc12_)
            {
               if(_loc7_.getParagraph() != _loc13_)
               {
                  _loc8_--;
                  _loc7_ = null;
               }
            }
         }
         if(_loc12_.getStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE) == "true" && _loc8_ == _loc13_.getAbsoluteStart() + _loc13_.textLength)
         {
            _loc8_--;
         }
         return _loc8_;
      }
      
      public static function makeTCY(param1:TextFlow, param2:int, param3:int) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TCYElement = null;
         var _loc4_:Boolean = true;
         var _loc5_:ParagraphElement = param1.findAbsoluteParagraph(param2);
         if(!_loc5_)
         {
            return false;
         }
         while(_loc5_)
         {
            _loc6_ = _loc5_.getAbsoluteStart() + _loc5_.textLength;
            _loc7_ = Math.min(_loc6_,param3);
            if(canInsertSPBlock(param1,param2,_loc7_,TCYElement) && _loc5_.textLength > 1)
            {
               _loc8_ = new TCYElement();
               _loc4_ = _loc4_ && insertNewSPBlock(param1,param2,_loc7_,_loc8_,TCYElement);
            }
            else
            {
               _loc4_ = false;
            }
            if(_loc6_ < param3)
            {
               _loc5_ = param1.findAbsoluteParagraph(_loc7_);
               param2 = _loc7_;
            }
            else
            {
               _loc5_ = null;
            }
         }
         return _loc4_;
      }
      
      public static function makeLink(param1:TextFlow, param2:int, param3:int, param4:String, param5:String) : Boolean
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:LinkElement = null;
         var _loc6_:Boolean = true;
         var _loc7_:ParagraphElement = param1.findAbsoluteParagraph(param2);
         if(!_loc7_)
         {
            return false;
         }
         while(_loc7_)
         {
            _loc8_ = _loc7_.getAbsoluteStart() + _loc7_.textLength;
            _loc9_ = Math.min(_loc8_,param3);
            _loc10_ = _loc9_ == _loc8_?int(_loc9_ - 1):int(_loc9_);
            if(_loc10_ > param2)
            {
               if(!canInsertSPBlock(param1,param2,_loc10_,LinkElement))
               {
                  return false;
               }
               _loc11_ = new LinkElement();
               _loc11_.href = param4;
               _loc11_.target = param5;
               _loc6_ = _loc6_ && insertNewSPBlock(param1,param2,_loc10_,_loc11_,LinkElement);
            }
            if(_loc8_ < param3)
            {
               _loc7_ = param1.findAbsoluteParagraph(_loc9_);
               param2 = _loc9_;
            }
            else
            {
               _loc7_ = null;
            }
         }
         return _loc6_;
      }
      
      public static function removeTCY(param1:TextFlow, param2:int, param3:int) : Boolean
      {
         if(param3 <= param2)
         {
            return false;
         }
         return findAndRemoveFlowGroupElement(param1,param2,param3,TCYElement);
      }
      
      public static function removeLink(param1:TextFlow, param2:int, param3:int) : Boolean
      {
         if(param3 <= param2)
         {
            return false;
         }
         return findAndRemoveFlowGroupElement(param1,param2,param3,LinkElement);
      }
      
      tlf_internal static function insertNewSPBlock(param1:TextFlow, param2:int, param3:int, param4:SubParagraphGroupElementBase, param5:Class) : Boolean
      {
         var _loc6_:int = param2;
         var _loc7_:FlowGroupElement = param1.findAbsoluteFlowGroupElement(_loc6_);
         var _loc8_:int = 0;
         var _loc9_:ParagraphElement = _loc7_.getParagraph();
         if(param3 == _loc9_.getAbsoluteStart() + _loc9_.textLength - 1)
         {
            param3++;
         }
         var _loc10_:int = _loc7_.parent.getAbsoluteStart();
         var _loc11_:int = _loc7_.getAbsoluteStart();
         if(_loc7_.parent && _loc7_.parent is param5 && !(_loc10_ == _loc11_ && _loc10_ + _loc7_.parent.textLength == _loc11_ + _loc7_.textLength))
         {
            return false;
         }
         if(!(_loc7_ is ParagraphElement) && _loc6_ == _loc11_ && _loc6_ + _loc7_.textLength <= param3)
         {
            _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
            _loc7_ = _loc7_.parent;
         }
         if(_loc6_ >= _loc11_)
         {
            if(!(_loc7_ is param5))
            {
               _loc8_ = findAndSplitElement(_loc7_,_loc8_,_loc6_,true);
            }
            else
            {
               _loc8_ = findAndSplitElement(_loc7_.parent,_loc7_.parent.getChildIndex(_loc7_),_loc6_,false);
               _loc7_ = _loc7_.parent;
            }
         }
         if(_loc7_ is param5)
         {
            _loc11_ = _loc7_.getAbsoluteStart();
            _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
            if(_loc6_ > _loc11_)
            {
               _loc8_ = _loc8_ + 1;
            }
            while(param3 >= _loc11_ + _loc7_.textLength)
            {
               _loc7_ = _loc7_.parent;
            }
            _loc7_.replaceChildren(_loc8_,_loc8_,param4);
         }
         else
         {
            _loc7_.replaceChildren(_loc8_,_loc8_,param4);
         }
         subsumeElementsToSPBlock(_loc7_,_loc8_ + 1,_loc6_,param3,param4,param5);
         return true;
      }
      
      tlf_internal static function splitElement(param1:FlowElement, param2:int, param3:Boolean) : void
      {
         var _loc4_:SubParagraphGroupElementBase = null;
         var _loc5_:SpanElement = null;
         if(param1 is SpanElement)
         {
            SpanElement(param1).splitAtPosition(param2);
         }
         else if(param1 is SubParagraphGroupElementBase && param3)
         {
            _loc4_ = SubParagraphGroupElementBase(param1);
            _loc5_ = _loc4_.findLeaf(param2) as SpanElement;
            if(_loc5_)
            {
               _loc5_.splitAtPosition(param2 - _loc5_.getElementRelativeStart(_loc4_));
            }
         }
         else if(param1 is FlowGroupElement)
         {
            FlowGroupElement(param1).splitAtPosition(param2);
         }
      }
      
      tlf_internal static function findAndSplitElement(param1:FlowGroupElement, param2:int, param3:int, param4:Boolean) : int
      {
         var _loc5_:FlowElement = null;
         var _loc6_:int = param3 - param1.getAbsoluteStart();
         while(param2 < param1.numChildren)
         {
            _loc5_ = param1.getChildAt(param2);
            if(_loc6_ == _loc5_.parentRelativeStart)
            {
               return param2;
            }
            if(_loc6_ > _loc5_.parentRelativeStart && _loc6_ < _loc5_.parentRelativeEnd)
            {
               splitElement(_loc5_,_loc6_ - _loc5_.parentRelativeStart,param4);
            }
            param2++;
         }
         return param2;
      }
      
      tlf_internal static function subsumeElementsToSPBlock(param1:FlowGroupElement, param2:int, param3:int, param4:int, param5:SubParagraphGroupElementBase, param6:Class) : int
      {
         var _loc8_:SubParagraphGroupElementBase = null;
         var _loc9_:FlowElement = null;
         var _loc10_:SubParagraphGroupElementBase = null;
         var _loc11_:int = 0;
         var _loc12_:FlowElement = null;
         var _loc7_:FlowElement = null;
         if(param2 >= param1.numChildren)
         {
            return param3;
         }
         while(param3 < param4)
         {
            _loc7_ = param1.getChildAt(param2);
            if(param3 + _loc7_.textLength > param4)
            {
               splitElement(_loc7_,param4 - _loc7_.getAbsoluteStart(),!(_loc7_ is param6));
            }
            param3 = param3 + _loc7_.textLength;
            param1.replaceChildren(param2,param2 + 1);
            if(_loc7_ is param6)
            {
               _loc8_ = _loc7_ as SubParagraphGroupElementBase;
               while(_loc8_.numChildren > 0)
               {
                  _loc9_ = _loc8_.getChildAt(0);
                  _loc8_.replaceChildren(0,1);
                  param5.replaceChildren(param5.numChildren,param5.numChildren,_loc9_);
               }
            }
            else
            {
               if(_loc7_ is SubParagraphGroupElementBase)
               {
                  flushSPBlock(_loc7_ as SubParagraphGroupElementBase,param6);
               }
               param5.replaceChildren(param5.numChildren,param5.numChildren,_loc7_);
               if(param5.numChildren == 1 && _loc7_ is SubParagraphGroupElementBase)
               {
                  _loc10_ = _loc7_ as SubParagraphGroupElementBase;
                  if(_loc10_.textLength == param5.textLength && param3 >= param4)
                  {
                     if(_loc10_.precedence > param5.precedence)
                     {
                        param5.replaceChildren(0,1);
                        while(_loc10_.numChildren > 0)
                        {
                           _loc12_ = _loc10_.getChildAt(0);
                           _loc10_.replaceChildren(0,1);
                           param5.replaceChildren(param5.numChildren,param5.numChildren,_loc12_);
                        }
                        _loc11_ = param5.parent.getChildIndex(param5);
                        param5.parent.replaceChildren(_loc11_,_loc11_ + 1,_loc10_);
                        _loc10_.replaceChildren(0,0,param5);
                     }
                  }
               }
            }
         }
         return param3;
      }
      
      tlf_internal static function findAndRemoveFlowGroupElement(param1:TextFlow, param2:int, param3:int, param4:Class) : Boolean
      {
         var _loc6_:FlowElement = null;
         var _loc7_:FlowGroupElement = null;
         var _loc8_:FlowGroupElement = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:FlowGroupElement = null;
         var _loc12_:FlowGroupElement = null;
         var _loc13_:int = 0;
         var _loc14_:FlowElement = null;
         var _loc15_:SubParagraphGroupElementBase = null;
         var _loc5_:int = param2;
         while(_loc5_ < param3)
         {
            _loc7_ = param1.findAbsoluteFlowGroupElement(_loc5_);
            while(_loc7_.parent && _loc7_.parent.getAbsoluteStart() == _loc7_.getAbsoluteStart() && !(_loc7_.parent is ParagraphElement) && !(_loc7_ is ParagraphElement))
            {
               _loc7_ = _loc7_.parent;
            }
            if(_loc7_ is param4)
            {
               _loc7_ = _loc7_.parent;
            }
            _loc8_ = _loc7_.parent;
            while(_loc8_ != null && !(_loc8_ is param4))
            {
               if(_loc8_.parent is param4)
               {
                  return false;
               }
               _loc8_ = _loc8_.parent;
            }
            _loc9_ = _loc7_.getAbsoluteStart();
            if(_loc8_ is param4 && (_loc9_ >= _loc5_ && _loc9_ + _loc7_.textLength <= param3))
            {
               _loc7_ = _loc8_.parent;
            }
            _loc10_ = _loc7_.findChildIndexAtPosition(_loc5_ - _loc9_);
            _loc6_ = _loc7_.getChildAt(_loc10_);
            if(_loc6_ is param4)
            {
               _loc11_ = _loc6_ as FlowGroupElement;
               _loc12_ = _loc11_.parent;
               _loc13_ = _loc12_.getChildIndex(_loc11_);
               if(_loc5_ > _loc11_.getAbsoluteStart())
               {
                  splitElement(_loc11_,_loc5_ - _loc11_.getAbsoluteStart(),false);
                  _loc5_ = _loc11_.getAbsoluteStart() + _loc11_.textLength;
               }
               else
               {
                  if(_loc11_.getAbsoluteStart() + _loc11_.textLength > param3)
                  {
                     splitElement(_loc11_,param3 - _loc11_.getAbsoluteStart(),false);
                  }
                  _loc5_ = _loc11_.getAbsoluteStart() + _loc11_.textLength;
                  while(_loc11_.numChildren > 0)
                  {
                     _loc14_ = _loc11_.getChildAt(0);
                     _loc11_.replaceChildren(0,1);
                     _loc12_.replaceChildren(_loc13_,_loc13_,_loc14_);
                     _loc13_++;
                  }
                  _loc12_.replaceChildren(_loc13_,_loc13_ + 1);
               }
            }
            else if(_loc6_ is SubParagraphGroupElementBase)
            {
               _loc15_ = SubParagraphGroupElementBase(_loc6_);
               if(_loc15_.numChildren == 1)
               {
                  _loc5_ = _loc15_.getAbsoluteStart() + _loc15_.textLength;
               }
               else
               {
                  _loc6_ = _loc15_.getChildAt(_loc15_.findChildIndexAtPosition(_loc5_ - _loc15_.getAbsoluteStart()));
                  _loc5_ = _loc6_.getAbsoluteStart() + _loc6_.textLength;
               }
            }
            else
            {
               _loc5_ = _loc6_.getAbsoluteStart() + _loc6_.textLength;
            }
         }
         return true;
      }
      
      tlf_internal static function canInsertSPBlock(param1:TextFlow, param2:int, param3:int, param4:Class) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param3 <= param2)
         {
            return false;
         }
         var _loc5_:FlowGroupElement = param1.findAbsoluteFlowGroupElement(param2);
         if(_loc5_.getParentByType(param4))
         {
            _loc5_ = _loc5_.getParentByType(param4) as FlowGroupElement;
         }
         var _loc6_:FlowGroupElement = param1.findAbsoluteFlowGroupElement(param3 - 1);
         if(_loc6_.getParentByType(param4))
         {
            _loc6_ = _loc6_.getParentByType(param4) as FlowGroupElement;
         }
         if(_loc5_ == _loc6_)
         {
            return true;
         }
         if(_loc5_.getParagraph() != _loc6_.getParagraph())
         {
            return false;
         }
         if(_loc5_ is param4 && _loc6_ is param4)
         {
            return true;
         }
         if(_loc5_ is SubParagraphGroupElementBase && !(_loc5_ is param4))
         {
            _loc7_ = _loc5_.getAbsoluteStart();
            if(param2 > _loc7_ && param3 > _loc7_ + _loc5_.textLength)
            {
               return false;
            }
         }
         else if((_loc5_.parent is SubParagraphGroupElementBase || _loc6_.parent is SubParagraphGroupElementBase) && _loc5_.parent != _loc6_.parent)
         {
            return false;
         }
         if(_loc6_ is SubParagraphGroupElementBase && !(_loc6_ is param4) && param3 > _loc6_.getAbsoluteStart())
         {
            _loc8_ = _loc6_.getAbsoluteStart();
            if(param2 < _loc8_ && param3 < _loc8_ + _loc6_.textLength)
            {
               return false;
            }
         }
         return true;
      }
      
      tlf_internal static function flushSPBlock(param1:SubParagraphGroupElementBase, param2:Class) : void
      {
         var _loc4_:FlowElement = null;
         var _loc5_:FlowGroupElement = null;
         var _loc6_:FlowElement = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is param2)
            {
               _loc5_ = _loc4_ as FlowGroupElement;
               while(_loc5_.numChildren > 0)
               {
                  _loc6_ = _loc5_.getChildAt(0);
                  _loc5_.replaceChildren(0,1);
                  param1.replaceChildren(_loc3_,_loc3_,_loc6_);
               }
               _loc3_++;
               param1.replaceChildren(_loc3_,_loc3_ + 1);
            }
            else if(_loc4_ is SubParagraphGroupElementBase)
            {
               flushSPBlock(_loc4_ as SubParagraphGroupElementBase,param2);
               _loc3_++;
            }
            else
            {
               _loc3_++;
            }
         }
      }
      
      tlf_internal static function findNextParagraph(param1:ParagraphElement) : ParagraphElement
      {
         var _loc2_:FlowLeafElement = null;
         if(param1)
         {
            _loc2_ = param1.getLastLeaf();
            _loc2_ = _loc2_.getNextLeaf();
            if(_loc2_)
            {
               return _loc2_.getParagraph();
            }
         }
         return null;
      }
      
      tlf_internal static function removeEmptyParentChain(param1:FlowGroupElement) : IMemento
      {
         var _loc3_:FlowGroupElement = null;
         var _loc4_:int = 0;
         if(param1 is ParagraphElement)
         {
            ParagraphElement(param1).removeEmptyTerminator();
         }
         var _loc2_:MementoList = new MementoList(param1.getTextFlow());
         while(param1 && param1.numChildren == 0)
         {
            _loc3_ = param1.parent;
            if(_loc3_ is ParagraphElement)
            {
               ParagraphElement(_loc3_).removeEmptyTerminator();
            }
            if(_loc3_)
            {
               _loc4_ = _loc3_.getChildIndex(param1);
               _loc2_.push(ModelEdit.removeElements(_loc3_.getTextFlow(),_loc3_,_loc4_,1));
            }
            param1 = _loc3_;
         }
         return _loc2_;
      }
      
      public static function joinNextParagraph(param1:ParagraphElement, param2:Boolean) : IMemento
      {
         var _loc3_:ParagraphElement = findNextParagraph(param1);
         if(_loc3_ && (!param2 || param1.parent == _loc3_.parent))
         {
            return joinToElement(param1,_loc3_);
         }
         return null;
      }
      
      public static function joinToNextParagraph(param1:ParagraphElement, param2:Boolean) : MementoList
      {
         var _loc3_:ParagraphElement = findNextParagraph(param1);
         if(_loc3_ && (!param2 || param1.parent == _loc3_.parent))
         {
            return joinToNextElement(param1,_loc3_);
         }
         return null;
      }
      
      public static function joinToElement(param1:FlowGroupElement, param2:FlowGroupElement) : IMemento
      {
         var _loc3_:MementoList = null;
         if(param1 && param2)
         {
            return ModelEdit.joinElement(param2.getTextFlow(),param1,param2);
         }
         return _loc3_;
      }
      
      public static function joinToNextElement(param1:FlowGroupElement, param2:FlowGroupElement) : MementoList
      {
         var _loc3_:MementoList = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1 && param2)
         {
            _loc3_ = new MementoList(param1.getTextFlow());
            _loc4_ = param1.mxmlChildren;
            _loc3_.push(ModelEdit.removeElements(param1.getTextFlow(),param1,0,param1.numChildren));
            _loc5_ = _loc4_.length - 1;
            while(_loc5_ >= 0)
            {
               _loc3_.push(ModelEdit.addElement(param2.getTextFlow(),_loc4_[_loc5_],param2,0));
               _loc5_--;
            }
            _loc3_.push(removeEmptyParentChain(param1));
            return _loc3_;
         }
         return _loc3_;
      }
   }
}
