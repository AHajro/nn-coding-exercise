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
public class ScheduleCountryDataImportTest {

    @isTest
    static void testExecute() {
        Test.startTest();

        // Create an instance of the schedule job
        ScheduleCountryDataImport job = new ScheduleCountryDataImport();
        
        // Call the execute method to run the job
        job.execute(null);
        
        Test.stopTest();
    }

}