//
//  ContentView.swift
//  Existence Score
//
//  Created by Simon Slamka on 2/22/22.
//

import SwiftUI
import HealthKit

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
    var body: some View {
        Button(action: fetchHealthData) {
            Text("Pull data")
                .font(.largeTitle)
                .bold()
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
