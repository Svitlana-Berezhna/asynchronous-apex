// Call in Developer Console:
// System.schedule('Two Batch Jobs (every 0 minutes)', '0 0 * * * ?', new UsingScheduledJob());  
// System.schedule('Two Batch Jobs (every 30 minutes)', '0 30 * * * ?', new UsingScheduledJob()); 

global class UsingScheduledJob implements Schedulable {    
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new UsingBatchJobAndQueryLocator());
        Database.executeBatch(new UsingBatchJobAndIterable());
    }
}
