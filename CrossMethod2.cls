public class InterMethodFlow {

    public static void entryPoint(String nameFromVF) {
        String normalized = nameFromVF.tosoql();
        buildAndRunQuery(normalized);
    }
    public static void entryPoint1(String nameFromVF) {
        String normalized = getName();
        buildAndRunQuery(normalized);
    }

    private static void buildAndRunQuery(String value) {
        String soql =
            'SELECT Id FROM Account WHERE Name = \'' + value + '\'';
        Database.query(soql);
    }
}
