//
//  PostServices.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation
import Firebase

struct PostServices{
    
    static var shared = PostServices()
    
    func getAllPost(sort: Bool, completion: @escaping ([Post]) -> Void){
        Firestore.firestore().collection("posts").order(by: "timeStamp", descending: sort).getDocuments { querySnapshts, _ in
            guard let documents = querySnapshts?.documents else {return}
            
            var posts: [Post] = []
            for doc in documents{
                guard let post = try? doc.data(as: Post.self) else {return}
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    func getHeaderPost( completion: @escaping ([Post]) -> Void){
        Firestore.firestore().collection("posts").order(by: "timeStamp").limit(to: 5).getDocuments { querySnapshts, _ in
            guard let documents = querySnapshts?.documents else {return}
            
            var posts: [Post] = []
            for doc in documents{
                guard let post = try? doc.data(as: Post.self) else {return}
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    func filterByKitchen(kitchen: String, completion: @escaping ([Post]) -> Void){
        Firestore.firestore().collection("posts").whereField("mutfaklar", arrayContains:"\(kitchen)").getDocuments { querySnapshts, _ in
            guard let documents = querySnapshts?.documents else {return}
            
            var posts: [Post] = []
            for doc in documents{
                guard let post = try? doc.data(as: Post.self) else {return}
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    func tariflerList(completion: @escaping ([Post]) -> Void){
        guard let user = Auth.auth().currentUser else {return}
        Firestore.firestore().collection("posts").whereField("authorUid", in:["\(user.uid)"]).getDocuments { querySnapshts, _ in
            guard let documents = querySnapshts?.documents else {return}
            
            var posts: [Post] = []
            for doc in documents{
                guard let post = try? doc.data(as: Post.self) else {return}
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    func addFavList(post: Post) {
        guard let user = Auth.auth().currentUser else {return}
        Firestore.firestore().collection("users").document(user.uid).collection("favList").document(post.id ?? "gelmedi")
            .setData([:]) { error in
                
            }
    }
    
    
    func delFavList(post: Post) {
        guard let user = Auth.auth().currentUser else {return}
        Firestore.firestore().collection("users").document(user.uid).collection("favList").document(post.id ?? "gelmedi")
            .delete()
    }
    
    func getFavList(completion: @escaping ([Post]) -> Void){
        guard let user = Auth.auth().currentUser else {
            print("user alınamadı")
            return}
        Firestore.firestore().collection("users").document(user.uid).collection("favList").getDocuments {
            querySnapshots, error in
            guard error == nil else {
                print("fetfav firestore error ")
                return
            }
            guard let snapshot = querySnapshots else {
                print("docs alınamadı")
                return}
            let documents = snapshot.documents
            
            var favlist = [Post]()
            for doc in documents{
                do {
                    try  getPostById(uid: doc.documentID) { geldi in
                        favlist.append(geldi)
                   }

                } catch let hata {
                    print(hata)
                }

            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion(favlist)
            }
        }
    }
    
    func getPostById(uid: String, completion: @escaping (Post) -> Void) throws {
        Firestore.firestore().collection("posts").document(uid).getDocument { snapshot, error in
            guard let user = try? snapshot?.data(as: Post.self) else {
                print("user olmadı")
                return}
            completion(user)
        }
    }
    
}
