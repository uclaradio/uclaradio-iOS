//
//  ViewController.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 4/26/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import UIKit
import MediaPlayer

protocol NowPlayingActionDelegate {
    func didTapShow(_ show: Show?)
}

class NowPlayingViewController: UIViewController{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlsParentView: UIView!
    //@IBOutlet weak var pullTabImageView: UIImageView!
    
    //weak var pullTabImageView: UIImageView!
    
    var nowPlayingView: NowPlayingView!
    //weak var sliderDelegate: SlidingVCDelegate?
    
    var actionDelegate: NowPlayingActionDelegate?
    fileprivate var nowPlaying: Show?
    
    fileprivate var tapGesture: UITapGestureRecognizer?
    private var lastOpenPercentage: CGFloat?
    
    //var slider: SlidingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        imageView.image = UIImage(named: "radio_banner")
        
        nowPlayingView = NowPlayingView(canSkipStream: true)
        nowPlayingView.translatesAutoresizingMaskIntoConstraints = false
        controlsParentView.addSubview(nowPlayingView)
        
        let volumeView = MPVolumeView()
        controlsParentView.addSubview(volumeView)
        controlsParentView.backgroundColor = UIColor.clear
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.setVolumeThumbImage(UIImage(named: "volumeSlider")?.imageWithColor(UIColor.white), for: UIControlState())
        volumeView.setRouteButtonImage(UIImage(named: "airplayIcon")?.imageWithColor(UIColor.white), for: UIControlState())
        volumeView.tintColor = UIColor.white
        
        let controlsViews: [String: UIView] = ["nowPlaying": nowPlayingView, "volume": volumeView]
        controlsParentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nowPlaying]-[volume(30)]|", options: [], metrics: nil, views: controlsViews))
        controlsParentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[nowPlaying]-|", options: [], metrics: nil, views: controlsViews))
        controlsParentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[volume]-(40)-|", options: [], metrics: nil, views: controlsViews))
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tapGesture!)
        
        // pull tab
//        pullTabImageView.image = UIImage(named: "pull_tab")
//        pullTabImageView.isUserInteractionEnabled = true
//        pullTabImageView.tintColor = UIColor.white
//        let pullTabTap = UITapGestureRecognizer(target: self, action: #selector(didTapPullTab))
//        pullTabImageView.addGestureRecognizer(pullTabTap)
        
        
        
        // call buttons (programmed, not storyboard)
        // in order to user autolayout instead of annoying math calcs, just need to set some anchors on button objects
        

        let onAirButton = UIButton(frame: CGRect(x: self.containerView.frame.size.width-350.0, y: self.containerView.frame.size.height-50.0, width: 150.0, height: 75.0))
        onAirButton.setTitle("On Air", for: .normal)
        onAirButton.setTitleColor(UIColor.black, for: .normal)
        onAirButton.backgroundColor = UIColor.white
        onAirButton.titleLabel?.font = UIFont(name: Constants.Fonts.titleBold, size: 31)
        onAirButton.titleLabel?.textAlignment = .center
        onAirButton.addTarget(self, action: #selector(didTapOnAirCallButton(_:)), for: .touchUpInside)
       
        let requestButton = UIButton(frame: CGRect(x: 50.0, y: self.containerView.frame.size.height-100.0, width: 150.0 , height: 75.0))
        requestButton.setTitle("Request", for: .normal)
        requestButton.titleLabel?.font = UIFont(name: Constants.Fonts.titleBold, size: 31)
        requestButton.titleLabel?.textAlignment = .center
        requestButton.backgroundColor = UIColor.white
        requestButton.setTitleColor(UIColor.black, for: .normal)
        requestButton.addTarget(self, action: #selector(didTapRequestCallButton(_:)), for: .touchUpInside)
        
        var callButtonArray: [UIView] = []
        callButtonArray.append(onAirButton)
        callButtonArray.append(requestButton)
        
        
        let stackView = UIStackView(arrangedSubviews: callButtonArray)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        containerView.addSubview(stackView)
        
        // constraints for call button array
        stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100).isActive = true
        stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: containerView.frame.height/8).isActive = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingView.willAppear()
        styleFromNowPlaying(RadioAPI.nowPlaying)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingUpdated), name: NSNotification.Name(rawValue: RadioAPI.NowPlayingUpdatedNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nowPlayingView.willDisappear()

        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleFromNowPlaying(_ nowPlaying: Show?) {
        if let nowPlaying = nowPlaying, let picture = nowPlaying.picture {
            imageView.sd_setImage(with: RadioAPI.absoluteURL(picture), placeholderImage: UIImage(named: "radio_banner"))
        }
        else {
            imageView.image = UIImage(named: "radio_banner")
        }
        self.nowPlaying = nowPlaying
    }
    
    // Call Button
    let onAirNumber = "3107949348"
    let requestNumber = "3108259999"
    
    func makeCall(phone: String) {
        let phoneUrl = "tel://\(phone)"
        let url:NSURL = NSURL(string: phoneUrl)!
        UIApplication.shared.openURL(url as URL)
    }
    
    @objc func didTapOnAirCallButton(_ gesture: UITapGestureRecognizer) {
        makeCall(phone: onAirNumber)
    }
    
    @objc func didTapRequestCallButton(_ gesture: UITapGestureRecognizer) {
        makeCall(phone: requestNumber)
    }
    
    // Slider
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        actionDelegate?.didTapShow(nowPlaying)
    }
    
//    @objc func didTapPullTab(_ gesture: UITapGestureRecognizer) {
//        actionDelegate?.didTapShow(nil)
//    }
    
    // MARK: - SlidingVCDelegate
    
//    func positionUpdated(_ position: SlidingViewControllerPosition) {
//        if let slider = slider {
//            if (slider.position == .closed) {
//                pullTabImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
//            } else {
//                pullTabImageView.transform = CGAffineTransform.identity
//            }
//        }
//        lastOpenPercentage = nil
//    }
//
//    func openPercentageChanged(_ openPercentage: CGFloat) {
//        if let lastOpenPercentage = lastOpenPercentage {
//            if (openPercentage < lastOpenPercentage) {
//                pullTabImageView.transform = CGAffineTransform.identity
//            } else {
//                pullTabImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
//            }
//        }
//        lastOpenPercentage = openPercentage
//    }
    
    // MARK: - Radio APIFetchDelegate
    
    @objc func nowPlayingUpdated(_ notification: Notification) {
        styleFromNowPlaying(RadioAPI.nowPlaying)
    }
    
    // Timers
    
    func updateTick() {
        RadioAPI.fetchNowPlaying()
    }
    
}

