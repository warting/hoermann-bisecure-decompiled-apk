package flashx.textLayout.formats
{
   import flash.text.engine.BreakOpportunity;
   import flash.text.engine.CFFHinting;
   import flash.text.engine.DigitCase;
   import flash.text.engine.DigitWidth;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.JustificationStyle;
   import flash.text.engine.Kerning;
   import flash.text.engine.LigatureLevel;
   import flash.text.engine.RenderingMode;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextRotation;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextLayoutFormat implements ITextLayoutFormat
   {
      
      private static var _columnBreakBeforeProperty:Property;
      
      private static var _columnBreakAfterProperty:Property;
      
      private static var _containerBreakBeforeProperty:Property;
      
      private static var _containerBreakAfterProperty:Property;
      
      private static var _colorProperty:Property;
      
      private static var _backgroundColorProperty:Property;
      
      private static var _lineThroughProperty:Property;
      
      private static var _textAlphaProperty:Property;
      
      private static var _backgroundAlphaProperty:Property;
      
      private static var _fontSizeProperty:Property;
      
      private static var _baselineShiftProperty:Property;
      
      private static var _trackingLeftProperty:Property;
      
      private static var _trackingRightProperty:Property;
      
      private static var _lineHeightProperty:Property;
      
      private static var _breakOpportunityProperty:Property;
      
      private static var _digitCaseProperty:Property;
      
      private static var _digitWidthProperty:Property;
      
      private static var _dominantBaselineProperty:Property;
      
      private static var _kerningProperty:Property;
      
      private static var _ligatureLevelProperty:Property;
      
      private static var _alignmentBaselineProperty:Property;
      
      private static var _localeProperty:Property;
      
      private static var _typographicCaseProperty:Property;
      
      private static var _fontFamilyProperty:Property;
      
      private static var _textDecorationProperty:Property;
      
      private static var _fontWeightProperty:Property;
      
      private static var _fontStyleProperty:Property;
      
      private static var _whiteSpaceCollapseProperty:Property;
      
      private static var _renderingModeProperty:Property;
      
      private static var _cffHintingProperty:Property;
      
      private static var _fontLookupProperty:Property;
      
      private static var _textRotationProperty:Property;
      
      private static var _textIndentProperty:Property;
      
      private static var _paragraphStartIndentProperty:Property;
      
      private static var _paragraphEndIndentProperty:Property;
      
      private static var _paragraphSpaceBeforeProperty:Property;
      
      private static var _paragraphSpaceAfterProperty:Property;
      
      private static var _textAlignProperty:Property;
      
      private static var _textAlignLastProperty:Property;
      
      private static var _textJustifyProperty:Property;
      
      private static var _justificationRuleProperty:Property;
      
      private static var _justificationStyleProperty:Property;
      
      private static var _directionProperty:Property;
      
      private static var _wordSpacingProperty:Property;
      
      private static var _tabStopsProperty:Property;
      
      private static var _leadingModelProperty:Property;
      
      private static var _columnGapProperty:Property;
      
      private static var _paddingLeftProperty:Property;
      
      private static var _paddingTopProperty:Property;
      
      private static var _paddingRightProperty:Property;
      
      private static var _paddingBottomProperty:Property;
      
      private static var _columnCountProperty:Property;
      
      private static var _columnWidthProperty:Property;
      
      private static var _firstBaselineOffsetProperty:Property;
      
      private static var _verticalAlignProperty:Property;
      
      private static var _blockProgressionProperty:Property;
      
      private static var _lineBreakProperty:Property;
      
      private static var _listStyleTypeProperty:Property;
      
      private static var _listStylePositionProperty:Property;
      
      private static var _listAutoPaddingProperty:Property;
      
      private static var _clearFloatsProperty:Property;
      
      private static var _styleNameProperty:Property;
      
      private static var _linkNormalFormatProperty:Property;
      
      private static var _linkActiveFormatProperty:Property;
      
      private static var _linkHoverFormatProperty:Property;
      
      private static var _listMarkerFormatProperty:Property;
      
      private static var _borderLeftWidthProperty:Property;
      
      private static var _borderRightWidthProperty:Property;
      
      private static var _borderTopWidthProperty:Property;
      
      private static var _borderBottomWidthProperty:Property;
      
      private static var _borderLeftColorProperty:Property;
      
      private static var _borderRightColorProperty:Property;
      
      private static var _borderTopColorProperty:Property;
      
      private static var _borderBottomColorProperty:Property;
      
      private static var _borderLeftPriorityProperty:Property;
      
      private static var _borderRightPriorityProperty:Property;
      
      private static var _borderTopPriorityProperty:Property;
      
      private static var _borderBottomPriorityProperty:Property;
      
      private static var _marginLeftProperty:Property;
      
      private static var _marginRightProperty:Property;
      
      private static var _marginTopProperty:Property;
      
      private static var _marginBottomProperty:Property;
      
      private static var _cellSpacingProperty:Property;
      
      private static var _cellPaddingProperty:Property;
      
      private static var _tableWidthProperty:Property;
      
      private static var _tableColumnWidthProperty:Property;
      
      private static var _minCellHeightProperty:Property;
      
      private static var _maxCellHeightProperty:Property;
      
      private static var _frameProperty:Property;
      
      private static var _rulesProperty:Property;
      
      private static var _description:Object = {
         "columnBreakBefore":columnBreakBeforeProperty,
         "columnBreakAfter":columnBreakAfterProperty,
         "containerBreakBefore":containerBreakBeforeProperty,
         "containerBreakAfter":containerBreakAfterProperty,
         "color":colorProperty,
         "backgroundColor":backgroundColorProperty,
         "lineThrough":lineThroughProperty,
         "textAlpha":textAlphaProperty,
         "backgroundAlpha":backgroundAlphaProperty,
         "fontSize":fontSizeProperty,
         "baselineShift":baselineShiftProperty,
         "trackingLeft":trackingLeftProperty,
         "trackingRight":trackingRightProperty,
         "lineHeight":lineHeightProperty,
         "breakOpportunity":breakOpportunityProperty,
         "digitCase":digitCaseProperty,
         "digitWidth":digitWidthProperty,
         "dominantBaseline":dominantBaselineProperty,
         "kerning":kerningProperty,
         "ligatureLevel":ligatureLevelProperty,
         "alignmentBaseline":alignmentBaselineProperty,
         "locale":localeProperty,
         "typographicCase":typographicCaseProperty,
         "fontFamily":fontFamilyProperty,
         "textDecoration":textDecorationProperty,
         "fontWeight":fontWeightProperty,
         "fontStyle":fontStyleProperty,
         "whiteSpaceCollapse":whiteSpaceCollapseProperty,
         "renderingMode":renderingModeProperty,
         "cffHinting":cffHintingProperty,
         "fontLookup":fontLookupProperty,
         "textRotation":textRotationProperty,
         "textIndent":textIndentProperty,
         "paragraphStartIndent":paragraphStartIndentProperty,
         "paragraphEndIndent":paragraphEndIndentProperty,
         "paragraphSpaceBefore":paragraphSpaceBeforeProperty,
         "paragraphSpaceAfter":paragraphSpaceAfterProperty,
         "textAlign":textAlignProperty,
         "textAlignLast":textAlignLastProperty,
         "textJustify":textJustifyProperty,
         "justificationRule":justificationRuleProperty,
         "justificationStyle":justificationStyleProperty,
         "direction":directionProperty,
         "wordSpacing":wordSpacingProperty,
         "tabStops":tabStopsProperty,
         "leadingModel":leadingModelProperty,
         "columnGap":columnGapProperty,
         "paddingLeft":paddingLeftProperty,
         "paddingTop":paddingTopProperty,
         "paddingRight":paddingRightProperty,
         "paddingBottom":paddingBottomProperty,
         "columnCount":columnCountProperty,
         "columnWidth":columnWidthProperty,
         "firstBaselineOffset":firstBaselineOffsetProperty,
         "verticalAlign":verticalAlignProperty,
         "blockProgression":blockProgressionProperty,
         "lineBreak":lineBreakProperty,
         "listStyleType":listStyleTypeProperty,
         "listStylePosition":listStylePositionProperty,
         "listAutoPadding":listAutoPaddingProperty,
         "clearFloats":clearFloatsProperty,
         "styleName":styleNameProperty,
         "linkNormalFormat":linkNormalFormatProperty,
         "linkActiveFormat":linkActiveFormatProperty,
         "linkHoverFormat":linkHoverFormatProperty,
         "listMarkerFormat":listMarkerFormatProperty,
         "borderLeftWidth":borderLeftWidthProperty,
         "borderRightWidth":borderRightWidthProperty,
         "borderTopWidth":borderTopWidthProperty,
         "borderBottomWidth":borderBottomWidthProperty,
         "borderLeftColor":borderLeftColorProperty,
         "borderRightColor":borderRightColorProperty,
         "borderTopColor":borderTopColorProperty,
         "borderBottomColor":borderBottomColorProperty,
         "marginLeft":marginLeftProperty,
         "marginRight":marginRightProperty,
         "marginTop":marginTopProperty,
         "marginBottom":marginBottomProperty,
         "cellSpacing":cellSpacingProperty,
         "cellPadding":cellPaddingProperty,
         "tableWidth":tableWidthProperty,
         "tableColumnWidth":tableColumnWidthProperty,
         "frame":frameProperty,
         "rules":rulesProperty,
         "borderLeftPriority":borderLeftPriorityProperty,
         "borderRightPriority":borderRightPriorityProperty,
         "borderTopPriority":borderTopPriorityProperty,
         "borderBottomPriority":borderBottomPriorityProperty,
         "minCellHeight":minCellHeightProperty,
         "maxCellHeight":maxCellHeightProperty
      };
      
      private static var _emptyTextLayoutFormat:ITextLayoutFormat;
      
      private static const _emptyStyles:Object = new Object();
      
      private static var _defaults:TextLayoutFormat;
       
      
      private var _styles:Object;
      
      private var _sharedStyles:Boolean;
      
      public function TextLayoutFormat(param1:ITextLayoutFormat = null)
      {
         super();
         this.copy(param1);
      }
      
      public static function get columnBreakBeforeProperty() : Property
      {
         if(!_columnBreakBeforeProperty)
         {
            _columnBreakBeforeProperty = Property.NewEnumStringProperty("columnBreakBefore",BreakStyle.AUTO,false,Vector.<String>([Category.PARAGRAPH]),BreakStyle.AUTO,BreakStyle.ALWAYS);
         }
         return _columnBreakBeforeProperty;
      }
      
      public static function get columnBreakAfterProperty() : Property
      {
         if(!_columnBreakAfterProperty)
         {
            _columnBreakAfterProperty = Property.NewEnumStringProperty("columnBreakAfter",BreakStyle.AUTO,false,Vector.<String>([Category.PARAGRAPH]),BreakStyle.AUTO,BreakStyle.ALWAYS);
         }
         return _columnBreakAfterProperty;
      }
      
      public static function get containerBreakBeforeProperty() : Property
      {
         if(!_containerBreakBeforeProperty)
         {
            _containerBreakBeforeProperty = Property.NewEnumStringProperty("containerBreakBefore",BreakStyle.AUTO,false,Vector.<String>([Category.PARAGRAPH]),BreakStyle.AUTO,BreakStyle.ALWAYS);
         }
         return _containerBreakBeforeProperty;
      }
      
      public static function get containerBreakAfterProperty() : Property
      {
         if(!_containerBreakAfterProperty)
         {
            _containerBreakAfterProperty = Property.NewEnumStringProperty("containerBreakAfter",BreakStyle.AUTO,false,Vector.<String>([Category.PARAGRAPH]),BreakStyle.AUTO,BreakStyle.ALWAYS);
         }
         return _containerBreakAfterProperty;
      }
      
      public static function get colorProperty() : Property
      {
         if(!_colorProperty)
         {
            _colorProperty = Property.NewUintOrEnumProperty("color",0,true,Vector.<String>([Category.CHARACTER]),ColorName.BLACK,ColorName.GREEN,ColorName.GRAY,ColorName.BLUE,ColorName.SILVER,ColorName.LIME,ColorName.OLIVE,ColorName.WHITE,ColorName.YELLOW,ColorName.MAROON,ColorName.NAVY,ColorName.RED,ColorName.PURPLE,ColorName.TEAL,ColorName.FUCHSIA,ColorName.AQUA,ColorName.MAGENTA,ColorName.CYAN);
         }
         return _colorProperty;
      }
      
      public static function get backgroundColorProperty() : Property
      {
         if(!_backgroundColorProperty)
         {
            _backgroundColorProperty = Property.NewUintOrEnumProperty("backgroundColor",BackgroundColor.TRANSPARENT,false,Vector.<String>([Category.CHARACTER,Category.PARAGRAPH,Category.CONTAINER,Category.TABLE,Category.TABLEROW,Category.TABLECOLUMN,Category.TABLECELL]),BackgroundColor.TRANSPARENT);
         }
         return _backgroundColorProperty;
      }
      
      public static function get lineThroughProperty() : Property
      {
         if(!_lineThroughProperty)
         {
            _lineThroughProperty = Property.NewBooleanProperty("lineThrough",false,true,Vector.<String>([Category.CHARACTER]));
         }
         return _lineThroughProperty;
      }
      
      public static function get textAlphaProperty() : Property
      {
         if(!_textAlphaProperty)
         {
            _textAlphaProperty = Property.NewNumberProperty("textAlpha",1,true,Vector.<String>([Category.CHARACTER]),0,1);
         }
         return _textAlphaProperty;
      }
      
      public static function get backgroundAlphaProperty() : Property
      {
         if(!_backgroundAlphaProperty)
         {
            _backgroundAlphaProperty = Property.NewNumberProperty("backgroundAlpha",1,false,Vector.<String>([Category.CHARACTER]),0,1);
         }
         return _backgroundAlphaProperty;
      }
      
      public static function get fontSizeProperty() : Property
      {
         if(!_fontSizeProperty)
         {
            _fontSizeProperty = Property.NewNumberProperty("fontSize",12,true,Vector.<String>([Category.CHARACTER]),1,720);
         }
         return _fontSizeProperty;
      }
      
      public static function get baselineShiftProperty() : Property
      {
         if(!_baselineShiftProperty)
         {
            _baselineShiftProperty = Property.NewNumberOrPercentOrEnumProperty("baselineShift",0,true,Vector.<String>([Category.CHARACTER]),-1000,1000,"-1000%","1000%",BaselineShift.SUPERSCRIPT,BaselineShift.SUBSCRIPT);
         }
         return _baselineShiftProperty;
      }
      
      public static function get trackingLeftProperty() : Property
      {
         if(!_trackingLeftProperty)
         {
            _trackingLeftProperty = Property.NewNumberOrPercentProperty("trackingLeft",0,true,Vector.<String>([Category.CHARACTER]),-1000,1000,"-1000%","1000%");
         }
         return _trackingLeftProperty;
      }
      
      public static function get trackingRightProperty() : Property
      {
         if(!_trackingRightProperty)
         {
            _trackingRightProperty = Property.NewNumberOrPercentProperty("trackingRight",0,true,Vector.<String>([Category.CHARACTER]),-1000,1000,"-1000%","1000%");
         }
         return _trackingRightProperty;
      }
      
      public static function get lineHeightProperty() : Property
      {
         if(!_lineHeightProperty)
         {
            _lineHeightProperty = Property.NewNumberOrPercentProperty("lineHeight","120%",true,Vector.<String>([Category.CHARACTER]),-720,720,"-1000%","1000%");
         }
         return _lineHeightProperty;
      }
      
      public static function get breakOpportunityProperty() : Property
      {
         if(!_breakOpportunityProperty)
         {
            _breakOpportunityProperty = Property.NewEnumStringProperty("breakOpportunity",BreakOpportunity.AUTO,true,Vector.<String>([Category.CHARACTER]),BreakOpportunity.ALL,BreakOpportunity.ANY,BreakOpportunity.AUTO,BreakOpportunity.NONE);
         }
         return _breakOpportunityProperty;
      }
      
      public static function get digitCaseProperty() : Property
      {
         if(!_digitCaseProperty)
         {
            _digitCaseProperty = Property.NewEnumStringProperty("digitCase",DigitCase.DEFAULT,true,Vector.<String>([Category.CHARACTER]),DigitCase.DEFAULT,DigitCase.LINING,DigitCase.OLD_STYLE);
         }
         return _digitCaseProperty;
      }
      
      public static function get digitWidthProperty() : Property
      {
         if(!_digitWidthProperty)
         {
            _digitWidthProperty = Property.NewEnumStringProperty("digitWidth",DigitWidth.DEFAULT,true,Vector.<String>([Category.CHARACTER]),DigitWidth.DEFAULT,DigitWidth.PROPORTIONAL,DigitWidth.TABULAR);
         }
         return _digitWidthProperty;
      }
      
      public static function get dominantBaselineProperty() : Property
      {
         if(!_dominantBaselineProperty)
         {
            _dominantBaselineProperty = Property.NewEnumStringProperty("dominantBaseline",FormatValue.AUTO,true,Vector.<String>([Category.CHARACTER]),FormatValue.AUTO,TextBaseline.ROMAN,TextBaseline.ASCENT,TextBaseline.DESCENT,TextBaseline.IDEOGRAPHIC_TOP,TextBaseline.IDEOGRAPHIC_CENTER,TextBaseline.IDEOGRAPHIC_BOTTOM);
         }
         return _dominantBaselineProperty;
      }
      
      public static function get kerningProperty() : Property
      {
         if(!_kerningProperty)
         {
            _kerningProperty = Property.NewEnumStringProperty("kerning",Kerning.AUTO,true,Vector.<String>([Category.CHARACTER]),Kerning.ON,Kerning.OFF,Kerning.AUTO);
         }
         return _kerningProperty;
      }
      
      public static function get ligatureLevelProperty() : Property
      {
         if(!_ligatureLevelProperty)
         {
            _ligatureLevelProperty = Property.NewEnumStringProperty("ligatureLevel",LigatureLevel.COMMON,true,Vector.<String>([Category.CHARACTER]),LigatureLevel.MINIMUM,LigatureLevel.COMMON,LigatureLevel.UNCOMMON,LigatureLevel.EXOTIC);
         }
         return _ligatureLevelProperty;
      }
      
      public static function get alignmentBaselineProperty() : Property
      {
         if(!_alignmentBaselineProperty)
         {
            _alignmentBaselineProperty = Property.NewEnumStringProperty("alignmentBaseline",TextBaseline.USE_DOMINANT_BASELINE,true,Vector.<String>([Category.CHARACTER]),TextBaseline.ROMAN,TextBaseline.ASCENT,TextBaseline.DESCENT,TextBaseline.IDEOGRAPHIC_TOP,TextBaseline.IDEOGRAPHIC_CENTER,TextBaseline.IDEOGRAPHIC_BOTTOM,TextBaseline.USE_DOMINANT_BASELINE);
         }
         return _alignmentBaselineProperty;
      }
      
      public static function get localeProperty() : Property
      {
         if(!_localeProperty)
         {
            _localeProperty = Property.NewStringProperty("locale","en",true,Vector.<String>([Category.CHARACTER,Category.PARAGRAPH]));
         }
         return _localeProperty;
      }
      
      public static function get typographicCaseProperty() : Property
      {
         if(!_typographicCaseProperty)
         {
            _typographicCaseProperty = Property.NewEnumStringProperty("typographicCase",TLFTypographicCase.DEFAULT,true,Vector.<String>([Category.CHARACTER]),TLFTypographicCase.DEFAULT,TLFTypographicCase.CAPS_TO_SMALL_CAPS,TLFTypographicCase.UPPERCASE,TLFTypographicCase.LOWERCASE,TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS);
         }
         return _typographicCaseProperty;
      }
      
      public static function get fontFamilyProperty() : Property
      {
         if(!_fontFamilyProperty)
         {
            _fontFamilyProperty = Property.NewStringProperty("fontFamily","Arial",true,Vector.<String>([Category.CHARACTER]));
         }
         return _fontFamilyProperty;
      }
      
      public static function get textDecorationProperty() : Property
      {
         if(!_textDecorationProperty)
         {
            _textDecorationProperty = Property.NewEnumStringProperty("textDecoration",TextDecoration.NONE,true,Vector.<String>([Category.CHARACTER]),TextDecoration.NONE,TextDecoration.UNDERLINE);
         }
         return _textDecorationProperty;
      }
      
      public static function get fontWeightProperty() : Property
      {
         if(!_fontWeightProperty)
         {
            _fontWeightProperty = Property.NewEnumStringProperty("fontWeight",FontWeight.NORMAL,true,Vector.<String>([Category.CHARACTER]),FontWeight.NORMAL,FontWeight.BOLD);
         }
         return _fontWeightProperty;
      }
      
      public static function get fontStyleProperty() : Property
      {
         if(!_fontStyleProperty)
         {
            _fontStyleProperty = Property.NewEnumStringProperty("fontStyle",FontPosture.NORMAL,true,Vector.<String>([Category.CHARACTER]),FontPosture.NORMAL,FontPosture.ITALIC);
         }
         return _fontStyleProperty;
      }
      
      public static function get whiteSpaceCollapseProperty() : Property
      {
         if(!_whiteSpaceCollapseProperty)
         {
            _whiteSpaceCollapseProperty = Property.NewEnumStringProperty("whiteSpaceCollapse",WhiteSpaceCollapse.COLLAPSE,true,Vector.<String>([Category.CHARACTER]),WhiteSpaceCollapse.PRESERVE,WhiteSpaceCollapse.COLLAPSE);
         }
         return _whiteSpaceCollapseProperty;
      }
      
      public static function get renderingModeProperty() : Property
      {
         if(!_renderingModeProperty)
         {
            _renderingModeProperty = Property.NewEnumStringProperty("renderingMode",RenderingMode.CFF,true,Vector.<String>([Category.CHARACTER]),RenderingMode.NORMAL,RenderingMode.CFF);
         }
         return _renderingModeProperty;
      }
      
      public static function get cffHintingProperty() : Property
      {
         if(!_cffHintingProperty)
         {
            _cffHintingProperty = Property.NewEnumStringProperty("cffHinting",CFFHinting.HORIZONTAL_STEM,true,Vector.<String>([Category.CHARACTER]),CFFHinting.NONE,CFFHinting.HORIZONTAL_STEM);
         }
         return _cffHintingProperty;
      }
      
      public static function get fontLookupProperty() : Property
      {
         if(!_fontLookupProperty)
         {
            _fontLookupProperty = Property.NewEnumStringProperty("fontLookup",FontLookup.DEVICE,true,Vector.<String>([Category.CHARACTER]),FontLookup.DEVICE,FontLookup.EMBEDDED_CFF);
         }
         return _fontLookupProperty;
      }
      
      public static function get textRotationProperty() : Property
      {
         if(!_textRotationProperty)
         {
            _textRotationProperty = Property.NewEnumStringProperty("textRotation",TextRotation.AUTO,true,Vector.<String>([Category.CHARACTER]),TextRotation.ROTATE_0,TextRotation.ROTATE_180,TextRotation.ROTATE_270,TextRotation.ROTATE_90,TextRotation.AUTO);
         }
         return _textRotationProperty;
      }
      
      public static function get textIndentProperty() : Property
      {
         if(!_textIndentProperty)
         {
            _textIndentProperty = Property.NewNumberProperty("textIndent",0,true,Vector.<String>([Category.PARAGRAPH]),-8000,8000);
         }
         return _textIndentProperty;
      }
      
      public static function get paragraphStartIndentProperty() : Property
      {
         if(!_paragraphStartIndentProperty)
         {
            _paragraphStartIndentProperty = Property.NewNumberProperty("paragraphStartIndent",0,true,Vector.<String>([Category.PARAGRAPH]),0,8000);
         }
         return _paragraphStartIndentProperty;
      }
      
      public static function get paragraphEndIndentProperty() : Property
      {
         if(!_paragraphEndIndentProperty)
         {
            _paragraphEndIndentProperty = Property.NewNumberProperty("paragraphEndIndent",0,true,Vector.<String>([Category.PARAGRAPH]),0,8000);
         }
         return _paragraphEndIndentProperty;
      }
      
      public static function get paragraphSpaceBeforeProperty() : Property
      {
         if(!_paragraphSpaceBeforeProperty)
         {
            _paragraphSpaceBeforeProperty = Property.NewNumberProperty("paragraphSpaceBefore",0,true,Vector.<String>([Category.PARAGRAPH]),0,8000);
         }
         return _paragraphSpaceBeforeProperty;
      }
      
      public static function get paragraphSpaceAfterProperty() : Property
      {
         if(!_paragraphSpaceAfterProperty)
         {
            _paragraphSpaceAfterProperty = Property.NewNumberProperty("paragraphSpaceAfter",0,true,Vector.<String>([Category.PARAGRAPH]),0,8000);
         }
         return _paragraphSpaceAfterProperty;
      }
      
      public static function get textAlignProperty() : Property
      {
         if(!_textAlignProperty)
         {
            _textAlignProperty = Property.NewEnumStringProperty("textAlign",TextAlign.START,true,Vector.<String>([Category.PARAGRAPH,Category.TABLE,Category.TABLECELL,Category.TABLEROW,Category.TABLECOLUMN]),TextAlign.LEFT,TextAlign.RIGHT,TextAlign.CENTER,TextAlign.JUSTIFY,TextAlign.START,TextAlign.END);
         }
         return _textAlignProperty;
      }
      
      public static function get textAlignLastProperty() : Property
      {
         if(!_textAlignLastProperty)
         {
            _textAlignLastProperty = Property.NewEnumStringProperty("textAlignLast",TextAlign.START,true,Vector.<String>([Category.PARAGRAPH]),TextAlign.LEFT,TextAlign.RIGHT,TextAlign.CENTER,TextAlign.JUSTIFY,TextAlign.START,TextAlign.END);
         }
         return _textAlignLastProperty;
      }
      
      public static function get textJustifyProperty() : Property
      {
         if(!_textJustifyProperty)
         {
            _textJustifyProperty = Property.NewEnumStringProperty("textJustify",TextJustify.INTER_WORD,true,Vector.<String>([Category.PARAGRAPH]),TextJustify.INTER_WORD,TextJustify.DISTRIBUTE);
         }
         return _textJustifyProperty;
      }
      
      public static function get justificationRuleProperty() : Property
      {
         if(!_justificationRuleProperty)
         {
            _justificationRuleProperty = Property.NewEnumStringProperty("justificationRule",FormatValue.AUTO,true,Vector.<String>([Category.PARAGRAPH]),JustificationRule.EAST_ASIAN,JustificationRule.SPACE,FormatValue.AUTO);
         }
         return _justificationRuleProperty;
      }
      
      public static function get justificationStyleProperty() : Property
      {
         if(!_justificationStyleProperty)
         {
            _justificationStyleProperty = Property.NewEnumStringProperty("justificationStyle",FormatValue.AUTO,true,Vector.<String>([Category.PARAGRAPH]),JustificationStyle.PRIORITIZE_LEAST_ADJUSTMENT,JustificationStyle.PUSH_IN_KINSOKU,JustificationStyle.PUSH_OUT_ONLY,FormatValue.AUTO);
         }
         return _justificationStyleProperty;
      }
      
      public static function get directionProperty() : Property
      {
         if(!_directionProperty)
         {
            _directionProperty = Property.NewEnumStringProperty("direction",Direction.LTR,true,Vector.<String>([Category.PARAGRAPH,Category.TABLE,Category.TABLECELL,Category.TABLEROW,Category.TABLECOLUMN]),Direction.LTR,Direction.RTL);
         }
         return _directionProperty;
      }
      
      public static function get wordSpacingProperty() : Property
      {
         if(!_wordSpacingProperty)
         {
            _wordSpacingProperty = Property.NewSpacingLimitProperty("wordSpacing","100%, 50%, 150%",true,Vector.<String>([Category.PARAGRAPH]),"-1000%","1000%");
         }
         return _wordSpacingProperty;
      }
      
      public static function get tabStopsProperty() : Property
      {
         if(!_tabStopsProperty)
         {
            _tabStopsProperty = Property.NewTabStopsProperty("tabStops",null,true,Vector.<String>([Category.PARAGRAPH]));
         }
         return _tabStopsProperty;
      }
      
      public static function get leadingModelProperty() : Property
      {
         if(!_leadingModelProperty)
         {
            _leadingModelProperty = Property.NewEnumStringProperty("leadingModel",LeadingModel.AUTO,true,Vector.<String>([Category.PARAGRAPH]),LeadingModel.ROMAN_UP,LeadingModel.IDEOGRAPHIC_TOP_UP,LeadingModel.IDEOGRAPHIC_CENTER_UP,LeadingModel.IDEOGRAPHIC_TOP_DOWN,LeadingModel.IDEOGRAPHIC_CENTER_DOWN,LeadingModel.APPROXIMATE_TEXT_FIELD,LeadingModel.ASCENT_DESCENT_UP,LeadingModel.BOX,LeadingModel.AUTO);
         }
         return _leadingModelProperty;
      }
      
      public static function get columnGapProperty() : Property
      {
         if(!_columnGapProperty)
         {
            _columnGapProperty = Property.NewNumberProperty("columnGap",20,false,Vector.<String>([Category.CONTAINER]),0,1000);
         }
         return _columnGapProperty;
      }
      
      public static function get paddingLeftProperty() : Property
      {
         if(!_paddingLeftProperty)
         {
            _paddingLeftProperty = Property.NewNumberOrEnumProperty("paddingLeft",FormatValue.AUTO,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000,FormatValue.AUTO);
         }
         return _paddingLeftProperty;
      }
      
      public static function get paddingTopProperty() : Property
      {
         if(!_paddingTopProperty)
         {
            _paddingTopProperty = Property.NewNumberOrEnumProperty("paddingTop",FormatValue.AUTO,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000,FormatValue.AUTO);
         }
         return _paddingTopProperty;
      }
      
      public static function get paddingRightProperty() : Property
      {
         if(!_paddingRightProperty)
         {
            _paddingRightProperty = Property.NewNumberOrEnumProperty("paddingRight",FormatValue.AUTO,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000,FormatValue.AUTO);
         }
         return _paddingRightProperty;
      }
      
      public static function get paddingBottomProperty() : Property
      {
         if(!_paddingBottomProperty)
         {
            _paddingBottomProperty = Property.NewNumberOrEnumProperty("paddingBottom",FormatValue.AUTO,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000,FormatValue.AUTO);
         }
         return _paddingBottomProperty;
      }
      
      public static function get columnCountProperty() : Property
      {
         if(!_columnCountProperty)
         {
            _columnCountProperty = Property.NewIntOrEnumProperty("columnCount",FormatValue.AUTO,false,Vector.<String>([Category.CONTAINER]),1,50,FormatValue.AUTO);
         }
         return _columnCountProperty;
      }
      
      public static function get columnWidthProperty() : Property
      {
         if(!_columnWidthProperty)
         {
            _columnWidthProperty = Property.NewNumberOrEnumProperty("columnWidth",FormatValue.AUTO,false,Vector.<String>([Category.CONTAINER]),0,8000,FormatValue.AUTO);
         }
         return _columnWidthProperty;
      }
      
      public static function get firstBaselineOffsetProperty() : Property
      {
         if(!_firstBaselineOffsetProperty)
         {
            _firstBaselineOffsetProperty = Property.NewNumberOrEnumProperty("firstBaselineOffset",BaselineOffset.AUTO,true,Vector.<String>([Category.CONTAINER]),0,1000,BaselineOffset.AUTO,BaselineOffset.ASCENT,BaselineOffset.LINE_HEIGHT);
         }
         return _firstBaselineOffsetProperty;
      }
      
      public static function get verticalAlignProperty() : Property
      {
         if(!_verticalAlignProperty)
         {
            _verticalAlignProperty = Property.NewEnumStringProperty("verticalAlign",VerticalAlign.TOP,false,Vector.<String>([Category.CONTAINER,Category.TABLECELL,Category.TABLE,Category.TABLEROW,Category.TABLECOLUMN]),VerticalAlign.TOP,VerticalAlign.MIDDLE,VerticalAlign.BOTTOM,VerticalAlign.JUSTIFY);
         }
         return _verticalAlignProperty;
      }
      
      public static function get blockProgressionProperty() : Property
      {
         if(!_blockProgressionProperty)
         {
            _blockProgressionProperty = Property.NewEnumStringProperty("blockProgression",BlockProgression.TB,true,Vector.<String>([Category.CONTAINER]),BlockProgression.RL,BlockProgression.TB);
         }
         return _blockProgressionProperty;
      }
      
      public static function get lineBreakProperty() : Property
      {
         if(!_lineBreakProperty)
         {
            _lineBreakProperty = Property.NewEnumStringProperty("lineBreak",LineBreak.TO_FIT,false,Vector.<String>([Category.CONTAINER,Category.TABLECELL]),LineBreak.EXPLICIT,LineBreak.TO_FIT);
         }
         return _lineBreakProperty;
      }
      
      public static function get listStyleTypeProperty() : Property
      {
         if(!_listStyleTypeProperty)
         {
            _listStyleTypeProperty = Property.NewEnumStringProperty("listStyleType",ListStyleType.DISC,true,Vector.<String>([Category.LIST]),ListStyleType.UPPER_ALPHA,ListStyleType.LOWER_ALPHA,ListStyleType.UPPER_ROMAN,ListStyleType.LOWER_ROMAN,ListStyleType.NONE,ListStyleType.DISC,ListStyleType.CIRCLE,ListStyleType.SQUARE,ListStyleType.BOX,ListStyleType.CHECK,ListStyleType.DIAMOND,ListStyleType.HYPHEN,ListStyleType.ARABIC_INDIC,ListStyleType.BENGALI,ListStyleType.DECIMAL,ListStyleType.DECIMAL_LEADING_ZERO,ListStyleType.DEVANAGARI,ListStyleType.GUJARATI,ListStyleType.GURMUKHI,ListStyleType.KANNADA,ListStyleType.PERSIAN,ListStyleType.THAI,ListStyleType.URDU,ListStyleType.CJK_EARTHLY_BRANCH,ListStyleType.CJK_HEAVENLY_STEM,ListStyleType.HANGUL,ListStyleType.HANGUL_CONSTANT,ListStyleType.HIRAGANA,ListStyleType.HIRAGANA_IROHA,ListStyleType.KATAKANA,ListStyleType.KATAKANA_IROHA,ListStyleType.LOWER_ALPHA,ListStyleType.LOWER_GREEK,ListStyleType.LOWER_LATIN,ListStyleType.UPPER_ALPHA,ListStyleType.UPPER_GREEK,ListStyleType.UPPER_LATIN);
         }
         return _listStyleTypeProperty;
      }
      
      public static function get listStylePositionProperty() : Property
      {
         if(!_listStylePositionProperty)
         {
            _listStylePositionProperty = Property.NewEnumStringProperty("listStylePosition",ListStylePosition.OUTSIDE,true,Vector.<String>([Category.LIST]),ListStylePosition.INSIDE,ListStylePosition.OUTSIDE);
         }
         return _listStylePositionProperty;
      }
      
      public static function get listAutoPaddingProperty() : Property
      {
         if(!_listAutoPaddingProperty)
         {
            _listAutoPaddingProperty = Property.NewNumberProperty("listAutoPadding",40,true,Vector.<String>([Category.CONTAINER]),-1000,1000);
         }
         return _listAutoPaddingProperty;
      }
      
      public static function get clearFloatsProperty() : Property
      {
         if(!_clearFloatsProperty)
         {
            _clearFloatsProperty = Property.NewEnumStringProperty("clearFloats",ClearFloats.NONE,false,Vector.<String>([Category.PARAGRAPH]),ClearFloats.START,ClearFloats.END,ClearFloats.LEFT,ClearFloats.RIGHT,ClearFloats.BOTH,ClearFloats.NONE);
         }
         return _clearFloatsProperty;
      }
      
      public static function get styleNameProperty() : Property
      {
         if(!_styleNameProperty)
         {
            _styleNameProperty = Property.NewStringProperty("styleName",null,false,Vector.<String>([Category.STYLE]));
         }
         return _styleNameProperty;
      }
      
      public static function get linkNormalFormatProperty() : Property
      {
         if(!_linkNormalFormatProperty)
         {
            _linkNormalFormatProperty = Property.NewTextLayoutFormatProperty("linkNormalFormat",null,true,Vector.<String>([Category.STYLE]));
         }
         return _linkNormalFormatProperty;
      }
      
      public static function get linkActiveFormatProperty() : Property
      {
         if(!_linkActiveFormatProperty)
         {
            _linkActiveFormatProperty = Property.NewTextLayoutFormatProperty("linkActiveFormat",null,true,Vector.<String>([Category.STYLE]));
         }
         return _linkActiveFormatProperty;
      }
      
      public static function get linkHoverFormatProperty() : Property
      {
         if(!_linkHoverFormatProperty)
         {
            _linkHoverFormatProperty = Property.NewTextLayoutFormatProperty("linkHoverFormat",null,true,Vector.<String>([Category.STYLE]));
         }
         return _linkHoverFormatProperty;
      }
      
      public static function get listMarkerFormatProperty() : Property
      {
         if(!_listMarkerFormatProperty)
         {
            _listMarkerFormatProperty = Property.NewListMarkerFormatProperty("listMarkerFormat",null,true,Vector.<String>([Category.STYLE]));
         }
         return _listMarkerFormatProperty;
      }
      
      public static function get borderLeftWidthProperty() : Property
      {
         if(!_borderLeftWidthProperty)
         {
            _borderLeftWidthProperty = Property.NewNumberProperty("borderLeftWidth",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),0,128);
         }
         return _borderLeftWidthProperty;
      }
      
      public static function get borderRightWidthProperty() : Property
      {
         if(!_borderRightWidthProperty)
         {
            _borderRightWidthProperty = Property.NewNumberProperty("borderRightWidth",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),0,128);
         }
         return _borderRightWidthProperty;
      }
      
      public static function get borderTopWidthProperty() : Property
      {
         if(!_borderTopWidthProperty)
         {
            _borderTopWidthProperty = Property.NewNumberProperty("borderTopWidth",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),0,128);
         }
         return _borderTopWidthProperty;
      }
      
      public static function get borderBottomWidthProperty() : Property
      {
         if(!_borderBottomWidthProperty)
         {
            _borderBottomWidthProperty = Property.NewNumberProperty("borderBottomWidth",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),0,128);
         }
         return _borderBottomWidthProperty;
      }
      
      public static function get borderLeftColorProperty() : Property
      {
         if(!_borderLeftColorProperty)
         {
            _borderLeftColorProperty = Property.NewUintOrEnumProperty("borderLeftColor",BorderColor.TRANSPARENT,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),BorderColor.TRANSPARENT);
         }
         return _borderLeftColorProperty;
      }
      
      public static function get borderRightColorProperty() : Property
      {
         if(!_borderRightColorProperty)
         {
            _borderRightColorProperty = Property.NewUintOrEnumProperty("borderRightColor",BorderColor.TRANSPARENT,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),BorderColor.TRANSPARENT);
         }
         return _borderRightColorProperty;
      }
      
      public static function get borderTopColorProperty() : Property
      {
         if(!_borderTopColorProperty)
         {
            _borderTopColorProperty = Property.NewUintOrEnumProperty("borderTopColor",BorderColor.TRANSPARENT,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),BorderColor.TRANSPARENT);
         }
         return _borderTopColorProperty;
      }
      
      public static function get borderBottomColorProperty() : Property
      {
         if(!_borderBottomColorProperty)
         {
            _borderBottomColorProperty = Property.NewUintOrEnumProperty("borderBottomColor",BorderColor.TRANSPARENT,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),BorderColor.TRANSPARENT);
         }
         return _borderBottomColorProperty;
      }
      
      public static function get borderLeftPriorityProperty() : Property
      {
         if(!_borderLeftPriorityProperty)
         {
            _borderLeftPriorityProperty = Property.NewNumberProperty("borderLeftPriority",0,false,Vector.<String>([Category.TABLE,Category.TABLECELL,Category.TABLECOLUMN,Category.TABLEROW]),-8000,8000);
         }
         return _borderLeftPriorityProperty;
      }
      
      public static function get borderRightPriorityProperty() : Property
      {
         if(!_borderRightPriorityProperty)
         {
            _borderRightPriorityProperty = Property.NewNumberProperty("borderRightPriority",0,false,Vector.<String>([Category.TABLE,Category.TABLECELL,Category.TABLECOLUMN,Category.TABLEROW]),-8000,8000);
         }
         return _borderRightPriorityProperty;
      }
      
      public static function get borderTopPriorityProperty() : Property
      {
         if(!_borderTopPriorityProperty)
         {
            _borderTopPriorityProperty = Property.NewNumberProperty("borderTopPriority",0,false,Vector.<String>([Category.TABLE,Category.TABLECELL,Category.TABLECOLUMN,Category.TABLEROW]),-8000,8000);
         }
         return _borderTopPriorityProperty;
      }
      
      public static function get borderBottomPriorityProperty() : Property
      {
         if(!_borderBottomPriorityProperty)
         {
            _borderBottomPriorityProperty = Property.NewNumberProperty("borderBottomPriority",0,false,Vector.<String>([Category.TABLE,Category.TABLECELL,Category.TABLECOLUMN,Category.TABLEROW]),-8000,8000);
         }
         return _borderBottomPriorityProperty;
      }
      
      public static function get marginLeftProperty() : Property
      {
         if(!_marginLeftProperty)
         {
            _marginLeftProperty = Property.NewNumberProperty("marginLeft",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000);
         }
         return _marginLeftProperty;
      }
      
      public static function get marginRightProperty() : Property
      {
         if(!_marginRightProperty)
         {
            _marginRightProperty = Property.NewNumberProperty("marginRight",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000);
         }
         return _marginRightProperty;
      }
      
      public static function get marginTopProperty() : Property
      {
         if(!_marginTopProperty)
         {
            _marginTopProperty = Property.NewNumberProperty("marginTop",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000);
         }
         return _marginTopProperty;
      }
      
      public static function get marginBottomProperty() : Property
      {
         if(!_marginBottomProperty)
         {
            _marginBottomProperty = Property.NewNumberProperty("marginBottom",0,false,Vector.<String>([Category.CONTAINER,Category.PARAGRAPH]),-8000,8000);
         }
         return _marginBottomProperty;
      }
      
      public static function get cellSpacingProperty() : Property
      {
         if(!_cellSpacingProperty)
         {
            _cellSpacingProperty = Property.NewNumberProperty("cellSpacing",0,false,Vector.<String>([Category.TABLE]),0,1000);
         }
         return _cellSpacingProperty;
      }
      
      public static function get cellPaddingProperty() : Property
      {
         if(!_cellPaddingProperty)
         {
            _cellPaddingProperty = Property.NewNumberOrPercentProperty("cellPadding",0,true,Vector.<String>([Category.TABLE]),0,1000,"0%","100%");
         }
         return _cellPaddingProperty;
      }
      
      public static function get tableWidthProperty() : Property
      {
         if(!_tableWidthProperty)
         {
            _tableWidthProperty = Property.NewNumberOrPercentProperty("tableWidth","100%",false,Vector.<String>([Category.TABLE]),0,8000,"0%","100%");
         }
         return _tableWidthProperty;
      }
      
      public static function get tableColumnWidthProperty() : Property
      {
         if(!_tableColumnWidthProperty)
         {
            _tableColumnWidthProperty = Property.NewNumberOrPercentProperty("tableColumnWidth",0,false,Vector.<String>([Category.TABLECOLUMN]),0,8000,"0%","100%");
         }
         return _tableColumnWidthProperty;
      }
      
      public static function get minCellHeightProperty() : Property
      {
         if(!_minCellHeightProperty)
         {
            _minCellHeightProperty = Property.NewNumberOrEnumProperty("minCellHeight",2,false,Vector.<String>([Category.TABLE,Category.TABLECELL]),2,8000);
         }
         return _minCellHeightProperty;
      }
      
      public static function get maxCellHeightProperty() : Property
      {
         if(!_maxCellHeightProperty)
         {
            _maxCellHeightProperty = Property.NewNumberOrEnumProperty("maxCellHeight",8000,false,Vector.<String>([Category.TABLE,Category.TABLECELL]),2,8000);
         }
         return _maxCellHeightProperty;
      }
      
      public static function get frameProperty() : Property
      {
         if(!_frameProperty)
         {
            _frameProperty = Property.NewEnumStringProperty("frame",TableFrame.VOID,false,Vector.<String>([Category.TABLE]),TableFrame.VOID,TableFrame.ABOVE,TableFrame.BELOW,TableFrame.HSIDES,TableFrame.VSIDES,TableFrame.LHS,TableFrame.RHS,TableFrame.BOX,TableFrame.BORDER);
         }
         return _frameProperty;
      }
      
      public static function get rulesProperty() : Property
      {
         if(!_rulesProperty)
         {
            _rulesProperty = Property.NewEnumStringProperty("rules",TableRules.NONE,false,Vector.<String>([Category.TABLE]),TableRules.NONE,TableRules.GROUPS,TableRules.ROWS,TableRules.COLS,TableRules.ALL);
         }
         return _rulesProperty;
      }
      
      tlf_internal static function get description() : Object
      {
         return _description;
      }
      
      tlf_internal static function get emptyTextLayoutFormat() : ITextLayoutFormat
      {
         if(_emptyTextLayoutFormat == null)
         {
            _emptyTextLayoutFormat = new TextLayoutFormat();
         }
         return _emptyTextLayoutFormat;
      }
      
      public static function isEqual(param1:ITextLayoutFormat, param2:ITextLayoutFormat) : Boolean
      {
         var _loc5_:Property = null;
         if(param1 == null)
         {
            param1 = emptyTextLayoutFormat;
         }
         if(param2 == null)
         {
            param2 = emptyTextLayoutFormat;
         }
         if(param1 == param2)
         {
            return true;
         }
         var _loc3_:TextLayoutFormat = param1 as TextLayoutFormat;
         var _loc4_:TextLayoutFormat = param2 as TextLayoutFormat;
         if(_loc3_ && _loc4_)
         {
            return Property.equalStyles(_loc3_.getStyles(),_loc4_.getStyles(),TextLayoutFormat.description);
         }
         for each(_loc5_ in TextLayoutFormat.description)
         {
            if(!_loc5_.equalHelper(param1[_loc5_.name],param2[_loc5_.name]))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function get defaultFormat() : ITextLayoutFormat
      {
         if(_defaults == null)
         {
            _defaults = new TextLayoutFormat();
            Property.defaultsAllHelper(_description,_defaults);
         }
         return _defaults;
      }
      
      tlf_internal static function resetModifiedNoninheritedStyles(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc2_)
         {
            _loc2_.writableStyles();
            param1 = _loc2_.getStyles();
         }
         if(param1.columnBreakBefore != undefined && param1.columnBreakBefore != TextLayoutFormat.columnBreakBeforeProperty.defaultValue)
         {
            param1.columnBreakBefore = TextLayoutFormat.columnBreakBeforeProperty.defaultValue;
         }
         if(param1.columnBreakAfter != undefined && param1.columnBreakAfter != TextLayoutFormat.columnBreakAfterProperty.defaultValue)
         {
            param1.columnBreakAfter = TextLayoutFormat.columnBreakAfterProperty.defaultValue;
         }
         if(param1.containerBreakBefore != undefined && param1.containerBreakBefore != TextLayoutFormat.containerBreakBeforeProperty.defaultValue)
         {
            param1.containerBreakBefore = TextLayoutFormat.containerBreakBeforeProperty.defaultValue;
         }
         if(param1.containerBreakAfter != undefined && param1.containerBreakAfter != TextLayoutFormat.containerBreakAfterProperty.defaultValue)
         {
            param1.containerBreakAfter = TextLayoutFormat.containerBreakAfterProperty.defaultValue;
         }
         if(param1.backgroundColor != undefined && param1.backgroundColor != TextLayoutFormat.backgroundColorProperty.defaultValue)
         {
            param1.backgroundColor = TextLayoutFormat.backgroundColorProperty.defaultValue;
         }
         if(param1.backgroundAlpha != undefined && param1.backgroundAlpha != TextLayoutFormat.backgroundAlphaProperty.defaultValue)
         {
            param1.backgroundAlpha = TextLayoutFormat.backgroundAlphaProperty.defaultValue;
         }
         if(param1.columnGap != undefined && param1.columnGap != TextLayoutFormat.columnGapProperty.defaultValue)
         {
            param1.columnGap = TextLayoutFormat.columnGapProperty.defaultValue;
         }
         if(param1.paddingLeft != undefined && param1.paddingLeft != TextLayoutFormat.paddingLeftProperty.defaultValue)
         {
            param1.paddingLeft = TextLayoutFormat.paddingLeftProperty.defaultValue;
         }
         if(param1.paddingTop != undefined && param1.paddingTop != TextLayoutFormat.paddingTopProperty.defaultValue)
         {
            param1.paddingTop = TextLayoutFormat.paddingTopProperty.defaultValue;
         }
         if(param1.paddingRight != undefined && param1.paddingRight != TextLayoutFormat.paddingRightProperty.defaultValue)
         {
            param1.paddingRight = TextLayoutFormat.paddingRightProperty.defaultValue;
         }
         if(param1.paddingBottom != undefined && param1.paddingBottom != TextLayoutFormat.paddingBottomProperty.defaultValue)
         {
            param1.paddingBottom = TextLayoutFormat.paddingBottomProperty.defaultValue;
         }
         if(param1.columnCount != undefined && param1.columnCount != TextLayoutFormat.columnCountProperty.defaultValue)
         {
            param1.columnCount = TextLayoutFormat.columnCountProperty.defaultValue;
         }
         if(param1.columnWidth != undefined && param1.columnWidth != TextLayoutFormat.columnWidthProperty.defaultValue)
         {
            param1.columnWidth = TextLayoutFormat.columnWidthProperty.defaultValue;
         }
         if(param1.verticalAlign != undefined && param1.verticalAlign != TextLayoutFormat.verticalAlignProperty.defaultValue)
         {
            param1.verticalAlign = TextLayoutFormat.verticalAlignProperty.defaultValue;
         }
         if(param1.lineBreak != undefined && param1.lineBreak != TextLayoutFormat.lineBreakProperty.defaultValue)
         {
            param1.lineBreak = TextLayoutFormat.lineBreakProperty.defaultValue;
         }
         if(param1.clearFloats != undefined && param1.clearFloats != TextLayoutFormat.clearFloatsProperty.defaultValue)
         {
            param1.clearFloats = TextLayoutFormat.clearFloatsProperty.defaultValue;
         }
         if(param1.styleName != undefined && param1.styleName != TextLayoutFormat.styleNameProperty.defaultValue)
         {
            param1.styleName = TextLayoutFormat.styleNameProperty.defaultValue;
         }
         if(param1.borderLeftWidth != undefined && param1.borderLeftWidth != TextLayoutFormat.borderLeftWidthProperty.defaultValue)
         {
            param1.borderLeftWidth = TextLayoutFormat.borderLeftWidthProperty.defaultValue;
         }
         if(param1.borderRightWidth != undefined && param1.borderRightWidth != TextLayoutFormat.borderRightWidthProperty.defaultValue)
         {
            param1.borderRightWidth = TextLayoutFormat.borderRightWidthProperty.defaultValue;
         }
         if(param1.borderTopWidth != undefined && param1.borderTopWidth != TextLayoutFormat.borderTopWidthProperty.defaultValue)
         {
            param1.borderTopWidth = TextLayoutFormat.borderTopWidthProperty.defaultValue;
         }
         if(param1.borderBottomWidth != undefined && param1.borderBottomWidth != TextLayoutFormat.borderBottomWidthProperty.defaultValue)
         {
            param1.borderBottomWidth = TextLayoutFormat.borderBottomWidthProperty.defaultValue;
         }
         if(param1.borderLeftColor != undefined && param1.borderLeftColor != TextLayoutFormat.borderLeftColorProperty.defaultValue)
         {
            param1.borderLeftColor = TextLayoutFormat.borderLeftColorProperty.defaultValue;
         }
         if(param1.borderRightColor != undefined && param1.borderRightColor != TextLayoutFormat.borderRightColorProperty.defaultValue)
         {
            param1.borderRightColor = TextLayoutFormat.borderRightColorProperty.defaultValue;
         }
         if(param1.borderTopColor != undefined && param1.borderTopColor != TextLayoutFormat.borderTopColorProperty.defaultValue)
         {
            param1.borderTopColor = TextLayoutFormat.borderTopColorProperty.defaultValue;
         }
         if(param1.borderBottomColor != undefined && param1.borderBottomColor != TextLayoutFormat.borderBottomColorProperty.defaultValue)
         {
            param1.borderBottomColor = TextLayoutFormat.borderBottomColorProperty.defaultValue;
         }
         if(param1.marginLeft != undefined && param1.marginLeft != TextLayoutFormat.marginLeftProperty.defaultValue)
         {
            param1.marginLeft = TextLayoutFormat.marginLeftProperty.defaultValue;
         }
         if(param1.marginRight != undefined && param1.marginRight != TextLayoutFormat.marginRightProperty.defaultValue)
         {
            param1.marginRight = TextLayoutFormat.marginRightProperty.defaultValue;
         }
         if(param1.marginTop != undefined && param1.marginTop != TextLayoutFormat.marginTopProperty.defaultValue)
         {
            param1.marginTop = TextLayoutFormat.marginTopProperty.defaultValue;
         }
         if(param1.marginBottom != undefined && param1.marginBottom != TextLayoutFormat.marginBottomProperty.defaultValue)
         {
            param1.marginBottom = TextLayoutFormat.marginBottomProperty.defaultValue;
         }
         if(param1.cellSpacing != undefined && param1.cellSpacing != TextLayoutFormat.cellSpacingProperty.defaultValue)
         {
            param1.cellSpacing = TextLayoutFormat.cellSpacingProperty.defaultValue;
         }
         if(param1.tableWidth != undefined && param1.tableWidth != TextLayoutFormat.tableWidthProperty.defaultValue)
         {
            param1.tableWidth = TextLayoutFormat.tableWidthProperty.defaultValue;
         }
         if(param1.tableColumnWidth != undefined && param1.tableColumnWidth != TextLayoutFormat.tableColumnWidthProperty.defaultValue)
         {
            param1.tableColumnWidth = TextLayoutFormat.tableColumnWidthProperty.defaultValue;
         }
         if(param1.frame != undefined && param1.frame != TextLayoutFormat.frameProperty.defaultValue)
         {
            param1.frame = TextLayoutFormat.frameProperty.defaultValue;
         }
         if(param1.rules != undefined && param1.rules != TextLayoutFormat.rulesProperty.defaultValue)
         {
            param1.rules = TextLayoutFormat.rulesProperty.defaultValue;
         }
         if(param1.borderBottomPriority != undefined && param1.borderBottomPriority != TextLayoutFormat.borderBottomPriorityProperty.defaultValue)
         {
            param1.borderBottomPriority = TextLayoutFormat.borderBottomPriorityProperty.defaultValue;
         }
         if(param1.borderTopPriority != undefined && param1.borderTopPriority != TextLayoutFormat.borderTopPriorityProperty.defaultValue)
         {
            param1.borderTopPriority = TextLayoutFormat.borderTopPriorityProperty.defaultValue;
         }
         if(param1.borderLeftPriority != undefined && param1.borderLeftPriority != TextLayoutFormat.borderLeftPriorityProperty.defaultValue)
         {
            param1.borderLeftPriority = TextLayoutFormat.borderLeftPriorityProperty.defaultValue;
         }
         if(param1.borderRightPriority != undefined && param1.borderRightPriority != TextLayoutFormat.borderRightPriorityProperty.defaultValue)
         {
            param1.borderRightPriority = TextLayoutFormat.borderRightPriorityProperty.defaultValue;
         }
         if(param1.minCellHeight != undefined && param1.minCellHeight != TextLayoutFormat.minCellHeightProperty.defaultValue)
         {
            param1.minCellHeight = TextLayoutFormat.minCellHeightProperty.defaultValue;
         }
         if(param1.maxCellHeight != undefined && param1.maxCellHeight != TextLayoutFormat.maxCellHeightProperty.defaultValue)
         {
            param1.maxCellHeight = TextLayoutFormat.maxCellHeightProperty.defaultValue;
         }
      }
      
      public static function createTextLayoutFormat(param1:Object) : TextLayoutFormat
      {
         var _loc4_:* = null;
         var _loc2_:ITextLayoutFormat = param1 as ITextLayoutFormat;
         var _loc3_:TextLayoutFormat = new TextLayoutFormat(_loc2_);
         if(_loc2_ == null && param1)
         {
            for(_loc4_ in param1)
            {
               _loc3_.setStyle(_loc4_,param1[_loc4_]);
            }
         }
         return _loc3_;
      }
      
      private function writableStyles() : void
      {
         if(this._sharedStyles)
         {
            this._styles = this._styles == _emptyStyles?new Object():Property.createObjectWithPrototype(this._styles);
            this._sharedStyles = false;
         }
      }
      
      tlf_internal function getStyles() : Object
      {
         return this._styles == _emptyStyles?null:this._styles;
      }
      
      tlf_internal function setStyles(param1:Object, param2:Boolean) : void
      {
         if(this._styles != param1)
         {
            this._styles = param1;
            this._sharedStyles = param2;
         }
      }
      
      tlf_internal function clearStyles() : void
      {
         this._styles = _emptyStyles;
         this._sharedStyles = true;
      }
      
      public function get coreStyles() : Object
      {
         return this._styles == _emptyStyles?null:Property.shallowCopyInFilter(this._styles,description);
      }
      
      public function get userStyles() : Object
      {
         return this._styles == _emptyStyles?null:Property.shallowCopyNotInFilter(this._styles,description);
      }
      
      public function get styles() : Object
      {
         return this._styles == _emptyStyles?null:Property.shallowCopy(this._styles);
      }
      
      tlf_internal function setStyleByName(param1:String, param2:*) : void
      {
         this.writableStyles();
         if(param2 !== undefined)
         {
            this._styles[param1] = param2;
         }
         else
         {
            delete this._styles[param1];
            if(this._styles[param1] !== undefined)
            {
               this._styles = Property.shallowCopy(this._styles);
               delete this._styles[param1];
            }
         }
      }
      
      private function setStyleByProperty(param1:Property, param2:*) : void
      {
         var _loc3_:String = param1.name;
         param2 = param1.setHelper(this._styles[_loc3_],param2);
         this.setStyleByName(_loc3_,param2);
      }
      
      public function setStyle(param1:String, param2:*) : void
      {
         if(description.hasOwnProperty(param1))
         {
            this[param1] = param2;
         }
         else
         {
            this.setStyleByName(param1,param2);
         }
      }
      
      public function getStyle(param1:String) : *
      {
         return this._styles[param1];
      }
      
      public function copy(param1:ITextLayoutFormat) : void
      {
         var _loc3_:Property = null;
         var _loc4_:* = undefined;
         if(this == param1)
         {
            return;
         }
         var _loc2_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc2_)
         {
            this._styles = _loc2_._styles;
            this._sharedStyles = true;
            _loc2_._sharedStyles = true;
            return;
         }
         this._styles = _emptyStyles;
         this._sharedStyles = true;
         if(param1)
         {
            for each(_loc3_ in TextLayoutFormat.description)
            {
               _loc4_ = param1[_loc3_.name];
               if(_loc4_ !== undefined)
               {
                  this[_loc3_.name] = _loc4_;
               }
            }
         }
      }
      
      public function concat(param1:ITextLayoutFormat) : void
      {
         var _loc3_:Property = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc2_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc2_)
         {
            _loc4_ = _loc2_._styles;
            for(_loc5_ in _loc4_)
            {
               _loc3_ = description[_loc5_];
               if(_loc3_)
               {
                  this.setStyleByProperty(_loc3_,_loc3_.concatHelper(this._styles[_loc5_],_loc4_[_loc5_]));
               }
               else
               {
                  this.setStyleByName(_loc5_,Property.defaultConcatHelper(this._styles[_loc5_],_loc4_[_loc5_]));
               }
            }
            return;
         }
         for each(_loc3_ in TextLayoutFormat.description)
         {
            this.setStyleByProperty(_loc3_,_loc3_.concatHelper(this._styles[_loc3_.name],param1[_loc3_.name]));
         }
      }
      
      public function concatInheritOnly(param1:ITextLayoutFormat) : void
      {
         var _loc3_:Property = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc2_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc2_)
         {
            _loc4_ = _loc2_._styles;
            for(_loc5_ in _loc4_)
            {
               _loc3_ = description[_loc5_];
               if(_loc3_)
               {
                  this.setStyleByProperty(_loc3_,_loc3_.concatInheritOnlyHelper(this._styles[_loc5_],_loc4_[_loc5_]));
               }
               else
               {
                  this.setStyleByName(_loc5_,Property.defaultConcatHelper(this._styles[_loc5_],_loc4_[_loc5_]));
               }
            }
            return;
         }
         for each(_loc3_ in TextLayoutFormat.description)
         {
            this.setStyleByProperty(_loc3_,_loc3_.concatInheritOnlyHelper(this._styles[_loc3_.name],param1[_loc3_.name]));
         }
      }
      
      public function apply(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Property = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc2_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc2_)
         {
            _loc5_ = _loc2_._styles;
            for(_loc6_ in _loc5_)
            {
               _loc3_ = _loc5_[_loc6_];
               if(_loc3_ !== undefined)
               {
                  this.setStyle(_loc6_,_loc3_);
               }
            }
            return;
         }
         for each(_loc4_ in TextLayoutFormat.description)
         {
            _loc7_ = _loc4_.name;
            _loc3_ = param1[_loc7_];
            if(_loc3_ !== undefined)
            {
               this.setStyle(_loc7_,_loc3_);
            }
         }
      }
      
      public function removeMatching(param1:ITextLayoutFormat) : void
      {
         var _loc2_:Property = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc3_)
         {
            _loc4_ = _loc3_._styles;
            for(_loc5_ in _loc4_)
            {
               _loc2_ = description[_loc5_];
               if(_loc2_)
               {
                  if(_loc2_.equalHelper(this._styles[_loc5_],_loc4_[_loc5_]))
                  {
                     this[_loc5_] = undefined;
                  }
               }
               else if(this._styles[_loc5_] == _loc4_[_loc5_])
               {
                  this.setStyle(_loc5_,undefined);
               }
            }
            return;
         }
         for each(_loc2_ in TextLayoutFormat.description)
         {
            if(_loc2_.equalHelper(this._styles[_loc2_.name],param1[_loc2_.name]))
            {
               this[_loc2_.name] = undefined;
            }
         }
      }
      
      public function removeClashing(param1:ITextLayoutFormat) : void
      {
         var _loc2_:Property = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:TextLayoutFormat = param1 as TextLayoutFormat;
         if(_loc3_)
         {
            _loc4_ = _loc3_._styles;
            for(_loc5_ in _loc4_)
            {
               _loc2_ = description[_loc5_];
               if(_loc2_)
               {
                  if(!_loc2_.equalHelper(this._styles[_loc5_],_loc4_[_loc5_]))
                  {
                     this[_loc5_] = undefined;
                  }
               }
               else if(this._styles[_loc5_] != _loc4_[_loc5_])
               {
                  this.setStyle(_loc5_,undefined);
               }
            }
            return;
         }
         for each(_loc2_ in TextLayoutFormat.description)
         {
            if(!_loc2_.equalHelper(this._styles[_loc2_.name],param1[_loc2_.name]))
            {
               this[_loc2_.name] = undefined;
            }
         }
      }
      
      public function get columnBreakBefore() : *
      {
         return this._styles.columnBreakBefore;
      }
      
      public function set columnBreakBefore(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.columnBreakBeforeProperty,param1);
      }
      
      public function get columnBreakAfter() : *
      {
         return this._styles.columnBreakAfter;
      }
      
      public function set columnBreakAfter(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.columnBreakAfterProperty,param1);
      }
      
      public function get containerBreakBefore() : *
      {
         return this._styles.containerBreakBefore;
      }
      
      public function set containerBreakBefore(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.containerBreakBeforeProperty,param1);
      }
      
      public function get containerBreakAfter() : *
      {
         return this._styles.containerBreakAfter;
      }
      
      public function set containerBreakAfter(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.containerBreakAfterProperty,param1);
      }
      
      public function get color() : *
      {
         return this._styles.color;
      }
      
      public function set color(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.colorProperty,param1);
      }
      
      public function get backgroundColor() : *
      {
         return this._styles.backgroundColor;
      }
      
      public function set backgroundColor(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.backgroundColorProperty,param1);
      }
      
      public function get lineThrough() : *
      {
         return this._styles.lineThrough;
      }
      
      public function set lineThrough(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.lineThroughProperty,param1);
      }
      
      public function get textAlpha() : *
      {
         return this._styles.textAlpha;
      }
      
      public function set textAlpha(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textAlphaProperty,param1);
      }
      
      public function get backgroundAlpha() : *
      {
         return this._styles.backgroundAlpha;
      }
      
      public function set backgroundAlpha(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.backgroundAlphaProperty,param1);
      }
      
      public function get fontSize() : *
      {
         return this._styles.fontSize;
      }
      
      public function set fontSize(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.fontSizeProperty,param1);
      }
      
      public function get baselineShift() : *
      {
         return this._styles.baselineShift;
      }
      
      public function set baselineShift(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.baselineShiftProperty,param1);
      }
      
      public function get trackingLeft() : *
      {
         return this._styles.trackingLeft;
      }
      
      public function set trackingLeft(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.trackingLeftProperty,param1);
      }
      
      public function get trackingRight() : *
      {
         return this._styles.trackingRight;
      }
      
      public function set trackingRight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.trackingRightProperty,param1);
      }
      
      public function get lineHeight() : *
      {
         return this._styles.lineHeight;
      }
      
      public function set lineHeight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.lineHeightProperty,param1);
      }
      
      public function get breakOpportunity() : *
      {
         return this._styles.breakOpportunity;
      }
      
      public function set breakOpportunity(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.breakOpportunityProperty,param1);
      }
      
      public function get digitCase() : *
      {
         return this._styles.digitCase;
      }
      
      public function set digitCase(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.digitCaseProperty,param1);
      }
      
      public function get digitWidth() : *
      {
         return this._styles.digitWidth;
      }
      
      public function set digitWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.digitWidthProperty,param1);
      }
      
      public function get dominantBaseline() : *
      {
         return this._styles.dominantBaseline;
      }
      
      public function set dominantBaseline(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.dominantBaselineProperty,param1);
      }
      
      public function get kerning() : *
      {
         return this._styles.kerning;
      }
      
      public function set kerning(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.kerningProperty,param1);
      }
      
      public function get ligatureLevel() : *
      {
         return this._styles.ligatureLevel;
      }
      
      public function set ligatureLevel(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.ligatureLevelProperty,param1);
      }
      
      public function get alignmentBaseline() : *
      {
         return this._styles.alignmentBaseline;
      }
      
      public function set alignmentBaseline(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.alignmentBaselineProperty,param1);
      }
      
      public function get locale() : *
      {
         return this._styles.locale;
      }
      
      public function set locale(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.localeProperty,param1);
      }
      
      public function get typographicCase() : *
      {
         return this._styles.typographicCase;
      }
      
      public function set typographicCase(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.typographicCaseProperty,param1);
      }
      
      public function get fontFamily() : *
      {
         return this._styles.fontFamily;
      }
      
      public function set fontFamily(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.fontFamilyProperty,param1);
      }
      
      public function get textDecoration() : *
      {
         return this._styles.textDecoration;
      }
      
      public function set textDecoration(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textDecorationProperty,param1);
      }
      
      public function get fontWeight() : *
      {
         return this._styles.fontWeight;
      }
      
      public function set fontWeight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.fontWeightProperty,param1);
      }
      
      public function get fontStyle() : *
      {
         return this._styles.fontStyle;
      }
      
      public function set fontStyle(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.fontStyleProperty,param1);
      }
      
      public function get whiteSpaceCollapse() : *
      {
         return this._styles.whiteSpaceCollapse;
      }
      
      public function set whiteSpaceCollapse(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.whiteSpaceCollapseProperty,param1);
      }
      
      public function get renderingMode() : *
      {
         return this._styles.renderingMode;
      }
      
      public function set renderingMode(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.renderingModeProperty,param1);
      }
      
      public function get cffHinting() : *
      {
         return this._styles.cffHinting;
      }
      
      public function set cffHinting(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.cffHintingProperty,param1);
      }
      
      public function get fontLookup() : *
      {
         return this._styles.fontLookup;
      }
      
      public function set fontLookup(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.fontLookupProperty,param1);
      }
      
      public function get textRotation() : *
      {
         return this._styles.textRotation;
      }
      
      public function set textRotation(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textRotationProperty,param1);
      }
      
      public function get textIndent() : *
      {
         return this._styles.textIndent;
      }
      
      public function set textIndent(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textIndentProperty,param1);
      }
      
      public function get paragraphStartIndent() : *
      {
         return this._styles.paragraphStartIndent;
      }
      
      public function set paragraphStartIndent(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paragraphStartIndentProperty,param1);
      }
      
      public function get paragraphEndIndent() : *
      {
         return this._styles.paragraphEndIndent;
      }
      
      public function set paragraphEndIndent(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paragraphEndIndentProperty,param1);
      }
      
      public function get paragraphSpaceBefore() : *
      {
         return this._styles.paragraphSpaceBefore;
      }
      
      public function set paragraphSpaceBefore(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paragraphSpaceBeforeProperty,param1);
      }
      
      public function get paragraphSpaceAfter() : *
      {
         return this._styles.paragraphSpaceAfter;
      }
      
      public function set paragraphSpaceAfter(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paragraphSpaceAfterProperty,param1);
      }
      
      public function get textAlign() : *
      {
         return this._styles.textAlign;
      }
      
      public function set textAlign(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textAlignProperty,param1);
      }
      
      public function get textAlignLast() : *
      {
         return this._styles.textAlignLast;
      }
      
      public function set textAlignLast(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textAlignLastProperty,param1);
      }
      
      public function get textJustify() : *
      {
         return this._styles.textJustify;
      }
      
      public function set textJustify(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.textJustifyProperty,param1);
      }
      
      public function get justificationRule() : *
      {
         return this._styles.justificationRule;
      }
      
      public function set justificationRule(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.justificationRuleProperty,param1);
      }
      
      public function get justificationStyle() : *
      {
         return this._styles.justificationStyle;
      }
      
      public function set justificationStyle(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.justificationStyleProperty,param1);
      }
      
      public function get direction() : *
      {
         return this._styles.direction;
      }
      
      public function set direction(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.directionProperty,param1);
      }
      
      public function get wordSpacing() : *
      {
         return this._styles.wordSpacing;
      }
      
      public function set wordSpacing(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.wordSpacingProperty,param1);
      }
      
      public function get tabStops() : *
      {
         return this._styles.tabStops;
      }
      
      public function set tabStops(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.tabStopsProperty,param1);
      }
      
      public function get leadingModel() : *
      {
         return this._styles.leadingModel;
      }
      
      public function set leadingModel(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.leadingModelProperty,param1);
      }
      
      public function get columnGap() : *
      {
         return this._styles.columnGap;
      }
      
      public function set columnGap(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.columnGapProperty,param1);
      }
      
      public function get paddingLeft() : *
      {
         return this._styles.paddingLeft;
      }
      
      public function set paddingLeft(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paddingLeftProperty,param1);
      }
      
      public function get paddingTop() : *
      {
         return this._styles.paddingTop;
      }
      
      public function set paddingTop(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paddingTopProperty,param1);
      }
      
      public function get paddingRight() : *
      {
         return this._styles.paddingRight;
      }
      
      public function set paddingRight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paddingRightProperty,param1);
      }
      
      public function get paddingBottom() : *
      {
         return this._styles.paddingBottom;
      }
      
      public function set paddingBottom(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.paddingBottomProperty,param1);
      }
      
      public function get columnCount() : *
      {
         return this._styles.columnCount;
      }
      
      public function set columnCount(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.columnCountProperty,param1);
      }
      
      public function get columnWidth() : *
      {
         return this._styles.columnWidth;
      }
      
      public function set columnWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.columnWidthProperty,param1);
      }
      
      public function get firstBaselineOffset() : *
      {
         return this._styles.firstBaselineOffset;
      }
      
      public function set firstBaselineOffset(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.firstBaselineOffsetProperty,param1);
      }
      
      public function get verticalAlign() : *
      {
         return this._styles.verticalAlign;
      }
      
      public function set verticalAlign(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.verticalAlignProperty,param1);
      }
      
      public function get blockProgression() : *
      {
         return this._styles.blockProgression;
      }
      
      public function set blockProgression(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.blockProgressionProperty,param1);
      }
      
      public function get lineBreak() : *
      {
         return this._styles.lineBreak;
      }
      
      public function set lineBreak(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.lineBreakProperty,param1);
      }
      
      public function get listStyleType() : *
      {
         return this._styles.listStyleType;
      }
      
      public function set listStyleType(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.listStyleTypeProperty,param1);
      }
      
      public function get listStylePosition() : *
      {
         return this._styles.listStylePosition;
      }
      
      public function set listStylePosition(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.listStylePositionProperty,param1);
      }
      
      public function get listAutoPadding() : *
      {
         return this._styles.listAutoPadding;
      }
      
      public function set listAutoPadding(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.listAutoPaddingProperty,param1);
      }
      
      public function get clearFloats() : *
      {
         return this._styles.clearFloats;
      }
      
      public function set clearFloats(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.clearFloatsProperty,param1);
      }
      
      public function get styleName() : *
      {
         return this._styles.styleName;
      }
      
      public function set styleName(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.styleNameProperty,param1);
      }
      
      public function get linkNormalFormat() : *
      {
         return this._styles.linkNormalFormat;
      }
      
      public function set linkNormalFormat(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.linkNormalFormatProperty,param1);
      }
      
      public function get linkActiveFormat() : *
      {
         return this._styles.linkActiveFormat;
      }
      
      public function set linkActiveFormat(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.linkActiveFormatProperty,param1);
      }
      
      public function get linkHoverFormat() : *
      {
         return this._styles.linkHoverFormat;
      }
      
      public function set linkHoverFormat(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.linkHoverFormatProperty,param1);
      }
      
      public function get listMarkerFormat() : *
      {
         return this._styles.listMarkerFormat;
      }
      
      public function set listMarkerFormat(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.listMarkerFormatProperty,param1);
      }
      
      public function get borderLeftWidth() : *
      {
         return this._styles.borderLeftWidth;
      }
      
      public function set borderLeftWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderLeftWidthProperty,param1);
      }
      
      public function get borderRightWidth() : *
      {
         return this._styles.borderRightWidth;
      }
      
      public function set borderRightWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderRightWidthProperty,param1);
      }
      
      public function get borderTopWidth() : *
      {
         return this._styles.borderTopWidth;
      }
      
      public function set borderTopWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderTopWidthProperty,param1);
      }
      
      public function get borderBottomWidth() : *
      {
         return this._styles.borderBottomWidth;
      }
      
      public function set borderBottomWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderBottomWidthProperty,param1);
      }
      
      public function get borderLeftColor() : *
      {
         return this._styles.borderLeftColor;
      }
      
      public function set borderLeftColor(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderLeftColorProperty,param1);
      }
      
      public function get borderRightColor() : *
      {
         return this._styles.borderRightColor;
      }
      
      public function set borderRightColor(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderRightColorProperty,param1);
      }
      
      public function get borderTopColor() : *
      {
         return this._styles.borderTopColor;
      }
      
      public function set borderTopColor(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderTopColorProperty,param1);
      }
      
      public function get borderBottomColor() : *
      {
         return this._styles.borderBottomColor;
      }
      
      public function set borderBottomColor(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderBottomColorProperty,param1);
      }
      
      public function get borderLeftPriority() : *
      {
         return this._styles.borderLeftPriority;
      }
      
      public function set borderLeftPriority(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderLeftPriorityProperty,param1);
      }
      
      public function get borderRightPriority() : *
      {
         return this._styles.borderRightPriority;
      }
      
      public function set borderRightPriority(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderRightPriorityProperty,param1);
      }
      
      public function get borderTopPriority() : *
      {
         return this._styles.borderTopPriority;
      }
      
      public function set borderTopPriority(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderTopPriorityProperty,param1);
      }
      
      public function get borderBottomPriority() : *
      {
         return this._styles.borderBottomPriority;
      }
      
      public function set borderBottomPriority(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.borderBottomPriorityProperty,param1);
      }
      
      public function get marginLeft() : *
      {
         return this._styles.marginLeft;
      }
      
      public function set marginLeft(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.marginLeftProperty,param1);
      }
      
      public function get marginRight() : *
      {
         return this._styles.marginRight;
      }
      
      public function set marginRight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.marginRightProperty,param1);
      }
      
      public function get marginTop() : *
      {
         return this._styles.marginTop;
      }
      
      public function set marginTop(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.marginTopProperty,param1);
      }
      
      public function get marginBottom() : *
      {
         return this._styles.marginBottom;
      }
      
      public function set marginBottom(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.marginBottomProperty,param1);
      }
      
      public function get cellSpacing() : *
      {
         return this._styles.cellSpacing;
      }
      
      public function set cellSpacing(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.cellSpacingProperty,param1);
      }
      
      public function get cellPadding() : *
      {
         return this._styles.cellPadding;
      }
      
      public function set cellPadding(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.cellPaddingProperty,param1);
      }
      
      public function get tableWidth() : *
      {
         return this._styles.tableWidth;
      }
      
      public function set tableWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.tableWidthProperty,param1);
      }
      
      public function get tableColumnWidth() : *
      {
         return this._styles.tableColumnWidth;
      }
      
      public function set tableColumnWidth(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.tableColumnWidthProperty,param1);
      }
      
      public function get minCellHeight() : *
      {
         return this._styles.minCellHeight;
      }
      
      public function set minCellHeight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.minCellHeightProperty,param1);
      }
      
      public function get maxCellHeight() : *
      {
         return this._styles.maxCellHeight;
      }
      
      public function set maxCellHeight(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.maxCellHeightProperty,param1);
      }
      
      public function get frame() : *
      {
         return this._styles.frame;
      }
      
      public function set frame(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.frameProperty,param1);
      }
      
      public function get rules() : *
      {
         return this._styles.rules;
      }
      
      public function set rules(param1:*) : void
      {
         this.setStyleByProperty(TextLayoutFormat.rulesProperty,param1);
      }
   }
}
