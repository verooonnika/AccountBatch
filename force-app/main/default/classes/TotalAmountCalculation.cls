public class TotalAmountCalculation implements Database.Batchable<sObject>, Database.Stateful {
    
    public Map<Account, List<Account>> hierarchy;
    // public TotalAmountService service;
    
    public TotalAmountCalculation(Map<Account, List<Account>> accountHierarchy){
        
        hierarchy = accountHierarchy;
    }
    
    public List<Account> start(Database.BatchableContext bc){
        
        List<Account> accounts = new List<Account>();
        for(Account account: hierarchy.keySet()){
            accounts.add(account);
        }
        return accounts;
        
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accounts){
        
        List<Account> toUpdate = new List<Account>();
        TotalAmountService service = new TotalAmountService(accounts);
        
        for(Account account: accounts){
            
            if(hierarchy.get(account) == null){ /////////////////////////////
                break;
            }
            
            if(hierarchy.get(account).isEmpty()){
                service.calculateTotalAmount(account);
            } 
            
            toUpdate.add(account);
        } 
        
        update toUpdate;
        
        for(Account account: accounts){
            System.debug('Name: ' + account.Name + 'Total Amount: ' + account.Total_Amount__c);
        }
        
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
}