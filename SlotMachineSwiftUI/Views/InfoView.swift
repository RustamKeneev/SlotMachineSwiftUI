//
//  InfoView.swift
//  SlotMachineSwiftUI
//
//  Created by Rustam Keneev on 22/3/24.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            LogoView()
            Spacer()
            Form{
                Section(header: Text("About the application")){
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "IPhone, IPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Rustam Keneev")
                    FormRowView(firstItem: "Designer", secondItem: "Rustam Keneev")
                    FormRowView(firstItem: "Music", secondItem: "Mozart")
                    FormRowView(firstItem: "GitHub", secondItem: "RustamKeneev")
                    FormRowView(firstItem: "Copyright", secondItem: "2024 all right reseerved.")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0.")
                }
            }
            .font(.system(.body, design: .rounded))
        }//: VSTACK
        .padding(.top, 40)
        .overlay(
            Button(action: {
                //Action
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark.circle")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
                .padding(.top, 30)
                .padding(.trailing, 20)
                .accentColor(Color.secondary)
            , alignment: .topTrailing)
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String

    var body: some View {
        HStack{
            Text(firstItem)
                .foregroundColor(Color.gray)
            Spacer()
            Text(secondItem)
        }//: HSTACK
    }
}

#Preview {
    InfoView()
}

