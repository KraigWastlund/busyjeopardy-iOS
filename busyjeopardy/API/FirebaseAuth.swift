//
//  FirebaseAuth.swift
//  busyjeopardy
//
//  Created by PJ Vea on 4/29/18.
//  Copyright © 2018 busybusy. All rights reserved.
//

import FirebaseAuth

final class FirebaseAuth {
    static let sharedInstance = FirebaseAuth()
    private init() {}
    
    let firebaseAuth = Auth.auth()
    
    func signInAnonymously() {
        guard Auth.auth().currentUser == nil else {
            return
        }
        
        self.firebaseAuth.signInAnonymously() { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func logout(completion: ((_ success: Bool) -> Void)? = nil) {
        do {
            try self.firebaseAuth.signOut()
            if let completion = completion {
                completion(true)
            }
        } catch let error as NSError {
            print("Error signing out: %@", error)
            if let completion = completion {
                completion(false)
            }
        }
    }
}
