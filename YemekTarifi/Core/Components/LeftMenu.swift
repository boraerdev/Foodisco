//
//  LeftMenu.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI

struct LeftMenu: View {
    @EnvironmentObject var authVm : AuthViewModel
    var body: some View {
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
                        HStack{
                            Image(systemName: item.imageTitle())
                                .font(.title2)
                            Text(item.rawValue)
                                .font(.headline)
                                .fontWeight(.light)
                        }.padding(.vertical,11)
                            .onTapGesture {
                                if item == .logout {
                                    authVm.logOut()
                                }
                            }
                    }
                }.padding(.top,40)
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

        }.transition(.slide)
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
