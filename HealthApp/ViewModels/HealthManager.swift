import Foundation
import HealthKit


class HealthManager : ObservableObject{
    
    let healthStore = HKHealthStore()
    
    @Published var activities : [String : Activity] = [:]
    
    //If you want to display some dummy data then add into it
    @Published  var mockActivities : [String:Activity] = [
        
        "todayStep" :Activity(id: 0, title: "Todays Steps", subTitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: "5,000"),
        "todaycalories":Activity(id: 1, title: "Todays Calories", subTitle: "Goal 900", image: "flame",tintColor: .green, amount: "450")
        
    ]
    
    init(){
        requestAuthorizationAndFetchData()
    }
    
    private func requestAuthorizationAndFetchData(){
        
        //User permission
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        
        let healthType: Set = [steps,calories,workout]
        
        Task{
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthType)
                fetchTodaySteps()
                fetchTodaysCalories()
                fetchCurrentWeekWorkoutsStats()
            } catch {
                print("Error")
            }
        }
    }
    
    //Fetch today steps----
    private func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        
        //To start today date---
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(),error == nil else {
                print("Error fetching today steps")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Todays Steps", subTitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString() ?? "0.0")
            
            DispatchQueue.main.async {
                self.activities["todayStep"] = activity
            }
            
            print("Total steps----",stepCount.formattedString() ?? "0")
            
        }
        
        healthStore.execute(query)
        
    }
    
    //Fetch today calories
    private func fetchTodaysCalories(){
        
        let calories = HKQuantityType(.activeEnergyBurned)
        
        //To start today date---
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _,result, error in
            
            guard let quantity = result?.sumQuantity(),error == nil else {
                print("Error fetching today calories")
                return
            }
            
            
            let totalCalories = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Todays Calories", subTitle: "Goal 900", image: "flame", tintColor: .red, amount: totalCalories.formattedString() ?? "0.0")
            
            DispatchQueue.main.async {
                self.activities["todayCalory"] = activity
            }
            
            print("Total Calories----",totalCalories.formattedString() ?? "0")
            
        }
        healthStore.execute(query)
    }
    
    
    //All workout stats
    private func fetchCurrentWeekWorkoutsStats() {
        
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: Date.startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts data: \(String(describing: error))")
                return
            }
            
            
            var totalTimeRunning = 0
            var totalTimeWeightLifting = 0
            var totalTimeSoccer = 0
            var totalTimeBasketball = 0
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
    
                switch workout.workoutActivityType {
                case .running:
                    totalTimeRunning += duration
                case .traditionalStrengthTraining:
                    totalTimeWeightLifting += duration
                case .soccer:
                    totalTimeSoccer += duration
                case .basketball:
                    totalTimeBasketball += duration
                default:
                    break
                }
            }
            
            let activities = [
                
                Activity(id: 2, title: "Running", subTitle: "Mins This Week", image: "figure.walk", tintColor: .blue, amount: "\(totalTimeRunning) minutes"),
                Activity(id: 3, title: "Weight Lifting", subTitle: "Mins This Week", image: "figure.walk", tintColor: .black, amount: "\(totalTimeWeightLifting) minutes"),
                Activity(id: 4, title: "Football", subTitle: "Mins This Week", image: "figure.walk", tintColor: .yellow, amount: "\(totalTimeSoccer) minutes"),
                Activity(id: 5, title: "Basketball", subTitle: "Mins This Week", image: "figure.walk", tintColor: .red, amount: "\(totalTimeBasketball) minutes")
            ]
            
            DispatchQueue.main.async {
                self.activities["weekRunning"] = activities[0]
                self.activities["weekWeightLifting"] = activities[1]
                self.activities["weekSoccer"] = activities[2]
                self.activities["weekBasketball"] = activities[3]
            }
        }
        healthStore.execute(query)
    }
    
    
}
