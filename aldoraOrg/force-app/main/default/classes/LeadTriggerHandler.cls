/**
* @description       : Trigger Handler for Lead object to handle country-related information.
* @author            : Aldora Hajro
* @group             : 
* @last modified on  : 07-05-2024
* @last modified by  : Aldora Hajro
* Modifications Log
* Ver   Date         Author         Modification
* 1.0   07-05-2024   Aldora Hajro   Initial Version
**/
public class LeadTriggerHandler extends TriggerHandler {

    // List to hold new Lead records
    List<Lead> newLeadsList;
    // Map to hold old Lead records, used in update triggers
    Map<Id, Lead> oldLeadsMap;

    // Constructor to initialize the lists and maps
    public LeadTriggerHandler() {
        this.newLeadsList = (List<Lead>) Trigger.new;
        this.oldLeadsMap = (Map<Id, Lead>) Trigger.oldMap;
    }
    

    /**
    * @description Handles the before insert trigger event for Leads.
    *              Collects country names from new Leads and updates them using LeadService.
    * @author Aldora Hajro | 07-05-2024 
    **/
    public override void beforeInsert() {
        // List to collect country names from new Leads
        List<String> countryNamesList = new List<String>();
        
        // Iterate over new Leads to collect country names
        for (Lead newLead : newLeadsList) {
            if (newLead.Country != null) {
                countryNamesList.add(newLead.Country);
            }
        }
        
        // If there are country names collected, update Lead country information
        if (countryNamesList.size() > 0) {
            LeadService.updateLeadCountry(newLeadsList, countryNamesList);
        }
    }
    
    
    /**
    * @description Handles the before update trigger event for Leads.
    *              Collects country names from updated Leads if the country has changed,
    *              and updates them using LeadService.
    * @author Aldora Hajro | 07-05-2024 
    **/
    public override void beforeUpdate() {
        // List to collect country names from updated Leads
        List<String> countryNamesList = new List<String>();
        
        // Iterate over new Leads to collect country names if they have changed
        for (Lead newLead : newLeadsList) {
            if (newLead.Country != oldLeadsMap.get(newLead.Id).Country) {
                countryNamesList.add(newLead.Country);
            }
        }
        
        // If there are country names collected, update Lead country information
        if (countryNamesList.size() > 0) {
            LeadService.updateLeadCountry(newLeadsList, countryNamesList);
        }
    }
}