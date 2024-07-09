/**
 * @description       : A class that implements the Schedulable interface to schedule a daily job for importing country data.
 *                      The job fetches country data and uploads it using the `CountryLayerIntegration` class.
 * @author            : Aldora Hajro
 * @group             : 
 * @last modified on  : 07-08-2024
 * @last modified by  : Aldora Hajro
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   07-08-2024   Aldora Hajro   Initial Version
 **/
global class ScheduleCountryDataImport implements Schedulable {

    /**
    * @description       : The method that will be executed by the scheduled job.
    * @author            : Aldora Hajro | 07-08-2024 
    * @param SchedulableContext ctx : 
    **/
    global void execute(SchedulableContext ctx) {
        // Call the method from the CountryLayerIntegration class to fetch country data and upload it
        CountryLayerIntegration.fetchAndUploadCountries();
    }
}