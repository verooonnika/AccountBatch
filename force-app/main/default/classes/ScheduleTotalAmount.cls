global class ScheduleTotalAmount implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AccountHierarchyPreparation());
    }

}