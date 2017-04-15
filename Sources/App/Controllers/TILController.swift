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
        drop.get("til", handler: indexView)
        drop.post("til",handler: addAcronyms)
        drop.post("til", Acronym.self, "delete", handler: deleteAcronyms)
        
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let acronyms = try Acronym.all().makeNode()
        let parameters = try Node(node: [
            "acronyms":acronyms,
            ])
        return try drop.view.make("index", parameters)
    }
    
    func addAcronyms(request: Request) throws -> ResponseRepresentable {
        guard let short = request.data["short"]?.string, let long = request.data["long"]?.string else{
            throw Abort.badRequest
        }
        var acronym = Acronym.init(short: short, long: long)
        try acronym.save()
        return Response(redirect: "/til")
        
    }
    
    func deleteAcronyms(request: Request, acronym: Acronym) throws -> ResponseRepresentable  {
        try acronym.delete()
        return Response(redirect: "/til")
    }
}
