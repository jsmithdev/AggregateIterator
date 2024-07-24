public with sharing class AggregateBatchExample implements Database.Batchable<sObject> {

    public Iterable<AggregateResult> start(Database.BatchableContext bc){ 
        return new CustomIterable();
    }

    public void execute(Database.BatchableContext bc, List<AggregateResult> scope) {
        logicExample(scope);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('AggregateBatchExample finished');
    }

    public with sharing class CustomIterable implements Iterable<AggregateResult> {

        public Iterator<AggregateResult> iterator(){

            String query = queryExample();

            return new AggregateIterator(
                Database.query(query)
            );
        }
    }
    
    private static String queryExample() {
        return ''+
            'SELECT Account.ParentId '+
            'FROM Opportunity '+
            'GROUP BY Account.ParentId'+
        '';
    }
    
    private static void logicExample(List<AggregateResult> ars) {

        /* 
        In this example we are getting Opp Account ParentIds to show 
        every Parent Account's Expected Revenue for all it's opportunities.
        We could make a field on account to store the expected revenue from opps but
        this is more to show how to break down the aggregate result from the iterator.
        */
        
        List<Id> accIds = new List<Id>();

        for(AggregateResult ar : ars) {
            accIds.add((Id)ar.get('ParentId'));
        }

        System.debug('Parent Account Size: '+accIds.size());

        for(Opportunity opp : [
            SELECT ExpectedRevenue, Account.ParentId 
            FROM Opportunity 
            WHERE Account.ParentId IN: accIds
            ORDER BY Account.ParentId, ExpectedRevenue DESC
        ]) {
            System.debug(Account.ParentId +': '+ opp.ExpectedRevenue);
        }
    }
}