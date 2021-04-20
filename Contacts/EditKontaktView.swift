//
//  EditKontaktView.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/26/21.
//
import SwiftUI
import MapKit
struct EditKontaktView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    let locationFetcher = LocationFetcher()
    var kontakt : FetchedResults<Allkontakts>.Element
    @State private var userLocation : MKCoordinateRegion = MKCoordinateRegion(center:CLLocationCoordinate2D(),span:MKCoordinateSpan())
    @State var name : String = ""
    @State var number : String = ""
    @State var age : String = ""
    @State private var email : String = ""
    @State private var isFavorite : Bool = false
    @State private var locationManager = CLLocationManager()
    @State private var showingAlert = false
    @State private var showError = false
    @State private var countryCode : String = "1"
    @State private var image: Data? = nil
    @State private var kontaktImage : UIImage?
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var capture = false
    @State private var errorMessage = ""
    init(kontakt: FetchedResults<Allkontakts>.Element){
        self.kontakt = kontakt
        self._name = State(wrappedValue: self.kontakt.name!)
        self._number = State(wrappedValue: String(self.kontakt.number))
        self._age = State(wrappedValue: String(self.kontakt.age))
        self._email = State(wrappedValue: self.kontakt.email!)
        self._countryCode = State(wrappedValue: self.kontakt.countryCode!)
        self._image = State(wrappedValue: self.kontakt.image)
        self._kontaktImage = State(wrappedValue: UIImage(data: self.image ?? .init(count:0)))
    }
    let countryCodes = ["886", "93", "355", "213", "1-684", "376", "244", "1-264", "672", "1-268", "54", "374", "297", "61", "43", "994", "1-242", "973", "880", "1-246", "375", "32", "501", "229", "1-441", "975", "591", "599", "387", "267", "47", "55", "246", "1-284", "673", "359", "226", "257", "238", "855", "237", "1", "1-345", "236", "235", "56", "86", "852", "853", "61", "61", "57", "269", "242", "682", "506", "385", "53", "599", "357", "420", "225", "850", "243", "45", "253", "1-767", "1-809,1-829,1-849", "593", "20", "503", "240", "291", "372", "268", "251", "500", "298", "679", "358", "33", "594", "689", "262", "241", "220", "995", "49", "233", "350", "30", "299", "1-473", "590", "1-671", "502", "44", "224", "245", "592", "509", "672", "39-06", "504", "36", "354", "91", "62", "98", "964", "353", "44", "972", "39", "1-876", "81", "44", "962", "7", "254", "686", "965", "996", "856", "371", "961", "266", "231", "218", "423", "370", "352", "261", "265", "60", "960", "223", "356", "692", "596", "222", "230", "262", "52", "691", "377", "976", "382", "1-664", "212", "258", "95", "264", "674", "977", "31", "687", "64", "505", "227", "234", "683", "672", "1-670", "47", "968", "92", "680", "507", "675", "595", "51", "63", "870", "48", "351", "1", "974", "82", "373", "40", "7", "250", "262", "590", "290", "1-869", "1-758", "590", "508", "1-784", "685", "378", "239", "966", "221", "381", "248", "232", "65", "1-721", "421", "386", "677", "252", "27", "500", "211", "34", "94", "970", "249", "597", "47", "46", "41", "963", "992", "66", "389", "670", "228", "690", "676", "1-868", "216", "90", "993", "1-649", "688", "256", "380", "971", "44", "255", "1-340", "1", "598", "998", "678", "58", "84", "681", "212", "967", "260", "263", "358"]
    private func saveContext(){
        do{
            try viewContext.save()
        } catch{
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    func updateKontakt(){
        withAnimation(){
            self.kontakt.uid = UUID()
            self.kontakt.name = name
            self.kontakt.number = Int64(number) ?? 0
            self.kontakt.age = Int16(age) ?? 0
            self.kontakt.isFavorite = isFavorite
            self.kontakt.email = email
            self.kontakt.latitude = userLocation.center.latitude
            self.kontakt.longitude = userLocation.center.longitude
            self.kontakt.image = kontaktImage?.jpegData(compressionQuality: 0)
            self.kontakt.countryCode = countryCode
        saveContext()
        }
    }
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    var body: some View {
        VStack{
            VStack{
            HStack{
                Button("Cancel"){
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Done"){
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
                        updateKontakt()
                        presentationMode.wrappedValue.dismiss()
                    }
                }.alert(isPresented: $showError){
                    Alert(title: Text("Kontakt cannot be created"), message: Text(errorMessage), dismissButton: .default(Text("Close")))
                }
            }.padding()
                if self.kontaktImage != nil{
                    Button(action:{self.showingActionSheet.toggle()}){
                        Image(uiImage: self.kontaktImage!)
                            .resizable()
                            .frame(width: 100,height: 100)
                            .clipShape(Circle())
                            .padding()
                    }
                }
                else{
                    Button(action:{self.showingImagePicker.toggle()}){
                        Circle().fill(Color.purple).frame(width: 100, height:100)
                            .padding()
                    }
                }
            }
            Form{
                Section(header:Text("Kontakt Name")){
                    TextField("Enter name",text:self.$name)
                }
                Section(header:Text("Kontakt Number")){
                    HStack{
                        Picker("+\(self.countryCode)", selection: self.$countryCode) {
                            ForEach(self.countryCodes, id: \.self) {
                                            Text("+\($0)")
                                        }
                                    }.pickerStyle(MenuPickerStyle())
                        TextField("Enter number",text:self.$number).keyboardType(.numberPad)
                    }
                }
                Section(header:Text("Kontakt Age")){
                    TextField("Enter age",text:self.$age).keyboardType(.numberPad)
                }
                Section(header:Text("Kontakt Email")){
                    TextField("Enter email",text:self.$email).autocapitalization(.none)
                }
                Section(header:Text("Favorite")){
                    Toggle(isOn: self.$isFavorite, label: {
                        Text("Mark Kontakt as favorite?")
                    })
                }
                Section(header:Text("Kontakt Location")){
                    Map(coordinateRegion: self.$userLocation, interactionModes: .all).frame(height:200)
                    Button("Get my Location"){
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        if let location = self.locationFetcher.lastKnownLocation {
                            self.userLocation = MKCoordinateRegion(
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
        }).actionSheet(isPresented: $showingActionSheet) {
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
