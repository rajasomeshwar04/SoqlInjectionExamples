public class PartialReturnFlow {

    public static void run(String input) {
        String filter = makeFilter(input);
        String soql = 'SELECT Id FROM Account WHERE ' + filter;
        Database.query(soql);
    }

    public static String makeFilter(String f) {
        return 'Name = \'' + f + '\'';
    }
}
