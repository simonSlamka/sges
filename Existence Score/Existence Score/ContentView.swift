//
//  ContentView.swift
//  Existence Score
//
//  Created by Simon Slamka on 2/22/22.
//

import SwiftUI
import HealthKit

let HKStore = HKHealthStore()

class ExistenceScore: ObservableObject
{
    @Published var heartAvg = 0.0
}

var valHR = 0.0
var heartCount = 0.0

func obtainHKAuthorization() -> Int
{
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
            HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
            HKObjectType.categoryType(forIdentifier: .sexualActivity)!,
            HKObjectType.categoryType(forIdentifier: .abdominalCramps)!,
            HKObjectType.categoryType(forIdentifier: .appetiteChanges)!,
            HKObjectType.categoryType(forIdentifier: .chestTightnessOrPain)!,
            HKObjectType.categoryType(forIdentifier: .chills)!,
            HKObjectType.categoryType(forIdentifier: .constipation)!,
            HKObjectType.categoryType(forIdentifier: .diarrhea)!,
            HKObjectType.categoryType(forIdentifier: .coughing)!,
            HKObjectType.categoryType(forIdentifier: .dizziness)!,
            HKObjectType.categoryType(forIdentifier: .drySkin)!,
            HKObjectType.categoryType(forIdentifier: .fatigue)!,
            HKObjectType.categoryType(forIdentifier: .fever)!,
            HKObjectType.categoryType(forIdentifier: .headache)!,
            HKObjectType.categoryType(forIdentifier: .heartburn)!,
            HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!,
            HKObjectType.categoryType(forIdentifier: .hotFlashes)!,
            HKObjectType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
            HKObjectType.categoryType(forIdentifier: .lowCardioFitnessEvent)!,
            HKObjectType.categoryType(forIdentifier: .lowerBackPain)!,
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
            HKObjectType.categoryType(forIdentifier: .moodChanges)!,
            HKObjectType.categoryType(forIdentifier: .nausea)!,
            HKObjectType.categoryType(forIdentifier: .runnyNose)!,
            HKObjectType.categoryType(forIdentifier: .shortnessOfBreath)!,
            HKObjectType.categoryType(forIdentifier: .skippedHeartbeat)!,
            HKObjectType.categoryType(forIdentifier: .soreThroat)!,
            HKObjectType.categoryType(forIdentifier: .vomiting)!,
            HKObjectType.categoryType(forIdentifier: .sleepChanges)!])
        HKStore.requestAuthorization(toShare: [], read: stolenData)
        {(success, error) in
            if success
            {
                print("Authorization processed - permission granted. Ready for queries ...")
            }
            else
            {
                fatalError("Access to HK data denied!")
            }
        }
    }
    return 0
}
        
func queryHRAvgToday(completion: @escaping (Double) -> Void)
{
    let cal = NSCalendar.current
    var anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
    let now = Date()
    
    
}

//func fetchHealthData(completion: @escaping (Double) -> Void)
//{
//
//                let cal = NSCalendar.current
//                var anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
//                let offset = (5 + anchorComps.weekday! - 2) % 5
//                let now = Date()
//                let startOfToday = Calendar.current.startOfDay(for: now)
//                let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: now, options: .strictStartDate)
//                anchorComps.day! -= offset
//                anchorComps.hour = 1
//                guard let anchorDate = Calendar.current.date(from: anchorComps)
//                else
//                {
//                    fatalError("Can't get a valid date from the achor. You fucked something up!")
//                }
//
//                guard let startDate = cal.date(byAdding: .month, value: -1, to: now)
//                        else
//                        {
//                            fatalError("Can't generate a startDate! :-/")
//                        }
//
//                let interval = NSDateComponents()
//                interval.hour = 1
//
//                // quantity type inits
//                guard let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount)
//                else
//                {
//                    fatalError("Can't get quantityType forIdentifier: .stepCount")
//                }
//
//                guard let HRtype = HKObjectType.quantityType(forIdentifier: .heartRate)
//                else
//                {
//                    fatalError("Can't get quantityType forIdentifier: .heartRate!")
//                }
//
//                // query inits
//                let HRquery = HKStatisticsCollectionQuery(quantityType: HRtype, quantitySamplePredicate: nil, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
//
//                let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepsType, quantitySamplePredicate: nil, options: [.cumulativeSum], anchorDate: startOfToday, intervalComponents: interval as DateComponents)
//
//                // query init result handlers
//                HRquery.initialResultsHandler =
//                {
//                    query, results, error in
//                    guard let statsCollection = results
//                            else
//                            {
//                                fatalError("Unable to get results! Reason: \(String(describing: error?.localizedDescription))")
//                            }
//
//                    statsCollection.enumerateStatistics(from: startDate, to: now)
//                    {
//                        statistics, stop in
//                        if let quantity = statistics.averageQuantity()
//                        {
//                            let date = statistics.startDate
//                            let val = quantity.doubleValue(for: HKUnit(from: "count/min"))
//                            print(val)
//                            print(date)
//                            valHR = valHR + val
//                            heartCount += 1.0
//                        }
//                    }
//
//                }
//
//                stepsQuery.initialResultsHandler =
//                {
//                    query, results, error in
//                    var count = 0.0
//                    guard let statsCollection = results
//                            else
//                            {
//                                fatalError("Unable to initresulthandler steps! Reason: \(String(describing: error?.localizedDescription))")
//                            }
//
//                    statsCollection.enumerateStatistics(from: startOfToday, to: now)
//                    {
//                        statistics, stop in
//                        if let quantity = statistics.sumQuantity()
//                        {
//                            count = quantity.doubleValue(for: HKUnit.count())
//                        }
//                        DispatchQueue.main.async
//                        {
//                            completion(count)
//                        }
//
//                    }
//                }
//                HKStore.execute(HRquery)
//                HKStore.execute(stepsQuery)
//            }
//            else
//            {
//                print("Unauthorized!")
//            }
//    }
//    else
//    {
//        print("ERROR: Unable to fetch data!")
//    }
//}

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
            //fetchHealthData()
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
