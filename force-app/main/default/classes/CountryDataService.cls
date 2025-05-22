public class CountryDataService {
    public static void fetchAndUpdateCountryData() {
       
        Map<String, Country__c> existingCountries = new Map<String, Country__c>();
        for (Country__c c : [SELECT Id, Name, Capital__c, Region__c, Alpha2Code__c, Alpha3Code__c FROM Country__c]) {
            existingCountries.put(c.Name, c);
        }


        CountryLayerKey__mdt keyRecord = CountryLayerKey__mdt.getInstance('Default');
        String apiKey = keyRecord != null ? keyRecord.AccessKey__c : null;
        if (apiKey == null) {
            System.debug('não há API KEY.');
            return;
        }

  
        String ENDPOINT = 'callout:CountryLayer/v2/all?access_key=' + apiKey;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        System.debug('Status Code: ' + res.getStatusCode());

        if (res.getStatusCode() == 200) {
     
            Object raw = JSON.deserializeUntyped(res.getBody());

            if (raw instanceof List<Object>) {
                List<Object> countryList = (List<Object>) raw;
                List<Country__c> recordsForUpdate = new List<Country__c>();

                for (Object obj : countryList) {
                    Map<String, Object> countryMap = (Map<String, Object>) obj;
                    String name = (String) countryMap.get('name');

                    Country__c record;

                    if (existingCountries.containsKey(name)) {
                        record = existingCountries.get(name);
                    } else {
                        record = new Country__c(Name = name);
                    }

                    record.Alpha2Code__c = (String) countryMap.get('alpha2Code');
                    record.Alpha3Code__c = (String) countryMap.get('alpha3Code');
                    record.Capital__c = (String) countryMap.get('capital');
                    record.Region__c = (String) countryMap.get('region');

                    recordsForUpdate.add(record);
                }

        
                upsert recordsForUpdate Country__c.Name;
            } else {
                System.debug('ERRO AQUI-----------------------');
            }
        } else {
            System.debug('HTTP ERRO AQUI------------: ' + res.getBody());
        }
    }
}