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
public class CountryLayerIntegrationTest {

    @isTest
    static void testFetchAndUploadCountriesSuccess() {
        // Set the mock callout response for a successful response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccess());

        // Call the method to test
        CountryLayerIntegration.fetchAndUploadCountries();

        // Verify the results
        List<Country__c> countryRecords = [SELECT Name, Alpha2Code__c, Alpha3Code__c, CapitalCity__c, Region__c FROM Country__c];

        // Check that 9 country records are inserted
        System.assertEquals(9, countryRecords.size());

        // Verify the data of one of the countries
        Country__c afghanistan = [SELECT Name, Alpha2Code__c, Alpha3Code__c, CapitalCity__c, Region__c FROM Country__c WHERE Name = 'Afghanistan' LIMIT 1];
        System.assertEquals('AF', afghanistan.Alpha2Code__c);
        System.assertEquals('AFG', afghanistan.Alpha3Code__c);
        System.assertEquals('Kabul', afghanistan.CapitalCity__c);
        System.assertEquals('Asia', afghanistan.Region__c);
    }

    
    @isTest
    static void testFetchAndUploadCountriesFailure() {
        // Set the mock callout response for a failure response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFailure());

        // Call the method to test
        CountryLayerIntegration.fetchAndUploadCountries();

        // Verify that no country records are inserted
        List<Country__c> countryRecords = [SELECT Name, Alpha2Code__c, Alpha3Code__c, CapitalCity__c, Region__c FROM Country__c];
        System.assertEquals(0, countryRecords.size());
    }


    // Mock HTTP Response Classes

    private class MockHttpResponseSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('[' +
                '{"name": "Afghanistan", "alpha2Code": "AF", "alpha3Code": "AFG", "capital": "Kabul", "region": "Asia"},' +
                '{"name": "Åland Islands", "alpha2Code": "AX", "alpha3Code": "ALA", "capital": "Mariehamn", "region": "Europe"},' +
                '{"name": "Albania", "alpha2Code": "AL", "alpha3Code": "ALB", "capital": "Tirana", "region": "Europe"},' +
                '{"name": "Algeria", "alpha2Code": "DZ", "alpha3Code": "DZA", "capital": "Algiers", "region": "Africa"},' +
                '{"name": "American Samoa", "alpha2Code": "AS", "alpha3Code": "ASM", "capital": "Pago Pago", "region": "Oceania"},' +
                '{"name": "Andorra", "alpha2Code": "AD", "alpha3Code": "AND", "capital": "Andorra la Vella", "region": "Europe"},' +
                '{"name": "Angola", "alpha2Code": "AO", "alpha3Code": "AGO", "capital": "Luanda", "region": "Africa"},' +
                '{"name": "Anguilla", "alpha2Code": "AI", "alpha3Code": "AIA", "capital": "The Valley", "region": "Americas"},' +
                '{"name": "Antarctica", "alpha2Code": "AQ", "alpha3Code": "ATA", "callingCodes": ["672"], "region": "Polar"}' +
            ']');
            return res;
        }
    }

    private class MockHttpResponseFailure implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(404);
            res.setBody('{"error": "Not Found"}');
            return res;
        }
    }

}