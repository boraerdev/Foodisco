//
//  PostModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Post:Codable, Identifiable {
    @DocumentID var id : String?
    var ad: String
    var aciklama: String
    var malzeme: String
    var tarif: String
    var imageUrl: String
    var mutfaklar: [String]
    var authorUid: String
    var timeStamp: Date
}
