public class TotalAmountService {
    
    public List<Account> accounts;
    
    public TotalAmountService(List<Account> parents){
        accounts = parents;
    }
    
    public void calculateTotalAmount(Account account){
        
        for(Opportunity opportunity : account.Opportunities) {
            account.Total_Amount__c += opportunity.Amount;
        }
        
        if(account.ParentId != null){
            for(Account parent: accounts) {
                if(account.ParentId == parent.Id){
                    parent.Total_Amount__c +=  account.Total_Amount__c;
                    calculateTotalAmount(parent);
                }
            }
        }
        
    }
}