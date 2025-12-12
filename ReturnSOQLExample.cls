public class ReturnSOQLExample {

    public static void entry(String userInput) {
        String soql = buildSOQL(userInput);
        Database.query(soql);
    }

    public static String buildSOQL(String x) {
        return 'SELECT Id FROM Account WHERE Name = \'' + x + '\'';
    }
}
