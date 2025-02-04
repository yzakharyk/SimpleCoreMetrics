import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class SimpleCoreMetricsView extends WatchUi.WatchFace {
  function initialize() {
    WatchFace.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {}

  // Update the view
  function onUpdate(dc as Dc) as Void {
    setDate();

    setNotifications();

    setBattery();

    setWeather();

    setBluetoothIndicator();

    setTime();

    setAlarmIndicator();

    setHeartRate();

    setCalories();

    setDistance();

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {}

  private function setDate() as Void {
    var dateLabel = View.findDrawableById("DateLabel") as Text;
    var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$", [now.day_of_week, now.day]);
    dateLabel.setText(dateString);
  }

  private function setNotifications() as Void {
    var notificationCountLabel =
      View.findDrawableById("NotificationCountLabel") as Text;
    var notificationCountIcon =
      View.findDrawableById("NotificationCountIcon") as Text;

    var notificationCount = System.getDeviceSettings().notificationCount;

    if (notificationCount > 0) {
      notificationCountIcon.setVisible(true);
      notificationCountLabel.setVisible(true);
      notificationCountLabel.setText(notificationCount.toString());
    } else if (notificationCount == 0) {
      notificationCountIcon.setVisible(false);
      notificationCountLabel.setVisible(false);
    }
  }

  private function setBattery() as Void {
    var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
    var batteryPercentage =
      Toybox.System.getSystemStats().battery.toNumber().toString() + "%";
    var batteryInDays =
      Toybox.System.getSystemStats().batteryInDays.format("%.1f");
    var batteryString = batteryPercentage + " " + batteryInDays;
    batteryLabel.setText(batteryString);
  }

  private function setWeather() as Void {
    var weatherLabel = View.findDrawableById("WeatherLabel") as Text;

    var currentWeather = Weather.getCurrentConditions();
    if (currentWeather == null) {
      weatherLabel.setText("--/--");
      return;
    }

    var isTemperatureCelcius =
      System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC;

    // low-high temperatures
    var lowTemperatureStr;
    var lowTemperatureCelcius = currentWeather.lowTemperature;
    if (lowTemperatureCelcius != null) {
      var lowTemperature = isTemperatureCelcius
        ? lowTemperatureCelcius
        : (lowTemperatureCelcius * 9) / 5 + 32;
      lowTemperatureStr = Math.round(lowTemperature).toNumber() + "°";
    } else {
      lowTemperatureStr = "--";
    }

    var highTemperatureStr;
    var highTemperatureCelcius = currentWeather.highTemperature;
    if (highTemperatureCelcius != null) {
      var highTemperature = isTemperatureCelcius
        ? highTemperatureCelcius
        : (highTemperatureCelcius * 9) / 5 + 32;
      highTemperatureStr = Math.round(highTemperature).toNumber() + "°";
    } else {
      highTemperatureStr = "--";
    }

    var lowHighTempsStr = lowTemperatureStr + "-" + highTemperatureStr;

    // feels like temperature
    var feelsLikeTempStr;
    var feelsLikeTempCelcius = currentWeather.feelsLikeTemperature;

    if (feelsLikeTempCelcius != null) {
      var feelsLikeTemp = isTemperatureCelcius
        ? feelsLikeTempCelcius
        : (feelsLikeTempCelcius * 9) / 5 + 32;
      feelsLikeTempStr = Math.round(feelsLikeTemp).toNumber() + "°";
    } else {
      feelsLikeTempStr = "--";
    }

    // precipitation chance
    var precipitationChance = currentWeather.precipitationChance;
    var precipitationChanceStr = precipitationChance != null ? "p" + precipitationChance + "%" : "--";

    // whole weather string
    var weatherString =
      lowHighTempsStr + "  " + feelsLikeTempStr + "  " + precipitationChanceStr;

    weatherLabel.setText(weatherString);
  }

  private function setBluetoothIndicator() as Void {
    var phoneConnectionLabel =
      View.findDrawableById("PhoneConnectionLabel") as Text;
    var isPhoneDisconnected = !System.getDeviceSettings().phoneConnected;
    if (isPhoneDisconnected) {
      phoneConnectionLabel.setVisible(true);
    } else {
      phoneConnectionLabel.setVisible(false);
    }
  }

  private function setTime() as Void {
    var clockTime = System.getClockTime();

    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour.format("%02d"),
      clockTime.min.format("%02d"),
    ]);

    var timeLabel = View.findDrawableById("TimeLabel") as Text;
    timeLabel.setText(timeString);
  }

  private function setAlarmIndicator() as Void {
    var alarmClockLabel = View.findDrawableById("AlarmClockLabel") as Text;
    var isAlarmClockSet = System.getDeviceSettings().alarmCount > 0;
    if (isAlarmClockSet) {
      alarmClockLabel.setVisible(true);
    } else {
      alarmClockLabel.setVisible(false);
    }
  }

  private function setHeartRate() as Void {
    var currentHeartRate = Activity.getActivityInfo().currentHeartRate;
    var currentHeartRateStr =
      currentHeartRate != null ? currentHeartRate.toString() : "--";

    var heartRateLabel = View.findDrawableById("HeartRateLabel") as Text;
    heartRateLabel.setText(currentHeartRateStr);
  }

  private function setCalories() as Void {
    var calories = Toybox.ActivityMonitor.getInfo().calories;
    var caloriesStr = calories != null ? calories.toString() : "--";
    var caloriesLabel = View.findDrawableById("CaloriesLabel") as Text;
    caloriesLabel.setText(caloriesStr);
  }

  private function isDistanceMetric() as Boolean {
    return System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
  }

  private function setDistance() as Void {
    var distanceUnits = View.findDrawableById("DistanceUnits") as Text;
    distanceUnits.setText(isDistanceMetric() ? "km" : "mi");

    var distanceLabel = View.findDrawableById("DistanceLabel") as Text;
    var distanceCm = Toybox.ActivityMonitor.getInfo().distance;
    if (distanceCm == null) {
      distanceLabel.setText("--");
      return;
    }
    var distance = isDistanceMetric()
      ? distanceCm / 100000.0
      : distanceCm / 160934.0;
    var distanceStr = distance.format("%.1f");
    distanceLabel.setText(distanceStr);
  }
}
