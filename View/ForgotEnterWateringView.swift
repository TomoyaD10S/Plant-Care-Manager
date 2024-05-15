import SwiftUI

enum AlertType3: Identifiable {
    case showingAlertWateringForgotDateError
    case showingConfirmationAlertWateringForgot
    
    var id: Int {
        switch self {
        case .showingAlertWateringForgotDateError:
            return 0
        case .showingConfirmationAlertWateringForgot:
            return 1
        }
    }
}

struct ForgotEnterWateringView: View {
    @State var alertType3: AlertType3?
    @State var selectedDate = Date()
    @State var errormessage = ""
    @ObservedObject var plantData: PlantData
    @Binding var fractionWatering: Double
    @Binding var showForgotEnterWateringDataView: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Watering.date, ascending: true)],
        animation: .default)
    private var wateringdata: FetchedResults<Watering>
    
    private var filteredWateringData: [Watering] {
        guard let nameEntity = fetchName(withName: name) else {
            return []
        }
        return wateringdata.filter { $0.name == nameEntity }
    }
    
    let account: String
    let name: String
    let lazy: Bool
    

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        return formatter
    }()
    
    private func updateFractionWatering() {
        fractionWatering = plantData.calculateBarWatering(forType: name).widthFraction
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Please enter the watering data. You cannot register a time that is ahead of the current time.")
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
                            alertType3 = .showingAlertWateringForgotDateError
                            return
                        }
                        alertType3 = .showingConfirmationAlertWateringForgot
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 18/255, green: 83/255, blue: 20/255))
                    .cornerRadius(8)
                    .padding()
                }
                .alert(item: $alertType3) { alertType in
                    switch alertType {
                    case .showingAlertWateringForgotDateError:
                        return Alert(
                            title: Text("Error"),
                            message: Text(errormessage),
                            dismissButton: .default(Text("OK"))
                        )
                    case .showingConfirmationAlertWateringForgot:
                        return Alert(
                            title: Text("Confirmation"),
                            message: Text("Are you sure you want to register at \(dateFormatter.string(from: selectedDate))?"),
                            primaryButton: .default(Text("Yes")) {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].lastUpdatedWatering = selectedDate
                                }
                                plantData.savePlants()
                                addWateringToDataList(forName: name, withDate: selectedDate, andValue: lazy)
                                let newInterval = calculateAverageDuration(dataItems: Array(filteredWateringData))
                                if newInterval != -1.0 {
                                    if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                        plantData.plants[index].intervalWatering = newInterval
                                    }
                                } else {
                                    if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                        plantData.plants[index].intervalWatering = plantData.plants[index].defaultintervalWatering
                                    }
                                }
                                updateFractionWatering()
                                plantData.savePlants()
                                showForgotEnterWateringDataView = false
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                }
                .navigationTitle("Data Entry")
                .navigationBarItems(trailing: Button("Cancel") {
                    showForgotEnterWateringDataView = false
                })
            }
        }
    }
}
