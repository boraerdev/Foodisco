//
//  AddViewModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation
import UIKit
import Firebase

class AddViewModel: ObservableObject {
    
    @Published var anError : Bool = false
    
    init(){
        
    }
    
    func addPost(ad: String, aciklama: String, malzeme: String, tarif: String, foto: UIImage?, mutfaklar: [Mutfaklar] ){
        if let image = foto{
            
            var mutfakName : [String] = []
            for i in mutfaklar {
                mutfakName.append(i.rawValue)
            }
            
            ImageServices.shared.uploadImage(image: image) { url in
                let data = ["ad": ad, "aciklama": aciklama, "malzeme": malzeme, "tarif":tarif, "imageUrl": url, "mutfaklar": mutfakName, "authorUid": Auth.auth().currentUser?.uid ?? "", "timeStamp": Date() ] as [String : Any]
                Firestore.firestore().collection("posts").document(UUID().uuidString).setData(data) { error in
                    guard error == nil else {
                        self.anError.toggle()
                        return}
                }
            }
        }
    }
    
}
