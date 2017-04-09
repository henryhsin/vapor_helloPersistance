import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(Acronym.self)



drop.get("version"){request in
    if let db = drop.database?.driver as? PostgreSQLDriver{
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    }else{
        return "No db connection."
    }
}

drop.get("model"){request in
    let acronym = Acronym(short: "AFK", long: "Away From Keyboard~~")
    return try acronym.makeJSON()
    
}

drop.get("test"){request in
    var acronym = Acronym(short: "FUM", long: "Fuck Your Mother!!")
    try acronym.save()
    return try JSON(node: Acronym.all().makeNode())
    
}

drop.post("new"){request in
    var acronym = try Acronym(node: request.json)
    print(request)
    try acronym.save()
    return acronym
}

drop.get("all"){request in
    return try JSON(node: Acronym.all().makeNode())
    
}

drop.get("first"){request in
    return try JSON(node: Acronym.query().first()?.makeNode())
}

drop.get("ASAP"){request in
    return try JSON(node: Acronym.query().filter("short", "ASAP").all().makeNode())
}

drop.get("nonASAP"){request in
    return try JSON(node: Acronym.query().filter("short", .notEquals , "ASAP") .all().makeNode())
}

drop.get("delete-ASAP"){request in
    let query = try Acronym.query().filter("short", "ASAP")
    try query.delete()
    return try JSON(node: Acronym.all().makeNode())
}
drop.run()
