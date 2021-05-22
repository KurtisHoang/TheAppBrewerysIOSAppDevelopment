//
//  ContentView.swift
//  H4k0rNews
//
//  Created by Kurtis Hoang on 4/15/21.
//

import SwiftUI

struct ContentView: View {
    
    //subscribed to networkManager when it updates
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView{ //navigation
            //tableview
            List(networkManager.posts) { post in //for post in posts
                NavigationLink(destination: DetailView(url: post.url!)) { //each post moves to DetailView passing the url
                    HStack {
                        Text(String(post.points))
                        Text(post.title)
                    }
                }
            }
            .navigationTitle("H4K0R News") //nav title
        }
        .onAppear(perform: {
            self.networkManager.fetchData() //fetch api data
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
