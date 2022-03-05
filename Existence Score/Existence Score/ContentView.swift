//
//  ContentView.swift
//  Existence Score
//
//  Created by Simon Slamka on 2/22/22.
//
// This app is being coded quickly with little efficiency - I just need to get it to work - do not judge coding practices ...
// ... in this particular project, please

import SwiftUI
import HealthKit

let HKStore = HKHealthStore()

class ExistenceScore: ObservableObject
{
    // daily values, including the averages (midnight to Date())
    @Published var HRAvg = 0.0
    @Published var BPsysAvg = 0.0
    @Published var BPdiaAvg = 0.0
    @Published var exerciseMinutes = 0.0
    @Published var burnedActiveEnergy = 0.0
    @Published var standTimeMinutes = 0.0
    @Published var bodyMassIndex = 0.0
    @Published var caffeineMilliGrams = 0.0
    @Published var sugarGrams = 0.0
    @Published var proteinMilliGrams = 0.0
    @Published var magnesiumMilliGrams = 0.0
    @Published var waterMilliLiters = 0.0
    @Published var energyConsumedCalories = 0.0
    @Published var bloodOxygenSaturationPercentage = 0.0
    @Published var restingHRAvg = 0.0
    @Published var stepCount = 0.0
    @Published var fitnessLevel = 0.0
    @Published var walkingHRAvg = 0.0
    
    // the following types are so-called categoryTypes. When we say "cough" or "chills", we mean a count of instances over the course of a day, so for example, coughed twice or ...
    // ... had two mindful sessions. Duration is irrelevant for now. Some of these might be harder to "count", but I don't have a better idea how to represent these yet
    @Published var sexCount = 0.0 // this is probably the hardest property of all these to increment :D
    @Published var abdominalCrampsCount = 0.0
    @Published var appetiteChangeCount = 0.0
    @Published var chestTightnessOrPainCount = 0.0
    @Published var chillsCount = 0.0
    @Published var constipationCount = 0.0
    @Published var diarrheaCount = 0.0
    @Published var coughCount = 0.0
    @Published var dizzinessCount = 0.0
    @Published var drySkinCount = 0.0
    @Published var fatigueCount = 0.0
    @Published var feverCount = 0.0
    @Published var headacheCount = 0.0
    @Published var heartburnCount = 0.0
    @Published var highHREventCount = 0.0
    @Published var hotFlashesCount = 0.0
    @Published var irregularHREventCount = 0.0
    @Published var lowFitnessEventCount = 0.0
    @Published var lowerBackPainCount = 0.0
    @Published var mindfulSessionCount = 0.0
    @Published var moodChangeCount = 0.0
    @Published var nauseaCount = 0.0
    @Published var runnyNoseCount = 0.0
    @Published var shortnessOfBreathCount = 0.0
    @Published var skippedHeartBeatCount = 0.0
    @Published var soreThroatCount = 0.0
    @Published var vomitingCount = 0.0
    @Published var sleepChangesCount = 0.0
    
}

var valHR = 0.0

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

func queryQuantityData(for typeIdentifier: HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void)
{
    print("Attempting to pull the requested data from HK ...")
    var val = 0.0
    var total = 0.0
    var howMany = 0.0
    let cal = NSCalendar.current
    let anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
    let now = Date()
    let startOfToday = Calendar.current.startOfDay(for: now)
    let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: now, options: .strictStartDate)
    guard let anchorDate = Calendar.current.date(from: anchorComps)
            else
            {
                fatalError("Can't init anchorDate!!")
            }
//    guard let startDate = cal.date(byAdding: .day, value: -1, to: now)
//            else
//            {
//                fatalError("Can't init startDate!!")
//            }
    let interval = NSDateComponents()
    interval.minute = 10
//    guard let HRtype = HKObjectType.quantityType(forIdentifier: .heartRate)
//            else
//            {
//                fatalError("Can't init HRtype quantityType forIdentifier .heartRate")
//            }
//    if(objectType == HKObjectType.quantityType(forIdentifier: .heartRate) || objectType == HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) || objectType ==  HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic))
    var HKquery = HKStatisticsCollectionQuery(quantityType: HKQuantityType(typeIdentifier), quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
    if(HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .heartRate) || HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) || HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic) || HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .bodyMassIndex) ||
       HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .oxygenSaturation) ||
       HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .restingHeartRate) ||
       HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage) ||
       HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .vo2Max))
    {
        HKquery = HKStatisticsCollectionQuery(quantityType: HKQuantityType(typeIdentifier), quantitySamplePredicate: nil, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
    }
    HKquery.initialResultsHandler =
    {
        query, result, error in
        guard let statsCollection = result
                else
                {
                    fatalError("Can't get results from HKquery!")
                }
        if(HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .heartRate) || HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) || HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic) ||
           HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .oxygenSaturation) ||
           HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .restingHeartRate) ||
           HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage) ||
           HKObjectType.quantityType(forIdentifier: typeIdentifier) == HKObjectType.quantityType(forIdentifier: .vo2Max))
        {
            statsCollection.enumerateStatistics(from: startOfToday, to: now)
            {
                statistics, stop in
                if let quantity = statistics.averageQuantity()
                {
                    let date = statistics.startDate
                    if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit(from: "count/min"))) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit(from: "count/min"))
                    }
                    else if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit.count())) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit.count())
                    }
                    else if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit(from: "mmHg"))) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit(from: "mmHg"))
                    }
                    else
                    {
                        fatalError("Unit unknown!")
                    }
                    print("---------------------------")
                    print("Times are in UTC!")
                    print(date)
                    print(val)
                    total = total + val
                    howMany = howMany + 1
                    DispatchQueue.main.async
                    {
                        let out = total/howMany
                        completion(out)
                    }
                }
            }
        }
        else //if(objectType == HKObjectType.quantityType(forIdentifier: .stepCount) || objectType == HKObjectType.quantityType(forIdentifier: .appleExerciseTime) || objectType == HKObjectType.quantityType(forIdentifier: .activeEnergyBurned))
        {
            statsCollection.enumerateStatistics(from: startOfToday, to: now)
            {
                statistics, stop in
                if let quantity = statistics.sumQuantity()
                {
                    let date = statistics.startDate
                    if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit.minute())) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit.minute())
                    }
                    else if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit.largeCalorie())) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit.largeCalorie())
                    }
                    else if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit.count())) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit.count())
                    }
                    else if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit.gram())) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit.gram())
                    }
                    else if((HKObjectType.quantityType(forIdentifier: typeIdentifier)?.is(compatibleWith: HKUnit.liter())) != false)
                    {
                        val = quantity.doubleValue(for: HKUnit.liter())
                    }
                    else
                    {
                        fatalError("Unit unknown!")
                    }
                    print("stepCount: " + String(val))
                    print("---------------------------")
                    print("Times are in UTC!")
                    print(date)
                    print(val)
                    total = total + val
                    DispatchQueue.main.async
                    {
                        completion(total)
                    }
                }
            }
        }
    }
    HKStore.execute(HKquery)
}

//func queryCategoryData(for typeIdentifier: HKCategoryTypeIdentifier, completion: @escaping (Double) -> Void)
//{
//    print("Attempting to pull the requested data from HK ...")
//    var val = 0.0
//    var total = 0.0
//    var howMany = 0.0
//    let cal = NSCalendar.current
//    let anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
//    let now = Date()
//    let startOfToday = Calendar.current.startOfDay(for: now)
//    let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: now, options: .strictStartDate)
//    guard let anchorDate = Calendar.current.date(from: anchorComps)
//            else
//            {
//                fatalError("Can't init anchorDate!!")
//            }
//    let interval = NSDateComponents()
//    interval.minute = 10
//    var HKquery = HKSampleQuery(sampleType: HKCategoryType(typeIdentifier), predicate: predicate, limit: 1, sortDescriptors: nil)
//    {
//        (query, result, error) in
//        if (error != nil)
//        {
//            fatalError("Can't set the categoryType query!")
//        }
//
//        if let result = result
//        {
//            // stuck here
//        }
//    }
//
//    HKStore.execute(HKquery)
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
        Button("Obtain HealthKit auth")
        {
            if(obtainHKAuthorization() != 0)
            {
                
            }
            Spacer(minLength: 10.0)
        }
        Button("Pull HealthKit data")
        {
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierHeartRate"))
            {
                (out) in
                score.HRAvg = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierBloodPressureSystolic"))
            {
                (out) in
                score.BPsysAvg = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierBloodPressureDiastolic"))
            {
                (out) in
                score.BPdiaAvg = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierStepCount"))
            {
                (out) in
                score.stepCount = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierAppleExerciseTime"))
            {
                (out) in
                score.exerciseMinutes = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierActiveEnergyBurned"))
            {
                (out) in
                score.burnedActiveEnergy = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierAppleStandTime"))
            {
                (out) in
                score.standTimeMinutes = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierBodyMassIndex"))
            {
                (out) in
                score.bodyMassIndex = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierDietaryCaffeine"))
            {
                (out) in
                score.caffeineMilliGrams = out * 1000 /* !! converting grams to milligrams */
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierDietarySugar"))
            {
                (out) in
                score.sugarGrams = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierDietaryProtein"))
            {
                (out) in
                score.proteinMilliGrams = out * 1000
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierDietaryMagnesium"))
            {
                (out) in
                score.magnesiumMilliGrams = out * 1000
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierDietaryWater"))
            {
                (out) in
                score.waterMilliLiters = out * 1000 /* converting liters to milliliters */
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierDietaryEnergyConsumed"))
            {
                (out) in
                score.energyConsumedCalories = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierOxygenSaturation"))
            {
                (out) in
                score.bloodOxygenSaturationPercentage = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierRestingHeartRate"))
            {
                (out) in
                score.restingHRAvg = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierVO2Max"))
            {
                (out) in
                score.fitnessLevel = out
            }
            queryQuantityData(for: HKQuantityTypeIdentifier(rawValue: "HKQuantityTypeIdentifierWalkingHeartRateAverage"))
            {
                (out) in
                score.walkingHRAvg = out
            }
//            queryCategoryData(for: HKCategoryTypeIdentifier(rawValue: "HKCategoryTypeIdentifierSexualActivity"))
//            {
//                (out) in
//                score.sexCount = out
//            }
            Spacer(minLength: 10.0)
        }
        .frame(width: 200.0, height: 35.0)
        .background(Color.cyan)
        //.opacity(0.8)
        .cornerRadius(25)
        Button("Push data to SimtoonAPI")
        {
            print("---")
            print("")
            print(score.HRAvg)
            print(score.BPsysAvg)
            print(score.BPdiaAvg)
            print(score.exerciseMinutes)
            print(score.burnedActiveEnergy)
            print(score.standTimeMinutes)
            print(score.bodyMassIndex)
            print(score.caffeineMilliGrams)
            print(score.sugarGrams)
            print(score.proteinMilliGrams)
            print(score.magnesiumMilliGrams)
            print(score.waterMilliLiters)
            print(score.energyConsumedCalories)
            print(score.bloodOxygenSaturationPercentage)
            print(score.restingHRAvg)
            print(score.stepCount)
            print(score.fitnessLevel)
            print(score.walkingHRAvg)
            print("")
            print("categoryTypes")
            print(score.sexCount)
            print(score.abdominalCrampsCount)
            print(score.appetiteChangeCount)
            print(score.chestTightnessOrPainCount)
            print(score.chillsCount)
            print(score.constipationCount)
            print(score.diarrheaCount)
            print(score.coughCount)
            print(score.dizzinessCount)
            print(score.drySkinCount)
            print(score.fatigueCount)
            print(score.feverCount)
            print(score.headacheCount)
            print(score.heartburnCount)
            print(score.highHREventCount)
            print(score.hotFlashesCount)
            print(score.irregularHREventCount)
            print(score.lowFitnessEventCount)
            print(score.lowerBackPainCount)
            print(score.mindfulSessionCount)
            print(score.moodChangeCount)
            print(score.nauseaCount)
            print(score.runnyNoseCount)
            print(score.shortnessOfBreathCount)
            print(score.skippedHeartBeatCount)
            print(score.soreThroatCount)
            print(score.vomitingCount)
            print(score.sleepChangesCount)
        }
        .frame(width: 200, height: 35)
        //.background(Color.green)
        .opacity(0.5)
        .cornerRadius(5)
        //.disabled(true)
    }
}

struct ContentView: View {
    @StateObject var score = ExistenceScore()
    var body: some View {
        VStack()
        {
            Text("Data for today")
                .font(.title)
            //Spacer(minLength: 1.0)
            Text("Average HR: " + String(format: "%.1f", score.HRAvg) + " BPM")
                .font(.footnote)
                //.foregroundColor(Color.cyan)
            if(score.BPsysAvg == 0.0 && score.BPdiaAvg == 0.0)
            {
                Text("You haven't measured your blood pressure today!")
                    .foregroundColor(Color.red)
            }
            else
            {
                Text("Average blood pressure: " + String(score.BPsysAvg) + "/" + String(score.BPdiaAvg) + " mmHg")
                    .font(.footnote)
                    //.foregroundColor(Color.cyan)
            }
            Text("Stepcount: " + String(format: "%.0f", score.stepCount))
                .font(.footnote)
            Text("Exercise minutes: " + String(score.exerciseMinutes))
                .font(.footnote)
            Text("Active burned energy: " + String(format: "%.1f", score.burnedActiveEnergy) + " large calories [kcal]")
                .font(.footnote)
            Text("Stand time in minutes: " + String(score.standTimeMinutes))
                .font(.footnote)
            if(score.bodyMassIndex == 0.0)
            {
                Text("No weight/height data for today!")
                    .foregroundColor(Color.red)
                    .font(.footnote)
            }
            else
            {
                Text("BMI: " + String(score.bodyMassIndex))
                    .font(.footnote)
            }
            Text("Caffeine in milligrams: " + String(format: "%.1f", score.caffeineMilliGrams))
                .font(.footnote)
//            Text("Sugar in grams: " + String(format: "%.1f", score.sugarGrams))
//                .font(.footnote)
            InnerView(score: score)
        }
    }
}
