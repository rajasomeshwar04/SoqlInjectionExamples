public class DeepReturnFlow {
  // for return
    public static void entry(String u) {
        String soql = level1(u);
        Database.query(soql);
    }

    static String level1(String v) { return level2(v); }
    static String level2(String v) { return level3(v); }
    static String level3(String v) { return level4(v); }
    static String level4(String v) { return level5(v); }
      static String level5(String u) {
        String v =getName();
        return 'SELECT Id FROM Account WHERE Name = \'' + v + '\'';
    }
}
