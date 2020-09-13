global class UsingScheduledJob implements Schedulable {
    public static final String CRON_EXP = '0 0/30 * * * ?'; 
    
    global void execute(SchedulableContext ctx) {
        
        
        UsingBatchJobAndQueryLocator ubjql = new UsingBatchJobAndQueryLocator();
        Database.executeBatch(ubjql);
        
        UsingBatchJobAndIterable ubji = new UsingBatchJobAndIterable();
        Database.executeBatch(ubji);
        
        Database.executeBatch(new UsingBatchJobAndQueryLocator());
        Database.executeBatch(new UsingBatchJobAndIterable());
        
        

        
        
        
        
        
        
        
        
        
        //UsingBatchJobAndQueryLocator sh1 = new UsingBatchJobAndQueryLocator();      
        //String sch = '0  00 1 3 * ?';
        //System.schedule('Test', sch, sh1);
        
        
        
        //System.schedule('Scheduled Job 1', '0 0/1 * * * ?', new UsingBatchJobAndQueryLocator());
        //System.schedule('Scheduled Job 2', '0 0/1 * * * ?', new UsingBatchJobAndIterable());
        
        
        
        //System.Schedule ('Remind Opp Owners', '0 0/30 * * * ?', new UsingBatchJobAndQueryLocator());
        //System.schedule('Remind Opp Owners', CRON_EXP, new UsingBatchJobAndIterable());
        
        //System.schedule(new UsingBatchJobAndQueryLocator, 'jobName 1', 1);
        
        //UsingBatchJobAndQueryLocator m = new UsingBatchJobAndQueryLocator();
        //String sch = '20 30 8 10 2 ?';
        //String jobID = system.schedule('Merge Job', sch, m);
        
        //UsingBatchJobAndQueryLocator ab = new UsingBatchJobAndQueryLocator();
        //String jobId = System.schedule('jobName', '0 5 * * * ?',ab);
        
        
        //System.Schedulable.execute(ctx);
    }
}