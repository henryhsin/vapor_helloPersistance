import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(Acronym.self)

var basicController = BasicControllers()
basicController.addRoutes(drop: drop)

let acronyms = AcronymController()
drop.resource("acronyms", acronyms)
drop.run()
