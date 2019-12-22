package refactor.bisecur._1_APP.components.stateImages
{
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgAutoClose;
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgError;
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgUnavailable;
   import me.mweber.basic.helper.StringHelper;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.IStateHelper;
   import refactor.bisecur._2_SAL.stateHelper.StateHelperFactory;
   import refactor.bisecur._5_UTIL.HmTransitionHelper;
   import refactor.logicware._5_UTIL.IDisposable;
   import spark.components.BusyIndicator;
   import spark.components.SkinnableContainer;
   
   public class StateImageBase extends SkinnableContainer implements IDisposable
   {
       
      
      private var _878226977imageRect:IVisualElement;
      
      public var groupId:int = -1;
      
      private var _862769432stateHeight:Number = 126;
      
      private var _156219382imageRectPaddingRight:Number = 0;
      
      private var _1781778094outlineThickness:Number = NaN;
      
      private var _transition:HmTransition;
      
      private var _showState:Boolean = true;
      
      private var _236218275stateViews:int = 1;
      
      private var _isRefreshing:Boolean = false;
      
      public function StateImageBase()
      {
         super();
      }
      
      private static function createWhiteWeel() : IVisualElement
      {
         var _loc1_:BusyIndicator = new BusyIndicator();
         _loc1_.styleName = "whiteWheel";
         _loc1_.width = 125;
         _loc1_.height = 125;
         return _loc1_;
      }
      
      public function get isRefreshing() : Boolean
      {
         return this._isRefreshing;
      }
      
      public function get showState() : Boolean
      {
         return this._showState;
      }
      
      public function get transition() : HmTransition
      {
         return this._transition;
      }
      
      public function set transition(param1:HmTransition) : void
      {
         var _loc4_:IStateHelper = null;
         var _loc5_:IStateHelper = null;
         this._transition = param1;
         var _loc2_:StateUpdateProperties = new StateUpdateProperties();
         _loc2_.transition = param1;
         var _loc3_:HmProcessor = AppCache.sharedCache.hmProcessor;
         _loc2_.requestable = _loc3_.collector.isGroupRequestable(this.groupId);
         _loc2_.collectingActive = _loc3_.transitionCollectingActive;
         _loc2_.additionalIcon = null;
         this._showState = true;
         switch(true)
         {
            case !_loc2_.requestable:
               break;
            case param1 == null && _loc2_.requestable:
               if(_loc2_.collectingActive)
               {
                  _loc2_.additionalIcon = createWhiteWeel();
               }
               else
               {
                  _loc2_.additionalIcon = new FxgUnavailable();
               }
               this._showState = false;
               break;
            case HmTransitionHelper.hasError(param1):
               _loc2_.additionalIcon = new FxgError();
               this._showState = false;
               break;
            case HmTransitionHelper.hasHint(param1):
               _loc2_.additionalIcon = new FxgError();
               this._showState = false;
               break;
            case param1.autoClose:
               _loc2_.additionalIcon = new FxgAutoClose();
               break;
            case HmTransitionHelper.isDriving(param1):
               _loc2_.additionalIcon = createWhiteWeel();
               this._showState = false;
         }
         _loc2_.actorState = null;
         if(param1 != null)
         {
            _loc4_ = StateHelperFactory.getDefaultHelper();
            _loc5_ = StateHelperFactory.getStateHelper(param1);
            _loc2_.showDrivingDirection = _loc5_.showDriveDirection(param1,_loc2_.requestable);
            if(_loc2_.additionalIcon == null && param1 != null)
            {
               _loc2_.additionalIcon = _loc5_.getAdditionalStateImage(param1,_loc2_.requestable);
               if(_loc2_.additionalIcon == null)
               {
                  _loc2_.additionalIcon = _loc4_.getAdditionalStateImage(param1,_loc2_.requestable);
               }
               this._showState = _loc5_.showState(param1,_loc2_.requestable);
               if(_loc2_.additionalIcon is FxgError)
               {
                  this._showState = false;
               }
               if(this._showState)
               {
                  _loc2_.actorState = _loc5_.forceState(param1,_loc2_.requestable);
                  if(_loc2_.actorState == null)
                  {
                     _loc2_.actorState = _loc4_.forceState(param1,_loc2_.requestable);
                  }
               }
            }
         }
         if(_loc2_.actorState == null)
         {
            _loc2_.actorState = HmTransitionHelper.getActorState(param1);
         }
         _loc2_.actorState = this.trimState(_loc2_.actorState,this.stateViews);
         _loc2_.showState = this._showState;
         if(skin != null)
         {
            skin.invalidateDisplayList();
         }
         this._isRefreshing = _loc2_.additionalIcon is BusyIndicator;
         this.updateState(_loc2_);
      }
      
      public function dispose() : void
      {
         this.imageRect = null;
         this.groupId = -1;
         this._transition = null;
      }
      
      protected function updateState(param1:StateUpdateProperties) : void
      {
      }
      
      private function trimState(param1:String, param2:int) : String
      {
         if(param2 < 1)
         {
            param2 = 1;
         }
         while(StringHelper.countChar(param1,":") > param2 - 1)
         {
            param1 = param1.substr(0,param1.lastIndexOf(":"));
         }
         return param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get imageRect() : IVisualElement
      {
         return this._878226977imageRect;
      }
      
      public function set imageRect(param1:IVisualElement) : void
      {
         var _loc2_:Object = this._878226977imageRect;
         if(_loc2_ !== param1)
         {
            this._878226977imageRect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageRect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stateHeight() : Number
      {
         return this._862769432stateHeight;
      }
      
      public function set stateHeight(param1:Number) : void
      {
         var _loc2_:Object = this._862769432stateHeight;
         if(_loc2_ !== param1)
         {
            this._862769432stateHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateHeight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get imageRectPaddingRight() : Number
      {
         return this._156219382imageRectPaddingRight;
      }
      
      public function set imageRectPaddingRight(param1:Number) : void
      {
         var _loc2_:Object = this._156219382imageRectPaddingRight;
         if(_loc2_ !== param1)
         {
            this._156219382imageRectPaddingRight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageRectPaddingRight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get outlineThickness() : Number
      {
         return this._1781778094outlineThickness;
      }
      
      public function set outlineThickness(param1:Number) : void
      {
         var _loc2_:Object = this._1781778094outlineThickness;
         if(_loc2_ !== param1)
         {
            this._1781778094outlineThickness = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outlineThickness",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stateViews() : int
      {
         return this._236218275stateViews;
      }
      
      public function set stateViews(param1:int) : void
      {
         var _loc2_:Object = this._236218275stateViews;
         if(_loc2_ !== param1)
         {
            this._236218275stateViews = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateViews",_loc2_,param1));
            }
         }
      }
   }
}
