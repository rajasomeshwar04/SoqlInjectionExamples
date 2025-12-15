public class SafeExample {

    public static void caller(String userInput) {
        String soql = getQuery(userInput);
        Database.query(soql); // should be safe
    }

    public static String getQuery(String s) {
        String safe = String.escapeSingleQuotes(s);
        return 'SELECT Id FROM Account WHERE Name = \'' + safe + '\'';
    }
}
