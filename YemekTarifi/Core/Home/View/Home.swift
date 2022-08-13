//
//  Home.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI
import Kingfisher

struct Home: View {
    @EnvironmentObject var vm: HomeViewModel
    @EnvironmentObject var authVm : AuthViewModel
    @Environment (\.colorScheme) var colorScheme
    @State var showAdd: Bool = false
    var body: some View {
        NavigationView{
            ZStack{
                Color("bg").ignoresSafeArea()
                
                VStack(spacing: 0){
                    header
                    search
                    .padding()
                    Divider()
                    ScrollView {
                        if vm.searched == "" {
                            VStack{
                                onerilenlerHeader
                                mutfaklarHeader
                                tariflerHeader
                                .padding()
                            }
                        } else {
                            searchedHeader.padding()
                        }
                    }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.bottom)
                .sheet(isPresented: $showAdd) {
                    AddView()
                }
                   
            }.navigationBarHidden(true)
        }
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//            .environmentObject(HomeViewModel())
//            .environmentObject(AuthViewModel())
//    }
//}

extension Home {
    
    private var header: some View {
        HStack{
            Image(systemName: "list.dash")
                .onTapGesture {
                    vm.showMenu.toggle()
                    
                }
            VStack(alignment: .leading){
                Text("Hoş Geldin").font(.caption2)
                Text((authVm.currentUser?.ad ?? "") + " " + (authVm.currentUser?.soyad ?? "")).font(.footnote.bold())
            }.padding(.leading,16)
            Spacer()
            HStack{
                Image(systemName: "plus.square.fill")
                    .onTapGesture {
                        showAdd.toggle()
                    }
                
                NavigationLink {
                    FavListView().navigationBarHidden(true)
                } label: {
                    Image(systemName: "heart.fill")
                }

            }.foregroundColor(Color("main"))
        }.font(.title2).padding([.horizontal,.top])
    }
    
    private var search: some View {
        HStack {
            TextField("Yemek veya tarif arayın...", text: $vm.searched)
                .padding(.leading)
                .frame(maxHeight: 35)
                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
            Spacer()
            Image(systemName: "magnifyingglass").font(.title2)
        }
    }
    
    private var onerilenlerHeader: some View {
        VStack{
            Text("Önerilenler").frame(maxWidth : .infinity, alignment: .leading)
                .font(.headline.bold())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:16){
                    ForEach(vm.headerPosts) { post in
                        NavigationLink {
                            Detail(post: post).navigationBarHidden(true)
                        } label: {
                            KFImage(URL(string: post.imageUrl)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 343, height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        
                    }
                }
            }
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
        }.padding([.leading,.top])
    }
    
    private var mutfaklarHeader: some View {
        VStack{
            Text("Mutfaklar").frame(maxWidth : .infinity, alignment: .leading)
                .font(.headline.bold())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:16){
                    ForEach(Mutfaklar.allCases, id: \.self) { mutfak in
                        NavigationLink {
                            FilteredListView(tab: mutfak).navigationBarHidden(true)
                        } label: {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.background)
                                .frame(width: 78, height: 78)
                                .overlay(Image(mutfak.getImage()))
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
                        }

                    }

                }
                
            }
        }.padding([.top,.leading])
    }
    
    private var tariflerHeader: some View {
        VStack{
            HStack{
                Text("Tarifler").frame(maxWidth : .infinity, alignment: .leading)
                    .font(.headline.bold())
                Spacer()
                Image(systemName: "arrow.up.arrow.down")
                    .onTapGesture {
                        vm.sort.toggle()
                    }
                    .font(.headline)
                    .foregroundColor(Color("main"))
            }
            ForEach(vm.allPosts) { post in
                NavigationLink {
                    Detail(post: post).navigationBarHidden(true)
                } label: {
                    PostRowView(post: post)
                }

            }
        }
    }
    
    private var searchedHeader: some View {
        VStack{
            HStack{
                Text("Sonuçlar").frame(maxWidth : .infinity, alignment: .leading)
                    .font(.headline.bold())
                Spacer()
                Image(systemName: "arrow.up.arrow.down")
                    .onTapGesture {
                        vm.sort.toggle()
                    }
                    .font(.headline)
                    .foregroundColor(Color("main"))
            }
            ForEach(vm.searchedList) { post in
                NavigationLink {
                    Detail(post: post).navigationBarHidden(true)
                } label: {
                    PostRowView(post: post)
                }

            }
        }
    }
    
}

enum Mutfaklar: String, CaseIterable {
    case burger = "Burger"
    case kebaap = "Kebap"
    case pizza = "Pizza"
    case borek = "Börek"
    
    func getImage() -> String {
        switch self {
        case .burger:
            return "burger"
        case .kebaap:
            return "kebap"
        case .pizza:
            return "pizza"
        case .borek:
            return "borek"
        }
    }
}
