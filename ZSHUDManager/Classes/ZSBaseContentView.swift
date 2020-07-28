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
        self.backgroundColor =  ZSHUDManager.shared().config.bgColor
        layer.cornerRadius = 5.0
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.2
        self.alpha = 0
        let mainLabel = UILabel()
        mainLabel.textAlignment = .center
        mainLabel.lineBreakMode = .byCharWrapping
        mainLabel.textColor = ZSHUDManager.shared().config.tipColor
        mainLabel.font = ZSHUDManager.shared().config.tipFont
        addSubview(mainLabel)
        mainLabel.preferredMaxLayoutWidth = ZSHUDManager.shared().config.textMaxWidth
        mainLabel.numberOfLines = 0
        self.mainLabel = mainLabel
        
        let subLabel = UILabel()
        subLabel.lineBreakMode = .byCharWrapping
        subLabel.textAlignment = .center
        subLabel.textColor = ZSHUDManager.shared().config.subColor
        subLabel.font = ZSHUDManager.shared().config.subFont
        addSubview(subLabel)
        subLabel.preferredMaxLayoutWidth = ZSHUDManager.shared().config.textMaxWidth
        subLabel.numberOfLines = 0
        self.subLabel = subLabel
        
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(ZSHUDManager.shared().config.buttonColor, for: .normal)
        button.titleLabel?.font = ZSHUDManager.shared().config.btFont
        button.layer.borderColor = ZSHUDManager.shared().config.buttonColor.cgColor
        button.layer.borderWidth = 1
        addSubview(button)
        self.button = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetConstraint() {
        setConstraint()
        UIView.animate(withDuration: ZSHUDManager.shared().config.animationTime, animations: {
            self.layoutIfNeeded()
        })
    }
    func setConstraint() {
        self.removeAllAutoLayout()
        let padding = ZSHUDManager.shared().config.padding
        
        if topView != nil {
            if mainLabel?.text?.count == 0 && subLabel?.text?.count == 0 {
                topView?.addConstraint(NSLayoutConstraint.Attribute.centerY, equalTo: self, offset: 0)
            } else {
                topView?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: self, offset: type == .loading ? padding! * 2 : padding!)
            }
            topView?.addConstraint(NSLayoutConstraint.Attribute.centerX, equalTo: self, offset: 0)
        }
        if mainLabel != nil {
            mainLabel?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: topView, fromConstraint: NSLayoutConstraint.Attribute.bottom, offset: padding!)
            mainLabel?.addConstraint(NSLayoutConstraint.Attribute.left, equalTo: self, offset: padding!)
            mainLabel?.addConstraint(NSLayoutConstraint.Attribute.right, equalTo: self, offset: -padding!)
        }
        if subLabel != nil {
            subLabel?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: mainLabel, fromConstraint: NSLayoutConstraint.Attribute.bottom, offset: padding! / 2)
            subLabel?.addConstraint(NSLayoutConstraint.Attribute.left, equalTo: self, offset: padding!)
            subLabel?.addConstraint(NSLayoutConstraint.Attribute.right, equalTo: self, offset: -padding!)
        }
        if type == .loading {
            if button != nil && showCancle {
                button?.isHidden = false
                button?.addConstraint(NSLayoutConstraint.Attribute.top, equalTo: subLabel, fromConstraint: NSLayoutConstraint.Attribute.bottom, offset: padding! / 2)
                button?.addConstraint(NSLayoutConstraint.Attribute.left, equalTo: self, offset: padding!)
                button?.addConstraint(NSLayoutConstraint.Attribute.right, equalTo: self, offset: -padding!)
            }else{
                button?.isHidden = true
            }
        }
        addConstraint(NSLayoutConstraint.Attribute.width, greatOrLess: NSLayoutConstraint.Relation.greaterThanOrEqual, value: ZSHUDManager.shared().config.contentMinWidth)
        addConstraint(NSLayoutConstraint.Attribute.width, greatOrLess: NSLayoutConstraint.Relation.lessThanOrEqual, value: ZSHUDManager.shared().config.contentMaxWidth)
        addConstraint(NSLayoutConstraint.Attribute.height, greatOrLess: NSLayoutConstraint.Relation.greaterThanOrEqual, value: ZSHUDManager.shared().config.contentMinWidth)
        
        
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
            addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: lastView, attribute: .bottom, multiplier: 1.0, constant: padding!))
        }
        
    }
    
    override func didMoveToSuperview() {
        guard self.superview != nil else {
            return
        }
        addConstraint(NSLayoutConstraint.Attribute.centerX, equalTo: superview, offset: 0)
        addConstraint(NSLayoutConstraint.Attribute.centerY, equalTo: superview, offset: 0)


        UIView.animate(withDuration: ZSHUDManager.shared().config.animationTime, animations: {
            self.alpha = ZSHUDManager.shared().config.alpha
        })
    }
    @objc
    func dismiss() {
        UIView.animate(withDuration: ZSHUDManager.shared().config.animationTime, animations: { [weak self] in
            self?.alpha = 0.1
        }) { [weak self] finished in
            self?.removeFromSuperview()
            self?.timer?.invalidate()
            self?.timer = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kZSDismissNotification), object: nil)
        }
        
    }
    deinit {
        print( "\(self)" + "\(#function)")
    }
}
