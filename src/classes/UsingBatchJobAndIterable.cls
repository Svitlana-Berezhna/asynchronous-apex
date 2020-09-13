// Call in Developer Console:           
// UsingBatchJobAndIterable batch = new UsingBatchJobAndIterable();
// Database.executeBatch(batch);

global class UsingBatchJobAndIterable implements 
Database.Batchable<sObject>, Database.Stateful {  
    
    global Integer recordsProcessed = 0;
    global Iterable<sObject> start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ' +
            '(SELECT ID, Name, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, ' + 
            'Is_Synced__c, Processed_By_Queue__c FROM Contacts WHERE Is_Synced__c = false) ' +
            'FROM Account'                                     
        ); 
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){        
        List<Contact> listOfContactsToUpdate = new List<Contact>();
        for (Account account : scope) {
            for (Contact contact : account.contacts) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingCountry = account.BillingCountry;
                contact.MailingPostalCode = account.BillingPostalCode;                
                contact.Is_Synced__c = true;
                account.Updated_By_Contact__c = true;                
                listOfContactsToUpdate.add(contact);
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update listOfContactsToUpdate;
        update scope;
    }    
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    }    
}
