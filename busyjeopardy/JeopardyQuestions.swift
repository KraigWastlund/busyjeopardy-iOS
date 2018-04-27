//
//  JeopardyQuestion.swift
//  busyjeopardy
//
//  Created by Kraig Wastlund on 4/27/18.
//  Copyright © 2018 busybusy. All rights reserved.
//

import UIKit

struct JeopardyQuestion {
    var x: Int!
    var y: Int!
    var question: String!
    var image: UIImage?
    var videoURL: String?
}

class Questions {
    
    // first cat
    static let question1  = JeopardyQuestion(x: 0, y: 0, question: "This is the weapon that every Jedi Knight carries.", image: nil, videoURL: nil)
    static let question2  = JeopardyQuestion(x: 0, y: 1, question: "this", image: nil, videoURL: nil)
    static let question3  = JeopardyQuestion(x: 0, y: 2, question: "After being denied the rank of Jedi Master, this Jedi Knight defected to the dark side of the force, becoming one of the galaxy's most fearsome villains.", image: nil, videoURL: nil)
    static let question4  = JeopardyQuestion(x: 0, y: 3, question: "After the formation of the Galactic Empire, Obi-Wan Kenobi went to tattooine to watch over Luke and changed his name to this.", image: nil, videoURL: nil)
    static let question5  = JeopardyQuestion(x: 0, y: 4, question: "While stranded on a desert planet, this Jedi Master discovered a young boy whom he believed was the fulfillment of an ancient prophecy of a chosen one bringing balance to the force.", image: nil, videoURL: nil)
    static let question6  = JeopardyQuestion(x: 0, y: 5, question: "this", image: nil, videoURL: nil)
    
    // second cat
    static let question7  = JeopardyQuestion(x: 1, y: 0, question: "this", image: nil, videoURL: nil)
    static let question8  = JeopardyQuestion(x: 1, y: 1, question: "this", image: nil, videoURL: nil)
    static let question9  = JeopardyQuestion(x: 1, y: 2, question: "this", image: nil, videoURL: nil)
    static let question10 = JeopardyQuestion(x: 1, y: 3, question: "this", image: nil, videoURL: nil)
    static let question11 = JeopardyQuestion(x: 1, y: 4, question: "this", image: nil, videoURL: nil)
    static let question12 = JeopardyQuestion(x: 1, y: 5, question: "this", image: nil, videoURL: nil)
    
    // third cat
    static let question13 = JeopardyQuestion(x: 2, y: 0, question: "this", image: nil, videoURL: nil)
    static let question14 = JeopardyQuestion(x: 2, y: 1, question: "this", image: nil, videoURL: nil)
    static let question15 = JeopardyQuestion(x: 2, y: 2, question: "this", image: nil, videoURL: nil)
    static let question16 = JeopardyQuestion(x: 2, y: 3, question: "this", image: nil, videoURL: nil)
    static let question17 = JeopardyQuestion(x: 2, y: 4, question: "this", image: nil, videoURL: nil)
    static let question18 = JeopardyQuestion(x: 2, y: 5, question: "this", image: nil, videoURL: nil)
    
    // fourth cat
    static let question19 = JeopardyQuestion(x: 3, y: 0, question: "this", image: nil, videoURL: nil)
    static let question20 = JeopardyQuestion(x: 3, y: 1, question: "this", image: nil, videoURL: nil)
    static let question21 = JeopardyQuestion(x: 3, y: 2, question: "this", image: nil, videoURL: nil)
    static let question22 = JeopardyQuestion(x: 3, y: 3, question: "this", image: nil, videoURL: nil)
    static let question23 = JeopardyQuestion(x: 3, y: 4, question: "this", image: nil, videoURL: nil)
    static let question24 = JeopardyQuestion(x: 3, y: 5, question: "this", image: nil, videoURL: nil)
    
    // fifth cat
    static let question25 = JeopardyQuestion(x: 4, y: 0, question: "this", image: nil, videoURL: nil)
    static let question26 = JeopardyQuestion(x: 4, y: 1, question: "this", image: nil, videoURL: nil)
    static let question27 = JeopardyQuestion(x: 4, y: 2, question: "this", image: nil, videoURL: nil)
    static let question28 = JeopardyQuestion(x: 4, y: 3, question: "this", image: nil, videoURL: nil)
    static let question29 = JeopardyQuestion(x: 4, y: 4, question: "this", image: nil, videoURL: nil)
    static let question30 = JeopardyQuestion(x: 4, y: 5, question: "this", image: nil, videoURL: nil)
    
    // sixth cat
    static let question31 = JeopardyQuestion(x: 5, y: 0, question: "this", image: nil, videoURL: nil)
    static let question32 = JeopardyQuestion(x: 5, y: 1, question: "this", image: nil, videoURL: nil)
    static let question33 = JeopardyQuestion(x: 5, y: 2, question: "this", image: nil, videoURL: nil)
    static let question34 = JeopardyQuestion(x: 5, y: 3, question: "this", image: nil, videoURL: nil)
    static let question35 = JeopardyQuestion(x: 5, y: 4, question: "this", image: nil, videoURL: nil)
    static let question36 = JeopardyQuestion(x: 5, y: 5, question: "this", image: nil, videoURL: nil)
    
    static func getQuestionAndOptionalImageAndVideoURL(forX x: Int, forY y: Int) -> (String, UIImage?, String?) {
        let questions = [question1, question2, question3]
        for question in questions {
            if question.x == x && question.y == y {
                return (question.question, question.image, question.videoURL)
            }
        }
        
        return ("", nil, nil)
    }
}
