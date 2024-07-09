/**
 * @description       : 
 * @author            : Aldora Hajro
 * @group             : 
 * @last modified on  : 07-08-2024
 * @last modified by  : Aldora Hajro
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   07-08-2024   Aldora Hajro   Initial Version
**/
@isTest
public class LeadTriggerHandlerTest {

    @testSetup
    static void setup() {
        // Insert Country__c records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Afghanistan'),
            new Country__c(Name = 'Åland Islands'),
            new Country__c(Name = 'Albania'),
            new Country__c(Name = 'Algeria'),
            new Country__c(Name = 'American Samoa'),
            new Country__c(Name = 'Andorra'),
            new Country__c(Name = 'Angola'),
            new Country__c(Name = 'Anguilla'),
            new Country__c(Name = 'Antarctica')
        };
        insert countries;
    }

    @isTest
    static void testBeforeInsertTrigger() {
        // Create new Lead records
        List<Lead> newLeads = new List<Lead>{
            new Lead(FirstName = 'Alice', LastName = 'Doe', Company = 'Company X', Country = 'Afghanistan'),
            new Lead(FirstName = 'Bob', LastName = 'Smith', Company = 'Company Y', Country = 'Åland Islands'),
            new Lead(FirstName = 'Charlie', LastName = 'Johnson', Company = 'Company Z', Country = 'Albania')
        };
        
        Test.startTest();
        // Insert the new Lead records
        insert newLeads;
        Test.stopTest();

        // Verify that Country__c field is populated
        List<Lead> insertedLeads = [SELECT Id, Country__c FROM Lead WHERE Id IN :newLeads];
        for (Lead lead : insertedLeads) {
            System.assertNotEquals(null, lead.Country__c, 'Country__c should not be null for Lead with ID: ' + lead.Id);
        }
    }

    @isTest
    static void testBeforeUpdateTrigger() {
        // Insert a Lead record with initial Country
        Lead leadToUpdate = new Lead(FirstName = 'Dave', LastName = 'Wilson', Company = 'Company A', Country = 'Algeria');
        insert leadToUpdate;

        // Update the Lead record with a new Country
        leadToUpdate.Country = 'Andorra';
        Test.startTest();
        update leadToUpdate;
        Test.stopTest();

        // Verify that Country__c field is populated
        Lead updatedLead = [SELECT Id, Country__c FROM Lead WHERE Id = :leadToUpdate.Id];
        System.assertNotEquals(null, updatedLead.Country__c, 'Country__c should not be null after update for Lead with ID: ' + updatedLead.Id);
    }

    @isTest
    static void testBeforeUpdateTriggerWithCountryChange() {
        // Insert Lead records with initial Country
        Lead lead1 = new Lead(FirstName = 'Eve', LastName = 'Adams', Company = 'Company A', Country = 'Angola');
        Lead lead2 = new Lead(FirstName = 'Frank', LastName = 'Williams', Company = 'Company B', Country = 'Antarctica');
        insert new List<Lead>{lead1, lead2};

        // Update the Lead records with new Countries
        lead1.Country = 'Albania';
        lead2.Country = 'Åland Islands';
        Test.startTest();
        update new List<Lead>{lead1, lead2};
        Test.stopTest();

        // Verify that Country__c field is populated
        List<Lead> updatedLeads = [SELECT Id, Country__c FROM Lead WHERE Id IN :new List<Id>{lead1.Id, lead2.Id}];
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.Country__c, 'Country__c should not be null after update for Lead with ID: ' + lead.Id);
        }
    }


    @isTest
    static void testBeforeInsertWithNullCountry() {
        // Create new Lead records with null Country
        Lead leadWithNullCountry = new Lead(FirstName = 'Hannah', LastName = 'Taylor', Company = 'Company D', Country = null);
        insert leadWithNullCountry;

        // Verify that Country__c field is null
        Lead insertedLead = [SELECT Id, Country__c FROM Lead WHERE Id = :leadWithNullCountry.Id];
        System.assertEquals(null, insertedLead.Country__c, 'Country__c should be null for Lead with null Country field');
    }

    @isTest
    static void testBeforeUpdateWithNullCountry() {
        // Insert a Lead record with an initial Country
        Lead leadToUpdate = new Lead(FirstName = 'Ian', LastName = 'Moore', Company = 'Company E', Country = 'Andorra');
        insert leadToUpdate;

        // Update the Lead record with a null Country
        leadToUpdate.Country = null;
        Test.startTest();
        update leadToUpdate;
        Test.stopTest();

        // Verify that Country__c field is null
        Lead updatedLead = [SELECT Id, Country__c FROM Lead WHERE Id = :leadToUpdate.Id];
        System.assertEquals(null, updatedLead.Country__c, 'Country__c should be null if Country is set to null during update for Lead with ID: ' + updatedLead.Id);
    }

}