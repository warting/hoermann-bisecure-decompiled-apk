package com.isisic.remote.hoermann.views.notifications
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.popups.NotifictionBox;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.List;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   
   use namespace mx_internal;
   
   public class NotificationCenter extends View implements IBindingClient
   {
      
      private static const dataURI:String = "http://hoe-ast.de/BisecurNotifications/?version={0}&platform={1}&portalId={2}&dataType=json&action={3}&lang={4}";
      
      private static const storage:File = File.applicationStorageDirectory.resolvePath("notifications.json");
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _3016817bbar:BottomBar;
      
      private var _205678947btnBack:Button;
      
      private var _1611284521notificationList:List;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _987494927provider:ArrayCollection;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function NotificationCenter()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._NotificationCenter_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_notifications_NotificationCenterWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return NotificationCenter[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._NotificationCenter_Button1_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._NotificationCenter_Array2_c);
         this.addEventListener("initialize",this.___NotificationCenter_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         NotificationCenter._watcherSetupUtil = param1;
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
      
      private function onInit() : void
      {
         var _loc1_:Array = NotificationLoader.instance.notifications;
         NotificationLoader.instance.seenNotifications = _loc1_;
         this.provider = new ArrayCollection(_loc1_);
      }
      
      private function onItemSelected(param1:IndexChangeEvent) : void
      {
         param1.preventDefault();
         new NotifictionBox(this.notificationList.selectedItem).open(null);
      }
      
      private function _NotificationCenter_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.__btnBack_click);
         _loc1_.id = "btnBack";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnBack = _loc1_;
         BindingManager.executeBindings(this,"btnBack",this.btnBack);
         return _loc1_;
      }
      
      public function __btnBack_click(param1:MouseEvent) : void
      {
         this.navigator.popView();
      }
      
      private function _NotificationCenter_Array2_c() : Array
      {
         var _loc1_:Array = [this._NotificationCenter_List1_i(),this._NotificationCenter_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _NotificationCenter_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.top = 10;
         _loc1_.itemRenderer = this._NotificationCenter_ClassFactory1_c();
         _loc1_.addEventListener("changing",this.__notificationList_changing);
         _loc1_.id = "notificationList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.notificationList = _loc1_;
         BindingManager.executeBindings(this,"notificationList",this.notificationList);
         return _loc1_;
      }
      
      private function _NotificationCenter_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = NotificationRenderer;
         return _loc1_;
      }
      
      public function __notificationList_changing(param1:IndexChangeEvent) : void
      {
         this.onItemSelected(param1);
      }
      
      private function _NotificationCenter_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
         _loc1_.notificationsEnabled = false;
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function ___NotificationCenter_View1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      private function _NotificationCenter_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("NOTIFICATION_CENTER");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[2] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"notificationList.bottom");
         result[3] = new Binding(this,function():IList
         {
            return provider;
         },null,"notificationList.dataProvider");
         result[4] = new Binding(this,function():Boolean
         {
            return HoermannRemote.appData.userId >= 0;
         },null,"bbar.logoutEnabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bbar() : BottomBar
      {
         return this._3016817bbar;
      }
      
      public function set bbar(param1:BottomBar) : void
      {
         var _loc2_:Object = this._3016817bbar;
         if(_loc2_ !== param1)
         {
            this._3016817bbar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bbar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnBack() : Button
      {
         return this._205678947btnBack;
      }
      
      public function set btnBack(param1:Button) : void
      {
         var _loc2_:Object = this._205678947btnBack;
         if(_loc2_ !== param1)
         {
            this._205678947btnBack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnBack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get notificationList() : List
      {
         return this._1611284521notificationList;
      }
      
      public function set notificationList(param1:List) : void
      {
         var _loc2_:Object = this._1611284521notificationList;
         if(_loc2_ !== param1)
         {
            this._1611284521notificationList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notificationList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get provider() : ArrayCollection
      {
         return this._987494927provider;
      }
      
      private function set provider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._987494927provider;
         if(_loc2_ !== param1)
         {
            this._987494927provider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"provider",_loc2_,param1));
            }
         }
      }
   }
}
