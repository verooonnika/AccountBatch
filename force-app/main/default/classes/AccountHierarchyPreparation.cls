global class AccountHierarchyPreparation implements Database.Batchable<sObject>, Database.Stateful {
    public Map<Account, List<Account>> hierarchy = new Map<Account, List<Account>>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Total_Amount__c, ParentId, Name, ' +
                                        + '(SELECT Amount, StageName FROM Opportunities WHERE StageName = \'Closed Won\') ' +
                                        + 'FROM Account');
        
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accounts){
        
        for(Account account: accounts){
            
            List<Account> children = new List<Account>();
            hierarchy.put(account, children);
            
            for(Account parent: hierarchy.keySet()){
                if(parent.Id == account.ParentId){
                    List<Account> ch = new List<Account>(hierarchy.get(parent));
                    ch.add(account);
                    hierarchy.put(parent, ch);
                    break;
                }
            }
            
            for(Account parent: hierarchy.keySet()){
                if(account.Id == parent.ParentId){
                    List<Account> ch = new List<Account>(hierarchy.get(account));
                    ch.add(parent);
                    hierarchy.put(account, ch);
                }
            }
        }
        
        AccountHierarchyService service = new AccountHierarchyService(hierarchy);
        
        for(Account parent: hierarchy.keySet()){
            if(hierarchy.get(parent).isEmpty()){  
                hierarchy = service.getHierarchy(parent);
            }
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        Database.executeBatch(new TotalAmountCalculation(hierarchy));
    }
}