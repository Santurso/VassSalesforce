@isTest
private class CountryDataServiceTest {
    @isTest
    static void testFetchAndUpdateCountryData() {
        Test.setMock(HttpCalloutMock.class, new CountryDataMock());

        Test.startTest();
        CountryDataService.fetchAndUpdateCountryData();
        Test.stopTest();

        List<Country__c> countries = [SELECT Name, Alpha2Code__c FROM Country__c WHERE Name = 'Germany'];
        System.assertEquals(1, countries.size(), 'One country should have been created.');
        System.assertEquals('DE', countries[0].Alpha2Code__c);
    }
}