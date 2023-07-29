class Utils{
  static String toBNNumber(String number){
    try {
      var chars = ["০", "১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯"];
      var numbers = number.split("");
      String bnNumber = "";
      for (String n in numbers) {
        int nn = int.parse(n);
        bnNumber += chars[nn];
      }
      return bnNumber;
    } catch(ex){
      print(ex);
      return number;
    }
  }
}