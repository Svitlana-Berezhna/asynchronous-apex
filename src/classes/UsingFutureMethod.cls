// Call in Developer Console:
// UsingFutureMethod.UpdateContactsForAccountsInWhichBillingAddressIsNotEmpty();

public class UsingFutureMethod implements Database.Stateful {   
    @future
    public static void UpdateContactsForAccountsInWhichBillingAddressIsNotEmpty() {
        List<Account> accounts = [SELECT ID, Name, BillingAddress, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                                  (SELECT ID, Name, Is_Synced__c, Processed_By_Future__c FROM Contacts)
                                  FROM Account LIMIT 150];          
        List<Contact> listOfContactsToUpdate = new List<Contact>();
        Integer recordsProcessed = 0;
        for (Account account : accounts) {            
            if((account.BillingStreet == null || account.BillingStreet.trim().equals(''))
               && (account.BillingCity == null || account.BillingCity.trim().equals(''))
               && (account.BillingState == null || account.BillingState.trim().equals(''))
               && (account.BillingCountry == null || account.BillingCountry.trim().equals(''))
               && (account.BillingPostalCode == null || account.BillingPostalCode.trim().equals(''))){
                   continue;
               }             
            for (Contact contact : account.contacts) {
                contact.Is_Synced__c = false;
                contact.Processed_By_Future__c = true;
                listOfContactsToUpdate.add(contact);
                recordsProcessed = recordsProcessed + 1;                
            }
        }
        update listOfContactsToUpdate;
        System.debug(recordsProcessed + ' records processed.');
    }    
}