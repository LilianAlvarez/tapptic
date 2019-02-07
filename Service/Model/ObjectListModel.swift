//
//  ObjectModel.swift
//  Tapptic
//
//  Created by Lilian on 23/01/2019.
//  Copyright © 2019 Lilian. All rights reserved.
//


import Foundation

// MARK : We will define here the object list retrieve with the listUrl API.

struct ObjectModel: Codable {
    enum CodingKeys: String, CodingKey {
        case name  = "name"
        case image = "image"
        case text  = "text"
    }
    let name: String?
    let image: String?
    let text: String?
}
