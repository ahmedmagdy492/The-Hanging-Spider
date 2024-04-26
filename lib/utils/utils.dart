class Utils {
  static List<int> getAllIndexesOfAChar(String char, String str) {
    List<int> indicies = [];

    for (int i = 0; i < str.length; ++i) {
      if (str[i].toLowerCase() == char.toLowerCase()) {
        indicies.add(i);
      }
    }

    return indicies;
  }
}
