public class InterMethodFlow {

    private static void buildAndRunQuery(String soql) {
        soql = getName();
         soql ='Select ';
        Database.query(soql);
    }
}