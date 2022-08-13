//
//  LeftMenu.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI

struct LeftMenu: View {
    @EnvironmentObject var authVm : AuthViewModel
    @State var goTarifler : Bool = false
    @State var goFav: Bool = false
    var body: some View {
        NavigationView{
            ZStack{
                Color("main").ignoresSafeArea()
                VStack(alignment: .leading){
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Hoş geldin")
                            .font(.footnote)
                        Text((authVm.currentUser?.ad ?? "") + " " + (authVm.currentUser?.soyad ?? ""))
                            .font(.title2.bold())
                    }
                    .foregroundColor(.white)
                    
                    VStack{
                        ForEach(menu.allCases, id: \.self) { item in
                            Button {
                                if item == .logout {
                                    authVm.logOut()
                                }
                                if item == .tarif {
                                    goTarifler.toggle()
                                }
                                if item == .fav {
                                    goFav.toggle()
                                }
                                
                            } label: {
                                HStack{
                                    Image(systemName: item.imageTitle())
                                        .font(.title2)
                                    Text(item.rawValue)
                                        .font(.headline)
                                        .fontWeight(.light)
                                }.padding(.vertical,11)
                            }
                        }
                    }
                    .padding(.top,40)
                    .foregroundColor(.white)
                    .fullScreenCover(isPresented: $goFav) {
                        FavListView()
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            }.transition(.slide)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $goTarifler) {
                TariflerListView()
            }
        }
    }
}

struct LeftMenu_Previews: PreviewProvider {
    static var previews: some View {
        LeftMenu().environmentObject(AuthViewModel())
    }
}

enum menu: String, CaseIterable {
    case fav = "Favoriler"
    case tarif = "Tariflerim"
    case logout = "Çıkış Yap"
    
    func imageTitle() -> String{
        switch self{
        case .fav:
           return  "heart.fill"
        case .tarif:
           return  "pencil.and.outline"
        case .logout:
          return   "delete.left.fill"
        }
    }
    
}
