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
    var points: Int
    var name: String
    var isConnected: Bool
    var buzzerTapDate: Date?
}

final class FirebaseDB {
    static let sharedInstance = FirebaseDB()
    private init() {}
    
    var reference = Database.database().reference()
    
    func updateReset() {
        let resetDict = ["reset": true] as [String : Any]
        FirebaseDB.sharedInstance.reference.updateChildValues(resetDict)
    }
    
    func updateReady() {
        let rdyDict = ["ready": true] as [String : Any]
        FirebaseDB.sharedInstance.reference.updateChildValues(rdyDict)
    }
    
    func updateScore(points: Int, teamIndex: Int) {
        var team: Team!
        self.getTeams { (teams) in
            team = teams[teamIndex]
            let teamDict = ["team_name": team.name, "is_connected": true, "points": points] as [String : Any]
            self.reference.child("teams").child(team.id).setValue(teamDict)
        }
    }
    
    func getBuzzerWinner(completion: @escaping (_ winner: Team) -> Void) {
        self.getTeamsListener { (teams) in
            var filteredTeams = teams.filter({ $0.buzzerTapDate != nil })
            
            filteredTeams.sort(by: {
                if let date1 = $0.buzzerTapDate, let date2 = $1.buzzerTapDate, date1.compare(date2) == .orderedAscending {
                    return true
                }
                return false
            })
            
            if let winningTeam = filteredTeams.first, winningTeam.buzzerTapDate != nil {
                completion(winningTeam)
            }
        }
    }
    
    func deleteTeam(name: String) {
        self.getTeams { (teams) in
            if let index = teams.index(where: { $0.name == name }) {
                let team = teams[index]
                self.reference.child("teams").child(team.id).removeValue()
            }
        }
    }
    
    func getIsConnected(completion: @escaping (_ isConnected: Bool) -> Void) {
        guard let currentUser = FirebaseAuth.sharedInstance.firebaseAuth.currentUser else {
            assertionFailure("currentUser must not be nil.")
            return
        }
        self.reference.child("teams").child(currentUser.uid).child("is_connected").observe(.value) { (snapshot) in
            if let isConnected = snapshot.value as? Bool {
                completion(isConnected)
            } else {
                completion(false)
            }
        }
    }
    
    func getSelectedCells(completion: @escaping (_ selectedIndexes: [Int]) -> Void) {
        self.reference.child("chosen_indexes").observeSingleEvent(of: .value) { (snapshot) in
            var array = [Int]()
            for chosenIndexes in snapshot.children.allObjects as! [DataSnapshot] {
                if let index = chosenIndexes.value as? Int {
                    array.append(index)
                }
            }
            completion(array)
        }
    }
    
    func getTeams(completion: @escaping (_ teams: [Team]) -> Void) {
        self.reference.child("teams").observeSingleEvent(of: .value) { (snapshot) in
            var teamsArray = [Team]()
            for teams in snapshot.children.allObjects as! [DataSnapshot] {
                if let teamObject = teams.value as? [String: AnyObject] {
                    var name = ""
                    var buzzerTap: Date? = nil
                    var isConnected = false
                    var points = 0
                    if let teamName = teamObject["team_name"] as? String {
                        name = teamName
                    }
                    if let teamBuzzerTap = teamObject["buzzer_tap_date"] as? NSNumber {
                        buzzerTap = Date(timeIntervalSince1970: teamBuzzerTap.doubleValue)
                    }
                    if let teamIsConnected = teamObject["is_connected"] as? Bool {
                        isConnected = teamIsConnected
                    }
                    if let p = teamObject["points"] as? Int {
                        points = p
                    }
                    teamsArray.append(Team(id: teams.key, points: points, name: name, isConnected: isConnected, buzzerTapDate: buzzerTap))
                }
            }
            completion(teamsArray)
        }
    }
    
    func getTeamsListener(completion: @escaping (_ teams: [Team]) -> Void) {
        self.reference.child("teams").observe(.value) { (snapshot) in
            var teamsArray = [Team]()
            for teams in snapshot.children.allObjects as! [DataSnapshot] {
                if let teamObject = teams.value as? [String: AnyObject] {
                    var name = ""
                    var buzzerTap: Date? = nil
                    var isConnected = false
                    var points = 0
                    if let teamName = teamObject["team_name"] as? String {
                        name = teamName
                    }
                    if let teamBuzzerTap = teamObject["buzzer_tap_date"] as? NSNumber {
                        buzzerTap = Date(timeIntervalSince1970: teamBuzzerTap.doubleValue)
                    }
                    if let teamIsConnected = teamObject["is_connected"] as? Bool {
                        isConnected = teamIsConnected
                    }
                    if let p = teamObject["points"] as? Int {
                        points = p
                    }
                    teamsArray.append(Team(id: teams.key, points: points, name: name, isConnected: isConnected, buzzerTapDate: buzzerTap))
                }
            }
            completion(teamsArray)
        }
    }
}
