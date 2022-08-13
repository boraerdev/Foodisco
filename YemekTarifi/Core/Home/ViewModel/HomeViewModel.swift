//
//  HomeViewModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import Foundation
import UIKit
import Firebase
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var showMenu : Bool = false
    @Published var allPosts: [Post] = []
    @Published var headerPosts: [Post] = []
    var cancellable = Set<AnyCancellable>()
    @Published var filtered: [Post] = []
    @Published var searchedList : [Post] = []
    @Published var searched : String = "" {
        didSet{
            search()
        }
    }
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
    
    func search() {
        $searched
            .combineLatest($allPosts)
            .map{ aranan, tumliste -> [Post] in
                if aranan == "" {
                    return tumliste
                } else {
                    var lower = aranan.lowercased()
                    var filtered = tumliste.filter { post in
                        return post.ad.lowercased().contains(lower)
                    }
                    return filtered
                }
            }
            .sink { [weak self] returned in
                self?.searchedList = returned
            }
            .store(in: &cancellable)
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
