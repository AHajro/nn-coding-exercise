/**
 * @description       : Service class for handling Lead related operations, specifically updating Lead records with country information.
 * @uthor            : Aldora Hajro
 * @group             : 
 * @last modified on  : 07-09-2024
 * @last modified by  : Aldora Hajro
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   07-05-2024   Aldora Hajro   Initial Version
**/
public with sharing class LeadService {

    /**
    * @description Updates Lead records with country information.
    *              Maps the country name to its corresponding Country__c record ID and updates the Lead records.
    * @author Aldora Hajro | 07-05-2024 
    * @param newLeadsList List of new Lead records to be updated
    * @param countryNamesList List of country names from the Lead records
    **/
    public static void updateLeadCountry(List<Lead> newLeadsList, List<String> countryNamesList){

        if(newLeadsList==null || newLeadsList.size()==0 || countryNamesList==null || countryNamesList.size()==0){
            throw new LeadServiceException('Leads or countries not specified');
        }

        // Get a map of country names to their corresponding Country__c record IDs
        Map<String, String> countryNameIdMap = getCountryIdMap(countryNamesList);

        //List to hold the updated leads
        List<Lead> leadsToUpdate = new List<Lead>();

        // Iterate over the new Lead records and update the Country__c field with the corresponding Country__c record ID
        for (Lead lead : newLeadsList) {
            lead.Country__c = countryNameIdMap.get(lead.Country);
        }
        
    }

    
    /**
    * @description Retrieves a map of country names to their corresponding Country__c record IDs.
    *              Queries the Country__c records based on the provided list of country names.
    * @author Aldora Hajro | 07-05-2024 
    * @param countryNames List of country names to query
    * @return Map<String, String> Map of country names to Country__c record IDs
    **/
    public static Map<String, String> getCountryIdMap(List<String> countryNames){

        // Map to hold country names and their corresponding Country__c record IDs
        Map<String, String> countryNameIdMap = new Map<String, String>();

        // Query the Country__c records based on the provided list of country names
        List<Country__c> countries = [SELECT Id, Name FROM Country__c WHERE Name IN :countryNames];
        
        // Populate the map with country names and their corresponding Country__c record IDs
        for (Country__c con : countries) {
            countryNameIdMap.put(con.Name, con.Id);
        }
        
        return countryNameIdMap;
    }


    public class LeadServiceException extends Exception {} 

}