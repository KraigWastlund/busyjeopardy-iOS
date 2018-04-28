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
    static let cat1Title = "I DON'T KNOW"
    static let question1  = JeopardyQuestion(x: 0, y: 0, question: "This is the weapon that every Jedi Knight carries.", image: nil, videoURL: nil)
    static let question2  = JeopardyQuestion(x: 0, y: 1, question: "??????", image: nil, videoURL: nil)
    static let question3  = JeopardyQuestion(x: 0, y: 2, question: "After being denied the rank of Jedi Master, this Jedi Knight defected to the dark side of the force, becoming one of the galaxy's most fearsome villains.", image: nil, videoURL: nil)
    static let question4  = JeopardyQuestion(x: 0, y: 3, question: "After the formation of the Galactic Empire, Obi-Wan Kenobi went to tattooine to watch over Luke and changed his name to this.", image: nil, videoURL: nil)
    static let question5  = JeopardyQuestion(x: 0, y: 4, question: "While stranded on a desert planet, this Jedi Master discovered a young boy whom he believed was the fulfillment of an ancient prophecy of a chosen one bringing balance to the force.", image: nil, videoURL: nil)
    static let question6  = JeopardyQuestion(x: 0, y: 5, question: "??????", image: nil, videoURL: nil)
    
    // second cat - SHIPS AND VEHICLES
    static let cat2Title = "SHIPS AND VEHICLES"
    static let question7  = JeopardyQuestion(x: 1, y: 0, question: "The name of this vehicle...", image: UIImage(named: "falcon.jpg"), videoURL: nil)
    static let question8  = JeopardyQuestion(x: 1, y: 1, question: "The name of this vehicle...", image: UIImage(named: "xwing.jpg"), videoURL: nil)
    static let question9  = JeopardyQuestion(x: 1, y: 2, question: "The name of this vehicle...", image: UIImage(named: "tie.jpg"), videoURL: nil)
    static let question10 = JeopardyQuestion(x: 1, y: 3, question: "The name of this vehicle...", image: UIImage(named: "landspeeder.jpg"), videoURL: nil)
    static let question11 = JeopardyQuestion(x: 1, y: 4, question: "The name of this vehicle...", image: UIImage(named: "atat.jpg"), videoURL: nil)
    static let question12 = JeopardyQuestion(x: 1, y: 5, question: "The name of this vehicle...", image: UIImage(named: "atst.jpg"), videoURL: nil)
    
    // third cat - THE JEDI ORDER
    static let cat3Title = "THE JEDI ORDER"
    static let question13 = JeopardyQuestion(x: 2, y: 0, question: "This is the weapon of a Jedi Knight. Not as clumsy or random as a blaster. An elegant weapon for a more civilized age.", image: nil, videoURL: nil)
    static let question14 = JeopardyQuestion(x: 2, y: 1, question: "After begin denied the rank of Jedi Master, this Jedi Knight defected to the dark side of the force, becoming one of the galaxy's most fearsome villains.", image: nil, videoURL: nil)
    static let question15 = JeopardyQuestion(x: 2, y: 2, question: "While stranded on a desert planet, this Jedi Master discovered a young boy whom he believed was the fulfillment of an ancient prophecy of a chosen one bringing balance to the force.", image: nil, videoURL: nil)
    static let question16 = JeopardyQuestion(x: 2, y: 3, question: "After the formation of the Galactic Empire, Obi-Wan Kenobi went to Tatooine to watch over Luke and changed his name to this.", image: nil, videoURL: nil)
    static let question17 = JeopardyQuestion(x: 2, y: 4, question: "This is the planet that the main Jedi Temple was located on, before being destroyed by Darth Vader at the end of the Clone War.", image: nil, videoURL: nil)
    static let question18 = JeopardyQuestion(x: 2, y: 5, question: "This Jedi Master is unique in that he is the only one to have a purple kyber crystal in his lightsaber.", image: nil, videoURL: nil)
    
    // fourth cat - A WAR IN THE STARS
    static let cat4Title = "A WAR IN THE STARS"
    static let question19 = JeopardyQuestion(x: 3, y: 0, question: "This super weapon was constructed in secret by the Empire. It had the ability to destroy an entire planet and was ultimately destroyed by the Rebel Alliance during the Battle of Yavin.", image: nil, videoURL: nil)
    static let question20 = JeopardyQuestion(x: 3, y: 1, question: "The Rebel Base on this Ice planet was destroyed by the Empire through the use of AT-ATs, Snowtroopers and Probe Droids.", image: nil, videoURL: nil)
    static let question21 = JeopardyQuestion(x: 3, y: 2, question: "During a desperate search for the Millennium Falcon, the Empire hired this bounty hunter, who successfully traced it to Cloud City.", image: nil, videoURL: nil)
    static let question22 = JeopardyQuestion(x: 3, y: 3, question: "She was responsible for transmitting the Death Star's plans to Princess Leia, ultimately sacrificing her entire team's life to forward the cause of the rebellion.", image: nil, videoURL: nil)
    static let question23 = JeopardyQuestion(x: 3, y: 4, question: "Issued by Chancellor Palpatine, this order ended the Clone War, destroyed the Jedi Order and started the formation of the Galactic Empire.", image: nil, videoURL: nil)
    static let question24 = JeopardyQuestion(x: 3, y: 5, question: "After destroying Starkiller base and being pursued relentlessly by the First Order, the Resistance prepared to make a last stand on the planet of Crait, which is covered in a layer of this substance.", image: nil, videoURL: nil)
    
    // fifth cat - THERE IS NO TRY
    static let cat5Title = "THERE IS NO TRY"
    static let question25 = JeopardyQuestion(x: 4, y: 0, question: "Prior to his discovery that his father was a Jedi Knight, Luke thought his father's occupation was this.", image: nil, videoURL: nil)
    static let question26 = JeopardyQuestion(x: 4, y: 1, question: "The age that Yoda was when he became one with the force.", image: nil, videoURL: nil)
    static let question27 = JeopardyQuestion(x: 4, y: 2, question: "It's the name of the planet where the Empire had their final battle, as well as where we first meet a certain highly force-sensitive scavenger", image: nil, videoURL: nil)
    static let question28 = JeopardyQuestion(x: 4, y: 3, question: "The name of Jabba the Hutt's court jester, known for his shrill laughter.", image: nil, videoURL: nil)
    static let question29 = JeopardyQuestion(x: 4, y: 4, question: "While aboard the Death Star, Luke assumes the identity of a stormtrooper with this call sign.", image: nil, videoURL: nil)
    static let question30 = JeopardyQuestion(x: 4, y: 5, question: "The name of the Imperial Shuttle stolen by the Rebel Alliance to infiltrate the moon of Endor.", image: nil, videoURL: nil)
    
    // sixth cat - CREATURES
    static let cat6Title = "CREATURES"
    static let question31 = JeopardyQuestion(x: 5, y: 0, question: "The most well known of this species is Chewbacca.", image: nil, videoURL: nil)
    static let question32 = JeopardyQuestion(x: 5, y: 1, question: "With the looks of a cross between a teddy bear and a shih tzu, these creatures are native to the moon of Endor.", image: nil, videoURL: nil)
    static let question33 = JeopardyQuestion(x: 5, y: 2, question: "These animals were created by the production team out of necessity, due to the large amount of puffins on Skellig Micheal while filming scenes in 'The Last Jedi'", image: nil, videoURL: nil)
    static let question34 = JeopardyQuestion(x: 5, y: 3, question: "Jabba the Hutt keeps one of these creatures in his dungeon, often feeding it prisoners.", image: nil, videoURL: nil)
    static let question35 = JeopardyQuestion(x: 5, y: 4, question: "These creatures are parasites that chew on power cables and energy conductors of starships.", image: nil, videoURL: nil)
    static let question36 = JeopardyQuestion(x: 5, y: 5, question: "Han Solo was transporting these dangerous creatures when he was confronted by kanjiklub and the guardian death gang.", image: nil, videoURL: nil)
    
    static func getQuestionAndOptionalImageAndVideoURL(forX x: Int, forY y: Int) -> (String, UIImage?, String?) {
        let questions = [question1, question2, question3, question4, question5, question7, question8, question9, question10, question11, question12, question13, question14, question15, question16, question17, question18, question19, question20, question21, question22, question23, question24, question25, question26, question27, question28, question29, question30, question31, question32, question33, question34, question35, question36]
        for question in questions {
            if question.x == x && question.y == y {
                return (question.question, question.image, question.videoURL)
            }
        }
        
        return ("", nil, nil)
    }
}
