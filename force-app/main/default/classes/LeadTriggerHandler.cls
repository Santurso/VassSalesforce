public class LeadTriggerHandler {
    public static void assignCountryLookup(List<Lead> leads) {
        Set<String> countryNames = new Set<String>();
        
        for (Lead l : leads) {
            if (l.Country != null) {
                countryNames.add(l.Country.trim());
            }
        }
        
        if (countryNames.isEmpty()) return;
        
        Map<String, Country__c> countryMap = new Map<String, Country__c>();
        for (Country__c c : [
            SELECT Id, Name
            FROM Country__c
            WHERE Name IN :countryNames
        ]) {
            countryMap.put(c.Name.trim(), c);
        }
        
        for (Lead l : leads) {
            if (l.Country != null) {
                Country__c matchedCountry = countryMap.get(l.Country.trim());
                if (matchedCountry != null) {
                    l.Country__c = matchedCountry.Id;
                } else {
                    l.Country__c = null; // Optional: Clear the lookup if no match
                }
            }
        }
    }
}