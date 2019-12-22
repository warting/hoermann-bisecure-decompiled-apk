package
{
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.views.actors.ActorScreen;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_actors_ActorScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_actors_ActorScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ActorScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_actors_ActorScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[18] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[bindings[18]],propertyGetter);
         watchers[19] = new PropertyWatcher("height",{"heightChanged":true},[bindings[18]],null);
         watchers[8] = new FunctionReturnWatcher("addButtonHelpVisible",target,function():Array
         {
            return [];
         },{"addButtonHelpVisible":true},[bindings[8]],propertyGetter);
         watchers[11] = new PropertyWatcher("helpArrow",{"propertyChange":true},[bindings[11],bindings[16]],propertyGetter);
         watchers[16] = new PropertyWatcher("width",{"widthChanged":true},[bindings[16]],null);
         watchers[12] = new PropertyWatcher("height",{"heightChanged":true},[bindings[11]],null);
         watchers[3] = new StaticPropertyWatcher("appData",{"propertyChange":true},[bindings[3],bindings[6]],null);
         watchers[4] = new PropertyWatcher("isAdmin",{"propertyChange":true},[bindings[3],bindings[6]],null);
         watchers[23] = new StaticPropertyWatcher("defaultProcessor",{"propertyChange":true},[bindings[21]],null);
         watchers[24] = new PropertyWatcher("transitionCollectingActive",{"processingChanged":true},[bindings[21]],null);
         watchers[22] = new PropertyWatcher("actorProvider",{"propertyChange":true},[bindings[20]],propertyGetter);
         watchers[10] = new PropertyWatcher("btnAdd",{"propertyChange":true},[bindings[10],bindings[13]],propertyGetter);
         watchers[9] = new PropertyWatcher("helpAddGW",{"propertyChange":true},[bindings[9],bindings[12],bindings[14]],propertyGetter);
         watchers[13] = new PropertyWatcher("y",{"yChanged":true},[bindings[12]],null);
         watchers[14] = new PropertyWatcher("height",{"heightChanged":true},[bindings[12]],null);
         watchers[15] = new PropertyWatcher("height",{"heightChanged":true},[bindings[15]],propertyGetter);
         watchers[20] = new PropertyWatcher("bbar",{"propertyChange":true},[bindings[19]],propertyGetter);
         watchers[21] = new PropertyWatcher("height",{"heightChanged":true},[bindings[19]],null);
         watchers[18].updateParent(target);
         watchers[18].addChild(watchers[19]);
         watchers[8].updateParent(target);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[16]);
         watchers[11].addChild(watchers[12]);
         watchers[3].updateParent(HoermannRemote);
         watchers[3].addChild(watchers[4]);
         watchers[23].updateParent(HmProcessor);
         watchers[23].addChild(watchers[24]);
         watchers[22].updateParent(target);
         watchers[10].updateParent(target);
         watchers[9].updateParent(target);
         watchers[9].addChild(watchers[13]);
         watchers[9].addChild(watchers[14]);
         watchers[15].updateParent(target);
         watchers[20].updateParent(target);
         watchers[20].addChild(watchers[21]);
      }
   }
}
