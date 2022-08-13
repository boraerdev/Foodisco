//
//  FilteredListView.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 13.08.2022.
//

import SwiftUI

struct FilteredListView: View {
    var tab: Mutfaklar
    @StateObject var vm : FilteredListViewModel
    @Environment (\.presentationMode) var presentationMode
    
    init(tab: Mutfaklar){
        self.tab = tab
        _vm = StateObject(wrappedValue: FilteredListViewModel(tab: tab))
    }
    
    var body: some View {
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
            Text(tab.rawValue).font(.headline.bold()).frame(maxWidth: .infinity, alignment: .leading).padding()
            ScrollView{
                ForEach(vm.list) { post in
                    PostRowView(post: post)
                }
            }.padding(.horizontal)
        }
    }
}

//struct FilteredListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredListView()
//    }
//}

class FilteredListViewModel: ObservableObject {
    
    @Published var list: [Post] = []
    
    init(tab: Mutfaklar?){
        DispatchQueue.main.async {
            self.filterByKitchen(kitchen: tab?.rawValue ?? "Kebap")
        }
    }
    
    func filterByKitchen(kitchen: String){
        PostServices.shared.filterByKitchen(kitchen: kitchen) { [weak self] posts in
            self?.list = posts
        }
    }
    
}
