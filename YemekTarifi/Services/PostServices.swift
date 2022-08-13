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
        Firestore.firestore().collection("posts").whereField("mutfaklar", in: ["\(kitchen)"]).getDocuments { querySnapshts, _ in
            guard let documents = querySnapshts?.documents else {return}
            
            var posts: [Post] = []
            for doc in documents{
                guard let post = try? doc.data(as: Post.self) else {return}
                posts.append(post)
            }
            completion(posts)
            print(posts)
        }
    }
    
}
