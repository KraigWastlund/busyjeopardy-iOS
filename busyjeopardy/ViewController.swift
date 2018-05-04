//
//  ViewController.swift
//  busyjeopardy
//
//  Created by Kraig Wastlund on 4/27/18.
//  Copyright © 2018 busybusy. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    let scoreBoard = ScoreBoardView()
    let categoryTitlesView = CategoryTitlesView()
    var jeopardyCollectionView: UICollectionView!
    
    var currentPointValueIndex: Int!
    var selectedIndexes = [Int]()
    
    var tempTimer: Timer!
    
    var lastTeamToGetAnAnswerCorrect: Int?
    var currentTeam: Int = 0 {
        didSet {
            scoreBoard.team1View.setSelectionState(state: .unselected)
            scoreBoard.team2View.setSelectionState(state: .unselected)
            scoreBoard.team3View.setSelectionState(state: .unselected)
            scoreBoard.team4View.setSelectionState(state: .unselected)
            switch currentTeam {
            case 0:
                scoreBoard.team1View.setSelectionState(state: .selected)
            case 1:
                scoreBoard.team2View.setSelectionState(state: .selected)
            case 2:
                scoreBoard.team3View.setSelectionState(state: .selected)
            case 3:
                scoreBoard.team4View.setSelectionState(state: .selected)
            default:
                assert(false)
            }
            
            self.navigationController!.dismiss(animated: true, completion: {
                self.didEnd(pointIndex: self.currentPointValueIndex)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BSYColor.c2
        jeopardyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        jeopardyCollectionView.delegate = self
        jeopardyCollectionView.dataSource = self
        
        scoreBoard.team1View.nc = navigationController
        scoreBoard.team1View.vc = self
        scoreBoard.team1View.team = 0
        scoreBoard.team2View.nc = navigationController
        scoreBoard.team2View.vc = self
        scoreBoard.team2View.team = 1
        scoreBoard.team3View.nc = navigationController
        scoreBoard.team3View.vc = self
        scoreBoard.team3View.team = 2
        scoreBoard.team4View.nc = navigationController
        scoreBoard.team4View.vc = self
        scoreBoard.team4View.team = 3
        
        jeopardyCollectionView.register(JeopardyCollectionCell.self, forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
        configureSubviews()
        
        self.loadTeams()
        FirebaseDB.sharedInstance.getBuzzerWinner { (team: Team) in
            for (index, teamView) in [self.scoreBoard.team1View, self.scoreBoard.team2View, self.scoreBoard.team3View, self.scoreBoard.team4View].enumerated() {
                if teamView.uuid == team.id {
                    self.currentTeam = index
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.populateChosenCells()
    }
    
    func currentTeamSelection(team: Int) {
        self.currentTeam = team
    }
    
    @objc private func tempSetCurrentTeam() {
        // random number between 0 and 3 inclusive
        let ran = Int(arc4random_uniform(4))
        self.currentTeam = ran
        self.tempTimer.invalidate()
    }
    
    @objc private func rotated() {
        // maybe later
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ((self.jeopardyCollectionView.frame.size.width - 20) / 6), height: ((self.jeopardyCollectionView.frame.size.height - 28) / 6))
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        self.jeopardyCollectionView.collectionViewLayout = layout
        self.jeopardyCollectionView.backgroundColor = BSYColor.c2
    }

    private func configureSubviews() {
        scoreBoard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreBoard)
        
        categoryTitlesView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categoryTitlesView)
        
        jeopardyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(jeopardyCollectionView)
        
        let views = [ "score": self.scoreBoard, "cat": categoryTitlesView, "coll": jeopardyCollectionView ] as [String : Any]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[score]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cat]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[coll]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[score(200)][cat(50)][coll]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        categoryTitlesView.titleLabel1.text = Questions.cat1Title
        categoryTitlesView.titleLabel2.text = Questions.cat2Title
        categoryTitlesView.titleLabel3.text = Questions.cat3Title
        categoryTitlesView.titleLabel4.text = Questions.cat4Title
        categoryTitlesView.titleLabel5.text = Questions.cat5Title
        categoryTitlesView.titleLabel6.text = Questions.cat6Title
    }
}

// MARK: - Private Methods

extension ViewController {
    private func loadTeams() {
        if FirebaseAuth.sharedInstance.firebaseAuth.currentUser == nil {
            FirebaseAuth.sharedInstance.signInAnonymously()
        }
        FirebaseDB.sharedInstance.getTeamsListener { (teams) in
            for team in teams {
                for teamView in [self.scoreBoard.team1View, self.scoreBoard.team2View, self.scoreBoard.team3View, self.scoreBoard.team4View] {
                    if teamView.uuid == nil {
                        teamView.name = team.name
                        teamView.uuid = team.id
                        teamView.points = "\(team.points)"
                        break
                    } else {
                        if team.id == teamView.uuid {
                            teamView.points = "\(team.points)"
                            teamView.name = team.name
                            break
                        }
                    }
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? JeopardyCollectionCell else { return UICollectionViewCell() }
        
        cell.selectionDelegate = self
        var title: String?
        if indexPath.row < 6 {
            title = "100"
            cell.x = indexPath.row % 6
            cell.y = 0
        } else if indexPath.row < 12 {
            title = "200"
            cell.x = indexPath.row % 6
            cell.y = 1
        } else if indexPath.row < 18 {
            title = "300"
            cell.x = indexPath.row % 6
            cell.y = 2
        } else if indexPath.row < 24 {
            title = "400"
            cell.x = indexPath.row % 6
            cell.y = 3
        } else if indexPath.row < 30 {
            title = "500"
            cell.x = indexPath.row % 6
            cell.y = 4
        } else {
            title = "600"
            cell.x = indexPath.row % 6
            cell.y = 5
        }
        cell.set(title: title!)
        
        if self.selectedIndexes.contains(indexPath.row) {
            cell.label.backgroundColor = JeopardyCollectionCell.selectionColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! JeopardyCollectionCell
        
        if cell.label.backgroundColor == JeopardyCollectionCell.selectionColor {
            return
        }
        
        self.selectedIndexes.append(indexPath.row)
        
        var points: String!
        if indexPath.row < 6 {
            points = "100"
        } else if indexPath.row < 12 {
            points = "200"
        } else if indexPath.row < 18 {
            points = "300"
        } else if indexPath.row < 24 {
            points = "400"
        } else if indexPath.row < 30 {
            points = "500"
        } else {
            points = "600"
        }
            
        var category: String!
        if indexPath.row % 6 == 0 {
            category = categoryTitlesView.titleLabel1.text
        } else if indexPath.row % 6 == 1 {
            category = categoryTitlesView.titleLabel2.text
        } else if indexPath.row % 6 == 2 {
            category = categoryTitlesView.titleLabel3.text
        } else if indexPath.row % 6 == 3 {
            category = categoryTitlesView.titleLabel4.text
        } else if indexPath.row % 6 == 4 {
            category = categoryTitlesView.titleLabel5.text
        } else if indexPath.row % 6 == 5 {
            category = categoryTitlesView.titleLabel6.text
        }
        
        let msg = "Category: \(category!) \n Points: \(points!)"
        let alert = UIAlertController(title: "You sure?", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default) { (alert: UIAlertAction) in
            cell.userDidSelect = true
            FirebaseDB.sharedInstance.updateReady()
            let rdyDict = ["chosen_indexes": self.selectedIndexes] as [String : Any]
            FirebaseDB.sharedInstance.reference.updateChildValues(rdyDict)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(alert, animated:true, completion: nil)
    }
    
    private func populateChosenCells() {
        FirebaseDB.sharedInstance.getSelectedCells { (array) in
            self.selectedIndexes = array
            self.jeopardyCollectionView.reloadData()
        }
    }
}

extension ViewController: JeopardyCollectionCellSelectionDelegate {
    
    func didSelect(x: Int, y: Int) {
        print("x: \(x) y: \(y)")
        let (question, image, url) = Questions.getQuestionAndOptionalImageAndvideoName(forX: x, forY: y)
        print(question)
        
        self.currentPointValueIndex = y
        
        // simulate someone clicking the buzzer
        // self.tempTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(tempSetCurrentTeam), userInfo: nil, repeats: false)
        
        if image != nil || url != nil {
            let vc = MediaQuestionPresentationViewController()
            vc.text = question
            vc.points = y
            vc.image = image
            vc.videoName = url
            let nc = UINavigationController(rootViewController: vc)
            nc.isNavigationBarHidden = true
            self.present(nc, animated: true, completion: { [weak self] in
                self?.scoreBoard.team1View.setSelectionState(state: .neutral)
                self?.scoreBoard.team2View.setSelectionState(state: .neutral)
                self?.scoreBoard.team3View.setSelectionState(state: .neutral)
                self?.scoreBoard.team4View.setSelectionState(state: .neutral)
            })
        } else {
            let vc = TextQuestionPresentationViewController()
            vc.points = y
            vc.text = question
            let nc = UINavigationController(rootViewController: vc)
            nc.isNavigationBarHidden = true
            self.present(nc, animated: true, completion: { [weak self] in
                self?.scoreBoard.team1View.setSelectionState(state: .neutral)
                self?.scoreBoard.team2View.setSelectionState(state: .neutral)
                self?.scoreBoard.team3View.setSelectionState(state: .neutral)
                self?.scoreBoard.team4View.setSelectionState(state: .neutral)
            })
        }
    }
}

extension ViewController {
    func didEnd(pointIndex: Int) {
        
        let alert = UIAlertController(title: "Correct?", message: "Did they get it right?", preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default) { [weak self] (alert: UIAlertAction) in
            var p: Int = 0
            switch pointIndex {
            case 0:
                p = 100
            case 1:
                p = 200
            case 2:
                p = 300
            case 3:
                p = 400
            case 4:
                p = 500
            case 5:
                p = 600
            default:
                assert(false)
            }
            
            switch self?.currentTeam {
            case 0:
                let currentPoints = Int((self?.scoreBoard.team1View.points)!)
                // self?.scoreBoard.team1View.points = "\(p + currentPoints!)"
                FirebaseDB.sharedInstance.updateScore(points: currentPoints! + p, teamIndex: (self?.currentTeam)!)
            case 1:
                let currentPoints = Int((self?.scoreBoard.team2View.points)!)
                // self?.scoreBoard.team2View.points = "\(p + currentPoints!)"
                FirebaseDB.sharedInstance.updateScore(points: currentPoints! + p, teamIndex: (self?.currentTeam)!)
            case 2:
                let currentPoints = Int((self?.scoreBoard.team3View.points)!)
                // self?.scoreBoard.team3View.points = "\(p + currentPoints!)"
                FirebaseDB.sharedInstance.updateScore(points: currentPoints! + p, teamIndex: (self?.currentTeam)!)
            case 3:
                let currentPoints = Int((self?.scoreBoard.team4View.points)!)
                // self?.scoreBoard.team4View.points = "\(p + currentPoints!)"
                FirebaseDB.sharedInstance.updateScore(points: currentPoints! + p, teamIndex: (self?.currentTeam)!)
            default:
                assert(false)
            }
            self?.lastTeamToGetAnAnswerCorrect = self?.currentTeam
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { [weak self] (action: UIAlertAction) in
            if let previous = self?.lastTeamToGetAnAnswerCorrect {
                self?.scoreBoard.team1View.setSelectionState(state: .unselected)
                self?.scoreBoard.team2View.setSelectionState(state: .unselected)
                self?.scoreBoard.team3View.setSelectionState(state: .unselected)
                self?.scoreBoard.team4View.setSelectionState(state: .unselected)
                switch previous {
                case 0:
                    self?.scoreBoard.team1View.setSelectionState(state: .selected)
                case 1:
                    self?.scoreBoard.team2View.setSelectionState(state: .selected)
                case 2:
                    self?.scoreBoard.team3View.setSelectionState(state: .selected)
                case 3:
                    self?.scoreBoard.team4View.setSelectionState(state: .selected)
                default:
                    assert(false)
                }
            }
        }))
        self.present(alert, animated:true, completion: nil)
    }
}

protocol JeopardyCollectionCellSelectionDelegate: class {
    func didSelect(x: Int, y: Int)
}

class JeopardyCollectionCell: UICollectionViewCell {
    
    let label = UILabel()
    static let selectionColor: UIColor = BSYColor.c8
    
    var x: Int!
    var y: Int!
    
    weak var selectionDelegate: JeopardyCollectionCellSelectionDelegate?
    
    var userDidSelect: Bool? {
        didSet {
            if label.backgroundColor != JeopardyCollectionCell.selectionColor {
                self.selectionDelegate?.didSelect(x: self.x, y: self.y)
            }
            if userDidSelect == true {
                label.backgroundColor = JeopardyCollectionCell.selectionColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        
        backgroundColor = BSYColor.c14
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = BSYColor.c2
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        contentView.addSubview(label)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label": label]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label": label]))
    }
    
    func set(title: String) {
        self.label.text = title
    }
}

class CategoryTitlesView: UIView {
    
    let titleLabel1 = CategoryTitleLabel()
    let titleLabel2 = CategoryTitleLabel()
    let titleLabel3 = CategoryTitleLabel()
    let titleLabel4 = CategoryTitleLabel()
    let titleLabel5 = CategoryTitleLabel()
    let titleLabel6 = CategoryTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.textColor = BSYColor.c14
        addSubview(titleLabel1)
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.textColor = BSYColor.c14
        addSubview(titleLabel2)
        titleLabel3.translatesAutoresizingMaskIntoConstraints = false
        titleLabel3.textColor = BSYColor.c14
        addSubview(titleLabel3)
        titleLabel4.translatesAutoresizingMaskIntoConstraints = false
        titleLabel4.textColor = BSYColor.c14
        addSubview(titleLabel4)
        titleLabel5.translatesAutoresizingMaskIntoConstraints = false
        titleLabel5.textColor = BSYColor.c14
        addSubview(titleLabel5)
        titleLabel6.translatesAutoresizingMaskIntoConstraints = false
        titleLabel6.textColor = BSYColor.c14
        addSubview(titleLabel6)

        let views = [ "one": titleLabel1, "two": titleLabel2, "three": titleLabel3, "four": titleLabel4, "five": titleLabel5, "six": titleLabel6 ]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[one]-14-[two]-14-[three]-14-[four]-14-[five]-14-[six]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[one]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[two]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[three]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[four]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[five]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[six]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))

        addConstraint(NSLayoutConstraint(item: titleLabel1, attribute: .width, relatedBy: .equal, toItem: titleLabel2, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: titleLabel2, attribute: .width, relatedBy: .equal, toItem: titleLabel3, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: titleLabel3, attribute: .width, relatedBy: .equal, toItem: titleLabel4, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: titleLabel4, attribute: .width, relatedBy: .equal, toItem: titleLabel5, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: titleLabel5, attribute: .width, relatedBy: .equal, toItem: titleLabel6, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
}

class CategoryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        textAlignment = .center
        textColor = .white
        font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
}

import AVKit

class TextQuestionPresentationViewController: UIViewController {
    
    private let textLabel = UILabel()
    var points: Int!

    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = UIFont.systemFont(ofSize: 72, weight: .light)
        
        self.view.addSubview(textLabel)
        
        let views = [ "text": textLabel ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[text]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        textLabel.text = self.text
    }
}

class MediaQuestionPresentationViewController: UIViewController {
    
    private let smallVideoPlayerViewController = AVPlayerViewController()
    
    private let videoView = UIView()
    private let textLabel = UILabel()
    private let imageView = UIImageView()
    var points: Int!
    
    var videoName: String?
    var image: UIImage?
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image == nil {
            assert(videoName != nil)
        }

        self.view.backgroundColor = .white
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = UIFont.systemFont(ofSize: 36, weight: .light)
        
        self.view.addSubview(videoView)
        self.view.addSubview(textLabel)
        self.view.addSubview(imageView)
        
        let views = [ "video": videoView, "text": textLabel ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[video]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[video][text(255)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: videoView, attribute: .width, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: videoView, attribute: .height, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: videoView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: videoView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        if let name = videoName {
            guard let path = Bundle.main.path(forResource: name, ofType:"mp4") else {
                debugPrint("video.m4v not found")
                return
            }
            
            imageView.isHidden = true
            smallVideoPlayerViewController.showsPlaybackControls = false
            smallVideoPlayerViewController.player = AVPlayer(url: URL(fileURLWithPath: path))
            videoView.addSubview(smallVideoPlayerViewController.view)
            smallVideoPlayerViewController.view.frame = videoView.bounds
            smallVideoPlayerViewController.player?.play()
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: smallVideoPlayerViewController.player!.currentItem)
        } else {
            textLabel.text = self.text
            videoView.isHidden = true
            imageView.image = self.image!
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        textLabel.text = self.text
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
