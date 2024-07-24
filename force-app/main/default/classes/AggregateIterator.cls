public with sharing class AggregateIterator implements Iterator<AggregateResult>{ 

    private List<AggregateResult> results;
    private Integer index;
    
    public AggregateIterator(List<AggregateResult> results){
        this.results = results;
        this.index = 0;
    }
    
    public boolean hasNext(){ 
        return results != null && !results.isEmpty() && index < results.size(); 
    }

    public AggregateResult next(){
        if(hasNext()) {
            return results[index++];
        } 
        else {
            throw new NoSuchElementException('Iterator has no more elements.');
        }
    }
}