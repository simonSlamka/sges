//
//  ContentView.swift
//  Existence Score
//
//  Created by Simon Slamka on 2/22/22.
//

import SwiftUI
import HealthKit
class ExistenceScore: ObservableObject
{
    @Published var heartAvg = 0.0
}

var heartCount = 0

func fetchHealthData() -> Void
{
    let HKStore = HKHealthStore()
    
    if HKHealthStore.isHealthDataAvailable()
    {
        let stolenData = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!])
        HKStore.requestAuthorization(toShare: [], read: stolenData) {(success, error) in
            if success
            {
                let cal = NSCalendar.current
                var anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                let offset = (5 + anchorComps.weekday! - 2) % 5
                let endDate = Date()
                
                anchorComps.day! -= offset
                anchorComps.hour = 1
                
                guard let anchorDate = Calendar.current.date(from: anchorComps)
                else
                {
                    fatalError("Can't get a valid date from the achor. You fucked something up!")
                }
                
                guard let startDate = cal.date(byAdding: .month, value: -1, to: endDate)
                        else
                        {
                            fatalError("Can't generate a startDate! :-/")
                        }
                
                let interval = NSDateComponents()
                interval.hour = 12
                
                guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate)
                else
                {
                    fatalError("Can't get quantityType forIdentifier: .heartRate!")
                }
                let HKquery = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
                
                HKquery.initialResultsHandler =
                {
                    query, results, error in
                    guard let statsCollection = results
                            else
                            {
                                fatalError("Unable to get results! Reason: \(String(describing: error?.localizedDescription))")
                            }
                    
                    statsCollection.enumerateStatistics(from: startDate, to: endDate)
                    {
                        statistics, stop in
                        if let quantity = statistics.averageQuantity()
                        {
                            let date = statistics.startDate
                            let val = quantity.doubleValue(for: HKUnit(from: "count/min"))
                            print("should be done")
                            print(val)
                            print(date)
                            @StateObject var score = ExistenceScore()
                            score.heartAvg = score.heartAvg + val
                            heartCount += 1
                        }
                    }
                    
                }
                HKStore.execute(HKquery)
            }
            else
            {
                print("Unauthorized!")
            }
        }
    }
    else
    {
        print("ERROR: Unable to fetch data!")
    }
}

struct ContentView: View {
    @StateObject var score = ExistenceScore()
    var body: some View {
        Button(action: fetchHealthData) {
            Text("Pull data")
                .font(.largeTitle)
                .bold()
                .padding()
        }
        Text(String(score.heartAvg))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
