//
//  YemekTarifiApp.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI
import Firebase

@main
struct YemekTarifiApp: App {
    @StateObject var authVm : AuthViewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            VStack{
               ContentView()
                
            }.environmentObject(authVm)
            
        }
        
    }
    
}
