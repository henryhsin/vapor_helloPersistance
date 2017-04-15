//
//  BasicControllers.swift
//  helloPersistance
//
//  Created by 辛忠翰 on 2017/4/10.
//
//

import Foundation
import Vapor
import HTTP
import VaporPostgreSQL

final class BasicControllers{
    func addRoutes(drop: Droplet){
        let basic = drop.grouped("basic")
        let data = drop.grouped("data")
        basic.get("version", handler: version)
        data.get("model", handler: model)
        data.get("addFUM", handler: addFUM)
        data.get("allRows", handler: allRows)
        data.get("firstRow", handler: firstRow)
        data.get("filterASAP", handler: filterASAP)
        data.get("nonASAP", handler: nonASAP)
        data.get("deleteASAP", handler: deleteASAP)
        data.post("addNew", handler: addNew)
        data.get("update",handler: update)
    }
    
    
    
    func version(request: Request) throws -> ResponseRepresentable {
        if let db = drop.database?.driver as? PostgreSQLDriver{
            let version = try db.raw("SELECT version()")
            return try JSON(node: version)
        }else{
            return "No db connection."
        }
    }
    
    func model(request: Request) throws -> ResponseRepresentable {
        let acronym = Acronym(short: "AFK", long: "Away From Keyboard~~")
        return try acronym.makeJSON()
    }
    
    func addFUM(request: Request) throws -> ResponseRepresentable {
        var acronym = Acronym(short: "FUM", long: "Fuck Your Mother!!")
        try acronym.save()
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func allRows(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func firstRow(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.query().first()?.makeNode())
    }
    
    func filterASAP(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.query().filter("short", "ASAP").all().makeNode())
        
    }
    
    func nonASAP(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.query().filter("short", .notEquals , "ASAP") .all().makeNode())
    }
    
    func deleteASAP(request: Request) throws -> ResponseRepresentable {
        let query = try Acronym.query().filter("short", "ASAP")
        try query.delete()
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func addNew(request: Request) throws -> ResponseRepresentable {
        var acronym = try Acronym(node: request.json)
        print(request)
        try acronym.save()
        return acronym
    }
    
    func update(request: Request) throws -> ResponseRepresentable {
        guard var phrase = try Acronym.query().first(), let long = request.data["long"]?.string else {
            throw Abort.badRequest
        }
        phrase.long = long
        try phrase.save()
        return phrase
    }
    
    
}

