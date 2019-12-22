package com.isisic.remote.hoermann.components.stateImages
{
   import com.isisic.remote.hoermann.assets.images.devices.pilomat.durchfahrtssperre.FXG_PDS_StateExtended;
   import com.isisic.remote.hoermann.assets.images.devices.pilomat.durchfahrtssperre.FXG_PDS_StateNotRetracted;
   import com.isisic.remote.hoermann.assets.images.devices.pilomat.durchfahrtssperre.FXG_PDS_StateRetracted;
   import com.isisic.remote.hoermann.skins.stateImageSkins.StateImageSkin;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.styles.CSSStyleDeclaration;
   
   use namespace mx_internal;
   
   public class Pilomat_DurchfahrtssperreStateImage extends Pilomat_PollerStateImage implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function Pilomat_DurchfahrtssperreStateImage()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._Pilomat_DurchfahrtssperreStateImage_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_components_stateImages_Pilomat_DurchfahrtssperreStateImageWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return Pilomat_DurchfahrtssperreStateImage[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         Pilomat_DurchfahrtssperreStateImage._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.skinClass = StateImageSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function get stateImage_Extended() : IVisualElement
      {
         return new FXG_PDS_StateExtended();
      }
      
      override protected function get stateImage_NotRetracted() : IVisualElement
      {
         return new FXG_PDS_StateNotRetracted();
      }
      
      override protected function get stateImage_Retracted() : IVisualElement
      {
         return new FXG_PDS_StateRetracted();
      }
      
      private function _Pilomat_DurchfahrtssperreStateImage_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"this.imageRect","stateContainer");
         return _loc1_;
      }
   }
}
