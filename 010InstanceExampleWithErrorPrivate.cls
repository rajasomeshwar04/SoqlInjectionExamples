public class InstanceFieldFlow {

    private String searchTerm;

    public void setSearchTerm(String input) {
        searchTerm = input;
    }

    public void runQuery() {
        String soql =
            'SELECT Id FROM Account WHERE Name LIKE \'%' + searchTerm + '%\'';
        Database.query(soql);
    }
}
