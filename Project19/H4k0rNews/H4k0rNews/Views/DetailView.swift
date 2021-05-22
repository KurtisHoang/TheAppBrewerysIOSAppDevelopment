//
//  DetailView.swift
//  H4k0rNews
//
//  Created by Kurtis Hoang on 4/15/21.
//

import SwiftUI

struct DetailView: View {
    
    let url: String
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://google.com") //test url with google.com
    }
}
