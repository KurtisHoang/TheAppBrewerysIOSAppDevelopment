//
//  ContentView.swift
//  BusinessCardSwiftUI
//
//  Created by Kurtis Hoang on 4/13/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.63, blue: 0.52, opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("profile-image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150
                           , alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 5)
                    )
                Text("Kurtis Hoang")
                    .font(Font.custom("Pacifico-Regular", size: 40))
                    .bold()
                    .foregroundColor(.white)
                Text("iOS Developer")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                Divider() //create a thin line divider
                InfoView(text: "1 (888) 888-8888", imageName: "phone.fill")
                InfoView(text: "email@email.com", imageName: "envelope.fill")
                
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

