//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Viranchee L on 30/12/19.
//  Copyright © 2019 Viranchee L. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    let avPlayer = AVPlayer()
    let item = AVPlayerItem(url: Constants.videoUrl)
    let playerPreviewView = PlayerPreviewView(frame: .zero)
    let avPlayerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        view.addSubview(playerPreviewView)
        playerPreviewView.backgroundColor = .red
        playerPreviewView.pinToSuperview(forAtrributes: [.leading,.trailing, .top, .bottom], multiplier: 1, constant: 0)
        setupLayer()
    }

    func setupLayer() {
        playerPreviewView.player = avPlayer
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.actionAtItemEnd = .pause
        avPlayer.play()
    }

}

enum Constants {
    static let videoUrl = URL(string: "http://d1jyuin3zbc42n.cloudfront.net/reaction/dade4944-126c-4e33-8b97-6c09dbeba832.mp4")!
}

// This class is created for AVPlayer frame adjustment
final class PlayerPreviewView: UIView {
    
    /// AVPlayer
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }

        set {
            playerLayer.player = newValue
        }
    }
    
    /// Player Layer
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
        
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspectFill
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playerLayer.videoGravity = .resizeAspectFill
    }
}


// swiftlint:disable function_parameter_count
// The below code is copy pasted from RayWenderlich's tutorial, specifically Lea Marolt Sonneschein's tutorial Customizing TableViews, which can be found in one of RWDevCon18 videos
// MARK: NSLayoutConstraint Convenience methods
extension NSLayoutConstraint {
    
    // Pins an attribute of a view to an attribute of another view
    static func pinning(view: UIView, attribute: NSLayoutConstraint.Attribute, toView: UIView?, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: toView, attribute: toAttribute, multiplier: multiplier, constant: constant)
    }
    
    // Pins an array of NSLayoutAttributes of a view to a specific view (has to respect view tree hierarchy)
    static func pinning(view: UIView, toView: UIView?, attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        return attributes.compactMap({ (attribute) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: toView, attribute: attribute, multiplier: multiplier, constant: constant)
        })
    }
    
    // Pins bottom, top, leading and trailing of a view to a specific view (has to respect view tree hierarchy)
    static func pinningEdges(view: UIView, toView: UIView?) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        return NSLayoutConstraint.pinning(view: view, toView: toView, attributes: attributes, multiplier: 1.0, constant: 1.0)
    }
    
    // Pins bottom, top, leading and trailing of a view to its superview
    static func pinningEdgesToSuperview(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.pinningEdges(view: view, toView: view.superview)
    }
    
    // Pins specified attribute to superview with specified or default multiplier and constant
    static func pinningToSuperview(view: UIView, attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.pinning(view: view, toView: view.superview, attributes: attributes, multiplier: multiplier, constant: constant)
    }
}

// MARK: UIView Convenience methods
extension UIView {
    
    func pinEdgesToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinningEdgesToSuperview(view: self)
        superview.addConstraints(constraints)
    }
    
    func pinToSuperview(forAtrributes attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinningToSuperview(view: self, attributes: attributes, multiplier: multiplier, constant: constant)
        superview.addConstraints(constraints)
    }
    
    func pin(toView: UIView, attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinning(view: self, toView: toView, attributes: attributes, multiplier: multiplier, constant: constant)
        superview.addConstraints(constraints)
    }
    
    func pin(attribute: NSLayoutConstraint.Attribute, toView: UIView?, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraint = NSLayoutConstraint.pinning(view: self, attribute: attribute, toView: toView, toAttribute: toAttribute, multiplier: multiplier, constant: constant)
        superview.addConstraint(constraint)
    }
}
