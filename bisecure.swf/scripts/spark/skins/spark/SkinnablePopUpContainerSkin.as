package spark.skins.spark
{
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.states.Transition;
   import spark.components.Group;
   import spark.components.SkinnablePopUpContainer;
   import spark.components.supportClasses.Skin;
   import spark.effects.Fade;
   import spark.layouts.BasicLayout;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class SkinnablePopUpContainerSkin extends Skin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _SkinnablePopUpContainerSkin_Fade1:Fade;
      
      public var _SkinnablePopUpContainerSkin_Fade2:Fade;
      
      public var _SkinnablePopUpContainerSkin_Fade3:Fade;
      
      public var _SkinnablePopUpContainerSkin_Fade4:Fade;
      
      private var _1332194002background:Rect;
      
      private var _1391998104bgFill:SolidColor;
      
      private var _1361128838chrome:Group;
      
      private var _809612678contentGroup:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:SkinnablePopUpContainer;
      
      public function SkinnablePopUpContainerSkin()
      {
         var bindings:Array = null;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._SkinnablePopUpContainerSkin_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_spark_SkinnablePopUpContainerSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SkinnablePopUpContainerSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.transitions = [this._SkinnablePopUpContainerSkin_Transition1_c(),this._SkinnablePopUpContainerSkin_Transition2_c(),this._SkinnablePopUpContainerSkin_Transition3_c(),this._SkinnablePopUpContainerSkin_Transition4_c()];
         this.mxmlContent = [this._SkinnablePopUpContainerSkin_Group1_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"closed",
            "stateGroups":["closedGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"chrome",
               "name":"visible",
               "value":false
            })]
         }),new State({
            "name":"disabledAndClosed",
            "stateGroups":["closedGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"chrome",
               "name":"visible",
               "value":false
            })]
         })];
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SkinnablePopUpContainerSkin._watcherSetupUtil = param1;
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
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(isNaN(getStyle("backgroundColor")))
         {
            this.background.visible = false;
         }
         else
         {
            this.background.visible = true;
            this.bgFill.color = getStyle("backgroundColor");
            this.bgFill.alpha = getStyle("backgroundAlpha");
         }
         super.updateDisplayList(param1,param2);
      }
      
      private function _SkinnablePopUpContainerSkin_Transition1_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "closed";
         _loc1_.toState = "normal";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._SkinnablePopUpContainerSkin_Fade1_i();
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Fade1_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 150;
         this._SkinnablePopUpContainerSkin_Fade1 = _loc1_;
         BindingManager.executeBindings(this,"_SkinnablePopUpContainerSkin_Fade1",this._SkinnablePopUpContainerSkin_Fade1);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Transition2_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "disabledAndClosed";
         _loc1_.toState = "disabled";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._SkinnablePopUpContainerSkin_Fade2_i();
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Fade2_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 150;
         this._SkinnablePopUpContainerSkin_Fade2 = _loc1_;
         BindingManager.executeBindings(this,"_SkinnablePopUpContainerSkin_Fade2",this._SkinnablePopUpContainerSkin_Fade2);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Transition3_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "normal";
         _loc1_.toState = "closed";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._SkinnablePopUpContainerSkin_Fade3_i();
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Fade3_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 150;
         this._SkinnablePopUpContainerSkin_Fade3 = _loc1_;
         BindingManager.executeBindings(this,"_SkinnablePopUpContainerSkin_Fade3",this._SkinnablePopUpContainerSkin_Fade3);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Transition4_c() : Transition
      {
         var _loc1_:Transition = new Transition();
         _loc1_.fromState = "disabled";
         _loc1_.toState = "disabledAndClosed";
         _loc1_.autoReverse = true;
         _loc1_.effect = this._SkinnablePopUpContainerSkin_Fade4_i();
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Fade4_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 150;
         this._SkinnablePopUpContainerSkin_Fade4 = _loc1_;
         BindingManager.executeBindings(this,"_SkinnablePopUpContainerSkin_Fade4",this._SkinnablePopUpContainerSkin_Fade4);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.mxmlContent = [this._SkinnablePopUpContainerSkin_Rect1_i(),this._SkinnablePopUpContainerSkin_Group2_i()];
         _loc1_.id = "chrome";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.chrome = _loc1_;
         BindingManager.executeBindings(this,"chrome",this.chrome);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._SkinnablePopUpContainerSkin_SolidColor1_i();
         _loc1_.initialized(this,"background");
         this.background = _loc1_;
         BindingManager.executeBindings(this,"background",this.background);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.bgFill = _loc1_;
         BindingManager.executeBindings(this,"bgFill",this.bgFill);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_Group2_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.minWidth = 0;
         _loc1_.minHeight = 0;
         _loc1_.layout = this._SkinnablePopUpContainerSkin_BasicLayout1_c();
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_BasicLayout1_c() : BasicLayout
      {
         var _loc1_:BasicLayout = new BasicLayout();
         return _loc1_;
      }
      
      private function _SkinnablePopUpContainerSkin_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"_SkinnablePopUpContainerSkin_Fade1.target","chrome");
         _loc1_[1] = new Binding(this,null,null,"_SkinnablePopUpContainerSkin_Fade2.target","chrome");
         _loc1_[2] = new Binding(this,null,null,"_SkinnablePopUpContainerSkin_Fade3.target","chrome");
         _loc1_[3] = new Binding(this,null,null,"_SkinnablePopUpContainerSkin_Fade4.target","chrome");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get background() : Rect
      {
         return this._1332194002background;
      }
      
      public function set background(param1:Rect) : void
      {
         var _loc2_:Object = this._1332194002background;
         if(_loc2_ !== param1)
         {
            this._1332194002background = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"background",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bgFill() : SolidColor
      {
         return this._1391998104bgFill;
      }
      
      public function set bgFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1391998104bgFill;
         if(_loc2_ !== param1)
         {
            this._1391998104bgFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgFill",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chrome() : Group
      {
         return this._1361128838chrome;
      }
      
      public function set chrome(param1:Group) : void
      {
         var _loc2_:Object = this._1361128838chrome;
         if(_loc2_ !== param1)
         {
            this._1361128838chrome = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chrome",_loc2_,param1));
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
      public function get hostComponent() : SkinnablePopUpContainer
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:SkinnablePopUpContainer) : void
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
