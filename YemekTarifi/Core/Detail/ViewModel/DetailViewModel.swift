//
//  DetailViewModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var favlist: [Post] = []
    
    init(userUid: String){
        DispatchQueue.main.async {
            self.updateFavList()
            self.getUser(uid: userUid)
        }
    }
    
    func getUser(uid: String){
        UserServces.shared.getUser(uid: uid) { returned in
            self.user = returned
        }
    }
    
    
    func addFavList(post: Post){
        if favlist.firstIndex(where: {$0.id == post.id }) == nil {
            PostServices.shared.addFavList(post: post)
            updateFavList()
        }
        else {
            PostServices.shared.delFavList(post: post)
            updateFavList()

        }
    }
    
    
    func updateFavList(){
            PostServices.shared.getFavList { [weak self] post in
                    self?.favlist = post
            }
    }
    
    
}
