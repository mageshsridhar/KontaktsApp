//
//  SeeKontaktView.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/26/21.
//

import SwiftUI
import MapKit

struct SeeKontaktView: View {
    @State private var editToggle = false
    var kontakt : FetchedResults<Allkontakts>.Element
    @Environment(\.managedObjectContext) private var viewContext
    @State var locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1, longitude: 1), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var phoneNumber : some View{
        HStack{
            Image(systemName: "phone.fill").font(.title).foregroundColor(.purple).padding(.horizontal)
            VStack(alignment:.leading,spacing: 2){
                Text("Mobile Number").font(.caption)
                Link("+"+kontakt.countryCode!+" "+String(kontakt.number),destination: URL(string: "tel:\(kontakt.number)")!)
            }
        }.padding()
    }
    var ageRow : some View{
        HStack{
            Image(systemName: "person.fill").font(.title).foregroundColor(.purple).padding(.horizontal)
            VStack(alignment:.leading,spacing: 2){
                Text("Age").font(.caption)
                Text(String(kontakt.age)).font(.headline)
            }
        }.padding()
    }
    var emailAddress : some View{
        HStack{
            Image(systemName: "envelope.fill").font(.title).foregroundColor(.purple).padding(.horizontal)
            VStack(alignment:.leading,spacing: 2){
                Text("Email Address").font(.caption)
                Link(kontakt.email!,destination: URL(string: "mailto:\(kontakt.email!)")!)
            }
        }.padding()
    }
    var location : some View{
        HStack(alignment: .top){
            Image(systemName: "location.fill").font(.title).foregroundColor(.purple).padding(.horizontal)
            VStack(alignment:.leading,spacing: 5){
                Text("Location").font(.caption)
                Map(coordinateRegion: $locationRegion).frame(height:200).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
        }.padding()
    }
    var body: some View {
        ScrollView(){
            VStack(alignment:.leading){
                if kontakt.image != nil{
                    Image(uiImage: UIImage(data: kontakt.image!)!)
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width, height: 120)
                        .clipShape(Circle())
                }
                else{
                    Circle().fill(Color.purple).frame(height: 120)
                }
            
            Text(kontakt.name!).font(.title).padding().frame(maxWidth:.infinity)
            phoneNumber
            Divider()
            ageRow
            Divider()
            emailAddress
            Divider()
            location
        }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarItems(trailing: Button("Edit"){
            editToggle.toggle()
            
        })
        .onAppear(perform: {
            locationRegion.center.latitude = kontakt.latitude
            locationRegion.center.longitude = kontakt.longitude
        }
        ).sheet(isPresented: $editToggle){
            EditKontaktView(kontakt: self.kontakt).environment(\.managedObjectContext, viewContext)
        }
    }
}
