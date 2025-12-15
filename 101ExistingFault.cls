public class ReturnSOQLExample {

    public static void entry(String soql) {

        soql = String.escapeSingleQuotes( soql );
        Database.query(soql);
    }

}