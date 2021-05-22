//
//  InfoView.swift
//  BusinessCardSwiftUI
//
//  Created by Kurtis Hoang on 4/13/21.
//

import SwiftUI

struct InfoView: View {
    
    let text: String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            //                    .foregroundColor(.white) option 2
            .frame(height: 50)
            .overlay(
                HStack {
                    Image(systemName: imageName)
                    .foregroundColor(.green)
                    Text(text).foregroundColor(.black)
                }
            )
            .padding(.all)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "+1 (888) 888-8888", imageName: "phone.fill")
            .previewLayout(.sizeThatFits)
    }
}
