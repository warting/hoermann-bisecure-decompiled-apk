package
{
   import flash.net.getClassByAlias;
   import flash.net.registerClassAlias;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.managers.systemClasses.ChildManager;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManagerImpl;
   import mx.utils.ObjectProxy;
   
   public class _BiSecurApp_FlexInit
   {
       
      
      public function _BiSecurApp_FlexInit()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var styleManager:IStyleManager2 = null;
         var fbs:IFlexModuleFactory = param1;
         new ChildManager(fbs);
         styleManager = new StyleManagerImpl(fbs);
         EffectManager.mx_internal::registerEffectTrigger("addedEffect","added");
         EffectManager.mx_internal::registerEffectTrigger("creationCompleteEffect","creationComplete");
         EffectManager.mx_internal::registerEffectTrigger("focusInEffect","focusIn");
         EffectManager.mx_internal::registerEffectTrigger("focusOutEffect","focusOut");
         EffectManager.mx_internal::registerEffectTrigger("hideEffect","hide");
         EffectManager.mx_internal::registerEffectTrigger("mouseDownEffect","mouseDown");
         EffectManager.mx_internal::registerEffectTrigger("mouseUpEffect","mouseUp");
         EffectManager.mx_internal::registerEffectTrigger("moveEffect","move");
         EffectManager.mx_internal::registerEffectTrigger("removedEffect","removed");
         EffectManager.mx_internal::registerEffectTrigger("resizeEffect","resize");
         EffectManager.mx_internal::registerEffectTrigger("rollOutEffect","rollOut");
         EffectManager.mx_internal::registerEffectTrigger("rollOverEffect","rollOver");
         EffectManager.mx_internal::registerEffectTrigger("showEffect","show");
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayCollection") != ArrayCollection)
            {
               registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayList") != mx.collections.ArrayList)
            {
               registerClassAlias("flex.messaging.io.ArrayList",mx.collections.ArrayList);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayList",mx.collections.ArrayList);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ObjectProxy") != ObjectProxy)
            {
               registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayList") != org.apache.flex.collections.ArrayList)
            {
               registerClassAlias("flex.messaging.io.ArrayList",org.apache.flex.collections.ArrayList);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayList",org.apache.flex.collections.ArrayList);
         }
         var styleNames:Array = ["paragraphStartIndent","breakOpportunity","kerning","alternatingItemColors","wordSpacing","leading","fontAntiAliasType","selectionColor","containerBreakBefore","cffHinting","contentBackgroundAlpha","fontFamily","digitCase","containerBreakAfter","clearFloats","paragraphEndIndent","layoutDirection","ligatureLevel","downColor","dropShadowColor","fontWeight","interactionMode","dominantBaseline","textAlign","accentColor","justificationStyle","fontSharpness","whiteSpaceCollapse","contentBackgroundColor","textDecoration","fontLookup","fontStyle","columnBreakAfter","chromeColor","digitWidth","focusColor","themeColor","listAutoPadding","blockProgression","showPromptWhenFocused","listStyleType","fontSize","columnBreakBefore","textAlignLast","trackingRight","fontGridFitType","paragraphSpaceAfter","showErrorSkin","errorColor","justificationRule","color","backgroundDisabledColor","textShadowColor","unfocusedTextSelectionColor","paragraphSpaceBefore","textIndent","textAlpha","locale","baselineShift","fontThickness","touchDelay","textShadowAlpha","renderingMode","textJustify","textRotation","tabStops","direction","firstBaselineOffset","lineThrough","symbolColor","focusedTextSelectionColor","letterSpacing","disabledColor","alignmentBaseline","trackingLeft","labelPlacement","rollOverColor","listStylePosition","useOpaqueBackground","inactiveTextSelectionColor","lineHeight","leadingModel","showErrorTip","typographicCase"];
         var i:int = 0;
         while(i < styleNames.length)
         {
            styleManager.registerInheritingStyle(styleNames[i]);
            i++;
         }
      }
   }
}
