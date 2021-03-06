//
//  PlayerService.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation

typealias GetPlayersCompletion = (([Player]?) -> Void)
typealias GetPlayerCompletion = ((Player?) -> Void)
typealias SavePlayerCompletion = ((Player?) -> Void)
typealias DeletePlayerCompletion = ((Bool) -> Void)

class PlayerService: BaseService {
    
    func savePlayer(name: String, completion: SavePlayerCompletion) {
        let object = PlayerMO(name: name)
        if CoreDataConnection.shared.managedContext.save(object) {
            completion(PlayerMO.parse(player: object))
        }
    }
    
    func getPlayers(completion: @escaping GetPlayersCompletion) {
        let objects: [PlayerMO] = CoreDataConnection.shared.managedContext.loadObjects(ofType: PlayerMO.entityName)
        completion(objects.map(PlayerMO.parse))
    }
    
    func getPlayer(withName name: String, completion: GetPlayerCompletion) {
        let objects: [PlayerMO] = CoreDataConnection.shared.managedContext.loadObjects(ofType: PlayerMO.entityName, matching: "name == %@", params: [name])
        completion(objects.map(PlayerMO.parse).first)
    }
    
    func deletePlayer(player: Player, completion: DeletePlayerCompletion) {
        if let playerToDelete = PlayerMO.reverseParse(fromPlayer: player) {
            completion(CoreDataConnection.shared.managedContext.delete(playerToDelete))
            return
        }
        completion(false)
    }
}
