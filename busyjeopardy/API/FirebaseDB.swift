//
//  FirebaseDB.swift
//  busyjeopardy
//
//  Created by PJ Vea on 4/29/18.
//  Copyright © 2018 busybusy. All rights reserved.
//

import FirebaseDatabase

struct Team {
    var id: String
    var name: String
}

final class FirebaseDB {
    static let sharedInstance = FirebaseDB()
    private init() {}
    
    var reference = Database.database().reference()
    
    func updateReset() {
        let resetDict = ["reset": true] as [String : Any]
        FirebaseDB.sharedInstance.reference.updateChildValues(resetDict)
    }
    
    func deleteTeam(name: String) {
        self.getTeams { (teams) in
            if let index = teams.index(where: { $0.name == name }) {
                let team = teams[index]
                self.reference.child("teams").child(team.id).removeValue()
            }
        }
    }
    
    func getTeams(completion: @escaping (_ teams: [Team]) -> Void) {
        self.reference.child("teams").observe(.value) { (snapshot) in
            var teamsArray = [Team]()
            for teams in snapshot.children.allObjects as! [DataSnapshot] {
                if let teamObject = teams.value as? [String: AnyObject] {
                    var name = ""
                    if let teamName = teamObject["team_name"] as? String {
                        name = teamName
                    }
                    teamsArray.append(Team(id: teams.key, name: name))
                }
            }
            completion(teamsArray)
        }
    }
}
