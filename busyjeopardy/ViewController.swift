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

    override func viewDidLoad() {
        super.viewDidLoad()
        jeopardyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        jeopardyCollectionView.delegate = self
        jeopardyCollectionView.dataSource = self
        
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
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! JeopardyCollectionCell
        cell.isSelected = false
    }
}

extension ViewController: JeopardyCollectionCellSelectionDelegate {
    
    func didSelect(x: Int, y: Int) {
        print("x: \(x) y: \(y)")
        let (question, image, url) = Questions.getQuestionAndOptionalImageAndVideoURL(forX: x, forY: y)
        print(question)
        let vc = TestViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        self.present(nc, animated: true, completion: nil)
    }
}

protocol JeopardyCollectionCellSelectionDelegate: class {
    func didSelect(x: Int, y: Int)
}

class JeopardyCollectionCell: UICollectionViewCell {
    
    private let label = UILabel()
    private let selectionColor: UIColor = .yellow
    
    var x: Int!
    var y: Int!
    
    weak var selectionDelegate: JeopardyCollectionCellSelectionDelegate?
    
    override var isSelected: Bool {
        didSet {
            if label.backgroundColor != selectionColor {
                self.selectionDelegate?.didSelect(x: self.x, y: self.y)
            }
            if isSelected == true {
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
        
        backgroundColor = .lightGray
        
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
        titleLabel1.text = "Category 1"
        addSubview(titleLabel1)
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.text = "Category 2"
        addSubview(titleLabel2)
        titleLabel3.translatesAutoresizingMaskIntoConstraints = false
        titleLabel3.text = "Category 3"
        addSubview(titleLabel3)
        titleLabel4.translatesAutoresizingMaskIntoConstraints = false
        titleLabel4.text = "Category 4"
        addSubview(titleLabel4)
        titleLabel5.translatesAutoresizingMaskIntoConstraints = false
        titleLabel5.text = "Category 5"
        addSubview(titleLabel5)
        titleLabel6.translatesAutoresizingMaskIntoConstraints = false
        titleLabel6.text = "Category 6"
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
        backgroundColor = .green
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
}

import AVKit

class QuestionPresentationViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    
    private let imageView = UIImageView()
    private let videoPlayer = AVPlayerViewController()
    private let questionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configure()
    }
    
    private func configure() {
        
        
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let layer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(layer)
        player.play()
//        videoPlayer.player = player
//        self.present(videoPlayer, animated: false) {
//            self.videoPlayer.player!.play()
//        }
    }
    
}

class TestViewController: UIViewController {
    
    let smallVideoPlayerViewController = AVPlayerViewController()
    
    var videoView = UIView()
    var textView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.backgroundColor = .white
        textView.textAlignment = .center
        textView.numberOfLines = 0
        textView.lineBreakMode = .byWordWrapping
        textView.font = UIFont.systemFont(ofSize: 36, weight: .light)
        
        self.view.addSubview(videoView)
        self.view.addSubview(textView)
        
        let views = [ "video": videoView, "text": textView ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[video]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[text]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[video][text(200)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        textView.text = "After destroying Starkiller base and being pursued relentlessly by the First Order, the Resistance prepared to make a last stand on the planet of Crait, which is covered in a layer of this substance."
        
        let videoUrl = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
        smallVideoPlayerViewController.showsPlaybackControls = false
        smallVideoPlayerViewController.player = AVPlayer(url: videoUrl)
        
        videoView.addSubview(smallVideoPlayerViewController.view)
        
        smallVideoPlayerViewController.view.frame = videoView.bounds
        
        smallVideoPlayerViewController.player?.play()
    }
}
