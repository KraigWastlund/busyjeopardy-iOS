//
//  ScoreBoardView.swift
//  busyjeopardy
//
//  Created by Kraig Wastlund on 4/27/18.
//  Copyright © 2018 busybusy. All rights reserved.
//

import UIKit

class ScoreBoardView: UIView {

    let team1View = TeamScoreView()
    let team2View = TeamScoreView()
    let team3View = TeamScoreView()
    let team4View = TeamScoreView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        team1View.translatesAutoresizingMaskIntoConstraints = false
        addSubview(team1View)
        team2View.translatesAutoresizingMaskIntoConstraints = false
        addSubview(team2View)
        team3View.translatesAutoresizingMaskIntoConstraints = false
        addSubview(team3View)
        team4View.translatesAutoresizingMaskIntoConstraints = false
        addSubview(team4View)
        
        let views = [ "one": team1View, "two": team2View, "three": team3View, "four": team4View ]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[one]-[two]-[three]-[four]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[one]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[two]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[three]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[four]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}

class TeamScoreView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        backgroundColor = .lightGray
    }
}
