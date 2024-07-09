/**
 * @description       : 
 * @author            : Aldora Hajro
 * @group             : 
 * @last modified on  : 07-05-2024
 * @last modified by  : Aldora Hajro
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   07-04-2024   Aldora Hajro   Initial Version
**/
trigger LeadTrigger on Lead (before insert, before update) {

    new LeadTriggerHandler().run();
}