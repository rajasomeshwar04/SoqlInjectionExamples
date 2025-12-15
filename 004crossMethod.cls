public class InterMethodFlow {

    public static void entryPoint(String nameFromVF) {
         nameFromVF = nameFromVF.tosoql();
        buildAndRunQuery(nameFromVF);
    }

    private static void buildAndRunQuery(String value) {
        String soql =
            'SELECT Id FROM Account WHERE Name = \'' + value + '\'';
        Database.query(soql);
    }
}
