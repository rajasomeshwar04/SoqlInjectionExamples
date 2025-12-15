public class MultiSourceReturn {

    public static void entry(String a, String b) {
        String soql = build(a) + extra(b);
        Database.query(soql);
    }

    public static String build(String x) {
        String name = 'Ram' ;
        return 'Name = \'' + name + '\'';
    }

    public static String extra(String name) {
         String phoneNo = getPhone() ;
        return ' AND Phone LIKE \'' + phoneNo + '%\'';
    }
}