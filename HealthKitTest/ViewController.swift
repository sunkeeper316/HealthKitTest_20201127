import HealthKit
import UIKit

class ViewController: UIViewController {

    let healthKitStore:HKHealthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHealthKitPermission()
        // Do any additional setup after loading the view.
    }
    func getHealthKitPermission() {
        let healthkitTypesToRead = NSSet(array: [
             HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sexualActivity) ?? "",
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) ?? "",
             HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) ?? "",
            ])

        let healthkitTypesToWrite = NSSet(array: [
            // Here we are only requesting access to write for the amount of Energy Burned.
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) ?? "",
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) ?? "",
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) ?? "",
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) ?? "",
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal) ?? "",
            ])
        healthKitStore.requestAuthorization(toShare: healthkitTypesToWrite as? Set, read: healthkitTypesToRead as? Set) { (success, error) in
            if success {
                print("Permission accept.")
                self.saveProtin()
                self.saveHeight()
                self.readHeight()
                self.readWeight()
            } else {
                if error != nil {
                    print(error ?? "")
                }
                print("Permission denied.")
            }
        }
    }
    func saveProtin(){
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) {
            let date = Date()
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: 50.0)
            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            self.healthKitStore.save(sample, withCompletion: { (success, error) in
                print("Saved \(success), error \(error)")
            })
        }
    }
    func saveHeight() {
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) {
            let date = Date()
            let quantity = HKQuantity(unit: HKUnit.inch(), doubleValue: 170.0)
            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            self.healthKitStore.save(sample, withCompletion: { (success, error) in
                print("Saved \(success), error \(error)")
            })
        }
    }
    func readHeight(){
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample{
                print("Height => \(result.quantity)")
            }else{
                print("OOPS didnt get height \nResults => \(results), error => \(error)")
            }
        }
        self.healthKitStore.execute(query)
    }
    func readWeight(){
        let bodyMass = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: bodyMass, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample{
                print("bodyMass => \(result.quantity)")
            }else{
                print("OOPS didnt get height \nResults => \(results), error => \(error)")
            }
        }
        self.healthKitStore.execute(query)
    }
}

