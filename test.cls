// File: SoqlInjectionViolationExamples.cls
public with sharing class SoqlInjectionViolationExamples {

    //
    // 1) Classic SOQL injection via Database.query(String)
    //
    public static List<Account> exampleDatabaseQuery(String userInput) {
        // userInput is untrusted (e.g., from URL param, form, etc.)
        String soql =
            'SELECT Id, Name FROM Account ' +
            'WHERE Name = \'' + userInput + '\'';                 // concat untrusted input

        // VIOLATION: untrusted input concatenated into dynamic SOQL
        return Database.query(soql);
    }

    //
    // 2) Database.query(String) with more complex expression
    //
    public static List<Contact> exampleDatabaseQueryExpression(String first, String last) {
        String where =
            'WHERE FirstName LIKE \'' + first + '%\' ' +          // untrusted
            'AND LastName LIKE \'' + last + '%\'';                // untrusted

        String soql =
            'SELECT Id, FirstName, LastName FROM Contact ' +
            where +                                                // expression with concat vars
            ' ORDER BY LastName';

        // VIOLATION: argument is an expression containing concatenated user input
        return Database.query(soql);
    }

    //
    // 3) Database.queryWithBinds(String, Map<String,Object>, AccessLevel) misused
    //    String still built unsafely even though binds are used.
    //
    public static List<SObject> exampleQueryWithBinds(String objApiName, String filter) {
        String base =
            'SELECT Id, Name FROM ' + objApiName + ' ';           // objApiName untrusted

        String soql =
            base +
            'WHERE Name LIKE \'%' + filter + '%\'';                // filter untrusted

        Map<String,Object> binds = new Map<String,Object>();
        binds.put('dummy', true);

        // VIOLATION: first parameter built from untrusted parts
        return Database.queryWithBinds(
            soql,                                                  // VIOLATION
            binds,
            Database.AccessLevel.USER_MODE
        );
    }

    //
    // 4) Database.getQueryLocator(String) with injection
    //
    public static Database.QueryLocator exampleGetQueryLocator(String city) {
        String soql =
            'SELECT Id, Name FROM Account ' +
            'WHERE BillingCity = \'' + city + '\'';               // untrusted

        // VIOLATION: untrusted input in locator query
        return Database.getQueryLocator(soql);
    }

    //
    // 5) SOSL injection via Search.find(String)
    //
    public static List<List<SObject>> exampleSearchFind(String userTerm) {
        String sosl =
            'FIND \'' + userTerm + '*\' ' +                       // untrusted
            'IN ALL FIELDS ' +
            'RETURNING Account(Id, Name), Contact(Id, LastName)';

        // VIOLATION: untrusted term concatenated into SOSL
        return Search.find(sosl);
    }

    //
    // 6) SOSL injection via Search.query(String, AccessLevel)
    //
    public static List<List<SObject>> exampleSearchQuery(String searchTerm, Boolean userMode) {
        Integer limitSize = userMode ? 50 : 100;

        String sosl =
            'FIND \'' + searchTerm + '\' IN Name Fields ' +       // untrusted
            'RETURNING Account(Id, Name LIMIT ' + limitSize + ')';

        // VIOLATION: first parameter built using untrusted input
        return Search.query(
            sosl,                                                  // VIOLATION
            userMode ? Search.AccessLevel.USER_MODE
                     : Search.AccessLevel.SYSTEM_MODE
        );
    }

    //
    // 7) Injection-like misuse of Search.suggest(String, String, SuggestionOption)
    //
    public static List<Search.SuggestionResult> exampleSearchSuggest(String prefix, String objName) {
        Search.SuggestionOption opt = new Search.SuggestionOption();
        opt.max = 10;

        // prefix & objName are untrusted
        // VIOLATION: first and second params use untrusted input directly
        return Search.suggest(
            prefix,                                                // VIOLATION (arg 1)
            objName,                                               // VIOLATION (arg 2)
            opt
        );
    }

    //
    // 8) fflib_QueryFactory + additional unsafe concatenation
    //
    public static List<Account> exampleQueryFactory(String userStatus, String rawLimit) {

        // assume fflib_QueryFactory is installed
        fflib_QueryFactory qf = new fflib_QueryFactory(Account.SObjectType);
        qf.selectField('Id');
        qf.selectField('Name');
        qf.selectField('Status__c');

        // Safe-ish usage inside QueryFactory (but string still built manually)
        qf.setCondition('Status__c = \'' + userStatus + '\'');     // untrusted

        // Bad: appending more untrusted text after toSOQL()
        String finalSoql =
            qf.toSOQL() +
            ' LIMIT ' + rawLimit;                                  // untrusted

        // VIOLATION: finalSoql includes untrusted rawLimit and userStatus
        return Database.query(finalSoql);
    }

    //
    // 9) Combination of method call + ternary + concatenation
    //    More complex expression for static analyzer to handle.
    //
    public static List<Account> complexExpressionViolation(String nameOrAll, Boolean includeClosed) {
        String filter =
            (nameOrAll == 'ALL')
                ? ' Name != null '                                 // still user-controlled choice
                : ' Name = \'' + nameOrAll + '\'';                 // untrusted

        String extra =
            includeClosed
                ? ' AND IsClosed__c = false '
                : '';

        String soql =
            'SELECT Id, Name FROM Account WHERE ' +
            filter + extra;                                        // expression built from untrusted parts

        // VIOLATION: argument is a complex expression with user-controlled content
        return Database.query(soql);
    }
}
