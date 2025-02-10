import Toybox.Lang;

class Utils {

  static function getWindArrow(windBearing as Number?) as String {
    if (windBearing == null) {
      return ""; 
    }

    if (windBearing >= 337.5 || windBearing < 22.5) {
      return "↓"; // North
    } else if (windBearing >= 22.5 && windBearing < 67.5) {
      return "↙"; // North-East
    } else if (windBearing >= 67.5 && windBearing < 112.5) {
      return "←"; // East
    } else if (windBearing >= 112.5 && windBearing < 157.5) {
      return "↖"; // South-East
    } else if (windBearing >= 157.5 && windBearing < 202.5) {
      return "↑"; // South
    } else if (windBearing >= 202.5 && windBearing < 247.5) {
      return "↗"; // South-West
    } else if (windBearing >= 247.5 && windBearing < 292.5) {
      return "→"; // West
    } else if (windBearing >= 292.5 && windBearing < 337.5) {
      return "↘"; // North-West
    }
    return "";
  }
}
