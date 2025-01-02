//
//  WellnessManager+HealthKit.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/18/24.
//

import Foundation
import HealthKit
import WidgetKit


extension WellnessManager {
    
    /// Requests authorization to read heart rate data from HealthKit
    /// - This function checks if HealthKit data is available and requests permission to read heart rate and resting heart rate data.
    func requestAuthorization() {
        
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        ])
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available!")
            return
        }
        
        health.requestAuthorization(toShare: nil, read: toReads) { success, error in
            if success {
                self.fetchAllDatas()
            } else {
                print("\(String(describing: error))")
            }
        }
    }

    /// Fetches heart rate data for today and the current week
    /// This function fetches heart rate data for both today and for the entire current week.
    func fetchAllDatas() {
        getTodaysHeartRates()
        getHeartRatesThisWeek()
    }

    /// Fetches heart rate data for today from HealthKit
    /// - This function queries the HealthKit store for heart rate data collected today and processes the results.
    func getTodaysHeartRates() {
        let calendar = NSCalendar.current
        let now = NSDate()
        let components = calendar.dateComponents([.year, .month, .day], from: now as Date)
        
        guard let startDate:NSDate = calendar.date(from: components) as NSDate? else { return }
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let endDate:NSDate? = calendar.date(byAdding: dayComponent, to: startDate as Date) as NSDate?
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date?, options: [])

        // Sort descriptor to get most recent samples first
        let sortDescriptors = [
            NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        ]
        
        heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 25, sortDescriptors: sortDescriptors, resultsHandler: { (query, results, error) in
            guard error == nil else { print("Error"); return }

            self.addHeartRateToday(results: results)
        })
        
        health.execute(heartRateQuery!)
    }

    /// Processes the heart rate data for today and updates the `heartRateToday` variable
    /// - Parameter results: An array of `HKSample` objects containing heart rate data for today
    private func addHeartRateToday(results: [HKSample]?) {
        var count = 0
        if (results?.count ?? 0) > 0 {
            for (_, sample) in results!.enumerated() {
                guard let currData: HKQuantitySample = sample as? HKQuantitySample else { return }
                count += 1
                self.heartRateToday += Int(currData.quantity.doubleValue(for: heartRateUnit))
                print("Heart Rate Today: \(currData.quantity.doubleValue(for: heartRateUnit))")
                print("Start Date: \(currData.startDate)")
                print("End Date: \(currData.endDate)")
            }
            self.heartRateToday = self.heartRateToday / count
        }
    }

    /// Fetches heart rate data for each day of the current week
    /// - This function queries HealthKit for heart rate data for each day in the current week (Sunday to Saturday).
    func getHeartRatesThisWeek() {
        let calendar = NSCalendar.current
        let now = NSDate()
        let components = calendar.component(.weekday, from: now as Date)
        
        let daysToSubtract = (components - 1 + 7) % 7
        
        guard let sunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: now as Date) else { return }
        
        for i in 0..<7 {
            guard let currentDay = calendar.date(byAdding: .day, value: i, to: sunday) else { continue }
            
            let dayStartComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
            guard let startDate = calendar.date(from: dayStartComponents) else { continue }
            
            var dayEndComponent = DateComponents()
            dayEndComponent.day = 1
            guard let endDate = calendar.date(byAdding: dayEndComponent, to: startDate) else { continue }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            
            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            
            let heartRateQuery = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: 25,
                sortDescriptors: sortDescriptors,
                resultsHandler: { (query, results, error) in
                    guard error == nil else {
                        print("Error fetching heart rate data for \(currentDay)")
                        return
                    }
                    
                    self.addHeartRateForDay(results: results, date: currentDay, index: i)
                }
            )
            
            health.execute(heartRateQuery)
        }
    }

    /// Processes the heart rate data for a specific day of the week and updates the weekly heart rate array
    /// - Parameters:
    ///   - results: An array of `HKSample` objects containing heart rate data for the day
    ///   - date: The specific date for which heart rate data is fetched
    ///   - index: The index representing the day of the week (0 for Sunday, 6 for Saturday)
    private func addHeartRateForDay(results: [HKSample]?, date: Date, index: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekdayName = dateFormatter.string(from: date as Date)
        
        print("\nHeart Rate Data for \(weekdayName):")
        
        if (results?.count ?? 0) > 0 {
            var count = 0
            for sample in results! {
                guard let currData = sample as? HKQuantitySample else { continue }
                
                let heartRate = currData.quantity.doubleValue(for: heartRateUnit)
                let startDate = currData.startDate
                let endDate = currData.endDate
                
                count += 1
                self.thisWeeksHeartRate[index + 1]! += Int(heartRate)
                print("Heart Rate: \(heartRate) bpm", index)
                print("Start Date: \(startDate)")
                print("End Date: \(endDate)")
            }
            self.thisWeeksHeartRate[index+1]! = self.thisWeeksHeartRate[index+1]! / count
        } else {
            print("No heart rate data found for \(weekdayName).")
        }
    }

}
