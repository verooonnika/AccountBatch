@isTest
public with sharing class AccountHierarchyTest {
    @TestSetup
    static void makeData(){

        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 5; i++){
            Account account = new Account(Name = 'Name ' + i);
            accounts.add(account);
        }
        insert accounts;

        for(Integer i = 0; i < accounts.size() - 1; i++){
            accounts[i].ParentId = accounts[i + 1].Id;
        }
        upsert accounts;

        Account acc = new Account(Name = 'Name 6', ParentId = accounts[3].Id);
        insert acc;

        Account acc2 = new Account(Name = 'Name 7', ParentId = accounts[1].Id);
        insert acc2; 

        List<Opportunity> opps = new List<Opportunity>();

        accounts = [SELECT Id, Name, (SELECT  Amount, StageName FROM Opportunities) FROM Account];

        for(Account account: accounts){
            Opportunity opportunity = new Opportunity(Name = 'Test', 
                                                        StageName = 'Closed Won',
                                                        CloseDate = Date.today().addDays(1),
                                                        Amount = 100,
                                                        AccountId = account.Id);

            opps.add(opportunity);

        }

        insert opps;


    }

    @isTest
    public static void AccountHierarchyTest() {

        Test.startTest();
        AccountHierarchyPreparation ahp = new AccountHierarchyPreparation();
        Id BatchId = Database.executeBatch(ahp);
        Test.stopTest();
    }
}