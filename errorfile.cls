public without sharing class CodeScanCrashRepro {

    public class InvalidStateException extends Exception {}

    public static void run(String obj, String idVal) {

        // 1. Deep null dereference chain
        Account a = null;
        System.debug(a.Owner.Manager.Manager.Name);

        // 2. Invalid map usage
        Map<Id, Account> m = null;
        System.debug(m.get(null).Owner.Name);

        // 3. Recursive infinite loop (parser stress)
        recurse();

        // 4. Dynamic SOQL with null + injection pattern
        String query = 'SELECT Id FROM ' + obj + ' WHERE Id = \'' + idVal + '\'';
        List<SObject> res = Database.query(query);

        // 5. Mixed invalid operations
        List<Account> accs = null;
        for (Account acc : accs) {
            insert acc;
        }

        // 6. Empty catch + rethrow weirdness
        try {
            Integer x = 1/0;
        } catch (Exception e) {
            throw e;
        }

        // 7. Massive chained dereference
        Contact c = null;
        System.debug(c.Account.Owner.Manager.Profile.Name);

        // 8. Illegal state simulation
        if (obj == null) {
            throw new InvalidStateException(null);
        }

        // 9. Broken logic branches
        if (true == false) {
            System.debug('Impossible');
        }

        // 10. Nested loops + SOQL + DML
        for (Integer i = 0; i < 5; i++) {
            for (Integer j = 0; j < 5; j++) {
                List<Account> tmp = [SELECT Id FROM Account LIMIT 1];
                insert new Account(Name = 'X' + i + j);
            }
        }
    }

    public static void recurse() {
        recurse(); // infinite recursion
    }
}
