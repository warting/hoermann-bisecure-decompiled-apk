package refactor.bisecur._1_APP.components.popups
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.lw.Debug;
   import flash.events.Event;
   import flash.events.LocationChangeEvent;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.Capabilities;
   import me.mweber.views.WebView;
   import mx.collections.ArrayList;
   import mx.events.FlexEvent;
   import spark.components.BusyIndicator;
   import spark.components.Button;
   import spark.components.ButtonBar;
   import spark.components.Group;
   import spark.events.IndexChangeEvent;
   
   public class InfoBox extends Popup
   {
      
      private static const INFOS:String = "INFO_BOX_INFOS";
      
      private static const FAQ:String = "INFO_BOX_FAQ";
      
      private static const ABOUT:String = "INFO_BOX_ABOUT";
       
      
      private var _navBar:ButtonBar;
      
      private var _container:Group;
      
      private var _htmlView:WebView;
      
      private var _submit:Button;
      
      private var biContent:BusyIndicator;
      
      public function InfoBox()
      {
         super();
         this.title = Lang.getString("INFO");
         this.addEventListener(FlexEvent.CREATION_COMPLETE,this.onComplete);
      }
      
      private function onComplete(param1:FlexEvent) : void
      {
         this._htmlView = new WebView();
         this._htmlView.height = this._container.height;
         this._htmlView.width = this._container.width;
         this._container.addElement(this._htmlView);
         var _loc2_:Class = Capabilities;
         this.showView(0);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._navBar = new ButtonBar();
         this._navBar.dataProvider = new ArrayList([Lang.getString(INFOS),Lang.getString(FAQ)]);
         this._navBar.selectedIndex = 0;
         this._navBar.addEventListener(IndexChangeEvent.CHANGING,this.onNavElement);
         this.addElement(this._navBar);
         this._container = new Group();
         this.addElement(this._container);
         this._submit = new Button();
         this._submit.label = Lang.getString("GENERAL_SUBMIT");
         this._submit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.addElement(this._submit);
         this.biContent = new BusyIndicator();
         this.biContent.visible = false;
         this.titleBar.addElement(this.biContent);
      }
      
      private function onNavElement(param1:IndexChangeEvent) : void
      {
         if(param1 && param1.newIndex < 0)
         {
            this._navBar.callLater(this.setIndex,[param1.oldIndex]);
            return;
         }
         this.showView(param1.newIndex);
      }
      
      public function setIndex(param1:int) : void
      {
         this._navBar.selectedIndex = param1;
      }
      
      private function showView(param1:int) : void
      {
         var index:int = param1;
         this.showLoading(function():void
         {
            _htmlView.stop();
            switch(index)
            {
               case 0:
                  showInfos();
                  break;
               case 1:
                  showFAQ();
                  break;
               case 2:
                  showAbout();
                  break;
               default:
                  Debug.warning("[InfoBox] index \'" + index + "\' not found");
            }
         });
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         this.close();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this._navBar.width = _loc3_;
         this._container.width = _loc3_;
         this._container.height = this.content.maxHeight - (this._submit.height + this._navBar.height + innerPadding * 4);
         this._submit.width = _loc3_;
         this.biContent.y = innerPadding;
         this.biContent.x = this.content.width - (this.biContent.width + innerPadding);
         super.updateDisplayList(param1,param2);
      }
      
      private function showLoading(param1:Function) : void
      {
         var onComplete:Function = null;
         var callback:Function = param1;
         this._htmlView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,onComplete = function(param1:Event):void
         {
            _htmlView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,onComplete);
            callback.call();
         });
         this._htmlView.loadString("<html></html>");
         this.biContent.visible = true;
      }
      
      private function showInfos() : void
      {
         var _loc1_:* = "com/isisic/remote/hoermann/assets/texts/Infos_" + Lang.getString("LANG_TAG") + ".txt";
         var _loc2_:File = File.applicationDirectory.resolvePath(_loc1_);
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(_loc2_,FileMode.READ);
         var _loc4_:String = _loc3_.readUTFBytes(_loc3_.bytesAvailable);
         _loc3_.close();
         Debug.debug("[InfoBox] using HTML FontSize: " + MultiDevice.htmlFontSize);
         var _loc5_:* = "<!DOCTYPE HTML><html><head><style type=\"text/css\">" + "body{" + "font-size:" + MultiDevice.htmlFontSize + "pt;" + "}" + "div{" + "padding:15px;" + "}" + ".title{" + "font-weight:bold;" + "}" + "</style></head>";
         _loc5_ = _loc5_ + ("<body><div><p class=\"title\">" + Lang.getString("POPUP_WARNING") + "</p><p class=\"content\">" + Lang.getString("POPUP_GATE_OUT_OF_VIEW") + "</p></div>");
         _loc5_ = _loc5_ + ("<div><p class=\"title\">" + Lang.getString("POPUP_INFO") + "</p><p class=\"content\">" + Lang.getString("POPUP_GATE_NOT_RESPONSABLE") + "</p></div>");
         _loc5_ = _loc5_ + ("<div><p><a href=\"" + Lang.getString("LINK_TERMS_OF_USE") + "\">" + Lang.getString("POPUP_AGREEMENT_TERMS_OF_USE") + "</a></p>");
         _loc5_ = _loc5_ + ("<p><a href=\"" + Lang.getString("LINK_TERMS_OF_PRIVACY") + "\">" + Lang.getString("POPUP_AGREEMENT_TERMS_OF_PRIVACY") + "</a></p></div>");
         _loc5_ = _loc5_ + "</body></html>";
         this._htmlView.loadString(_loc5_);
         this.biContent.visible = false;
      }
      
      private function showFAQ() : void
      {
         var onComplete:Function = null;
         this._htmlView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,onComplete = function(param1:Event):void
         {
            _htmlView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,onComplete);
            biContent.visible = false;
         });
         this._htmlView.load("http://www.bisecur-home.com/faqs");
      }
      
      private function showAbout() : void
      {
         this._htmlView.loadString(ABOUT,"text/plain");
      }
   }
}
