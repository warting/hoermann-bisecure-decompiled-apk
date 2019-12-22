package spark.skins.android4
{
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.effects.Parallel;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.states.Transition;
   import spark.components.Group;
   import spark.components.ViewMenu;
   import spark.effects.Fade;
   import spark.effects.Move;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Power;
   import spark.filters.DropShadowFilter;
   import spark.layouts.VerticalLayout;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   
   use namespace mx_internal;
   
   public class ViewMenuSkin extends SparkSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ViewMenuSkin_Fade1:Fade;
      
      public var _ViewMenuSkin_Fade2:Fade;
      
      public var _ViewMenuSkin_Fade3:Fade;
      
      public var _ViewMenuSkin_Fade4:Fade;
      
      public var _ViewMenuSkin_Move1:Move;
      
      public var _ViewMenuSkin_Move2:Move;
      
      public var _ViewMenuSkin_Move3:Move;
      
      public var _ViewMenuSkin_Move4:Move;
      
      private var _1184103047_ViewMenuSkin_SetProperty1:SetProperty;
      
      private var _1184103046_ViewMenuSkin_SetProperty2:SetProperty;
      
      private var _1427430450backgroundRect:Rect;
      
      private var _434221093chromeGroup:Group;
      
      private var _809612678contentGroup:Group;
      
      private var _992534608contentGroupLayout:VerticalLayout;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:ViewMenu;
      
      public function ViewMenuSkin()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ViewMenuSkin_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_android4_ViewMenuSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ViewMenuSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.transitions = [this._ViewMenuSkin_Transition1_c(),this._ViewMenuSkin_Transition2_c(),this._ViewMenuSkin_Transition3_c(),this._ViewMenuSkin_Transition4_c()];
         this.mxmlContent = [this._ViewMenuSkin_Group1_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "stateGroups":["openedGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"bottom",
               "value":0
            })]
         }),new State({
            "name":"closed",
            "stateGroups":["closedGroup"],
            "overrides":[this._ViewMenuSkin_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"top",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"visible",
               "value":false
            })]
         }),new State({
            "name":"disabled",
            "stateGroups":["openedGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"bottom",
               "value":0
            })]
         }),new State({
            "name":"normalAndLandscape",
            "stateGroups":["openedGroup","landscapeGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"bottom",
               "value":0
            })]
         }),new State({
            "name":"closedAndLandscape",
            "stateGroups":["closedGroup","landscapeGroup"],
            "overrides":[this._ViewMenuSkin_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"top",
               "value":undefined
            })),new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"visible",
               "value":false
            })]
         }),new State({
            "name":"disabledAndLandscape",
            "stateGroups":["openedGroup","landscapeGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"chromeGroup",
               "name":"bottom",
               "value":0
            })]
         })];
         BindingManager.executeBindings(this,"_ViewMenuSkin_SetProperty1",this._ViewMenuSkin_SetProperty1);
         BindingManager.executeBindings(this,"_ViewMenuSkin_SetProperty2",this._ViewMenuSkin_SetProperty2);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ViewMenuSkin._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = false;
         super.initializationComplete();
      }
      
      public function get applicationDPI() : int
      {
         return FlexGlobals.topLevelApplication.applicationDPI;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredHeight = 200;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.applicationDPI == DPIClassification.DPI_640 || this.applicationDPI == DPIClassification.DPI_480 || this.applicationDPI == DPIClassification.DPI_320?Number(2):Number(1);
         var _loc4_:Number = 1;
         if(this.applicationDPI == DPIClassification.DPI_640)
         {
            _loc4_ = 6;
         }
         else if(this.applicationDPI == DPIClassification.DPI_480)
         {
            _loc4_ = 4;
         }
         else if(this.applicationDPI == DPIClassification.DPI_320)
         {
            _loc4_ = 3;
         }
         else if(this.applicationDPI == DPIClassification.DPI_240)
         {
            _loc4_ = 2;
         }
         else if(this.applicationDPI == DPIClassification.DPI_120)
         {
            _loc4_ = 1;
         }
         this.contentGroup.top = _loc3_ + _loc4_;
         this.contentGroup.bottom = _loc4_;
         this.contentGroupLayout.gap = _loc4_;
      }
      
      private function _ViewMenuSkin_Transition1_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "closed";
         _loc1_.toState = "normal";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._ViewMenuSkin_Parallel1_c();
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Parallel1_c() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         _loc1_.children = [this._ViewMenuSkin_Fade1_i(),this._ViewMenuSkin_Move1_i()];
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Fade1_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 150;
         this._ViewMenuSkin_Fade1 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Fade1",this._ViewMenuSkin_Fade1);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Move1_i() : Move
      {
         var _loc1_:Move = new Move();
         _loc1_.duration = 150;
         _loc1_.disableLayout = true;
         this._ViewMenuSkin_Move1 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Move1",this._ViewMenuSkin_Move1);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Transition2_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "closedAndLandscape";
         _loc1_.toState = "normalAndLandscape";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._ViewMenuSkin_Parallel2_c();
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Parallel2_c() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         _loc1_.children = [this._ViewMenuSkin_Fade2_i(),this._ViewMenuSkin_Move2_i()];
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Fade2_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 150;
         this._ViewMenuSkin_Fade2 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Fade2",this._ViewMenuSkin_Fade2);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Move2_i() : Move
      {
         var _loc1_:Move = new Move();
         _loc1_.duration = 150;
         _loc1_.disableLayout = true;
         this._ViewMenuSkin_Move2 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Move2",this._ViewMenuSkin_Move2);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Transition3_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "normal";
         _loc1_.toState = "closed";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._ViewMenuSkin_Parallel3_c();
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Parallel3_c() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         _loc1_.children = [this._ViewMenuSkin_Fade3_i(),this._ViewMenuSkin_Move3_i()];
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Fade3_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 100;
         this._ViewMenuSkin_Fade3 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Fade3",this._ViewMenuSkin_Fade3);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Move3_i() : Move
      {
         var _loc1_:Move = new Move();
         _loc1_.duration = 100;
         _loc1_.disableLayout = true;
         this._ViewMenuSkin_Move3 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Move3",this._ViewMenuSkin_Move3);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Transition4_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "normalAndLandscape";
         _loc1_.toState = "closedAndLandscape";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._ViewMenuSkin_Parallel4_c();
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Parallel4_c() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         _loc1_.children = [this._ViewMenuSkin_Fade4_i(),this._ViewMenuSkin_Move4_i()];
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Fade4_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 100;
         this._ViewMenuSkin_Fade4 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Fade4",this._ViewMenuSkin_Fade4);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Move4_i() : Move
      {
         var _loc1_:Move = new Move();
         _loc1_.duration = 100;
         _loc1_.disableLayout = true;
         this._ViewMenuSkin_Move4 = _loc1_;
         BindingManager.executeBindings(this,"_ViewMenuSkin_Move4",this._ViewMenuSkin_Move4);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.mxmlContent = [this._ViewMenuSkin_Rect1_i(),this._ViewMenuSkin_Group2_i()];
         _loc1_.id = "chromeGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.chromeGroup = _loc1_;
         BindingManager.executeBindings(this,"chromeGroup",this.chromeGroup);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 18;
         _loc1_.right = 18;
         _loc1_.top = 1;
         _loc1_.bottom = 0;
         _loc1_.fill = this._ViewMenuSkin_SolidColor1_c();
         _loc1_.stroke = this._ViewMenuSkin_SolidColorStroke1_c();
         _loc1_.filters = [this._ViewMenuSkin_DropShadowFilter1_c()];
         _loc1_.initialized(this,"backgroundRect");
         this.backgroundRect = _loc1_;
         BindingManager.executeBindings(this,"backgroundRect",this.backgroundRect);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      private function _ViewMenuSkin_SolidColorStroke1_c() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.weight = 0.5;
         _loc1_.alpha = 0.2;
         return _loc1_;
      }
      
      private function _ViewMenuSkin_DropShadowFilter1_c() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.alpha = 0.5;
         return _loc1_;
      }
      
      private function _ViewMenuSkin_Group2_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 20;
         _loc1_.right = 20;
         _loc1_.top = 3;
         _loc1_.bottom = 2;
         _loc1_.minWidth = 0;
         _loc1_.minHeight = 0;
         _loc1_.layout = this._ViewMenuSkin_VerticalLayout1_i();
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_VerticalLayout1_i() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = -1;
         _loc1_.horizontalAlign = "contentJustify";
         this.contentGroupLayout = _loc1_;
         BindingManager.executeBindings(this,"contentGroupLayout",this.contentGroupLayout);
         return _loc1_;
      }
      
      private function _ViewMenuSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"_ViewMenuSkin_Fade1.target","chromeGroup");
         result[1] = new Binding(this,function():IEaser
         {
            return new Power(0.5,3);
         },null,"_ViewMenuSkin_Fade1.easer");
         result[2] = new Binding(this,null,null,"_ViewMenuSkin_Move1.target","chromeGroup");
         result[3] = new Binding(this,function():IEaser
         {
            return new Power(0,5);
         },null,"_ViewMenuSkin_Move1.easer");
         result[4] = new Binding(this,null,null,"_ViewMenuSkin_Fade2.target","chromeGroup");
         result[5] = new Binding(this,function():IEaser
         {
            return new Power(0.5,3);
         },null,"_ViewMenuSkin_Fade2.easer");
         result[6] = new Binding(this,null,null,"_ViewMenuSkin_Move2.target","chromeGroup");
         result[7] = new Binding(this,function():IEaser
         {
            return new Power(0,5);
         },null,"_ViewMenuSkin_Move2.easer");
         result[8] = new Binding(this,null,null,"_ViewMenuSkin_Fade3.target","chromeGroup");
         result[9] = new Binding(this,null,null,"_ViewMenuSkin_Move3.target","chromeGroup");
         result[10] = new Binding(this,null,null,"_ViewMenuSkin_Fade4.target","chromeGroup");
         result[11] = new Binding(this,null,null,"_ViewMenuSkin_Move4.target","chromeGroup");
         result[12] = new Binding(this,function():*
         {
            return hostComponent.height - chromeGroup.height / 2;
         },null,"_ViewMenuSkin_SetProperty1.value");
         result[13] = new Binding(this,function():*
         {
            return hostComponent.height - chromeGroup.height / 2;
         },null,"_ViewMenuSkin_SetProperty2.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _ViewMenuSkin_SetProperty1() : SetProperty
      {
         return this._1184103047_ViewMenuSkin_SetProperty1;
      }
      
      public function set _ViewMenuSkin_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1184103047_ViewMenuSkin_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._1184103047_ViewMenuSkin_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ViewMenuSkin_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ViewMenuSkin_SetProperty2() : SetProperty
      {
         return this._1184103046_ViewMenuSkin_SetProperty2;
      }
      
      public function set _ViewMenuSkin_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1184103046_ViewMenuSkin_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._1184103046_ViewMenuSkin_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ViewMenuSkin_SetProperty2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundRect() : Rect
      {
         return this._1427430450backgroundRect;
      }
      
      public function set backgroundRect(param1:Rect) : void
      {
         var _loc2_:Object = this._1427430450backgroundRect;
         if(_loc2_ !== param1)
         {
            this._1427430450backgroundRect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundRect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chromeGroup() : Group
      {
         return this._434221093chromeGroup;
      }
      
      public function set chromeGroup(param1:Group) : void
      {
         var _loc2_:Object = this._434221093chromeGroup;
         if(_loc2_ !== param1)
         {
            this._434221093chromeGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chromeGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get contentGroup() : Group
      {
         return this._809612678contentGroup;
      }
      
      public function set contentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get contentGroupLayout() : VerticalLayout
      {
         return this._992534608contentGroupLayout;
      }
      
      public function set contentGroupLayout(param1:VerticalLayout) : void
      {
         var _loc2_:Object = this._992534608contentGroupLayout;
         if(_loc2_ !== param1)
         {
            this._992534608contentGroupLayout = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroupLayout",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : ViewMenu
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:ViewMenu) : void
      {
         var _loc2_:Object = this._213507019hostComponent;
         if(_loc2_ !== param1)
         {
            this._213507019hostComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
            }
         }
      }
   }
}
