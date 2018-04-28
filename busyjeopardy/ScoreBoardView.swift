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
        
        addConstraint(NSLayoutConstraint(item: team1View, attribute: .width, relatedBy: .equal, toItem: team2View, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: team2View, attribute: .width, relatedBy: .equal, toItem: team3View, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: team3View, attribute: .width, relatedBy: .equal, toItem: team4View, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
}

class TeamScoreView: UIView {
    
    var name: String! {
        didSet {
            nameLabel.text = name
        }
    }
    var points: String! {
        didSet {
            pointsLabel.text = points
        }
    }
    var nc: UINavigationController!
    
    private let nameLabel = UILabel()
    private let pointsLabel = UILabel()
    private let touchButton = UIButton()
    
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
        
        touchButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        touchButton.translatesAutoresizingMaskIntoConstraints = false
        
        touchButton.backgroundColor = .clear
        
        pointsLabel.textAlignment = .center
        pointsLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 36, weight: .light)
        
        addSubview(nameLabel)
        addSubview(pointsLabel)
        addSubview(touchButton)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[name]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["name": nameLabel, "points": pointsLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[points]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["name": nameLabel, "points": pointsLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[name(50)][points]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["name": nameLabel, "points": pointsLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[touch]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["touch": touchButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[touch]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["touch": touchButton]))
        
        bringSubview(toFront: touchButton)
        
        nameLabel.text = "Team Name"
        pointsLabel.text = "0"
    }
    
    @objc private func buttonPressed() {
        let alert = UIAlertController(title: "Great Title", message: "Please input something", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your name"
        }
        let action = UIAlertAction(title: "Name Input", style: .default) { [weak self] (alertAction) in
            if let tfs = alert.textFields, !tfs.isEmpty {
                if let text = tfs[0].text {
                    self?.nameLabel.text = text
                }
            }
        }
        alert.addAction(action)
        self.nc.present(alert, animated:true, completion: nil)
    }
}
