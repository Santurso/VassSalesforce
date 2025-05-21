public class CountryDataService {
    private static final String API_URL = 'https://api.countrylayer.com/v2/all?access_key=YOUR_ACCESS_KEY';

    public static void fetchAndUpdateCountryData() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(API_URL);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Object raw = JSON.deserializeUntyped(res.getBody());

            if (raw instanceof List<Object>) {
                List<Object> countryList = (List<Object>) raw;
                List<Country__c> recordsToUpsert = new List<Country__c>();

                for (Object obj : countryList) {
                    Map<String, Object> countryMap = (Map<String, Object>) obj;

                    // Extract regional blocs (acronyms)
                    String regionalBlocsStr = '';
                    if (countryMap.containsKey('regionalBlocs')) {
                        List<Object> blocs = (List<Object>) countryMap.get('regionalBlocs');
                        List<String> acronyms = new List<String>();

                        for (Object bloc : blocs) {
                            Map<String, Object> blocMap = (Map<String, Object>) bloc;
                            if (blocMap.containsKey('acronym')) {
                                acronyms.add((String) blocMap.get('acronym'));
                            }
                        }

                        regionalBlocsStr = String.join(acronyms, ', ');
                    }

                    Country__c record = new Country__c(
                        Name = (String) countryMap.get('name'),
                        Alpha2Code__c = (String) countryMap.get('alpha2Code'),
                        Alpha3Code__c = (String) countryMap.get('alpha3Code'),
                        Capital__c = (String) countryMap.get('capital'),
                        Region__c = (String) countryMap.get('region'),
                        RegionalBlocs__c = regionalBlocsStr
                    );

                    recordsToUpsert.add(record);
                }

                upsert recordsToUpsert;
            }
        } else {
            System.debug('Error: ' + res.getBody());
        }
    }
}