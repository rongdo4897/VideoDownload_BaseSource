//
//  CircularProgressBar.swift
//  Progress
//
//  Created by NiravPatel on 12/06/19.
//  Copyright © 2019 NiravPatel. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    var currentTime:Double = 0
    var previousProgress:Double = 0
    // MARK: awakeFromNib

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
        labelPercent.text = "%"
    }
    // MARK: Public
    public var lineWidth: CGFloat = 3 {
        didSet {
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }

    public var labelSize: CGFloat = 12 {
        didSet {
            label.font = Defined.fontWithSize(name: Constants.ralewayRegular, size: labelSize)
            label.sizeToFit()
            configLabel()
        }
    }

    public var labelPercentSize: CGFloat = 12 {
        didSet {
            labelPercent.font = Defined.fontWithSize(name: Constants.ralewayRegular, size: labelPercentSize)
            labelPercent.sizeToFit()
            configLabelPercent()
        }
    }

    public var safePercent: Int = 100 {
        didSet {
            setForegroundLayerColorForSafePercent()
        }
    }

    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        var progress: Double {
            get {
                if progressConstant > 1 {return 1} else if progressConstant < 0 {return 0} else { return progressConstant }
            }
        }

        foregroundLayer.strokeEnd = CGFloat(progress)
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = previousProgress
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
        }

        previousProgress = progress
        currentTime = 0
        DispatchQueue.main.async {
            self.label.text = "\(Int(progress * 100))"
            self.setForegroundLayerColorForSafePercent()
            self.configLabel()
            self.configLabelPercent()
        }
    }
    // MARK: Private
    private var label = UILabel()
    private var labelPercent = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let pulsatingLayer = CAShapeLayer()
    private var radius: CGFloat {
        get {
            if self.frame.width < self.frame.height {return (self.frame.width - lineWidth)/2} else { return (self.frame.height - lineWidth)/2}
        }
    }

    private var pathCenter: CGPoint {get { return self.convert(self.center, from:self.superview)}}
    private func makeBar() {
        self.layer.sublayers = nil
        drawPulsatingLayer()
        self.animatePulsatingLayer()
        drawBackgroundLayer()
        drawForegroundLayer()
    }

    private func drawBackgroundLayer() {
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.backgroundLayer.lineWidth = lineWidth
        self.backgroundLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.addSublayer(backgroundLayer)
    }

    private func drawForegroundLayer() {
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        foregroundLayer.strokeEnd = 0
        self.layer.addSublayer(foregroundLayer)

    }
    private func drawPulsatingLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        pulsatingLayer.lineWidth = lineWidth
        pulsatingLayer.fillColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = pathCenter
        // self.layer.addSublayer(pulsatingLayer)
    }

    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }

    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = Defined.fontWithSize(name: Constants.ralewayRegular, size: labelSize)
        label.sizeToFit()
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y - 10)
        return label
    }

    private func makeLabelPercent(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = Defined.fontWithSize(name: Constants.ralewayRegular, size: labelPercentSize)
        label.sizeToFit()
        label.textColor = UIColor.white
        label.center = CGPoint(x: pathCenter.x + (label.frame.size.width/2) + 10, y: pathCenter.y - 15)
        return label
    }

    private func configLabel() {
        label.textColor = #colorLiteral(red: 0.06306586415, green: 0.243198514, blue: 0.3424732685, alpha: 1)
        label.sizeToFit()
        if previousProgress < 0.1 {
            label.center = CGPoint(x: pathCenter.x - 7, y: pathCenter.y )
        } else if previousProgress >= 0.1  && previousProgress < 0.2 {
            label.center = CGPoint(x: pathCenter.x - 8, y: pathCenter.y )
        } else if previousProgress >= 0.2  && previousProgress < 1 {
            label.center = CGPoint(x: pathCenter.x - 9, y: pathCenter.y )
        } else {
            label.center = CGPoint(x: pathCenter.x - 10, y: pathCenter.y )
        }
    }

    private func configLabelPercent() {
        labelPercent.textColor = #colorLiteral(red: 0.06306586415, green: 0.243198514, blue: 0.3424732685, alpha: 1)
        labelPercent.sizeToFit()
        if previousProgress < 0.1 {
            labelPercent.center = CGPoint(x: pathCenter.x + 7 , y: pathCenter.y)
        } else if previousProgress >= 0.1 && previousProgress < 0.2 {
            labelPercent.center = CGPoint(x: pathCenter.x + 8 , y: pathCenter.y)
        } else if previousProgress >= 0.2  && previousProgress < 1 {
            labelPercent.center = CGPoint(x: pathCenter.x + 9 , y: pathCenter.y)
        } else {
            labelPercent.center = CGPoint(x: pathCenter.x + 10 , y: pathCenter.y)
        }
    }

    private func setForegroundLayerColorForSafePercent() {
        self.foregroundLayer.strokeColor = #colorLiteral(red: 0.09183641523, green: 0.73603338, blue: 0.6131522059, alpha: 1)
    }

    private func setupView() {
        makeBar()
        self.addSubview(label)
        self.addSubview(labelPercent)
    }
    // Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
}
