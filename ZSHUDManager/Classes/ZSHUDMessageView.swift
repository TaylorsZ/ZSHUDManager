//
//  ZSHUDMessageView.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit

extension ZSBaseContentView {
    
    func start(msg:String?,type:ZSMsgType) {
        
        self.type = .message
        mainLabel?.text = msg
        setImageView(type: type)
        creatTimer()
        
    }
    func imageWithName(_ name:String) -> UIImage? {
        var image = UIImage(named: name)
        if image == nil {
            let path = Bundle.init(for: ZSHUDManager.self)
            image = UIImage(named: name, in: path, compatibleWith: nil)
        }
        return image
    }
    func getImageName(type:ZSMsgType) -> String {
        var pathString = ""
        switch type {
        case .done:
            pathString = "ZSProgressHUD.bundle/done"
        case .fail:
            pathString = "ZSProgressHUD.bundle/fail"
        case .warning:
            pathString = "ZSProgressHUD.bundle/warning"
        case .default:
            pathString = "ZSProgressHUD.bundle/done"
        }
        return pathString
    }
    func setImageView(type:ZSMsgType) {
        
        let pathString = getImageName(type: type)
        
        let iconImageView = UIImageView()
        iconImageView.image = imageWithName(pathString)
        iconImageView.tintColor = ZSHEXCOLOR(kZSImageColor)
        self.addSubview(iconImageView)
        self.topView = iconImageView
        self.setConstraint()
    }
    func creatTimer() {
        timer?.invalidate()
        timer = Timer(timeInterval: TimeInterval(kZSMessageDelayTime), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.default)
    }
    func setMsg(_ msg: String?, type: ZSMsgType) {
        
        let pathString = getImageName(type: type)
        
        if let imageIV:UIImageView = topView as? UIImageView {
            
            let image = imageWithName(pathString)?.withRenderingMode(.alwaysTemplate)
            imageIV.image  = image
            mainLabel?.text = msg
            self.setConstraint()
            UIView.animate(withDuration: TimeInterval(kZSDefaultAnimationTime)) {
                self.layoutIfNeeded()
            }
            creatTimer()
        }
    }
    func toBeMessage(msg:String?,type:ZSMsgType,complete:(()->())?) {
        if self.type != .message {
            let oldView = topView
            if (oldView is UIImageView) {
                (oldView as? UIImageView)?.stopAnimating()
            }
            let oldMsg = mainLabel?.text
            topView?.removeFromSuperview()
            self.type = .message
            setImageView(type: type)
            mainLabel?.text = msg
            subLabel?.isHidden = true
            button?.isHidden = true
            
            topView?.layoutIfNeeded()
            UIView.animate(withDuration: TimeInterval(kZSDefaultAnimationTime)) {
                self.layoutIfNeeded()
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(kZSMessageDelayTime * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { [unowned self] in
                self.topView?.removeFromSuperview()
                self.type = .loading
                if oldView != nil {
                    self.addSubview(oldView!)
                }
                
                if (oldView is UIImageView) {
                    (oldView as? UIImageView)?.startAnimating()
                }
                self.topView = oldView
                self.mainLabel?.text = oldMsg
                self.subLabel?.isHidden = false
                self.button?.isHidden = false
                self.setConstraint()
                if complete != nil {
                    complete!()
                }
                
            })
            
            
        }
    }
    
    
}
