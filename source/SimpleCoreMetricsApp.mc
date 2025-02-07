import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SimpleCoreMetricsApp extends Application.AppBase {
  var view;

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {}

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {}

  // Return the initial view of your application here
  function getInitialView() as [Views] or [Views, InputDelegates] {
    view = new SimpleCoreMetricsView();
    return [ view ];
  }

  // New app settings have been received so trigger a UI update
  function onSettingsChanged() as Void {
    view.handleSettingsUpdate();
    WatchUi.requestUpdate();
  }
}

function getApp() as SimpleCoreMetricsApp {
  return Application.getApp() as SimpleCoreMetricsApp;
}
