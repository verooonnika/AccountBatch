public with sharing class AccountHierarchyService {

    public Map<Account, List<Account>> hierarchy;

    public AccountHierarchyService(Map<Account, List<Account>> hierarchyOneLevel){
        hierarchy = hierarchyOneLevel;
    }

    public Map<Account, List<Account>> getHierarchy(Account account){ 

        if(account.ParentId != null){
            for(Account accKey: hierarchy.keySet()){
                if(accKey.Id == account.ParentId){
                    List<Account> listh = new List<Account>(hierarchy.get(accKey));
                    List<Account> list2 = new List<Account>(hierarchy.get(account));
                    listh.addAll(list2);
                    Set<Account> accSet = new Set<Account>(listh);
                    List<Account> accList = new List<Account>(accSet);
                    hierarchy.put(accKey, accList);
                    getHierarchy(accKey);
                }
            }
        }
        
        return hierarchy;
    }

}