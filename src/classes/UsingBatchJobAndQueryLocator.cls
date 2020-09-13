global class UsingBatchJobAndQueryLocator implements 
Database.Batchable<sObject>, Database.Stateful {        
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ' +
            '(SELECT ID, Name, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, Is_Synced__c, Processed_By_Queue__c FROM Contacts WHERE Is_Synced__c = false) ' +
            'FROM Account'                         
            //'SELECT ID, Name, AccountId, (SELECT Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode FROM Accounts), MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, Is_Synced__c, Processed_By_Queue__c FROM Contact WHERE Is_Synced__c = false'
        ); 
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){        
        List<Contact> contacts = new List<Contact>();
        for (Account account : scope) {
            for (Contact contact : account.contacts) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingCountry = account.BillingCountry;
                contact.MailingPostalCode = account.BillingPostalCode;                
                contact.Is_Synced__c = true;
                account.Updated_By_Contact__c = true;                
                contacts.add(contact);
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update contacts;
        update scope;
    }    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    }    
}