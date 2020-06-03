//
//  ZSBaseContentView.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit

class ZSBaseContentView: UIView {

    var type: ZSContentViewType?
    weak var topView: UIView?
    weak var mainLabel: UILabel?
    weak var subLabel: UILabel?
    var button: UIButton?
    var showCancle = false
    var timer: Timer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  ZSHEXCOLOR(kZSDminantColor)
        layer.cornerRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        self.alpha = 0
        
        let mainLabel = UILabel()
        mainLabel.textAlignment = .center
        mainLabel.lineBreakMode = .byCharWrapping
        mainLabel.textColor = ZSHEXCOLOR(kZSTextColor)
        mainLabel.font = UIFont.systemFont(ofSize: kZSDefaultTipFontSize)
        addSubview(mainLabel)
        mainLabel.preferredMaxLayoutWidth = kZSMaxTextWidth
        mainLabel.numberOfLines = 0
        self.mainLabel = mainLabel
        
        let subLabel = UILabel()
        subLabel.lineBreakMode = .byCharWrapping
        subLabel.textAlignment = .center
        subLabel.textColor = ZSHEXCOLOR(kZSTextColor)
        subLabel.font = UIFont.systemFont(ofSize: kZSDefaultSubFontSize)
        addSubview(subLabel)
        subLabel.preferredMaxLayoutWidth = kZSMaxTextWidth
        subLabel.numberOfLines = 0
        self.subLabel = subLabel
        
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(ZSHEXCOLOR(kZSTextColor), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: kZSDefaultSubFontSize)
        button.layer.borderColor = ZSHEXCOLOR(kZSTextColor).cgColor
        button.layer.borderWidth = 1
        addSubview(button)
        self.button = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetConstraint() {
        setConstraint()
        UIView.animate(withDuration: TimeInterval(kZSDefaultAnimationTime), animations: {
            self.layoutIfNeeded()
        })
    }
    func setConstraint() {
        self.removeAllAutoLayout()
        if topView != nil {
            if mainLabel?.text?.count == 0 && subLabel?.text?.count == 0 {
                topView?.addConstraint(NSLayoutConstraint.Attribute.centerY, equalTo: self, offset: 0)
            } else {
                topView?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: self, offset: type == .loading ? kZSPadding * 2 : kZSPadding)
            }
            topView?.addConstraint(NSLayoutConstraint.Attribute.centerX, equalTo: self, offset: 0)
        }
        if mainLabel != nil {
            mainLabel?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: topView, fromConstraint: NSLayoutConstraint.Attribute.bottom, offset: kZSPadding)
            mainLabel?.addConstraint(NSLayoutConstraint.Attribute.left, equalTo: self, offset: kZSPadding)
            mainLabel?.addConstraint(NSLayoutConstraint.Attribute.right, equalTo: self, offset: -kZSPadding)
        }
        if subLabel != nil {
            subLabel?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: mainLabel, fromConstraint: NSLayoutConstraint.Attribute.bottom, offset: kZSPadding / 2)
            subLabel?.addConstraint(NSLayoutConstraint.Attribute.left, equalTo: self, offset: kZSPadding)
            subLabel?.addConstraint(NSLayoutConstraint.Attribute.right, equalTo: self, offset: -kZSPadding)
        }
        if type == .loading {
            if button != nil && showCancle {
                button?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: subLabel, fromConstraint: NSLayoutConstraint.Attribute.bottom, offset: kZSPadding / 2)
                button?.addConstraint(NSLayoutConstraint.Attribute.left, equalTo: self, offset: kZSPadding)
                button?.addConstraint(NSLayoutConstraint.Attribute.right, equalTo: self, offset: -kZSPadding)
            }
        }
        addConstraint(NSLayoutConstraint.Attribute.width, greatOrLess: NSLayoutConstraint.Relation.greaterThanOrEqual, value: kZSContentMinWidth)
        addConstraint(NSLayoutConstraint.Attribute.width, greatOrLess: NSLayoutConstraint.Relation.lessThanOrEqual, value: kZSContentMaxWidth)
        addConstraint(NSLayoutConstraint.Attribute.height, greatOrLess: NSLayoutConstraint.Relation.greaterThanOrEqual, value: kZSContentMinWidth)
        
        
        var lastView = topView
        if let mainLength = mainLabel?.text?.count,mainLength>0 {
            lastView = mainLabel
        }
        if let subLength = subLabel?.text?.count,subLength>0 {
            lastView = subLabel
        }
      
        if type == .loading && showCancle {
            lastView = button
        }

        if lastView != topView {
            addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: lastView, attribute: .bottom, multiplier: 1.0, constant: kZSPadding))
        }
        
    }
    
    override func didMoveToSuperview() {
        guard self.superview != nil else {
            return
        }
        addConstraint(NSLayoutConstraint.Attribute.centerX, equalTo: superview, offset: 0)
        addConstraint(NSLayoutConstraint.Attribute.centerY, equalTo: superview, offset: 0)


        UIView.animate(withDuration: TimeInterval(kZSDefaultAnimationTime), animations: {
            self.alpha = kZSDefaultAlpha
        })
    }
    @objc
    func dismiss() {
        UIView.animate(withDuration: TimeInterval(kZSDefaultAnimationTime), animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] finished in
            self?.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kZSDismissNotification), object: nil)
        }
    }
}
