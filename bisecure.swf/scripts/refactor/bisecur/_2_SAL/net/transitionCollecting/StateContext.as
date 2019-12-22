package refactor.bisecur._2_SAL.net.transitionCollecting
{
   import com.codecatalyst.promise.Deferred;
   import com.codecatalyst.promise.Promise;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.net.transitionCollecting.states.Error_State;
   import refactor.bisecur._2_SAL.net.transitionCollecting.states.Parsing;
   import refactor.bisecur._2_SAL.net.transitionCollecting.states.Preperation;
   import refactor.bisecur._2_SAL.net.transitionCollecting.states.StateBase;
   import refactor.bisecur._2_SAL.net.transitionCollecting.states.TransitionRequest;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class StateContext implements IDisposable
   {
      
      public static const MAX_REQUEST_RETRYS:int = 2;
      
      public static const MAX_ERROR_RETRYS:int = 5;
      
      private static const PreparationState:Preperation = new Preperation();
      
      private static const TransitionRequestState:TransitionRequest = new TransitionRequest();
      
      private static const ParsingState:Parsing = new Parsing();
      
      private static const ErrorState:Error_State = new Error_State();
       
      
      private var promiseDeferred:Deferred;
      
      private var _groupType:uint = 0;
      
      private var _groupId:uint = 255;
      
      private var _portId:uint = 255;
      
      private var _transitionData:ByteArray = null;
      
      private var _transition:HmTransition = null;
      
      private var _requestCount:int = 0;
      
      private var _errorCount:int = 0;
      
      private var _error:Error = null;
      
      private var _shouldCancel:Boolean = false;
      
      private var _lastState:StateBase = null;
      
      private var _activeState:StateBase = null;
      
      private var _finished:Boolean = false;
      
      public function StateContext(param1:uint)
      {
         super();
         this._groupId = param1;
      }
      
      public function dispose() : void
      {
         this._transitionData = null;
         this._transition = null;
         this._error = null;
      }
      
      public function request() : Promise
      {
         return this.onStartRequest();
      }
      
      public function cancel() : void
      {
         this._shouldCancel = true;
      }
      
      public function get isRequestable() : Boolean
      {
         return this._portId != 255;
      }
      
      public function get groupId() : uint
      {
         return this._groupId;
      }
      
      public function get groupType() : uint
      {
         return this._groupType;
      }
      
      public function get portId() : uint
      {
         return this._portId;
      }
      
      public function get transitionData() : ByteArray
      {
         return this._transitionData;
      }
      
      public function get transition() : HmTransition
      {
         return this._transition;
      }
      
      public function get error() : Error
      {
         return this._error;
      }
      
      public function get requestCount() : int
      {
         return this._requestCount;
      }
      
      public function get errorCount() : int
      {
         return this._errorCount;
      }
      
      public function resetRequestCounter() : *
      {
         this._requestCount = 0;
      }
      
      public function onStartRequest() : Promise
      {
         this.promiseDeferred = new Deferred();
         this._transitionData = null;
         this._transition = null;
         this._requestCount = 0;
         this._errorCount = 0;
         this._error = null;
         this._shouldCancel = false;
         this._lastState = null;
         this._activeState = null;
         this._finished = false;
         this.processTransition(null,PreparationState);
         return this.promiseDeferred.promise;
      }
      
      public function onRetry() : void
      {
         this.processTransition(ErrorState,PreparationState);
      }
      
      public function onPreparationFinished(param1:uint, param2:uint) : void
      {
         this._groupType = param1;
         this._portId = param2;
         this._requestCount++;
         this.processTransition(PreparationState,TransitionRequestState);
      }
      
      public function onTransitionReceived(param1:ByteArray) : void
      {
         this._transitionData = param1;
         this.processTransition(TransitionRequestState,ParsingState);
      }
      
      public function onTransitionParsed(param1:HmTransition) : void
      {
         this._finished = true;
         this._transition = param1;
         this.promiseDeferred.resolve({
            "context":this,
            "transition":param1
         });
      }
      
      public function onError(param1:StateBase, param2:Error) : void
      {
         this._errorCount++;
         this._error = param2;
         this.processTransition(param1,ErrorState);
      }
      
      public function onRequestFailed(param1:Error) : void
      {
         this._finished = true;
         this._error = param1;
         this.promiseDeferred.reject({
            "context":this,
            "error":param1
         });
      }
      
      private function processTransition(param1:StateBase, param2:StateBase) : void
      {
         if(this._shouldCancel)
         {
            this.onRequestFailed(new Error("Request canceled!"));
            return;
         }
         this._lastState = param1;
         this._activeState = param2;
         if(param1 != null)
         {
            param1.Exit(this);
         }
         param2.Enter(this);
      }
   }
}
