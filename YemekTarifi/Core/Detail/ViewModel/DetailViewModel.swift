//
//  DetailViewModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation
import Firebase

class DetailViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var favlist: [Post] = []
    @Published var post: Post
    @Published var comments: [Comment] = []
    
    init(post: Post, userUid: String){
        self.post = post
        DispatchQueue.main.async {
            self.updateFavList()
            self.getUser(uid: userUid)
            self.getComments()
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
    
    
    func addComment(post: Post, comment: String){
        let data = ["comment": comment, "authorUid": Auth.auth().currentUser?.uid] as [String: Any]
        Firestore.firestore().collection("posts").document(post.id ?? "").collection("comments").document(UUID().uuidString)
            .setData(data) { error in
                
            }
    }
    
    func getComments(){
        Firestore.firestore().collection("posts").document(post.id ?? "").collection("comments").addSnapshotListener { querySnapshot, error in
            guard let docs = querySnapshot?.documents else {return}
            var commentsin : [Comment] = []
            for doc in docs {
                guard let comment = try? doc.data(as: Comment.self) else {return}
                commentsin.append(comment)
            }
            self.comments = commentsin
            //self.comments.sort(by: {$0.timestamp > $1.timestamp})
        }
    }
    
    
}
