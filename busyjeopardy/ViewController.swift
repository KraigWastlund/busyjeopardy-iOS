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
    let categoryTitlesView = CategoryTitlesView()
    var jeopardyCollectionView: UICollectionView!
    
    var currentTeam: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        jeopardyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        jeopardyCollectionView.delegate = self
        jeopardyCollectionView.dataSource = self
        
        scoreBoard.team1View.nc = navigationController
        scoreBoard.team2View.nc = navigationController
        scoreBoard.team3View.nc = navigationController
        scoreBoard.team4View.nc = navigationController
        
        jeopardyCollectionView.register(JeopardyCollectionCell.self, forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ((self.jeopardyCollectionView.frame.size.width - 10) / 6), height: ((self.jeopardyCollectionView.frame.size.height - 10) / 6))
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        self.jeopardyCollectionView.collectionViewLayout = layout
    }

    private func configureSubviews() {
        scoreBoard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreBoard)
        
        categoryTitlesView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categoryTitlesView)
        
        jeopardyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(jeopardyCollectionView)
        
        let views = [ "score": self.scoreBoard, "cat": categoryTitlesView, "coll": jeopardyCollectionView ] as [String : Any]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[score]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cat]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[coll]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[score(200)][cat(100)][coll]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        categoryTitlesView.titleLabel1.text = Questions.cat1Title
        categoryTitlesView.titleLabel2.text = Questions.cat2Title
        categoryTitlesView.titleLabel3.text = Questions.cat3Title
        categoryTitlesView.titleLabel4.text = Questions.cat4Title
        categoryTitlesView.titleLabel5.text = Questions.cat5Title
        categoryTitlesView.titleLabel6.text = Questions.cat6Title
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! JeopardyCollectionCell
        
        if cell.userDidSelect == true {
            return
        }
        
        var category: String!
        var points: String!
        if indexPath.row < 6 {
            category = categoryTitlesView.titleLabel1.text
            points = "100"
        } else if indexPath.row < 12 {
            category = categoryTitlesView.titleLabel2.text
            points = "200"
        } else if indexPath.row < 18 {
            category = categoryTitlesView.titleLabel3.text
            points = "300"
        } else if indexPath.row < 24 {
            category = categoryTitlesView.titleLabel4.text
            points = "400"
        } else if indexPath.row < 30 {
            category = categoryTitlesView.titleLabel5.text
            points = "500"
        } else {
            category = categoryTitlesView.titleLabel6.text
            points = "600"
        }
        let msg = "Category: \(category!) \n Points: \(points!)"
        let alert = UIAlertController(title: "You sure?", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default) { (alert: UIAlertAction) in
            cell.userDidSelect = true
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(alert, animated:true, completion: nil)
    }
}

extension ViewController: JeopardyCollectionCellSelectionDelegate {
    
    func didSelect(x: Int, y: Int) {
        print("x: \(x) y: \(y)")
        let (question, image, url) = Questions.getQuestionAndOptionalImageAndVideoURL(forX: x, forY: y)
        print(question)
        
        if image != nil || url != nil {
            let vc = MediaQuestionPresentationViewController()
            vc.delegate = self
            vc.text = question
            vc.points = y
            vc.image = image
            vc.videoURL = url
            let nc = UINavigationController(rootViewController: vc)
            nc.isNavigationBarHidden = true
            self.present(nc, animated: true, completion: nil)
        } else {
            let vc = TextQuestionPresentationViewController()
            vc.delegate = self
            vc.points = y
            vc.text = question
            let nc = UINavigationController(rootViewController: vc)
            nc.isNavigationBarHidden = true
            self.present(nc, animated: true, completion: nil)
        }
    }
}

extension ViewController: QuestionPresentationEnded {
    func didEnd(points: Int) {
        
        let alert = UIAlertController(title: "Correct?", message: "Did they get it right?", preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default) { [weak self] (alert: UIAlertAction) in
            var p: Int = 0
            switch points {
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
                self?.scoreBoard.team1View.points = "\(p)"
            case 1:
                self?.scoreBoard.team2View.points = "\(p)"
            case 2:
                self?.scoreBoard.team3View.points = "\(p)"
            case 3:
                self?.scoreBoard.team4View.points = "\(p)"
            default:
                assert(false)
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(alert, animated:true, completion: nil)
    }
}

protocol JeopardyCollectionCellSelectionDelegate: class {
    func didSelect(x: Int, y: Int)
}

class JeopardyCollectionCell: UICollectionViewCell {
    
    private let label = UILabel()
    private let selectionColor: UIColor = BSYColor.c8
    
    var x: Int!
    var y: Int!
    
    weak var selectionDelegate: JeopardyCollectionCellSelectionDelegate?
    
    var userDidSelect: Bool? {
        didSet {
            if label.backgroundColor != selectionColor {
                self.selectionDelegate?.didSelect(x: self.x, y: self.y)
            }
            if userDidSelect == true {
                label.backgroundColor = selectionColor
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
        addSubview(titleLabel1)
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel2)
        titleLabel3.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel3)
        titleLabel4.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel4)
        titleLabel5.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel5)
        titleLabel6.translatesAutoresizingMaskIntoConstraints = false
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
        backgroundColor = BSYColor.c8
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
}

import AVKit

protocol QuestionPresentationEnded: class {
    func didEnd(points: Int)
}

class TextQuestionPresentationViewController: UIViewController {
    
    private let textLabel = UILabel()
    private let timerLabel = UILabel()
    private var timer: Timer!
    
    weak var delegate: QuestionPresentationEnded!
    var points: Int!

    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var countdown = 5
        self.timerLabel.text = "\(countdown)"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer: Timer) in
            countdown -= 1
            self?.timerLabel.text = "\(countdown)"
            if countdown == 0 {
                self?.navigationController?.dismiss(animated: true, completion: nil)
                self?.delegate.didEnd(points: (self?.points)!)
            }
        })
        
        self.view.backgroundColor = .white
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = UIFont.systemFont(ofSize: 72, weight: .light)
        
        timerLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        timerLabel.textColor = .white
        timerLabel.backgroundColor = BSYColor.c8
        timerLabel.textAlignment = .center
        
        self.view.addSubview(textLabel)
        self.view.addSubview(timerLabel)
        
        let views = [ "text": textLabel ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[text]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100))
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100))
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        self.view.bringSubview(toFront: timerLabel)
        
        textLabel.text = self.text
    }
}

class MediaQuestionPresentationViewController: UIViewController {
    
    private let smallVideoPlayerViewController = AVPlayerViewController()
    
    private let videoView = UIView()
    private let textLabel = UILabel()
    private let imageView = UIImageView()
    private let timerLabel = UILabel()
    private var timer: Timer!
    
    weak var delegate: QuestionPresentationEnded!
    var points: Int!
    
    var videoURL: String?
    var image: UIImage?
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image == nil {
            assert(videoURL != nil)
        }
        
        var countdown = 5
        self.timerLabel.text = "\(countdown)"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer: Timer) in
            countdown -= 1
            self?.timerLabel.text = "\(countdown)"
            if countdown == 0 {
                self?.navigationController?.dismiss(animated: true, completion: nil)
                self?.delegate.didEnd(points: (self?.points)!)
            }
        })

        self.view.backgroundColor = .white
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = UIFont.systemFont(ofSize: 36, weight: .light)
        
        timerLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        timerLabel.textColor = .white
        timerLabel.backgroundColor = BSYColor.c8
        timerLabel.textAlignment = .center
        
        self.view.addSubview(videoView)
        self.view.addSubview(textLabel)
        self.view.addSubview(imageView)
        self.view.addSubview(timerLabel)
        
        let views = [ "video": videoView, "text": textLabel ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[video]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[video][text(255)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: videoView, attribute: .width, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: videoView, attribute: .height, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: videoView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: videoView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100))
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100))
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .right, relatedBy: .equal, toItem: videoView, attribute: .right, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: timerLabel, attribute: .top, relatedBy: .equal, toItem: videoView, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        self.view.bringSubview(toFront: timerLabel)
        
        textLabel.text = self.text
        
        if let url = videoURL {
            imageView.isHidden = true
            smallVideoPlayerViewController.showsPlaybackControls = false
            smallVideoPlayerViewController.player = AVPlayer(url: URL(fileURLWithPath: url))
            
            videoView.addSubview(smallVideoPlayerViewController.view)
            
            smallVideoPlayerViewController.view.frame = videoView.bounds
            
            smallVideoPlayerViewController.player?.play()
        } else {
            videoView.isHidden = true
            imageView.image = self.image!
        }
    }
}
