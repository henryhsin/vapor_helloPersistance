//
//  TILController.swift
//  helloPersistance
//
//  Created by 辛忠翰 on 2017/4/15.
//
//

import Foundation
import Vapor
import HTTP

final class TILController{
    func addRoutes(drop: Droplet){
        let til = drop.grouped("til")
        til.get("all", handler: indexView)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let acronyms = try Acronym.all().makeNode()
        let parameters = try Node(node: [
                "acronyms":acronyms,
            ])
        return try drop.view.make("index", parameters)
    }
    
}
