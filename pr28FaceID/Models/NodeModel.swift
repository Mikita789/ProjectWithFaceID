//
//  NodeModel.swift
//  pr28FaceID
//
//  Created by Никита Попов on 29.09.23.
//

import Foundation



class NodeModel{
    var title:String
    var date: Date
    var trueBody: String
    var falseBody: String
    var isPrivate:Bool = false
    
    init(title: String, date: Date, trueBody:String, falseBody:String) {
        self.title = title
        self.date = date
        self.trueBody = trueBody
        self.falseBody = falseBody
    }
    
    var dateString:String{
        let currendDate = self.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY time: HH:mm"
        
        return dateFormatter.string(from: currendDate)
    }
}
