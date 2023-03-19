.pragma library

function get_julian_date() {
    var dt = new Date();
    return julian_date(dt);
}

function julian_date(dt) {
    var MM=dt.getUTCMonth() + 1;
    var DD=dt.getUTCDate();
    var YY=dt.getUTCFullYear();
    var HR=dt.getUTCHours();
    var MN=dt.getUTCMinutes();
    var SC=dt.getUTCSeconds();
    with (Math) {
      var HR = HR + (MN / 60) + (SC/3600);
      var GGG = 1;
      if (YY <= 1585) {
          GGG = 0;
      }
      var JD = -1 * floor(7 * (floor((MM + 9) / 12) + YY) / 4);
      var S = 1;
      if ((MM - 9)<0) {
          S = -1;
      }
      var A = abs(MM - 9);
      var J1 = floor(YY + S * floor(A / 7));
      J1 = -1 * floor((floor(J1 / 100) + 1) * 3 / 4);
      JD = JD + floor(275 * MM / 9) + DD + (GGG * J1);
      JD = JD + 1721027 + 2 * GGG + 367 * YY - 0.5;
      JD = JD + (HR / 24);
    }
    return JD;
}

function calendar_date(julianDate) {
   with (Math) {
      var X = parseFloat(julianDate)+0.5
      var Z = floor(X)
      var F = X - Z
      var Y = floor((Z-1867216.25)/36524.25)
      var A = Z+1+Y-floor(Y/4)
      var B = A+1524
      var C = floor((B-122.1)/365.25)
      var D = floor(365.25*C)
      var G = floor((B-D)/30.6001)
      var month = (G<13.5) ? (G-1) : (G-13)
      var year = (month<2.5) ? (C-4715) : (C-4716)
      month -= 1 // month in JavaScript is from 0 to 11
      var UT = B-D-floor(30.6001*G)+F
      var day = floor(UT)
      UT -= floor(UT)
      UT *= 24;
      var hour = floor(UT)
      UT -= floor(UT)
      UT *= 60
      var minute = floor(UT)
      UT -= floor(UT)
      UT *= 60
      var second = round(UT)
   }
   return new Date(Date.UTC(year, month, day, hour, minute, second));
}

function sin(angle) {
    return Math.sin(angle * Math.PI / 180);
}

function asin(val) {
    return Math.asin(val) * 180 / Math.PI;
}

function cos(angle) {
    return Math.cos(angle * Math.PI / 180);
}

function acos(val) {
    return Math.acos(val) * 180 / Math.PI;
}

function julian_cycle(dt, latitude, longitude) {
    return Math.round(julian_date(dt) - 2451545 - 0.0009 - (-longitude / 360));
}

function solar_noon(dt, latitude, longitude) {
    return 2451545 + 0.0009 + (-longitude / 360) + julian_cycle(dt, latitude, longitude);
}

function solar_mean(dt, latitude, longitude) {
    return (357.5291 + (0.98560028 * (solar_noon(dt, latitude, longitude) - 2451545))) % 360;
}

function equation_center(dt, latitude, longitude) {
    var M = solar_mean(dt, latitude, longitude);
    return 1.9148 * sin(M) + 0.0200 * sin(2*M) + 0.0003 * sin(3*M);
}

function ecliptic_longitude(dt, latitude, longitude) {
    var M = solar_mean(dt, latitude, longitude);
    var C = equation_center(dt, latitude, longitude);
    return (M + 102.9372 + C + 180) % 360;
}

function solar_transit(dt, latitude, longitude) {
    return solar_noon(dt, latitude, longitude) + (0.0053 * sin(solar_mean(dt, latitude, longitude))) - (0.0069 * sin(2*ecliptic_longitude(dt, latitude, longitude)));
}

function sun_declination(dt, latitude, longitude) {
    return asin(sin(ecliptic_longitude(dt, latitude, longitude)) * sin(23.45));
}

function hour_angle(dt, latitude, longitude) {
    var D = sun_declination(dt, latitude, longitude);
    return acos((sin(-0.83) - sin(latitude) * sin(D)) / (cos(latitude) * cos(D)));
}

function solar_elevation(dt, latitude, longitude) {
    var H = hour_angle(dt, latitude, longitude);
    var D = sun_declination(dt, latitude, longitude);
    return asin(cos(H) * cos(D) * cos(latitude) + sin(D) * sin(latitude));
}

function sun_set(dt, latitude, longitude) {
    var H = hour_angle(dt, latitude, longitude);
    var n = julian_cycle(dt, latitude, longitude);
    var M = solar_mean(dt, latitude, longitude);
    var d = ecliptic_longitude(dt, latitude, longitude);
    return 2451545 + 0.0009 + (H + -longitude) / 360 + n + 0.0053 * sin(M) - 0.0069 * sin(2 * d);
}

function sun_rise(dt, latitude, longitude) {
    var tr = solar_transit(dt, latitude, longitude);
    var se = sun_set(dt, latitude, longitude);
    return tr - (se - tr);
}

function sun_azimuth(dt, latitude, longitude) {
    var D = sun_declination(dt, latitude, longitude);
    var t = solar_transit(dt, latitude, longitude);
    var j = julian_date(dt);
    /* Hour angle */
    var h = 15 * 24 * (j - t);
    /* Solar elevation angle */
    var S = asin(cos(h) * cos(D) * cos(latitude) + sin(D) * sin(latitude));
    var ret = acos((sin(D) * cos(latitude) - cos(h) * cos(D) * sin(latitude)) / cos(S));
    if (h < 0) {
        return ret;
    } else {
        return 360 - ret;
    }
}

function moon_phase(dt) {
    var start = new Date(1900, 0, 1);
    return ((julian_date(dt) - julian_date(start)) % 29.530588853) / 29.530588853;
}
