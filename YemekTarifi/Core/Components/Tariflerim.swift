//
//  FilteredListView.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import SwiftUI

struct TariflerListView: View {
    @StateObject var vm : TariflerListViewModel
    @Environment (\.presentationMode) var presentationMode
    
    init(){
        
        _vm = StateObject(wrappedValue: TariflerListViewModel())
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("bg").ignoresSafeArea()
                VStack(spacing:0){
                    HStack{
                        Image(systemName: "chevron.left")
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 31, height: 31)
                            .background(Color("main"), in: Circle())
                        Spacer()
                    }
                    .padding()
                    Text("Tariflerim").font(.headline.bold()).frame(maxWidth: .infinity, alignment: .leading).padding()
                    ScrollView{
                        ForEach(vm.list) { post in
                            NavigationLink {
                                Detail(post: post).navigationBarHidden(true)
                            } label: {
                                PostRowView(post: post)
                            }.padding([.horizontal, .bottom])

                        }
                    }
                }.navigationBarHidden(true)


            }
        }

            
        
    }
}

class TariflerListViewModel: ObservableObject {
    
    @Published var list: [Post] = []
    
    init(){
        DispatchQueue.main.async {
            self.getFavList()
        }
    }
    
    func getFavList() {
        PostServices.shared.tariflerList { posts in
            self.list = posts
        }
    }
    
    
}
