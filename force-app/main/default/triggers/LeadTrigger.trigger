trigger LeadTrigger on Lead (before insert, before update) {
    LeadTriggerHandler.assignCountryLookup(Trigger.new);
}