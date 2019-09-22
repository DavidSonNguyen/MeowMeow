class Helper {
  static String encode(String text) {
    RegExp rx = new RegExp(".");
    return text.replaceAll(rx, "*");
  }
}
