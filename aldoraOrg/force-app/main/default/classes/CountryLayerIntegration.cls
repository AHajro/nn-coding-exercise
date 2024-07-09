/**
 * @description       : 
 * @author            : Aldora Hajro
 * @group             : 
 * @last modified on  : 07-09-2024
 * @last modified by  : Aldora Hajro
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   07-05-2024   Aldora Hajro   Initial Version
**/
public with sharing class CountryLayerIntegration {
    // Define the API endpoint and the API key
    private static final String API_ENDPOINT = CountryLayerAPIConfiguration__c.getInstance().AllCountriesEndpoint__c;
    private static final String API_KEY = CountryLayerAPIConfiguration__c.getInstance().APIKey__c;

    /**
    * @description Method to fetch and upload country data
    * @author Aldora Hajro | 07-05-2024 
    **/
    public static void fetchAndUploadCountries() {
        // Create an instance of the HTTP class
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // Set the API endpoint and method
        request.setEndpoint(API_ENDPOINT + '?access_key=' + API_KEY);
        request.setMethod('GET');

        System.debug('Request: ' + request);

        try {
            // Send the HTTP request
            HttpResponse response = http.send(request);

        System.debug('Response: ' + response);
        System.debug('Response.Body: ' + response.getBody());
            
            // Check if the response status code is 200 (OK)
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON response into a list of CountryInfo objects
                List<CountryInfo> countries = (List<CountryInfo>) JSON.deserialize(response.getBody(), List<CountryInfo>.class);

                // Create a list to hold the Country__c records
                List<Country__c> countryRecords = new List<Country__c>();
                
                // Iterate over the country data
                for (CountryInfo country : countries) {
                    // Create a new Country__c record
                    Country__c countryRecord = new Country__c();
                    countryRecord.Name = country.name;
                    countryRecord.Alpha2Code__c = country.alpha2Code;
                    countryRecord.Alpha3Code__c = country.alpha3Code;
                    countryRecord.CapitalCity__c = country.capital;
                    countryRecord.Region__c = country.region;
                    
                    // Check if regionalBlocs is not empty and add the first acronym
                /*    if (!country.regionalBlocs.isEmpty()) {
                        List<String> acronyms = new List<String>();
                        for (RegionalBloc bloc : country.regionalBlocs) {
                            acronyms.add(bloc.acronym);
                        }
                        countryRecord.regionalBlocs__c = String.join(acronyms, ', ');
                    }
                */
                    // Add the record to the list
                    countryRecords.add(countryRecord);
                }

                // Upsert the list of Country__c records based on the Name field
                if (!countryRecords.isEmpty()) {
                    upsert countryRecords Name;
                }
            } else {
                // Log an error message if the response status is not 200
                System.debug('Error: ' + response.getStatus());
            }
        } catch (Exception e) {
            // Log the exception message
            System.debug('Exception: ' + e.getMessage());
        }
    }

    // Inner class to map the JSON response structure
    public class CountryInfo {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public List<RegionalBloc> regionalBlocs;
    }

    public class RegionalBloc {
        public String acronym;
    }
    
}