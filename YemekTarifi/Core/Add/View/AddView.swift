//
//  AddView.swift
//  YemekTarifi
//
//  Created by Bora Erdem on 12.08.2022.
//

import SwiftUI

struct AddView: View {
    @State var name: String = ""
    @State var tarif: String = ""
    @State var aciklama: String = ""
    @State var malzemeler: String = ""
    @State var mutfakSecim : [Mutfaklar] = []
    
    @State private var image: UIImage? = UIImage()
    @State private var showSheet = false
    
    @StateObject var addVm = AddViewModel()


    @Environment (\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Form{
                HStack{
                    Text("Tarif Ekle")
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(Color("main"))
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                Section("Yemek Bilgileri"){
                    TextField("Açıklama", text: $aciklama)
                    TextField("Yemek Adı", text: $name)
                    ZStack(alignment: .leading){
                        if malzemeler == "" {
                            Text("Malzemeler").foregroundColor(.secondary.opacity(0.5))
                        }
                        TextEditor(text: $malzemeler)
                        
                    }
                    ZStack(alignment: .leading){
                        if tarif == "" {
                            Text("Tarif").foregroundColor(.secondary.opacity(0.5))
                        }
                        TextEditor(text: $tarif)
                        
                    }
                }
                
                Section("Mutfak"){
                    HStack{
                        ForEach(Mutfaklar.allCases, id: \.self) { mutfak in
                            Text(mutfak.rawValue)
                                .foregroundColor(.white)
                                .padding(.horizontal,5)
                                .padding(.vertical,2)
                                .background(
                                    
                                    (mutfakSecim.first(where: {$0 == mutfak}) != nil) ?
                                    Color("main") : Color("main").opacity(0.5)
                                    
                                    , in: RoundedRectangle(cornerRadius: 4))
                                .onTapGesture {
                                    addMutfak(geelnMutfak: mutfak)
                                }
                            
                        }
                    }
                }
                
                Section("Fotoğraf"){
                    VStack{
                        if self.image == UIImage() {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.blue)
                                
                        }else {
                            if let image = image {
                                Image(uiImage: self.image!)
                                    .resizable()
                                    .scaledToFit()
                            }
                            
                        }
                    }.onTapGesture {
                        showSheet = true
                    }

                }
                
                Section{
                    Button {
                        if let image = image {
                            paylas(ad: name, tarif: tarif, aciklama: aciklama, malzemeler: malzemeler, mutfaklar: mutfakSecim, image: image)
                            if !addVm.anError{
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text("Paylaş")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(image == UIImage())
                    

                }
            }
        }
        .accentColor(Color("main"))
        .sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

extension AddView {
    
    func addMutfak(geelnMutfak: Mutfaklar){
        if mutfakSecim.firstIndex(where: {$0 == geelnMutfak}) == nil {
            mutfakSecim.append(geelnMutfak)
        }else {
            if let i = mutfakSecim.firstIndex(where: {$0 == geelnMutfak}) {
                let index = i
                mutfakSecim.remove(at: index)
                    
            }
        }
    }
    
    func paylas(ad: String, tarif: String, aciklama: String, malzemeler: String, mutfaklar: [Mutfaklar], image: UIImage){
        addVm.addPost(ad: ad, aciklama: aciklama, malzeme: malzemeler, tarif: tarif, foto: image, mutfaklar: mutfaklar)
    }
    
}
