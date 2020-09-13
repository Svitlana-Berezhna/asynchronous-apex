// Call in Developer Console:
// QueuebleJob.addJobOnTheQueue();

public class UsingQueuebleJob implements Queueable {      
    
    public List<Account> getContactsForAccountsInWhichBillingAddressIsNotEmpty() {
        List<Account> accounts = [SELECT ID, Name, BillingAddress, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                                  (SELECT ID, Name, Is_Synced__c, Processed_By_Queue__c FROM Contacts)
                                  FROM Account
                                  WHERE (BillingStreet != NULL)
                                  AND (BillingCity != NULL)
                                  AND (BillingState != NULL)
                                  AND (BillingCountry != NULL)
                                  AND (BillingPostalCode != NULL)]; 
        return accounts;
    }
    
    public void execute(QueueableContext context) {
        UsingQueuebleJob queuebleJob = new UsingQueuebleJob();
        List<Account> accounts = queuebleJob.getContactsForAccountsInWhichBillingAddressIsNotEmpty();        
        List<Contact> listOfContactsToUpdate = new List<Contact>();       
        for (Account account : accounts) {            
            for (Contact contact : account.contacts) {
                contact.Is_Synced__c = false;
                contact.Processed_By_Queue__c = true;
                listOfContactsToUpdate.add(contact);                           
            }
        }
        update listOfContactsToUpdate;
    } 
    
    public static void addJobOnTheQueue() {
        UsingQueuebleJob queuebleJob = new UsingQueuebleJob();
        ID jobID = System.enqueueJob(queuebleJob);
        List<AsyncApexJob> asyncApexJobs = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID]; 
        for (AsyncApexJob asyncApexJob : asyncApexJobs) {
            System.debug('Id ' + asyncApexJob.Id + ', Status ' + asyncApexJob.Status + ', Number of errors ' + asyncApexJob.NumberOfErrors);
        }    
    }
}