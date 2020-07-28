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
    func image(name:String,type:String) -> UIImage? {
        let mainBundlePath = Bundle.main.bundlePath
        var bundlePath = "\(mainBundlePath)/\("ZSProgressHUD.bundle")"
        var bundle = Bundle(path: bundlePath)
        if bundle == nil {
            bundlePath = "\(mainBundlePath)/\("Frameworks/ZSHUDManager.framework/ZSProgressHUD.bundle")"
            bundle = Bundle(path: bundlePath)
        }
        if UIImage.responds(to: #selector(UIImage.init(named:in:compatibleWith:))) {
            return UIImage(named: name , in: bundle, compatibleWith: nil)
        } else {
            
            if let path = bundle?.path(forResource: name, ofType: type) {
                return UIImage(contentsOfFile: path)
            }else{
                return nil
            }
            
        }
    }
    func getImageName(type:ZSMsgType) -> String {
        var pathString = ""
        switch type {
        case .done:
            pathString = "success"
            break
        case .fail:
            pathString = "fail"
            break
        case .warning:
            pathString = "warning"
            break
        case .default:
            pathString = "tip"
            break
        }
        return pathString
    }
    func setImageView(type:ZSMsgType) {
        
        let pathString = getImageName(type: type)
        
        let iconImageView = UIImageView()
        iconImageView.image = image(name: pathString, type: "png")
        iconImageView.tintColor = ZSHUDManager.shared().config.imageColor
        self.addSubview(iconImageView)
        self.topView = iconImageView
        self.setConstraint()
    }
    func creatTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: TimeInterval(ZSHUDManager.shared().config.messageDelay), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.default)
    }
    func setMsg(_ msg: String?, type: ZSMsgType) {
        
        let pathString = getImageName(type: type)
        
        if let imageIV:UIImageView = topView as? UIImageView , let image = image(name: pathString, type: "png")?.withRenderingMode(.alwaysTemplate){
            
            imageIV.image  = image
            mainLabel?.text = msg
            self.setConstraint()
            UIView.animate(withDuration: TimeInterval(ZSHUDManager.shared().config.animationTime)) {
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
            UIView.animate(withDuration: ZSHUDManager.shared().config.animationTime) {
                self.layoutIfNeeded()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + ZSHUDManager.shared().config.messageDelay) { [weak self] in
                self?.topView?.removeFromSuperview()
                self?.type = .loading
                if oldView != nil {
                    self?.addSubview(oldView!)
                }
                
                if (oldView is UIImageView) {
                    (oldView as? UIImageView)?.startAnimating()
                }
                self?.topView = oldView
                self?.mainLabel?.text = oldMsg
                self?.subLabel?.isHidden = false
                self?.button?.isHidden = false
                self?.setConstraint()
                if complete != nil {
                    complete!()
                }
            }
            
            
            
        }
    }
    
    
}
