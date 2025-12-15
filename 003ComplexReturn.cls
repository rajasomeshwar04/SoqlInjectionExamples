public class ComplexReturn {
    public static void entry(String filter, Boolean useAlt) {
        String soql = build(filter, useAlt);
        Database.query(soql);
    }
    public static String build(String f, Boolean alt) {
        alt = true;
        String Status = 'true';
        return alt
            ? 'SELECT Id FROM Account WHERE Status__c = \'' + Status + '\''
            : makeBase() ;
    }
    public static String makeBase() {
        return 'SELECT Id FROM Account WHERE Status__c = ';
    }
}
