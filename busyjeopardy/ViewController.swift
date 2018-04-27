//
//  ViewController.swift
//  busyjeopardy
//
//  Created by Kraig Wastlund on 4/27/18.
//  Copyright © 2018 busybusy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let scoreBoard = ScoreBoardView()
    var jeopardyCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        jeopardyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        // Do any additional setup after loading the view, typically from a nib.
        configureSubviews()
    }

    private func configureSubviews() {
        scoreBoard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreBoard)
        
        jeopardyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(jeopardyCollectionView)
        
        let views = [ "score": self.scoreBoard, "coll": jeopardyCollectionView ] as [String : Any]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[score]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[coll]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[score(100)][coll]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}

