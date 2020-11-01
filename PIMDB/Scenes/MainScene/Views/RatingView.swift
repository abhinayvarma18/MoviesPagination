//
//  RatingView.swift
//  AliveCorAssignment
//
//  Created by abhinay varma on 31/10/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    var trackBackgroundColor = UIColor(red: 41.0/255.0, green: 68.0/255.0, blue: 43.0/255.0, alpha: 1)
    var trackBorderWidth: CGFloat = 6
    var progressColor = UIColor(red: 98.0/255.0, green: 204.0/255.0, blue: 130.0/255.0, alpha: 1)
    var label = UILabel()
    
    var percent: Double = 0 {
        didSet {
            setNeedsDisplay()
            
            label.textAlignment = .center
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 11)
            addSubview(label)
            
            label.frame = CGRect(x: 10, y: 25, width: 50, height: 20)

            let percentage = Int(percent * 100)
            
            label.text = "\(percentage)%"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .orange
        label.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(label)
        
        label.frame = CGRect(x: 20, y: 30, width: 50, height: 20)

        label.text = "\(percent * 100)%"
        
    }
    
    // Adjust these to meet your needs. 90 degrees is the bottom of the circle
    static let startDegrees: CGFloat = 270
    static let endDegrees: CGFloat = 269

    override func draw(_ rect: CGRect) {
        let startAngle: CGFloat = radians(of: RatingView.startDegrees)
        let endAngle: CGFloat = radians(of: RatingView.endDegrees)
        let progressAngle = radians(of: RatingView.startDegrees + (360 - RatingView.startDegrees + RatingView.endDegrees) * CGFloat(max(0.0, min(percent, 1.0))))

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(center.x, center.y) - trackBorderWidth / 2 - 10

       // print(startAngle, endAngle, progressAngle)
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: progressAngle, clockwise: true)
        trackPath.lineWidth = trackBorderWidth
        trackPath.lineCapStyle = .round
        progressPath.lineWidth = trackBorderWidth
        progressPath.lineCapStyle = .round

        trackBackgroundColor.set()
        trackPath.stroke()

        progressColor.set()
        progressPath.stroke()
    }

    private func radians(of degrees: CGFloat) -> CGFloat {
        return degrees / 180 * .pi
    }
    
}

