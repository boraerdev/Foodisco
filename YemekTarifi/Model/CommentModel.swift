//
//  CommentModel.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id : String?
    var comment: String
    var authorUid : String
    //var timestamp : Date
}
