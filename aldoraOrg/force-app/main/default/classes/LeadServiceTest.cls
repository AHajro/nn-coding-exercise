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
private class LeadServiceTest {

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

        // Insert Lead records
        List<Lead> leads = new List<Lead>{
            new Lead(FirstName = 'John', LastName = 'Doe', Company = 'Company A', Country = 'Afghanistan'),
            new Lead(FirstName = 'Jane', LastName = 'Smith', Company = 'Company B', Country = 'Åland Islands'),
            new Lead(FirstName = 'Jim', LastName = 'Brown', Company = 'Company C', Country = 'Albania'),
            new Lead(FirstName = 'Jill', LastName = 'Johnson', Company = 'Company D', Country = 'Algeria')
        };
        insert leads;
    }

    @isTest
    static void testUpdateLeadCountry() {
        // Get Lead records
        List<Lead> leadsToUpdate = [SELECT Id, Country__c, Country FROM Lead WHERE Country IN ('Afghanistan', 'Åland Islands', 'Albania', 'Algeria')];
        List<String> countryNames = new List<String>{'Afghanistan', 'Åland Islands', 'Albania', 'Algeria'};

        // Call the method to test
        LeadService.updateLeadCountry(leadsToUpdate, countryNames);

        // Verify the updates
        for (Lead lead : leadsToUpdate) {
            // Check that Country__c field is populated
            System.assertNotEquals(null, lead.Country__c, 'Country__c should not be null for Lead with ID: ' + lead.Id);
        }
    }

    @isTest
    static void testUpdateLeadCountryWithNullLeads() {
        List<String> countryNames = new List<String>{'Afghanistan', 'Åland Islands', 'Albania', 'Algeria'};

        Boolean exceptionThrown = false;
        try {
            LeadService.updateLeadCountry(null, countryNames);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e instanceof LeadService.LeadServiceException, 'Exception should be of type LeadServiceException');
            System.assertEquals('Leads or countries not specified', e.getMessage(), 'Exception message should be "Leads or countries not specified"');
        }
        System.assert(exceptionThrown, 'Exception should be thrown for null Lead list');
    }

    @isTest
    static void testUpdateLeadCountryWithEmptyLeads() {
        List<Lead> emptyLeads = new List<Lead>();
        List<String> countryNames = new List<String>{'Afghanistan', 'Åland Islands', 'Albania', 'Algeria'};

        Boolean exceptionThrown = false;
        try {
            LeadService.updateLeadCountry(emptyLeads, countryNames);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e instanceof LeadService.LeadServiceException, 'Exception should be of type LeadServiceException');
            System.assertEquals('Leads or countries not specified', e.getMessage(), 'Exception message should be "Leads or countries not specified"');
        }
        System.assert(exceptionThrown, 'Exception should be thrown for empty Lead list');
    }

    @isTest
    static void testUpdateLeadCountryWithNullCountries() {
        List<Lead> leadsToUpdate = [SELECT Id, Country__c, Country FROM Lead WHERE Country IN ('Afghanistan', 'Åland Islands', 'Albania', 'Algeria')];

        Boolean exceptionThrown = false;
        try {
            LeadService.updateLeadCountry(leadsToUpdate, null);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e instanceof LeadService.LeadServiceException, 'Exception should be of type LeadServiceException');
            System.assertEquals('Leads or countries not specified', e.getMessage(), 'Exception message should be "Leads or countries not specified"');
        }
        System.assert(exceptionThrown, 'Exception should be thrown for null country names list');
    }

    @isTest
    static void testUpdateLeadCountryWithEmptyCountries() {
        List<Lead> leadsToUpdate = [SELECT Id, Country__c, Country FROM Lead WHERE Country IN ('Afghanistan', 'Åland Islands', 'Albania', 'Algeria')];
        List<String> emptyCountries = new List<String>();

        Boolean exceptionThrown = false;
        try {
            LeadService.updateLeadCountry(leadsToUpdate, emptyCountries);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e instanceof LeadService.LeadServiceException, 'Exception should be of type LeadServiceException');
            System.assertEquals('Leads or countries not specified', e.getMessage(), 'Exception message should be "Leads or countries not specified"');
        }
        System.assert(exceptionThrown, 'Exception should be thrown for empty country names list');
    }

    @isTest
    static void testGetCountryIdMap() {
        List<String> countryNames = new List<String>{'Afghanistan', 'Åland Islands', 'Albania', 'Algeria'};

        // Call the method to test
        Map<String, String> countryIdMap = LeadService.getCountryIdMap(countryNames);

        // Verify the map is populated correctly
        System.assertEquals(4, countryIdMap.size(), 'Country ID map should contain 4 entries');
        System.assertEquals([SELECT Id FROM Country__c WHERE Name = 'Afghanistan'].Id, countryIdMap.get('Afghanistan'), 'Afghanistan ID should be in the map');
        System.assertEquals([SELECT Id FROM Country__c WHERE Name = 'Åland Islands'].Id, countryIdMap.get('Åland Islands'), 'Åland Islands ID should be in the map');
        System.assertEquals([SELECT Id FROM Country__c WHERE Name = 'Albania'].Id, countryIdMap.get('Albania'), 'Albania ID should be in the map');
        System.assertEquals([SELECT Id FROM Country__c WHERE Name = 'Algeria'].Id, countryIdMap.get('Algeria'), 'Algeria ID should be in the map');
    }

    @isTest
    static void testGetCountryIdMapWithNullCountries() {
        Boolean exceptionThrown = false;
        try {
            LeadService.getCountryIdMap(null);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e instanceof LeadService.LeadServiceException, 'Exception should be of type LeadServiceException');
            System.assertEquals('No country names specified', e.getMessage(), 'Exception message should be "No country names specified"');
        }
        System.assert(exceptionThrown, 'Exception should be thrown for null country names list');
    }

    @isTest
    static void testGetCountryIdMapWithEmptyCountries() {
        List<String> emptyCountries = new List<String>();

        Boolean exceptionThrown = false;
        try {
            LeadService.getCountryIdMap(emptyCountries);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e instanceof LeadService.LeadServiceException, 'Exception should be of type LeadServiceException');
            System.assertEquals('No country names specified', e.getMessage(), 'Exception message should be "No country names specified"');
        }
        System.assert(exceptionThrown, 'Exception should be thrown for empty country names list');
    }

    @isTest
    static void testGetCountryIdMapWithNoMatchingCountries() {
        List<String> nonExistentCountries = new List<String>{'NonExistentCountry1', 'NonExistentCountry2'};

        // Call the method to test
        Map<String, String> countryIdMap = LeadService.getCountryIdMap(nonExistentCountries);

        // Verify the map is empty
        System.assertEquals(0, countryIdMap.size(), 'Country ID map should be empty for non-existent countries');
    }

}