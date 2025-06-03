class CookiesService {
  static Map<String, String> savedCookies = {"Cookie": ""};

  // Setting cloud front cookies in a shared static variable
  static void setAndModifyCloudFrontCookies(String allCookies) {
    String cookieForSave = '';

    allCookies.replaceAll(" ", "").split(",").forEach((obj) {
      List<String> objList = obj.split(";");
      cookieForSave = cookieForSave +
          objList[0].split("=")[0] +
          '=' +
          objList[0].split("=")[1] +
          '; ';
    });

    cookieForSave = cookieForSave.substring(1, cookieForSave.length - 2);

    savedCookies = {"Cookie": cookieForSave};
  }
}
