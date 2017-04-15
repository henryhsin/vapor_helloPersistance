//
//  AcronymController.swift
//  helloPersistance
//
//  Created by 辛忠翰 on 2017/4/10.
//
//

import Foundation
import Vapor
import HTTP

final class AcronymController: ResourceRepresentable{
    
    //Get
    // show the all datas
    func index(request: Request) throws -> ResponseRepresentable{
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func makeResource() -> Resource<Acronym> {
       //Resource has index, store, show, replace, modify, destroy, clear... members
        return Resource(
        index: index,
        store: create,
        show: show,
        modify: update,
        destroy: delete
        )
    }
    
    //Post
    // /ancroyms/
    // creat a new data
    func create(request: Request) throws -> ResponseRepresentable{
        var acronym = try request.acronym()
        try acronym.save()
        return acronym
    }
    //Get
    //To retrieve a particular acronym, the second argument is the result to retrieve. And it is looking up the acronym's ID pass in the url from the database. ex: /acronyms/1 and it will return id1's acronym. As same as the Reource's member "show"
    func show(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
        return acronym
    }
    
    
    //Patch
    // /acronyms/id
    // ex: acronyms/4
    func update(request: Request, acronym: Acronym) throws -> ResponseRepresentable{
        let new = try request.acronym()
        var acronym = acronym
        acronym.long = new.long
        acronym.short = new.short
        try acronym.save()
        return acronym
    }
    
    
    //delete
    func delete(request: Request, acronym: Acronym) throws -> ResponseRepresentable{
        try acronym.delete()
        return JSON([:])
    }
}




extension Request{
    func acronym() throws -> Acronym {
        guard let json = json else{ throw Abort.badRequest }
        return try Acronym(node: json)
    }
}
