//
//  ContentView.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/23/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @State private var createToggle = false
    @State private var searchText = ""
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Allkontakts.name, ascending: true)]) private var kontakts : FetchedResults<Allkontakts>
    private func saveContext(){
        do{
            try viewContext.save()
        } catch{
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    var favoriteView : some View{
        ScrollView(showsIndicators: false){
            VStack(spacing:10){
                ForEach(kontakts){kontakt in
                    if kontakt.isFavorite{
                        NavigationLink(destination: SeeKontaktView(kontakt: kontakt).environment(\.managedObjectContext, viewContext)){
                            HStack(){
                                if kontakt.image != nil{
                                    Image(uiImage: UIImage(data: kontakt.image!)!)
                                        .resizable()
                                        .frame(width:80, height: 80)
                                        .clipShape(Circle())
                                        
                                }
                                else{
                                    Circle().fill(Color.purple).frame(width: 60,height: 60)
                                }
                                VStack(alignment:.leading,spacing: 10){
                                    HStack{
                                        Image(systemName: "person.circle.fill")
                                        Text(kontakt.name ?? "Untitled")
                                    }
                                    HStack{
                                        Image(systemName: "phone.circle.fill")
                                        Text("+"+kontakt.countryCode!+" "+String(kontakt.number))
                                    }
                                    HStack{
                                        Image(systemName: "envelope.circle.fill")
                                        Text(kontakt.email!)
                                    }
                                }.font(.callout).padding()
                                Spacer()
                            }.padding().foregroundColor(colorScheme == .dark ? .black : .white).frame(width:UIScreen.main.bounds.width-30,height:UIScreen.main.bounds.height/6).background(RoundedRectangle(cornerRadius: 20,style:.continuous).fill(Color.purple))
                        }
                    }
                }
            }.padding(.horizontal).navigationBarHidden(true)
        }
    }
    var myKontakts: some View{
        VStack(alignment:.leading){
            TextField("Search kontakts", text:$searchText).autocapitalization(.none).padding(.horizontal).textFieldStyle(RoundedBorderTextFieldStyle())
            Text("My Kontakts").font(.title2).padding(.horizontal)
                
               List{
                    ForEach(kontakts){kontakt in
                        if kontakt.name!.lowercased().hasPrefix(searchText.lowercased()) {
                            NavigationLink(destination: SeeKontaktView(kontakt: kontakt).environment(\.managedObjectContext, viewContext)){
                                HStack{
                                    if kontakt.image != nil{
                                        Image(uiImage: UIImage(data: kontakt.image!)!)
                                            .resizable()
                                            .frame(width: 30,height: 30)
                                            .clipShape(Circle())
                                    }
                                    else{
                                        Circle().fill(Color.purple).frame(width: 30, height: 30)
                                    }
                                    VStack(alignment: .leading, spacing: 2){
                                        Text(kontakt.name ?? "Untitled").font(.subheadline)
                                        Text("+"+kontakt.countryCode!+String(kontakt.number)).font(.caption)
                                    }
                                    Spacer()
                                }.padding()
                            }
                            
                        
                        }
                    }.onDelete(perform:deleteKontakt)
                }.ignoresSafeArea().navigationBarHidden(true)
        }
    }
    var body: some View {
        NavigationView{
            VStack(alignment:.leading){
                VStack(){
                    HStack{
                        Text("Kontakts").font(.title2).foregroundColor(.purple).fontWeight(.bold)
                    Spacer()
                        Button(action:{
                                createToggle.toggle()
                            }){
                            Image(systemName: "plus").font(.system(size: 18, weight: .bold)).foregroundColor(colorScheme == .dark ? Color.black : Color.white).padding().background(Circle().fill(Color.purple))
                            .shadow(color: Color.black.opacity(0.3), radius: 14, x: 0, y: 7)
                        }
                    }.padding()
                }
                TabView{
                    myKontakts.tabItem { Label("All kontakts", systemImage:"person.crop.circle") }
                    favoriteView.tabItem { Label("Favorites",systemImage:"heart" )}
                }.accentColor(.purple)
                    
                Spacer()
            }.sheet(isPresented: $createToggle){
                NewKontaktView().environment(\.managedObjectContext, viewContext)
            }
        }
    }
    private func deleteKontakt(offsets: IndexSet){
        withAnimation(){
            offsets.map{ kontakts[$0] }.forEach(viewContext.delete)
            saveContext()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
