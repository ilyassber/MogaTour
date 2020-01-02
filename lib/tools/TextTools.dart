class TextTools {

  String resizeText(String text, int n) {
    String newText;
    if (text.length <= n)
      return text;
    newText = text.substring(0, (n - 3)) + '...';
    return newText;
  }
}