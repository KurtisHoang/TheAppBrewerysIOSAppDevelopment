//
//  PostData.swift
//  H4k0rNews
//
//  Created by Kurtis Hoang on 4/15/21.
//

import Foundation

struct  Results: Decodable {
    let hits: [Post]
}

//identifiable allows to recognize the order of post object base on id
struct Post: Decodable, Identifiable {
    var id: String { //assign objectID to id
        return objectID
    }
    let objectID: String
    let title: String
    let points: Int
    let url: String?
}
