@isTest
global class CountryDataMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        String responseBody = '[{"name":"Germany","alpha2Code":"DE","alpha3Code":"DEU","capital":"Berlin","region":"Europe","regionalBlocs":[{"acronym":"EU"}]}]';
        
        res.setBody(responseBody);
        res.setStatusCode(200);
        return res;
    }
}