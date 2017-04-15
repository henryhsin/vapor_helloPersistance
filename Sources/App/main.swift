//rrun postgresql $postgres -D /usr/local/var/postgres
import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(Acronym.self)

//it can help u refresh the html page, after editing *.leaf without rebuild again
(drop.view as! LeafRenderer).stem.cache = nil

var basicController = BasicControllers()
basicController.addRoutes(drop: drop)

var tilController = TILController()
tilController.addRoutes(drop: drop)

let acronyms = AcronymController()
drop.resource("acronyms", acronyms)
drop.run()
