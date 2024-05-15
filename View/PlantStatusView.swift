import SwiftUI
import CoreData

enum AlertType: Identifiable {
    case wateringConfirmation
    case fertilizingConfirmation
    case changeDormancyConfirmation
    
    var id: Int {
        // Use a unique identifier for each case
        switch self {
        case .wateringConfirmation:
            return 0
        case .fertilizingConfirmation:
            return 1
        case .changeDormancyConfirmation:
            return 2
        }
    }
}


struct PlantStatusView: View {
    let id = UUID()
    var name: String
    var isDormancy: Bool
    var isActionNeedView: Bool
    
    public init(name: String, plantData: PlantData, isDormancy: Bool = false, isActionNeedView: Bool = false) {
        self.name = name
        self.plantData = plantData
        self.isDormancy = isDormancy
        self.isActionNeedView = isActionNeedView
    }
    
    @State private var alertType: AlertType?
    
    @State private var isWatered: Bool = false
    @State private var isSnooze: Bool = false
    @State private var isInfo: Bool = false
    @State private var ischangeDG: Bool = false
    @State private var ispod: Bool = false
    
    @State private var currentDate = Date()
    @State private var formattedDate = ""
    
    @State private var isRepodView = false
    @State private var showCustomPopupWatering = false
    @State private var showCustomPopupFertilizing = false
    @State private var showConfirmationAlertWatering = false
    @State private var showConfirmationAlertFertilizing = false
    @State private var showingSettingsSheet = false
    @State private var showingImageSheet = false
    @State private var showConfirmationAlert = false
    @State private var showingConfirmationPopup = false
    @State private var showForgotEnterFertilizingDataView = false
    @State private var showForgotEnterWateringDataView = false
    
    @State private var selectedOption: String = ""
    @State private var lazy: Bool = true
    @State private var fractionWatering: Double = 0.0
    @State private var fractionFertilizingDormancy: Double = 0.0
    @State private var fractionFertilizingActiveGrowth: Double = 0.0
    @State private var plantImage: Image?
    @State private var account = "Rebecca"
    @State private var imagename = ""
    @State private var editedname = ""
    
    @ObservedObject var plantData: PlantData
    @Environment(\.colorScheme) var colorScheme
    
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

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        return formatter
    }()
    
    private func updateFractionWatering() {
        fractionWatering = plantData.calculateBarWatering(forType: name).widthFraction
    }
    
    private func updateFractionFertilizing() {
        if isDormancy {
            fractionFertilizingDormancy = plantData.calculateBarFertilizingDormancy(forType: name).widthFraction
        } else {
            fractionFertilizingActiveGrowth = plantData.calculateBarFertilizingActiveGrowth(forType: name).widthFraction
        }
    }
    
    private func updateFractionWatering_v2(name: String) {
        fractionWatering = plantData.calculateBarWatering(forType: name).widthFraction
    }
    
    private func updateFractionFertilizing_v2(name: String) {
        if isDormancy {
            fractionFertilizingDormancy = plantData.calculateBarFertilizingDormancy(forType: name).widthFraction
        } else {
            fractionFertilizingActiveGrowth = plantData.calculateBarFertilizingActiveGrowth(forType: name).widthFraction
        }
    }
    
    private func updateFractionFertilizing_double() {
        fractionFertilizingDormancy = plantData.calculateBarFertilizingDormancy(forType: name).widthFraction
        fractionFertilizingActiveGrowth = plantData.calculateBarFertilizingActiveGrowth(forType: name).widthFraction
    }
    
    
    private func loadImage() {
        guard let plant = plantData.plants.first(where: { $0.plantType == name }),
              let imageData = plant.image,
              let uiImage = UIImage(data: imageData) else {
            plantImage = nil
            return
        }
        plantImage = Image(uiImage: uiImage)
    }
    
    private func plantStatusSection() -> some View {
        return HStack {
            if (isDormancy ? fractionFertilizingDormancy : fractionFertilizingActiveGrowth) < 0 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.horizontal, 75)
                    .padding(.vertical, 5)
            } else if (isDormancy ? fractionFertilizingDormancy : fractionFertilizingActiveGrowth) != 2 {

                Rectangle()
                    .frame(width: 220 * (isDormancy ? fractionFertilizingDormancy : fractionFertilizingActiveGrowth), height: 30)
                    .foregroundColor((isDormancy ? plantData.calculateBarFertilizingDormancy(forType: name) : plantData.calculateBarFertilizingActiveGrowth(forType: name)).color)
                    .cornerRadius(10)
                    .background(
                        GeometryReader { geometry in
                            Color.gray
                                .frame(width:220, height: 30)
                                .cornerRadius(10)
                                .opacity(0.3)
                        }
                    )
            }
            
            Spacer()
            
            Button(action: {
                showCustomPopupFertilizing.toggle()
            }) {
                Image(systemName: "leaf.fill")
                    .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                    .font(.system(size: 30, weight: .bold))
                    .padding(.horizontal, -5)
            }
            .buttonStyle(BorderlessButtonStyle())
            .actionSheet(isPresented: $showCustomPopupFertilizing) {
                ActionSheet(
                    title: Text("Options"),
                    message: Text("Choose an option"),
                    buttons: [
                        .default(Text("Right on Schedule")) {
                            selectedOption = "Right on Schedule"
                            lazy = false
                            alertType = .fertilizingConfirmation
                        },
                        .destructive(Text("Lazy")) {
                            selectedOption = "Lazy"
                            lazy = true
                            alertType = .fertilizingConfirmation
                        },
                        .destructive(Text("Forgot to Enter Data")) {
                            selectedOption = "Forgot to Enter Data"
                            lazy = false
                            showForgotEnterFertilizingDataView = true
                        },
                        .destructive(Text("Registration right after changing Dormancy or Active Growth")) {
                            selectedOption = "Registration right after changing Dormancy or Active Growth"
                            lazy = true
                            alertType = .fertilizingConfirmation
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showForgotEnterFertilizingDataView) {
                ForgotEnterFertilizingView(plantData:plantData,fractionFertilizingDormancy:$fractionFertilizingDormancy,fractionFertilizingActiveGrowth:$fractionFertilizingActiveGrowth,showForgotEnterFertilizingDataView:$showForgotEnterFertilizingDataView,account:account,name:name,isDormancy:isDormancy,lazy:lazy)
            }
        }
    }
    
    private func snoozeButton() -> some View {
        Rectangle()
            .frame(width: 120, height: 30)
            .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
            .cornerRadius(5)
            .overlay(
                ZStack {
                    HStack{
                        Text("Snooze")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .bold))
                        Image(systemName: "alarm")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            )
    }
    
    private func changeDGButton() -> some View {
        if isDormancy == true {
            Rectangle()
                .frame(width: 120, height: 30)
                .foregroundColor(Color(red: 90/255, green: 160/255, blue: 111/255))
                .cornerRadius(5)
                .overlay(
                    ZStack {
                        HStack{
                            Text("Dormancy")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .bold))
                        }
                    }
                )
            
        } else {
            Rectangle()
                .frame(width: 120, height: 30)
                .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                .cornerRadius(5)
                .overlay(
                    ZStack {
                        HStack{
                            Text("ActiveGrowth")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .bold))
                        }
                    }
                )
        }
    }
    
    private func repot() -> some View {
        Rectangle()
            .frame(width: 120, height: 30)
            .foregroundColor(Color(red: 148/255, green: 76/255, blue: 56/255))
            .cornerRadius(5)
            .overlay(
                ZStack {
                    HStack{
                        Text("Repot")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .bold))
                        Image(systemName: "bathtub")
                          .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                    }
                }
            )
    }
    
    private func Statusbar() -> some View {
        Rectangle()
            .frame(width: 220 * fractionWatering, height: 30)
            .foregroundColor(plantData.calculateBarWatering(forType: name).color)
            .cornerRadius(10)
            .background(
                GeometryReader { geometry in
                    Color.gray
                        .frame(width:220, height: 30)
                        .cornerRadius(10)
                        .opacity(0.3)
                    
                }
            )
        
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        showingImageSheet.toggle()
                    }) {
                        if let image = plantImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        } else {
                            Rectangle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                                .background(
                                    Image(systemName: "camera.macro")
                                        .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                                        .font(.system(size: 30, weight: .bold)))
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .sheet(isPresented: $showingImageSheet,onDismiss: {
                        loadImage()
                    }) {
                        AddImageView(name: name, plantData: plantData, isAddImageViewPresented: $showingImageSheet) {
                            showingImageSheet = false
                        }
                    }
                    
                    Text(name)
                        .font(.system(size: 25, weight: .bold))
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSettingsSheet.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                            .font(.system(size: 20, weight: .bold))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .sheet(isPresented: $showingSettingsSheet, onDismiss: {
                        if editedname != "" {
                            updateFractionWatering_v2(name: editedname)
                            updateFractionFertilizing_v2(name: editedname)
                        } else {
                            updateFractionWatering()
                            updateFractionFertilizing()
                        }
                    }) {
                        DataOptionNewView(plantData: plantData, isDataOptionViewPresented: $showingSettingsSheet, name: $editedname, plantType: name, Account: account)
                    }
                }
                
                HStack {
                    if fractionWatering < 0 {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                            .font(.system(size: 30, weight: .bold))
                            .padding(.horizontal, 75)
                            .padding(.vertical, 5)
                    } else if fractionWatering != 2 {
                        Statusbar()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isWatered.toggle()
                        showCustomPopupWatering.toggle()
                    }) {
                        Image(systemName: "drop.fill")
                            .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                            .font(.system(size: 30, weight: .bold))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .actionSheet(isPresented: $showCustomPopupWatering) {
                        ActionSheet(
                            title: Text("Options"),
                            message: Text("Choose an option"),
                            buttons: [
                                .default(Text("Right on Schedule")) {
                                    selectedOption = "Right on Schedule"
                                    lazy = false
                                    alertType = .wateringConfirmation

                                },
                                .destructive(Text("Lazy")) {
                                    selectedOption = "Lazy"
                                    lazy = true
                                    alertType = .wateringConfirmation
                                },
                                .destructive(Text("Forgot to Enter Data")) {
                                    selectedOption = "Forgot to Enter Data"
                                    lazy = false
                                    showForgotEnterWateringDataView = true
                                },
                                .cancel()
                            ]
                        )
                    }
                    .sheet(isPresented: $showForgotEnterWateringDataView) {
                        ForgotEnterWateringView(plantData:plantData,fractionWatering:$fractionWatering,showForgotEnterWateringDataView:$showForgotEnterWateringDataView,account:account,name:name,lazy:lazy)
                    }
                }
                .padding(.top, 20)
                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                    let plant = plantData.plants[index]
                    if let lastUpdatedWatering = plant.lastUpdatedWatering {
                        Text("Next: \(dateFormatter.string(from: lastUpdatedWatering + plant.intervalWatering))")
                    } else {
                        Text("Watering lastUpdated not found")
                    }
                } else {
                    Text("Plant not found")
                }
                
                
                
                if isDormancy == true {
                    plantStatusSection()
                    .padding(.top, 15)
                    if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                        let plant = plantData.plants[index]
                        if let lastUpdatedFertilizingDormancy = plant.lastUpdatedFertilizingDormancy {
                            Text("Next: \(dateFormatter.string(from: lastUpdatedFertilizingDormancy+plant.intervalFertilizingDormancy))")
                        } else {
                            Text("Fertilizing lastUpdated not found")
                        }
                    } else {
                        Text("Plant not found")
                    }
                    
                    
                } else {
                    plantStatusSection()
                    .padding(.top, 15)
                    if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                        let plant = plantData.plants[index]
                        if let lastUpdatedFertilizingActiveGrowth = plant.lastUpdatedFertilizingActiveGrowth {
                            Text("Next: \(dateFormatter.string(from: lastUpdatedFertilizingActiveGrowth+plant.intervalFertilizingActiveGrowth))")
                        } else {
                            Text("Fertilizing lastUpdated not found")
                        }
                    } else {
                        Text("Plant not found")
                    }
                }
                
                Spacer().frame(height:20)
                
                HStack{
                    if self.isActionNeedView == true {
                        Button(action: {
                            isSnooze.toggle()
                        }) {
                            snoozeButton()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .actionSheet(isPresented: $isSnooze) {
                            ActionSheet(
                                title: Text("Snooze"),
                                message: Text("Are you sure you checked the \(name)?"),
                                buttons: [
                                    .default(Text("Yes")) {
                                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                            plantData.plants[index].snooze = Date()
                                            plantData.savePlants()
                                        }
                                    },
                                    .cancel(Text("No"))
                                ]
                            )
                        }
                    } else {
                        Rectangle()
                            .fill(Color.green.opacity(0))
                            .frame(width: 0, height: 10)
                    }
                }
                
                if self.isActionNeedView == true {
                    Spacer().frame(width: 10)
                }
                
                DisclosureGroup("Details") {
                    HStack{
                        Button(action: {
                            ischangeDG.toggle()
                        }) {
                            changeDGButton()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .actionSheet(isPresented: $ischangeDG) {
                            ActionSheet(
                                title: Text("Select an option:"),
                                buttons: [
                                    .default(Text("Dormancy")) {
                                        selectedOption = "Dormancy"
                                        alertType = .changeDormancyConfirmation
                                    },
                                    .default(Text("ActiveGrowth")) {
                                        selectedOption = "ActiveGrowth"
                                        alertType = .changeDormancyConfirmation
                                    },
                                    .cancel()
                                ]
                            )
                        }
                    }
                    .padding(.top, 10)
                    
                    HStack{
                        Button(action: {
                            ispod.toggle()
                        }) {
                            repot()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $ispod) {
                            RepotView(plantData:plantData, isRepodView:$ispod, name: name, account:account)
                        }
                        
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            if let potsize_unit = plantData.plants[index].potsize_unit, let potsize_num = plantData.plants[index].potsize_num{
                                Text(potsize_num + " " + potsize_unit)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack{
                        Button(action: {
                            isInfo.toggle()
                        }) {
                            Image(systemName: "info.circle")
                            
                                .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                                .font(.system(size: 30))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $isInfo) {
                            InfoView(plantData:plantData, isInfoView:$isInfo, name:name)
                        }
                        Spacer().frame(width: 30)
                    }
                }
                .accentColor(Color(red: 18/255, green: 83/255, blue: 20/255))
            }
            Spacer()
        }
        .listRowBackground(
            Image("23")
                .resizable()
                .scaledToFill()
                .opacity(0.95)
        )
        .padding()
        .onAppear {
            updateFractionWatering()
            updateFractionFertilizing()
            formattedDate = dateFormatter.string(from: currentDate)
            loadImage()
        }
        .onDisappear {
            updateFractionWatering()
            updateFractionFertilizing()
            formattedDate = dateFormatter.string(from: currentDate)
            loadImage()
        }
        .alert(item: $alertType) { alertType in
            switch alertType {
            case .wateringConfirmation:
                return Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to select \(selectedOption)?"),
                    primaryButton: .default(Text("Yes")) {
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            plantData.plants[index].lastUpdatedWatering = Date()
                            plantData.savePlants()
                        }
                        addWateringToDataList(forName: name, withDate: Date(), andValue: lazy)
                        let newInterval = calculateAverageDuration(dataItems: Array(filteredWateringData))
                        if newInterval != -1.0 {
                            if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                plantData.plants[index].intervalWatering = newInterval
                                plantData.savePlants()
                                print(plantData.plants[index].intervalWatering)
                            }
                        } else {
                            if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                plantData.plants[index].intervalWatering = plantData.plants[index].defaultintervalWatering
                                plantData.savePlants()
                            }
                        }
                        updateFractionWatering()
                        showConfirmationAlertWatering.toggle()
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            case .fertilizingConfirmation:
                return Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to select \(selectedOption)?"),
                    primaryButton: .default(Text("Yes")) {
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            if isDormancy == true {
                                plantData.plants[index].lastUpdatedFertilizingDormancy = Date()
                            } else {
                                plantData.plants[index].lastUpdatedFertilizingActiveGrowth = Date()
                            }
                        }
                        if isDormancy == true {
                            addFertilizingDormancyToDataList(forName: name, withDate: Date(), andValue: lazy)
                            let newInterval = calculateFertilizingDormancyAverageDuration(dataItems: Array(filteredFertilizingDormancyData))
                            if newInterval != -1.0 {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].intervalFertilizingDormancy = newInterval
                                    plantData.savePlants()
                                }
                            } else {
                                print(44)
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].intervalFertilizingDormancy = plantData.plants[index].defaultintervalFertilizingDormancy
                                    plantData.savePlants()
                                }
                            }
                        } else {
                            addFertilizingActiveGrowthToDataList(forName: name, withDate: Date(), andValue: lazy)
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
                        showConfirmationAlertFertilizing.toggle()
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            case .changeDormancyConfirmation:
                return Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to select \(selectedOption)?"),
                    primaryButton: .default(Text("Yes")) {
                        updateFractionFertilizing_double()
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            if selectedOption == "Dormancy" {
                                plantData.plants[index].dormancy = true
                            } else if selectedOption == "ActiveGrowth" {
                                plantData.plants[index].dormancy = false
                            }
                            plantData.savePlants()
                            updateFractionFertilizing()
                            showConfirmationAlert.toggle()
                        }
                        print("Selected option: \(selectedOption)")
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
    }
}

