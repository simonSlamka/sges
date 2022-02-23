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

var valHR = 0.0
var heartCount = 0.0

func fetchHealthData() -> Void
{
    let HKStore = HKHealthStore()
    
    if HKHealthStore.isHealthDataAvailable()
    {
        let stolenData = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleMoveTime)!,
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!,
            HKObjectType.quantityType(forIdentifier: .dietarySugar)!,
            HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
            HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!])
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
                interval.hour = 6
                
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
                            print(val)
                            print(date)
                            valHR = valHR + val
                            heartCount += 1.0
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

func pushToSimtoonAPI() -> Void
{
    // PUSH TO SIMTOON API
}

struct InnerView: View
{
    @ObservedObject var score: ExistenceScore
    
    var body: some View
    {
        Button("Pull HealthKit data")
        {
            fetchHealthData()
            score.heartAvg = valHR/heartCount
            Spacer(minLength: 10.0)
        }
        .frame(width: 200.0, height: 35.0)
        .background(Color.cyan)
        //.opacity(0.8)
        .cornerRadius(25)
        Button("Push data to SimtoonAPI")
        {
            
        }
        .frame(width: 200, height: 35)
        //.background(Color.green)
        .opacity(0.5)
        .cornerRadius(5)
        .disabled(true)
    }
}

struct ContentView: View {
    @StateObject var score = ExistenceScore()
    var body: some View {
        VStack()
        {
            Text("Your average HR in the past 30 days taken in 6-hour intervals is " + String(format: "%.1f", score.heartAvg) + " BPM")
                .font(.headline)
                .bold()
                .padding()
                .foregroundColor(Color.cyan)
            InnerView(score: score)
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
