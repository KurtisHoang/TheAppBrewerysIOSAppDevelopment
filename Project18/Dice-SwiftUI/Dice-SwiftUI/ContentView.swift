//
//  ContentView.swift
//  Dice-SwiftUI
//
//  Created by Kurtis Hoang on 4/15/21.
//

import SwiftUI

struct ContentView: View {
    
    //@State allows to update variable
    @State var leftDiceNum = 1
    @State var rightDiceNum = 2
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Spacer().frame(height: 50) // create space with height of 50
                Image("diceeLogo")
                Spacer() //create enough space between two items
                HStack {
                    DiceView(diceFace: leftDiceNum)
                    DiceView(diceFace: rightDiceNum)
                }
                .padding(.horizontal)
                Spacer() //create enough space between two items
                Button(action: {
                    leftDiceNum = Int.random(in: 1...6)
                    rightDiceNum = Int.random(in: 1...6)
                }, label: { //button label
                    Text("Roll")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                })
                .background(Color.red)
                Spacer().frame(height: 50) // create space with height of 50
            }
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DiceView: View {
    let diceFace: Int
    
    var body: some View {
        Image("dice\(diceFace)")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}
