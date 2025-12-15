public class MultiTransform {

    public static void start(String term) {
        String soql = build(term.trim());
        Database.query(soql);
    }

    public static String build(String x) {
        String t = x + '';
        return 'SELECT Id FROM Account WHERE Name = \'' + t + '\'';
    }
}
