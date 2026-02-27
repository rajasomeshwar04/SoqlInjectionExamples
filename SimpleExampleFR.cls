public class SimpleExample1 {

    public static void entry(String soql) {

        soql = String.escapeSingleQuotes( soql );
        Database.query(soql);
    }

}
