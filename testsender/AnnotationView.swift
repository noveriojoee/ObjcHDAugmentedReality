//
//  AnnotationView.swift
//  testsender
//
//  Created by Noverio Joe on 20/04/18.
//  Copyright © 2018 ocbcnisp. All rights reserved.
//

import UIKit


@objc public protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}

public class AnnotationView: ARAnnotationView {
    @objc public var titleLabel: UILabel?
    @objc public var distanceLabel: UILabel?
    @objc public var delegate: AnnotationViewDelegate?
    
    @objc override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loadUI()
    }
    
    //1
    @objc override public func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width, height: 30)
        distanceLabel?.frame = CGRect(x: 10, y: 30, width: self.frame.size.width, height: 20)
    }
    
    //2
    @objc override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
    
    //4
    @objc public func loadUI() {
        titleLabel?.removeFromSuperview()
        distanceLabel?.removeFromSuperview()
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width, height: 30))
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        label.textColor = UIColor.white
        self.addSubview(label)
        self.titleLabel = label
        
        distanceLabel = UILabel(frame: CGRect(x: 10, y: 30, width: self.frame.size.width, height: 20))
        distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        distanceLabel?.textColor = UIColor.green
        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(distanceLabel!)
        
        if let annotation = annotation as? Place {
            titleLabel?.text = annotation.placeName
            distanceLabel?.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
        }
    }
}
