//
//  PostRowView.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import SwiftUI
import Kingfisher

struct PostRowView: View {
    var post: Post
    @StateObject var vm : rowViewModel
    init(post: Post){
        self.post = post
        _vm = StateObject(wrappedValue: rowViewModel(userUid: post.authorUid))
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
            HStack(spacing: 15){
                KFImage(URL(string: post.imageUrl)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 78, height: 78)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .padding(.leading,20)
                
                VStack(alignment: .leading, spacing: 8){
                    Text(post.ad)
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.primary)
                    Text(post.aciklama)
                        .lineLimit(2)
                        .padding(.trailing,16)
                        .font(.caption2)
                        .foregroundColor(Color("secondary"))
                    HStack(spacing:3){
                        HStack(spacing: 0){
                            ForEach(0..<5) { i in
                                Image(systemName: "star.fill").font(.footnote)
                                    .foregroundColor(Color("star"))
                            }
                        }
                        HStack(alignment: .center, spacing: 2){
                            Text("\(vm.user?.ad ?? "") \(vm.user?.soyad ?? "")")
                            Text("·")
                            Text("\(post.timeStamp.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: Date.FormatStyle.TimeStyle.omitted))")
                        }
                        .font(.caption2)
                        .foregroundColor(.primary)

                    }

                }
                .padding(.trailing)
                
                
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height: 115)
        
    }
}

class rowViewModel: ObservableObject {
    
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
