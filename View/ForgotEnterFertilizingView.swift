import SwiftUI

enum AlertType2: Identifiable {
    case showingAlertfertilizingForgotDateError
    case showingConfirmationAlertfertilizingForgot
    
    var id: Int {
        switch self {
        case .showingAlertfertilizingForgotDateError:
            return 0
        case .showingConfirmationAlertfertilizingForgot:
            return 1
        }
    }
}

struct ForgotEnterFertilizingView: View {
    @State var alertType2: AlertType2?
    @State var selectedDate = Date()
    @State var errormessage = ""
    @ObservedObject var plantData: PlantData
    @Binding var fractionFertilizingDormancy: Double
    @Binding var fractionFertilizingActiveGrowth: Double
    @Binding var showForgotEnterFertilizingDataView: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FertilizingDormancy.date, ascending: true)],
        animation: .default)
    private var fertilizingDormancydata: FetchedResults<FertilizingDormancy>
    
    private var filteredFertilizingDormancyData: [FertilizingDormancy] {
        guard let nameEntity = fetchName(withName: name) else {
            return []
        }
        return fertilizingDormancydata.filter { $0.name == nameEntity }
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FertilizingActiveGrowth.date, ascending: true)],
        animation: .default)
    private var fertilizingActiveGrowthdata: FetchedResults<FertilizingActiveGrowth>
    
    private var filteredFertilizingActiveGrowthData: [FertilizingActiveGrowth] {
        guard let nameEntity = fetchName(withName: name) else {
            return []
        }
        return fertilizingActiveGrowthdata.filter { $0.name == nameEntity }
    }
    
    let account: String
    let name: String
    let isDormancy: Bool
    let lazy: Bool
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        return formatter
    }()
    
    private func updateFractionFertilizing() {
        if isDormancy {
            fractionFertilizingDormancy = plantData.calculateBarFertilizingDormancy(forType: name).widthFraction
        } else {
            fractionFertilizingActiveGrowth = plantData.calculateBarFertilizingActiveGrowth(forType: name).widthFraction
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Please enter the fertilizing data. You cannot register a time that is ahead of the current time.")
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    DatePicker("Select date and time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding()
                    
                    Button("Register") {
                        let elapsedTime = selectedDate.timeIntervalSince(Date())
                        if elapsedTime > 0 {
                            errormessage = "You cannot register a time that is ahead of the current time."
                            alertType2 = .showingAlertfertilizingForgotDateError
                            return
                        }
                        alertType2 = .showingConfirmationAlertfertilizingForgot
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 18/255, green: 83/255, blue: 20/255))
                    .cornerRadius(8)
                    .padding()
                }
                .alert(item: $alertType2) { alertType in
                    switch alertType {
                    case .showingAlertfertilizingForgotDateError:
                        return Alert(
                            title: Text("Error"),
                            message: Text(errormessage),
                            dismissButton: .default(Text("OK"))
                        )
                    case .showingConfirmationAlertfertilizingForgot:
                        return Alert(
                            title: Text("Confirmation"),
                            message: Text("Are you sure you want to register at \(dateFormatter.string(from: selectedDate))?"),
                            primaryButton: .default(Text("Yes")) {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    if isDormancy == true {
                                        plantData.plants[index].lastUpdatedFertilizingDormancy = selectedDate
                                    } else {
                                        plantData.plants[index].lastUpdatedFertilizingActiveGrowth = selectedDate
                                    }
                                }
                                if isDormancy == true {
                                    addFertilizingDormancyToDataList(forName: name, withDate: selectedDate, andValue: lazy)
                                    let newInterval = calculateFertilizingDormancyAverageDuration(dataItems: Array(filteredFertilizingDormancyData))
                                    if newInterval != -1.0 {
                                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                            plantData.plants[index].intervalFertilizingDormancy = newInterval
                                            plantData.savePlants()
                                        }
                                    } else {
                                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                            plantData.plants[index].intervalFertilizingDormancy = plantData.plants[index].defaultintervalFertilizingDormancy
                                            plantData.savePlants()
                                        }
                                    }
                                } else {
                                    addFertilizingActiveGrowthToDataList(forName: name, withDate: selectedDate, andValue: lazy)
                                    let newInterval = calculateFertilizingActiveGrowthAverageDuration(dataItems: Array(filteredFertilizingActiveGrowthData))
                                    if newInterval != -1.0 {
                                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                            plantData.plants[index].intervalFertilizingActiveGrowth = newInterval
                                            plantData.savePlants()
                                        }
                                    } else {
                                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                            plantData.plants[index].intervalFertilizingActiveGrowth = plantData.plants[index].defaultintervalFertilizingActiveGrowth
                                            plantData.savePlants()
                                        }
                                    }
                                }
                                updateFractionFertilizing()
                                showForgotEnterFertilizingDataView = false
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                }
                .navigationTitle("Data Entry")
                .navigationBarItems(trailing: Button("Cancel") {
                    showForgotEnterFertilizingDataView = false
                })
            }
        }
    }
}
