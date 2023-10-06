//
//  DataModel.swift
//  pr28FaceID
//
//  Created by Никита Попов on 5.10.23.
//

import Foundation
let key = "0VxVJ2Po57lg1t+nw6rhwQ==P9dWJ6V5IqOeI1Na"

struct BaseJoke: Codable{
    var joke: String
}

struct ResultJoke{
    var joke: String?
    
    
    init(item: BaseJoke?) {
        self.joke = item?.joke
    }
}



