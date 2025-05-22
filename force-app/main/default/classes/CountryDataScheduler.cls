global class CountryDataScheduler implements Schedulable {
    global void execute(SchedulableContext sched) {
        CountryDataService.fetchAndUpdateCountryData();
    }
}