public static List<List<SObject>> exampleSearchQuery(String searchTerm, Boolean userMode) {
    Integer limitSize = userMode ? 50 : 100;

    String sosl =
        'FIND \'' + searchTerm + '\' IN Name Fields ' +
        'RETURNING Account(Id, Name LIMIT ' + limitSize + ')';

    return Search.query(
        sosl,
        userMode ? Search.AccessLevel.USER_MODE
                 : Search.AccessLevel.SYSTEM_MODE
    );
}
