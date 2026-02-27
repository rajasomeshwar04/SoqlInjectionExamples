public class SimpleExample2 {

    public static void entry() {
        String soql = getSoqlStatement();
        soql = String.escapeSingleQuotes( soql );
        Database.query(soql);
    }

}
