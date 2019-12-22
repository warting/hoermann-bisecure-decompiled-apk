package
{
   import mx.core.IFlexModuleFactory;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.skins.halo.BusyCursor;
   import mx.skins.halo.DefaultDragImage;
   import mx.skins.halo.HaloFocusRect;
   import mx.skins.halo.ToolTipBorder;
   import mx.styles.CSSCondition;
   import mx.styles.CSSSelector;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.utils.ObjectUtil;
   import spark.components.supportClasses.ListItemDragProxy;
   import spark.skins.ios7.StageTextAreaSkin;
   import spark.skins.ios7.StageTextInputSkin;
   import spark.skins.mobile.ActionBarSkin;
   import spark.skins.mobile.BeveledActionButtonSkin;
   import spark.skins.mobile.BeveledBackButtonSkin;
   import spark.skins.mobile.BusyIndicatorSkin;
   import spark.skins.mobile.ButtonBarSkin;
   import spark.skins.mobile.ButtonSkin;
   import spark.skins.mobile.CalloutActionBarSkin;
   import spark.skins.mobile.CalloutSkin;
   import spark.skins.mobile.CalloutViewNavigatorSkin;
   import spark.skins.mobile.CheckBoxSkin;
   import spark.skins.mobile.DefaultBeveledActionButtonSkin;
   import spark.skins.mobile.DefaultBeveledBackButtonSkin;
   import spark.skins.mobile.DefaultButtonSkin;
   import spark.skins.mobile.DefaultTransparentActionButtonSkin;
   import spark.skins.mobile.DefaultTransparentNavigationButtonSkin;
   import spark.skins.mobile.HScrollBarSkin;
   import spark.skins.mobile.ImageSkin;
   import spark.skins.mobile.ListSkin;
   import spark.skins.mobile.ScrollingStageTextAreaSkin;
   import spark.skins.mobile.ScrollingStageTextInputSkin;
   import spark.skins.mobile.SkinnableContainerSkin;
   import spark.skins.mobile.TabbedViewNavigatorSkin;
   import spark.skins.mobile.TabbedViewNavigatorTabBarSkin;
   import spark.skins.mobile.TextAreaHScrollBarSkin;
   import spark.skins.mobile.TextAreaVScrollBarSkin;
   import spark.skins.mobile.ToggleSwitchSkin;
   import spark.skins.mobile.TransparentActionButtonSkin;
   import spark.skins.mobile.TransparentNavigationButtonSkin;
   import spark.skins.mobile.VScrollBarSkin;
   import spark.skins.mobile.ViewMenuItemSkin;
   import spark.skins.mobile.ViewMenuSkin;
   import spark.skins.mobile.ViewNavigatorApplicationSkin;
   import spark.skins.mobile.ViewNavigatorSkin;
   import spark.skins.spark.ApplicationSkin;
   import spark.skins.spark.BorderContainerSkin;
   import spark.skins.spark.ErrorSkin;
   import spark.skins.spark.FocusSkin;
   import spark.skins.spark.ListDropIndicator;
   import spark.skins.spark.ScrollerSkin;
   import spark.skins.spark.SkinnableDataContainerSkin;
   import spark.skins.spark.SkinnablePopUpContainerSkin;
   import spark.skins.spark.ToggleButtonSkin;
   
   public class _BiSecurApp_Styles
   {
      
      private static var _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragReject_1224370337:Class = _class_embed_css_Assets_swf__1432423865_mx_skins_cursor_DragReject_1224370337;
      
      private static var _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragMove_263169777:Class = _class_embed_css_Assets_swf__1432423865_mx_skins_cursor_DragMove_263169777;
      
      private static var _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragLink_263144202:Class = _class_embed_css_Assets_swf__1432423865_mx_skins_cursor_DragLink_263144202;
      
      private static var _embed_css_Assets_swf__1432423865_mx_skins_cursor_BusyCursor_55297237:Class = _class_embed_css_Assets_swf__1432423865_mx_skins_cursor_BusyCursor_55297237;
      
      private static var _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragCopy_262882197:Class = _class_embed_css_Assets_swf__1432423865_mx_skins_cursor_DragCopy_262882197;
       
      
      public function _BiSecurApp_Styles()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var styleManager:IStyleManager2 = null;
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var mergedStyle:CSSStyleDeclaration = null;
         var fbs:IFlexModuleFactory = param1;
         styleManager = fbs.getImplementation("mx.styles::IStyleManager2") as IStyleManager2;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Application",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Application");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = ApplicationSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.osStatusBarHeight = 15;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.osStatusBarHeight = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:240)"))
               {
                  this.osStatusBarHeight = 30;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.osStatusBarHeight = 40;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.osStatusBarHeight = 60;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:120) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 15;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:160) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:240) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 30;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:320) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 40;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:480) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 60;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:640) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 80;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.osStatusBarHeight = 15;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.osStatusBarHeight = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:240)"))
               {
                  this.osStatusBarHeight = 30;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.osStatusBarHeight = 40;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.osStatusBarHeight = 60;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:120) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 15;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:160) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:240) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 30;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:320) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 40;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:480) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 60;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (application-dpi:640) and (min-os-version:6.0 0.1)"))
               {
                  this.osStatusBarHeight = 80;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.BorderContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.BorderContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = BorderContainerSkin;
               this.borderStyle = "solid";
               this.cornerRadius = 0;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ButtonSkin;
               this.fontWeight = "bold";
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.skinClass = ButtonSkin;
                  this.fontWeight = "bold";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.skinClass = ButtonSkin;
                  this.fontWeight = "bold";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.skinClass = ButtonSkin;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.skinClass = ButtonSkin;
                  this.fontWeight = "bold";
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DefaultButtonSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = DefaultButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = DefaultButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = DefaultButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = DefaultButtonSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar spark.components.Group#navigationGroup spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = TransparentNavigationButtonSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar spark.components.Group#navigationGroup spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DefaultTransparentNavigationButtonSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar.beveled spark.components.Group#navigationGroup spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontSize = 18;
               this.skinClass = BeveledBackButtonSkin;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 36;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 48;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar.beveled spark.components.Group#navigationGroup spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DefaultBeveledBackButtonSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","actionGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar spark.components.Group#actionGroup spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = TransparentActionButtonSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = TransparentActionButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = TransparentActionButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = TransparentActionButtonSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","actionGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar spark.components.Group#actionGroup spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DefaultTransparentActionButtonSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","actionGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar.beveled spark.components.Group#actionGroup spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontSize = 18;
               this.skinClass = BeveledActionButtonSkin;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 36;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 48;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","actionGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar.beveled spark.components.Group#actionGroup spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DefaultBeveledActionButtonSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator spark.components.ActionBar.beveled spark.components.Group#navigationGroup spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = BeveledActionButtonSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = BeveledActionButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = BeveledActionButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = BeveledActionButtonSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator spark.components.ActionBar.beveled spark.components.Group#navigationGroup spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = DefaultBeveledActionButtonSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = DefaultBeveledActionButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = DefaultBeveledActionButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = DefaultBeveledActionButtonSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator spark.components.ActionBar spark.components.Group#navigationGroup spark.components.Button");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","navigationGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","emphasized");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator spark.components.ActionBar spark.components.Group#navigationGroup spark.components.Button.emphasized");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ButtonSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ButtonBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ButtonBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ButtonBarSkin;
               this.fontWeight = "bold";
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.color = 31487;
                  this.skinClass = ButtonBarSkin;
                  this.fontWeight = "bold";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.skinClass = ButtonBarSkin;
                  this.fontWeight = "bold";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.color = 31487;
                  this.skinClass = ButtonBarSkin;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.skinClass = ButtonBarSkin;
                  this.fontWeight = "bold";
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.BusyIndicator",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.BusyIndicator");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.rotationInterval = 50;
               this.skinClass = BusyIndicatorSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.rotationInterval = 50;
                  this.skinClass = BusyIndicatorSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = BusyIndicatorSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.rotationInterval = 30;
                  this.skinClass = BusyIndicatorSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = BusyIndicatorSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.contentBackgroundAppearance = "inset";
               this.borderThickness = "NaN";
               this.backgroundColor = 4737096;
               this.borderColor = 0;
               this.gap = 12;
               this.contentBackgroundColor = 16777215;
               this.skinClass = CalloutSkin;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.gap = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.gap = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.gap = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.gap = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.gap = 12;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.borderThickness = "NaN";
                  this.contentBackgroundAppearance = "inset";
                  this.backgroundColor = 4737096;
                  this.frameThickness = 0;
                  this.gap = 12;
                  this.skinClass = CalloutSkin;
                  this.contentBackgroundColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.borderThickness = "NaN";
                  this.contentBackgroundAppearance = "inset";
                  this.backgroundColor = 4737096;
                  this.borderColor = 0;
                  this.gap = 12;
                  this.contentBackgroundColor = 16777215;
                  this.skinClass = CalloutSkin;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.gap = 6;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.gap = 8;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.gap = 16;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.gap = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.gap = 32;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.borderThickness = 0;
                  this.contentBackgroundAppearance = "flat";
                  this.backgroundColor = 16185078;
                  this.frameThickness = 0;
                  this.gap = 12;
                  this.skinClass = CalloutSkin;
                  this.contentBackgroundColor = 16185078;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.borderThickness = 0;
                  this.contentBackgroundAppearance = "flat";
                  this.backgroundColor = 3388901;
                  this.borderColor = 0;
                  this.gap = 12;
                  this.contentBackgroundColor = 16777215;
                  this.skinClass = CalloutSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("id","viewNavigatorPopUp");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout#viewNavigatorPopUp");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.contentBackgroundAppearance = "none";
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.contentBackgroundAppearance = "none";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.contentBackgroundAppearance = "none";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.contentBackgroundAppearance = "flat";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.contentBackgroundAppearance = "none";
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.CheckBox",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.CheckBox");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.gap = 5;
               this.skinClass = CheckBoxSkin;
               this.labelPlacement = "right";
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = CheckBoxSkin;
                  this.chromeColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = CheckBoxSkin;
                  this.chromeColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = CheckBoxSkin;
                  this.chromeColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = CheckBoxSkin;
                  this.chromeColor = 16777215;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.HScrollBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.HScrollBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = HScrollBarSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.color = 15132390;
                  this.skinClass = HScrollBarSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.color = 3355443;
                  this.skinClass = HScrollBarSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.color = 15132390;
                  this.skinClass = HScrollBarSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.color = 3355443;
                  this.skinClass = HScrollBarSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextArea",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.HScrollBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TextArea spark.components.HScrollBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = TextAreaHScrollBarSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Image",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Image");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.showErrorSkin = false;
               this.enableLoadingState = false;
               this.smoothingQuality = "default";
               this.skinClass = ImageSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.List",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.List");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.borderVisible = false;
               this.borderColor = 0;
               this.dropIndicatorSkin = ListDropIndicator;
               this.skinClass = ListSkin;
               this.dragIndicatorClass = ListItemDragProxy;
               this.borderAlpha = 1;
               this.verticalScrollPolicy = "on";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.RichEditableText",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.RichEditableText");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.layoutDirection = "ltr";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Scroller",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Scroller");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ScrollerSkin;
               this.touchDelay = 100;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableDataContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.SkinnableDataContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = SkinnableDataContainerSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.supportClasses.SkinnableComponent",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.SkinnableComponent");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.errorSkin = ErrorSkin;
               this.focusSkin = FocusSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.SkinnableContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = SkinnableContainerSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnablePopUpContainer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.SkinnablePopUpContainer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = SkinnablePopUpContainerSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("pseudo","normalWithPrompt");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.supportClasses.SkinnableTextBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.SkinnableTextBase:normalWithPrompt");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 12237498;
               this.fontStyle = "normal";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("pseudo","disabledWithPrompt");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.supportClasses.SkinnableTextBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.SkinnableTextBase:disabledWithPrompt");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 12237498;
               this.fontStyle = "normal";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.supportClasses.TextBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.TextBase");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.layoutDirection = "ltr";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextArea",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TextArea");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingBottom = 9;
               this.paddingRight = 9;
               this.showPromptWhenFocused = true;
               this.skinClass = ScrollingStageTextAreaSkin;
               this.paddingTop = 9;
               this.paddingLeft = 9;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:160) and (os-platform:\"IOS\")"))
               {
                  this.leading = 1.5;
                  this.paddingRight = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:320) and (os-platform:\"IOS\")"))
               {
                  this.leading = 4.5;
                  this.paddingRight = 9;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.contentBackgroundBorder = "rectangle";
                  this.borderColor = 13421772;
                  this.focusThickness = 0;
                  this.focusColor = 13421772;
                  this.selectionHighlighting = "never";
                  this.focusAlpha = 0;
                  this.focusEnabled = "false";
                  this.skinClass = ScrollingStageTextAreaSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 1;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.contentBackgroundBorder = "rectangle";
                  this.fontFamily = "RobotoRegular";
                  this.focusThickness = 0;
                  this.focusColor = 3388901;
                  this.selectionHighlighting = "never";
                  this.focusEnabled = "false";
                  this.skinClass = ScrollingStageTextAreaSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 1;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 4;
                  this.paddingTop = 4;
                  this.paddingLeft = 4;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 6;
                  this.paddingRight = 6;
                  this.paddingTop = 6;
                  this.paddingLeft = 6;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 12;
                  this.paddingRight = 12;
                  this.paddingTop = 12;
                  this.paddingLeft = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 18;
                  this.paddingRight = 18;
                  this.paddingTop = 18;
                  this.paddingLeft = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 24;
                  this.paddingTop = 24;
                  this.paddingLeft = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:160) and (os-platform:\"IOS\")"))
               {
                  this.leading = 1.5;
                  this.paddingRight = 1.5;
               }
               if(styleManager.acceptMediaList("(application-dpi:320) and (os-platform:\"IOS\")"))
               {
                  this.leading = 4.5;
                  this.paddingRight = 3;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.contentBackgroundBorder = "rectangle";
                  this.borderColor = 13421772;
                  this.focusThickness = 0;
                  this.focusColor = 13421772;
                  this.selectionHighlighting = "never";
                  this.focusAlpha = 0;
                  this.focusEnabled = "false";
                  this.skinClass = StageTextAreaSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 1;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.contentBackgroundBorder = "rectangle";
                  this.fontFamily = "RobotoRegular";
                  this.focusThickness = 0;
                  this.focusColor = 3388901;
                  this.selectionHighlighting = "never";
                  this.focusEnabled = "false";
                  this.skinClass = StageTextAreaSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 1;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextInput",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TextInput");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingBottom = 9;
               this.paddingRight = 9;
               this.showPromptWhenFocused = true;
               this.skinClass = ScrollingStageTextInputSkin;
               this.paddingTop = 9;
               this.paddingLeft = 9;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 9;
                  this.paddingRight = 9;
                  this.paddingTop = 9;
                  this.paddingLeft = 9;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.contentBackgroundBorder = "roundedrect";
                  this.borderColor = 13421772;
                  this.fontFamily = "RobotoRegular";
                  this.focusThickness = 0;
                  this.focusColor = 13421772;
                  this.selectionHighlighting = "never";
                  this.focusAlpha = 0;
                  this.focusEnabled = "false";
                  this.skinClass = ScrollingStageTextInputSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 0;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.contentBackgroundBorder = "flat";
                  this.fontFamily = "RobotoRegular";
                  this.focusThickness = 0;
                  this.focusColor = 3388901;
                  this.selectionHighlighting = "never";
                  this.focusEnabled = "false";
                  this.skinClass = ScrollingStageTextInputSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 4;
                  this.paddingTop = 4;
                  this.paddingLeft = 4;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 6;
                  this.paddingRight = 6;
                  this.paddingTop = 6;
                  this.paddingLeft = 6;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 12;
                  this.paddingRight = 12;
                  this.paddingTop = 12;
                  this.paddingLeft = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 18;
                  this.paddingRight = 18;
                  this.paddingTop = 18;
                  this.paddingLeft = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 24;
                  this.paddingTop = 24;
                  this.paddingLeft = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.contentBackgroundBorder = "roundedrect";
                  this.borderColor = 13421772;
                  this.fontFamily = "RobotoRegular";
                  this.focusThickness = 0;
                  this.focusColor = 13421772;
                  this.selectionHighlighting = "never";
                  this.focusAlpha = 0;
                  this.focusEnabled = "false";
                  this.skinClass = StageTextInputSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 0;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.contentBackgroundBorder = "flat";
                  this.fontFamily = "RobotoRegular";
                  this.focusThickness = 0;
                  this.focusColor = 3388901;
                  this.selectionHighlighting = "never";
                  this.focusEnabled = "false";
                  this.skinClass = StageTextInputSkin;
                  this.contentBackgroundColor = 14606045;
                  this.contentBackgroundAlpha = 0;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ToggleButton",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ToggleButton");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ToggleButtonSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.VScrollBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.VScrollBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = VScrollBarSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.color = 15132390;
                  this.skinClass = VScrollBarSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.color = 3355443;
                  this.skinClass = VScrollBarSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.color = 15132390;
                  this.skinClass = VScrollBarSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.color = 3355443;
                  this.skinClass = VScrollBarSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextArea",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.VScrollBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TextArea spark.components.VScrollBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = TextAreaVScrollBarSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("global",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("global");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paragraphStartIndent = 0;
               this.shadowDistance = 2;
               this.breakOpportunity = "auto";
               this.kerning = "default";
               this.selectionDuration = 250;
               this.alternatingItemColors = 16777215;
               this.leading = 2;
               this.paddingRight = 0;
               this.rollOverOpenDelay = 200;
               this.liveDragging = true;
               this.slideDuration = 300;
               this.iconPlacement = "left";
               this.textFieldClass = UITextField;
               this.layoutDirection = "ltr";
               this.borderStyle = "inset";
               this.ligatureLevel = "common";
               this.repeatDelay = 500;
               this.dropShadowColor = 0;
               this.shadowColor = 15658734;
               this.downColor = 14737632;
               this.verticalAlign = "top";
               this.interactionMode = "touch";
               this.dominantBaseline = "auto";
               this.focusAlpha = 0.55;
               this.fontSharpness = 0;
               this.justificationStyle = "auto";
               this.whiteSpaceCollapse = "collapse";
               this.textDecoration = "none";
               this.fontStyle = "normal";
               this.shadowDirection = "center";
               this.version = "4.0.0";
               this.horizontalScrollPolicy = "auto";
               this.digitWidth = "default";
               this.indicatorGap = 14;
               this.lineBreak = "toFit";
               this.borderCapColor = 9542041;
               this.focusColor = 7385838;
               this.themeColor = 7385838;
               this.fontSize = 24;
               this.textAlignLast = "start";
               this.paddingLeft = 0;
               this.selectionDisabledColor = 14540253;
               this.trackingRight = 0;
               this.smoothScrolling = true;
               this.showErrorSkin = true;
               this.useRollOver = true;
               this.unfocusedTextSelectionColor = 15263976;
               this.backgroundAlpha = 1;
               this.baselineShift = 0;
               this.textAlpha = 1;
               this.verticalGap = 6;
               this.closeDuration = 50;
               this.disabledAlpha = 0.5;
               this.fillColor = 16777215;
               this.roundedBottomCorners = true;
               this.highlightAlphas = [0.3,0];
               this.horizontalAlign = "left";
               this.verticalGridLines = true;
               this.textRotation = "auto";
               this.dropShadowVisible = false;
               this.backgroundSize = "auto";
               this.horizontalGridLines = false;
               this.tabStops = null;
               this.softKeyboardEffectDuration = 150;
               this.firstBaselineOffset = "auto";
               this.focusRoundedCorners = "tl tr bl br";
               this.lineThrough = false;
               this.focusSkin = HaloFocusRect;
               this.focusedTextSelectionColor = 11060974;
               this.symbolColor = 0;
               this.borderAlpha = 1;
               this.filled = true;
               this.openDuration = 1;
               this.disabledColor = 11187123;
               this.alignmentBaseline = "useDominantBaseline";
               this.modalTransparencyColor = 14540253;
               this.embedFonts = false;
               this.modalTransparencyDuration = 100;
               this.modalTransparency = 0;
               this.backgroundImageFillMode = "scale";
               this.lineHeight = "120%";
               this.typographicCase = "default";
               this.borderColor = 6908265;
               this.fontAntiAliasType = "advanced";
               this.selectionColor = 14737632;
               this.cffHinting = "horizontalStem";
               this.contentBackgroundAlpha = 1;
               this.cornerRadius = 2;
               this.borderThickness = 1;
               this.fontFamily = "_sans";
               this.indentation = 17;
               this.paddingBottom = 0;
               this.digitCase = "default";
               this.repeatInterval = 35;
               this.textSelectedColor = 0;
               this.paragraphEndIndent = 0;
               this.disabledIconColor = 10066329;
               this.fontWeight = "normal";
               this.borderVisible = true;
               this.focusBlendMode = "normal";
               this.textAlign = "start";
               this.accentColor = 39423;
               this.shadowCapColor = 14015965;
               this.contentBackgroundColor = 15790320;
               this.fontLookup = "embeddedCFF";
               this.chromeColor = 13421772;
               this.columnGap = 20;
               this.focusThickness = 3;
               this.verticalGridLineColor = 14015965;
               this.blockProgression = "tb";
               this.textRollOverColor = 0;
               this.fillAlphas = [0.6,0.4,0.75,0.65];
               this.horizontalGridLineColor = 16250871;
               this.strokeWidth = 1;
               this.fontGridFitType = "pixel";
               this.errorColor = 16646144;
               this.paragraphSpaceAfter = 0;
               this.justificationRule = "auto";
               this.borderSides = "left top right bottom";
               this.color = 0;
               this.buttonColor = 7305079;
               this.textShadowColor = 16777215;
               this.fillColors = [16777215,13421772,16777215,15658734];
               this.paragraphSpaceBefore = 0;
               this.locale = "en";
               this.textIndent = 0;
               this.fontThickness = 0;
               this.touchDelay = 0;
               this.textShadowAlpha = 0.55;
               this.renderingMode = "cff";
               this.textJustify = "interWord";
               this.fullScreenHideControlsDelay = 3000;
               this.columnWidth = "auto";
               this.paddingTop = 0;
               this.direction = "ltr";
               this.fixedThumbSize = false;
               this.caretColor = 92159;
               this.letterSpacing = 0;
               this.borderWeight = 1;
               this.columnCount = "auto";
               this.bevel = true;
               this.verticalScrollPolicy = "auto";
               this.trackingLeft = 0;
               this.horizontalGap = 8;
               this.rollOverColor = 13556719;
               this.modalTransparencyBlur = 0;
               this.stroked = false;
               this.iconColor = 1118481;
               this.inactiveTextSelectionColor = 15263976;
               this.leadingModel = "auto";
               this.showErrorTip = true;
               this.autoThumbVisibility = true;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0.55;
                  this.color = 0;
                  this.textShadowColor = 16777215;
                  this.fontSize = 24;
                  this.highlightTextColor = 16777215;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0.55;
                  this.color = 0;
                  this.textShadowColor = 16777215;
                  this.fontSize = 24;
                  this.primaryAccentColor = 3388901;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.focusThickness = 3;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.focusThickness = 2;
                  this.fontSize = 12;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.focusThickness = 2;
                  this.fontSize = 16;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 32;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.focusThickness = 6;
                  this.fontSize = 48;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 64;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0;
                  this.color = 0;
                  this.textShadowColor = 16777215;
                  this.fontSize = 24;
                  this.highlightTextColor = 16777215;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.focusThickness = 2;
                  this.fontSize = 12;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.focusThickness = 2;
                  this.fontSize = 16;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.fontSize = 32;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.focusThickness = 6;
                  this.fontSize = 48;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.fontSize = 64;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0;
                  this.color = 0;
                  this.textShadowColor = 16777215;
                  this.fontSize = 24;
                  this.primaryAccentColor = 3388901;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.focusThickness = 2;
                  this.fontSize = 12;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.focusThickness = 2;
                  this.fontSize = 16;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.fontSize = 32;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.focusThickness = 6;
                  this.fontSize = 48;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.fontSize = 64;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","errorTip");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".errorTip");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.borderColor = 13510953;
               this.paddingBottom = 4;
               this.color = 16777215;
               this.paddingRight = 4;
               this.fontSize = 10;
               this.paddingTop = 4;
               this.borderStyle = "errorTipRight";
               this.shadowColor = 0;
               this.paddingLeft = 4;
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","headerDragProxyStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".headerDragProxyStyle");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","titleDisplay");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar #titleDisplay");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 16777215;
               this.fontSize = 28;
               this.fontWeight = "bold";
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.color = 16777215;
                  this.fontSize = 28;
                  this.fontWeight = "bold";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.color = 16777215;
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 36;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 54;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 72;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.color = 31487;
                  this.fontSize = 24;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.fontSize = 36;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.fontSize = 54;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.fontSize = 72;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.color = 3355443;
                  this.fontSize = 24;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.fontSize = 36;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.fontSize = 54;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.fontSize = 72;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","iconItemRendererMessageStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".iconItemRendererMessageStyle");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 3355443;
               this.fontSize = 20;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 11;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 26;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 42;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 26;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TabbedViewNavigator",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","tabBar");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TabbedViewNavigator #tabBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.textShadowAlpha = 0.65;
               this.interactionMode = "mouse";
               this.color = 16777215;
               this.iconPlacement = "top";
               this.textShadowColor = 0;
               this.fontSize = 20;
               this.skinClass = TabbedViewNavigatorTabBarSkin;
               this.chromeColor = 4737096;
               this.fontWeight = "normal";
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0.65;
                  this.fontFamily = "RobotoRegular";
                  this.interactionMode = "mouse";
                  this.color = 16777215;
                  this.iconPlacement = "top";
                  this.textShadowColor = 0;
                  this.highlightTextColor = 16777215;
                  this.fontSize = 20;
                  this.skinClass = TabbedViewNavigatorTabBarSkin;
                  this.chromeColor = 4737096;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0.65;
                  this.fontFamily = "RobotoRegular";
                  this.interactionMode = "mouse";
                  this.color = 16777215;
                  this.iconPlacement = "top";
                  this.textShadowColor = 0;
                  this.fontSize = 20;
                  this.skinClass = TabbedViewNavigatorTabBarSkin;
                  this.chromeColor = 4737096;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.fontSize = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 11;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 42;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 56;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0;
                  this.fontFamily = "RobotoRegular";
                  this.interactionMode = "mouse";
                  this.color = 31487;
                  this.iconPlacement = "top";
                  this.textShadowColor = 0;
                  this.highlightTextColor = 16777215;
                  this.fontSize = 20;
                  this.skinClass = TabbedViewNavigatorTabBarSkin;
                  this.chromeColor = 16777215;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.fontSize = 11;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.fontSize = 42;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.fontSize = 56;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0;
                  this.fontFamily = "RobotoRegular";
                  this.interactionMode = "mouse";
                  this.color = 0;
                  this.iconPlacement = "top";
                  this.textShadowColor = 0;
                  this.fontSize = 20;
                  this.skinClass = TabbedViewNavigatorTabBarSkin;
                  this.chromeColor = 4737096;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.fontSize = 11;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.fontSize = 28;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.fontSize = 42;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.fontSize = 56;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.managers.CursorManager",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.managers.CursorManager");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.busyCursor = BusyCursor;
               this.busyCursorBackground = _embed_css_Assets_swf__1432423865_mx_skins_cursor_BusyCursor_55297237;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.managers.DragManager",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.managers.DragManager");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.linkCursor = _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragLink_263144202;
               this.rejectCursor = _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragReject_1224370337;
               this.copyCursor = _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragCopy_262882197;
               this.moveCursor = _embed_css_Assets_swf__1432423865_mx_skins_cursor_DragMove_263169777;
               this.defaultDragImageSkin = DefaultDragImage;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.ToolTip",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.ToolTip");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777164;
               this.borderColor = 9542041;
               this.paddingBottom = 2;
               this.paddingRight = 4;
               this.backgroundAlpha = 0.95;
               this.fontSize = 10;
               this.paddingTop = 2;
               this.borderSkin = ToolTipBorder;
               this.borderStyle = "toolTip";
               this.paddingLeft = 4;
               this.cornerRadius = 2;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.textShadowAlpha = 0.65;
               this.paddingBottom = 1;
               this.paddingRight = 0;
               this.defaultButtonAppearance = "normal";
               this.textShadowColor = 0;
               this.skinClass = ActionBarSkin;
               this.paddingTop = 1;
               this.paddingLeft = 0;
               this.chromeColor = 4737096;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0.65;
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "normal";
                  this.textShadowColor = 0;
                  this.skinClass = ActionBarSkin;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0.65;
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "normal";
                  this.textShadowColor = 0;
                  this.skinClass = ActionBarSkin;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
                  this.chromeColor = 4737096;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 2;
                  this.paddingRight = 0;
                  this.paddingTop = 2;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 0;
                  this.paddingTop = 4;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 0;
                  this.paddingTop = 4;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0;
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "normal";
                  this.textShadowColor = 0;
                  this.skinClass = ActionBarSkin;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:160)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:320)"))
               {
                  this.paddingBottom = 2;
                  this.paddingRight = 0;
                  this.paddingTop = 2;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:480)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 0;
                  this.paddingTop = 4;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:640)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 0;
                  this.paddingTop = 4;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0;
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "normal";
                  this.textShadowColor = 0;
                  this.skinClass = ActionBarSkin;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
                  this.chromeColor = 14606045;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:160)"))
               {
                  this.paddingBottom = 1;
                  this.paddingRight = 0;
                  this.paddingTop = 1;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:320)"))
               {
                  this.paddingBottom = 2;
                  this.paddingRight = 0;
                  this.paddingTop = 2;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:480)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 0;
                  this.paddingTop = 4;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:640)"))
               {
                  this.paddingBottom = 4;
                  this.paddingRight = 0;
                  this.paddingTop = 4;
                  this.paddingLeft = 0;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar.beveled");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingRight = 7;
               this.paddingLeft = 7;
               this.titleAlign = "center";
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.paddingRight = 7;
                  this.paddingLeft = 7;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingRight = 4;
                  this.paddingLeft = 4;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingRight = 5;
                  this.paddingLeft = 5;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingRight = 10;
                  this.paddingLeft = 10;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingRight = 15;
                  this.paddingLeft = 15;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingRight = 20;
                  this.paddingLeft = 20;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7) and (application-dpi:120)"))
               {
                  this.paddingRight = 4;
                  this.paddingLeft = 4;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\") and (application-dpi:120)"))
               {
                  this.paddingRight = 4;
                  this.paddingLeft = 4;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator spark.components.ActionBar");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingRight = 0;
               this.defaultButtonAppearance = "beveled";
               this.skinClass = CalloutActionBarSkin;
               this.paddingLeft = 0;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0;
                  this.contentBackgroundAppearance = "flat";
                  this.paddingBottom = 0;
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "beveled";
                  this.textShadowColor = 0;
                  this.skinClass = CalloutActionBarSkin;
                  this.paddingTop = 0;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "beveled";
                  this.skinClass = CalloutActionBarSkin;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0;
                  this.contentBackgroundAppearance = "flat";
                  this.paddingBottom = 0;
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "normal";
                  this.textShadowColor = 0;
                  this.skinClass = CalloutActionBarSkin;
                  this.paddingTop = 0;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.paddingRight = 0;
                  this.defaultButtonAppearance = "none";
                  this.skinClass = CalloutActionBarSkin;
                  this.paddingLeft = 0;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","beveled");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator spark.components.ActionBar.beveled");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingRight = 0;
               this.paddingLeft = 0;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.paddingRight = 0;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.paddingRight = 0;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.paddingRight = 0;
                  this.paddingLeft = 0;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.paddingRight = 0;
                  this.paddingLeft = 0;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.supportClasses.ButtonBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ActionBar spark.components.supportClasses.ButtonBase");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.color = 16777215;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.color = 16777215;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.color = 16777215;
                  this.fontWeight = "bold";
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.fontFamily = "RobotoRegular";
                  this.color = 31487;
                  this.fontWeight = "normal";
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.fontFamily = "RobotoBold";
                  this.color = 3355443;
                  this.fontWeight = "bold";
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.supportClasses.ButtonBase",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.supportClasses.ButtonBase");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.iconPlacement = "left";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.CalloutButton",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.CalloutButton");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.rollOverOpenDelay = "NaN";
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.Callout spark.components.ViewNavigator");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = CalloutViewNavigatorSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = CalloutViewNavigatorSkin;
                  this.contentBackgroundColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = CalloutViewNavigatorSkin;
                  this.contentBackgroundColor = 16777215;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigator",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ViewNavigator");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ViewNavigatorSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ViewNavigatorSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = ViewNavigatorSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ViewNavigatorSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = ViewNavigatorSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.LabelItemRenderer",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.LabelItemRenderer");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.verticalAlign = "middle";
               this.paddingBottom = 24;
               this.paddingRight = 15;
               this.paddingTop = 24;
               this.paddingLeft = 15;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 15;
                  this.paddingTop = 24;
                  this.paddingLeft = 15;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 15;
                  this.paddingTop = 24;
                  this.paddingLeft = 15;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 15;
                  this.paddingTop = 24;
                  this.paddingLeft = 15;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 15;
                  this.paddingTop = 24;
                  this.paddingLeft = 15;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 24;
                  this.paddingRight = 15;
                  this.paddingTop = 24;
                  this.paddingLeft = 15;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.paddingBottom = 12;
                  this.paddingRight = 8;
                  this.paddingTop = 12;
                  this.paddingLeft = 8;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.paddingBottom = 16;
                  this.paddingRight = 10;
                  this.paddingTop = 16;
                  this.paddingLeft = 10;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.paddingBottom = 32;
                  this.paddingRight = 20;
                  this.paddingTop = 32;
                  this.paddingLeft = 20;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.paddingBottom = 48;
                  this.paddingRight = 30;
                  this.paddingTop = 48;
                  this.paddingLeft = 30;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.paddingBottom = 64;
                  this.paddingRight = 40;
                  this.paddingTop = 64;
                  this.paddingLeft = 40;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TabbedViewNavigator",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.TabbedViewNavigator");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = TabbedViewNavigatorSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ToggleSwitch",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ToggleSwitch");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.textShadowAlpha = 0.65;
               this.color = 16777215;
               this.accentColor = 4161466;
               this.textShadowColor = 0;
               this.fontSize = 27;
               this.skinClass = ToggleSwitchSkin;
               this.slideDuration = 125;
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 27;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 27;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 27;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 27;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 27;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0.65;
                  this.color = 16777215;
                  this.accentColor = 4161466;
                  this.textShadowColor = 0;
                  this.skinClass = ToggleSwitchSkin;
                  this.slideDuration = 125;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0.65;
                  this.color = 16777215;
                  this.accentColor = 4161466;
                  this.textShadowColor = 0;
                  this.skinClass = ToggleSwitchSkin;
                  this.slideDuration = 125;
               }
               if(styleManager.acceptMediaList("(application-dpi:120)"))
               {
                  this.fontSize = 14;
               }
               if(styleManager.acceptMediaList("(application-dpi:160)"))
               {
                  this.fontSize = 18;
               }
               if(styleManager.acceptMediaList("(application-dpi:320)"))
               {
                  this.fontSize = 36;
               }
               if(styleManager.acceptMediaList("(application-dpi:480)"))
               {
                  this.fontSize = 54;
               }
               if(styleManager.acceptMediaList("(application-dpi:640)"))
               {
                  this.fontSize = 72;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.textShadowAlpha = 0.65;
                  this.color = 16777215;
                  this.accentColor = 4161466;
                  this.textShadowColor = 0;
                  this.skinClass = ToggleSwitchSkin;
                  this.slideDuration = 125;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.textShadowAlpha = 0.65;
                  this.color = 16777215;
                  this.accentColor = 4161466;
                  this.textShadowColor = 0;
                  this.skinClass = ToggleSwitchSkin;
                  this.slideDuration = 125;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.View",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.View");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = SkinnableContainerSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ViewMenu",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ViewMenu");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.skinClass = ViewMenuSkin;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ViewMenuSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = ViewMenuSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = ViewMenuSkin;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.skinClass = ViewMenuSkin;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ViewMenuItem",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ViewMenuItem");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paddingBottom = 8;
               this.iconPlacement = "top";
               this.paddingRight = 8;
               this.skinClass = ViewMenuItemSkin;
               this.paddingTop = 8;
               this.paddingLeft = 8;
               this.chromeColor = 16777215;
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.paddingBottom = 8;
                  this.iconPlacement = "top";
                  this.focusColor = 14606045;
                  this.paddingRight = 8;
                  this.skinClass = ViewMenuItemSkin;
                  this.paddingTop = 8;
                  this.paddingLeft = 8;
                  this.chromeColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.paddingBottom = 8;
                  this.iconPlacement = "top";
                  this.focusColor = 14606045;
                  this.paddingRight = 8;
                  this.skinClass = ViewMenuItemSkin;
                  this.paddingTop = 8;
                  this.paddingLeft = 8;
                  this.chromeColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.paddingBottom = 8;
                  this.iconPlacement = "left";
                  this.focusColor = 14606045;
                  this.paddingRight = 8;
                  this.skinClass = ViewMenuItemSkin;
                  this.paddingTop = 8;
                  this.paddingLeft = 8;
                  this.chromeColor = 16777215;
               }
               if(styleManager.acceptMediaList("(os-platform:\"android\") and (min-os-version:\"4.1.2\")"))
               {
                  this.paddingBottom = 8;
                  this.iconPlacement = "left";
                  this.focusColor = 14606045;
                  this.paddingRight = 8;
                  this.skinClass = ViewMenuItemSkin;
                  this.paddingTop = 8;
                  this.paddingLeft = 8;
                  this.chromeColor = 16777215;
               }
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigatorApplication",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("spark.components.ViewNavigatorApplication");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777215;
               this.skinClass = ViewNavigatorApplicationSkin;
            };
         }
         if(mergedStyle != null && (mergedStyle.defaultFactory == null || ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory())))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
      }
   }
}
