//
//  ContentView.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var authVm : AuthViewModel
    @StateObject var homeVm = HomeViewModel()
    var body: some View {
        VStack{
            if Auth.auth().currentUser != nil {
                ZStack(alignment: .topLeading){
                    Home()
                        .environmentObject(homeVm)
                        .environmentObject(authVm)
                    if homeVm.showMenu == true {
                        ZStack(alignment: .topLeading){
                            Color.black.opacity(0.7).ignoresSafeArea()
                                .onTapGesture {
                                        homeVm.showMenu.toggle()
                                    
                                }
                            LeftMenu()
                                .frame(maxWidth: UIScreen.main.bounds.width / 1.3)

                        }
                    }
                }
            } else {
                LoginPage()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
