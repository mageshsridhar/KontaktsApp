//
//  NewKontaktView.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/23/21.
//

import SwiftUI
import MapKit
struct NewKontaktView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    let locationFetcher = LocationFetcher()
    @State private var userLocation : MKCoordinateRegion = MKCoordinateRegion(center:CLLocationCoordinate2D(),span:MKCoordinateSpan())
    @State private var name = ""
    @State private var number = ""
    @State private var age = ""
    @State private var email = ""
    @State private var isFavorite = false
    @State private var locationManager = CLLocationManager()
    @State private var showingAlert = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var countryCode = "1"
    @State private var image: Data = .init(count:0)
    @State private var kontaktImage : UIImage?
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var capture = false

    let countryCodes = ["886", "93", "355", "213", "1-684", "376", "244", "1-264", "672", "1-268", "54", "374", "297", "61", "43", "994", "1-242", "973", "880", "1-246", "375", "32", "501", "229", "1-441", "975", "591", "599", "387", "267", "47", "55", "246", "1-284", "673", "359", "226", "257", "238", "855", "237", "1", "1-345", "236", "235", "56", "86", "852", "853", "61", "61", "57", "269", "242", "682", "506", "385", "53", "599", "357", "420", "225", "850", "243", "45", "253", "1-767", "1-809,1-829,1-849", "593", "20", "503", "240", "291", "372", "268", "251", "500", "298", "679", "358", "33", "594", "689", "262", "241", "220", "995", "49", "233", "350", "30", "299", "1-473", "590", "1-671", "502", "44", "224", "245", "592", "509", "672", "39-06", "504", "36", "354", "91", "62", "98", "964", "353", "44", "972", "39", "1-876", "81", "44", "962", "7", "254", "686", "965", "996", "856", "371", "961", "266", "231", "218", "423", "370", "352", "261", "265", "60", "960", "223", "356", "692", "596", "222", "230", "262", "52", "691", "377", "976", "382", "1-664", "212", "258", "95", "264", "674", "977", "31", "687", "64", "505", "227", "234", "683", "672", "1-670", "47", "968", "92", "680", "507", "675", "595", "51", "63", "870", "48", "351", "1", "974", "82", "373", "40", "7", "250", "262", "590", "290", "1-869", "1-758", "590", "508", "1-784", "685", "378", "239", "966", "221", "381", "248", "232", "65", "1-721", "421", "386", "677", "252", "27", "500", "211", "34", "94", "970", "249", "597", "47", "46", "41", "963", "992", "66", "389", "670", "228", "690", "676", "1-868", "216", "90", "993", "1-649", "688", "256", "380", "971", "44", "255", "1-340", "1", "598", "998", "678", "58", "84", "681", "212", "967", "260", "263", "358"]
    private func saveContext(){
        do{
            try viewContext.save()
        } catch{
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    func addKontakt(){
        withAnimation(){
        let newKontakt = Allkontakts(context: viewContext)
        newKontakt.uid = UUID()
        newKontakt.name = name
        newKontakt.number = Int64(number) ?? 0
        newKontakt.age = Int16(age) ?? 0
        newKontakt.isFavorite = isFavorite
        newKontakt.email = email
        newKontakt.latitude = userLocation.center.latitude
        newKontakt.longitude = userLocation.center.longitude
        newKontakt.image = kontaktImage?.jpegData(compressionQuality: 0)
        newKontakt.countryCode = countryCode
        saveContext()
        }
    }
    var body: some View {
        VStack{
            VStack{
            HStack{
                Button("Cancel"){
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Create"){
                    if name == "" || number == "" || email == "" || age == "" {
                        errorMessage = "Enter all the details"
                        showError.toggle()
                    }
                    
                    else if number.count < 10 || number.count > 10{
                        errorMessage = "Invalid mobile number. Please enter a valid phone number."
                        showError.toggle()
                    }
                    else if Int(age)! < 4 || Int(age)! > 105{
                        errorMessage = "Invalid age. Please try again with a valid age."
                        showError.toggle()
                    }
                    
                    else if email.count > 100 {
                        errorMessage = "Invalid email address. Please try again."
                        showError.toggle()
                    }
                    else if !validateEmail(enteredEmail: email){
                        errorMessage = "Invalid email format. Please try again."
                        showError.toggle()
                    }
                    else{
                        addKontakt()
                        presentationMode.wrappedValue.dismiss()
                    }
                }.alert(isPresented: $showError){
                    Alert(title: Text("Kontakt cannot be created"), message: Text(errorMessage), dismissButton: .default(Text("Close")))
                }
            }.padding()
                if kontaktImage != nil{
                    Button(action:{showingImagePicker.toggle()}){
                        Image(uiImage: kontaktImage!)
                            .resizable()
                            .frame(width: 100,height: 100)
                            .clipShape(Circle())
                            .padding()
                    }
                }
                else{
                    Button(action:{showingActionSheet.toggle()}){
                        Circle().fill(Color.purple).frame(width: 100, height:100)
                            .padding()
                    }
                }
            }
            Form{
                Section(header:Text("Kontakt Name")){
                    TextField("Enter name",text:$name)
                }
                Section(header:Text("Kontakt Number")){
                    HStack{
                        Picker("+\(countryCode)", selection: $countryCode) {
                                        ForEach(countryCodes, id: \.self) {
                                            Text("+\($0)")
                                        }
                                    }.pickerStyle(MenuPickerStyle())
                        TextField("Enter number",text:$number).keyboardType(.numberPad)
                    }
                }
                Section(header:Text("Kontakt Age")){
                    TextField("Enter age",text:$age).keyboardType(.numberPad)
                }
                Section(header:Text("Kontakt Email")){
                    TextField("Enter email",text:$email).autocapitalization(.none)
                }
                Section(header:Text("Favorite")){
                    Toggle(isOn: $isFavorite, label: {
                        Text("Mark Kontakt as favorite?")
                    })
                }
                Section(header:Text("Kontakt Location")){
                    Map(coordinateRegion: $userLocation, interactionModes: .all).frame(height:200)
                    Button("Get my Location"){
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        if let location = self.locationFetcher.lastKnownLocation {
                                            userLocation = MKCoordinateRegion(
                                                center: CLLocationCoordinate2D(
                                                    latitude: location.latitude,
                                                    longitude: location.longitude
                                                ),
                                                span: MKCoordinateSpan(
                                                    latitudeDelta: 0.01,
                                                    longitudeDelta: 0.01
                                                )
                                            )
                                        }
                        })
                    }
                    
                }
            }
        }.background(RoundedRectangle(cornerRadius: 20).fill(colorScheme == .dark ? Color.black : Color.white)).onAppear(perform: {
            locationFetcher.start()
        })
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Select an option"), buttons: [
                .default(Text("Capture an image")) { capture.toggle()
                    showingImagePicker.toggle()
                },
                .default(Text("Select from Photo Library")) {
                    showingImagePicker.toggle()
                },
                .cancel()
            ])
        }
        .sheet(isPresented: $showingImagePicker){
            if capture{
                ImagePickerView(sourceType: .camera) { image in
                withAnimation(.spring()){
                    self.kontaktImage = image
                    }
                }
            }
            else{
                ImagePickerView(sourceType: .photoLibrary) { image in
                withAnimation(.spring()){
                    self.kontaktImage = image
                    }
                }
            }
            
        }
    }
}
class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

struct NewKontaktView_Previews: PreviewProvider {
    static var previews: some View {
        NewKontaktView()
    }
}
