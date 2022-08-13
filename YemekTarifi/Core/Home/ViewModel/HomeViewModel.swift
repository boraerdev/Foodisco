//
//  HomeViewModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import Foundation
import UIKit
import Firebase

class HomeViewModel: ObservableObject {
    
    @Published var showMenu : Bool = false
    @Published var allPosts: [Post] = []
    @Published var headerPosts: [Post] = []
    @Published var filtered: [Post] = []
    @Published var sort: Bool = true {
        didSet{
            getAllPosts()
        }
    }
    init(){
        DispatchQueue.main.async {
            self.getAllPosts()
            self.getHeaderPost()

        }
    }
    
    func getAllPosts(){
        PostServices.shared.getAllPost(sort: sort) { [weak self] posts in
            self?.allPosts = posts
        }
    }
    
    func getHeaderPost(){
        PostServices.shared.getHeaderPost { [weak self] posts in
            self?.headerPosts = posts
        }
    }
    
    
    
}
