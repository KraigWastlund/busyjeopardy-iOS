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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[one]-[two]-[three]-[four]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[one]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[two]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[three]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[four]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        addConstraint(NSLayoutConstraint(item: team1View, attribute: .width, relatedBy: .equal, toItem: team2View, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: team2View, attribute: .width, relatedBy: .equal, toItem: team3View, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: team3View, attribute: .width, relatedBy: .equal, toItem: team4View, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
}

enum TeamSelectionState {
    case selected
    case unselected
    case neutral
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
    var vc: ViewController!
    var team: Int!
    
    private let nameLabel = UILabel()
    private let pointsLabel = UILabel()
    private let nameButton = UIButton()
    private let pointsButton = UIButton()
    
    private let tempButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        backgroundColor = BSYColor.c14
        
        nameButton.addTarget(self, action: #selector(nameButtonPressed), for: .touchUpInside)
        pointsButton.addTarget(self, action: #selector(pointsButtonPressed), for: .touchUpInside)
        tempButton.addTarget(self, action: #selector(tempButtonPressed), for: .touchUpInside)
        
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameButton.translatesAutoresizingMaskIntoConstraints = false
        pointsButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameButton.backgroundColor = .clear
        pointsButton.backgroundColor = .clear
        tempButton.backgroundColor = .clear
        
        pointsLabel.textAlignment = .center
        pointsLabel.textColor = BSYColor.c2
        pointsLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 36, weight: .light)
        nameLabel.textColor = BSYColor.c2
        
        addSubview(nameLabel)
        addSubview(pointsLabel)
        addSubview(nameButton)
        addSubview(pointsButton)
        addSubview(tempButton)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[name]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["name": nameLabel, "points": pointsLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[points]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["name": nameLabel, "points": pointsLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[name(50)][points]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["name": nameLabel, "points": pointsLabel]))
        
        addConstraint(NSLayoutConstraint(item: nameButton, attribute: .width, relatedBy: .equal, toItem: nameLabel, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: nameButton, attribute: .height, relatedBy: .equal, toItem: nameLabel, attribute: .height, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: nameButton, attribute: .centerY, relatedBy: .equal, toItem: nameLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: nameButton, attribute: .centerX, relatedBy: .equal, toItem: nameLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: pointsButton, attribute: .width, relatedBy: .equal, toItem: pointsLabel, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: pointsButton, attribute: .height, relatedBy: .equal, toItem: pointsLabel, attribute: .height, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: pointsButton, attribute: .centerY, relatedBy: .equal, toItem: pointsLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: pointsButton, attribute: .centerX, relatedBy: .equal, toItem: pointsLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: tempButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100.0))
        addConstraint(NSLayoutConstraint(item: tempButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100.0))
        addConstraint(NSLayoutConstraint(item: tempButton, attribute: .right, relatedBy: .equal, toItem: nameLabel, attribute: .right, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: tempButton, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        bringSubview(toFront: nameButton)
        bringSubview(toFront: pointsButton)
        bringSubview(toFront: tempButton)
        
        nameLabel.text = "Team Name"
        points = "0"
    }
    
    func setSelectionState(state: TeamSelectionState) {
        switch state {
        case .neutral:
            self.backgroundColor = BSYColor.c14
        case .selected:
            self.backgroundColor = .green
        case .unselected:
            self.backgroundColor = .red
        }
    }
    
    @objc private func tempButtonPressed() {
        vc.currentTeamSelection(team: self.team)
    }
    
    @objc private func nameButtonPressed() {
        let alert = UIAlertController(title: "Name Your Team!", message: "Input the name of the team below", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your name"
        }
        let action = UIAlertAction(title: "Name Input", style: .default) { [weak self] (alertAction) in
            if let tfs = alert.textFields, !tfs.isEmpty {
                if let text = tfs[0].text, text.count > 0 {
                    self?.nameLabel.text = text
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.nc.present(alert, animated:true, completion: nil)
    }
    
    @objc private func pointsButtonPressed() {
        let alert = UIAlertController(title: "Modify Points?", message: "Use this to manually modify points", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your points"
        }
        let action = UIAlertAction(title: "Points Input", style: .default) { [weak self] (alertAction) in
            if let tfs = alert.textFields, !tfs.isEmpty {
                if let text = tfs[0].text, text.count > 0 {
                    self?.pointsLabel.text = text
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.nc.present(alert, animated:true, completion: nil)
    }
}
