//
//  DetailViewModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    @Published var user: User?
    
    init(userUid: String){
        DispatchQueue.main.async {
            self.getUser(uid: userUid)
        }
    }
    
    func getUser(uid: String){
        UserServces.shared.getUser(uid: uid) { returned in
            self.user = returned
        }
    }
    
}
