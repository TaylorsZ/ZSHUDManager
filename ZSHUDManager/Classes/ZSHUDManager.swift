//
//  ZSHUDManager.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit

public let ZSHUD = ZSHUDManager.sharedInstance()


open class ZSHUDManager: NSObject {
    
    private var window:UIWindow?
    private var navWindow:UIWindow!
    private var navBar:UIButton?
    private var firstResponder:UIView?
    private var count:Int = 0
    private var currentView:ZSBaseContentView?
    
    private var complete:(()->())?
    private var cancled:(()->())?
    
    public var config:ZSHUDConfig!
    private static var _sharedInstance: ZSHUDManager?
    
    fileprivate class func sharedInstance() -> ZSHUDManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = ZSHUDManager()
            return _sharedInstance!
        }
        return instance
    }
    //销毁单例对象
    class func destroy() {
        _sharedInstance = nil
    }
    
    override private init() {
        super.init()
        //create window
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.clear
        
        window.windowLevel =  UIWindow.Level.alert + 1
        window.isUserInteractionEnabled = false
        window.rootViewController = ZSBaseProgressViewController()
        self.window = window
        
        let window2 = UIWindow.init(frame: UIScreen.main.bounds)
        window2.makeKeyAndVisible()
        window2.backgroundColor = UIColor.clear
        
        window2.windowLevel =  UIWindow.Level.alert + 2
        window2.isUserInteractionEnabled = false
        window2.rootViewController = ZSBaseProgressViewController()
        self.navWindow = window2
        
        
        
        self.config = ZSHUDConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(dismiss), name: NSNotification.Name.init(kZSDismissNotification), object: nil)
    }
    
    open func changLoadingDismissTime() {
        
    }
    @objc public func dismiss() {
        
        if ZSContentViewType.loading == currentView?.type && count - 1 > 0 {
            count -= 1
//            print("无需关闭, 当前 %@ ：\(count)")
            return
        }
        
        OperationQueue.main.addOperation({ [unowned self] in
            self.window?.isHidden = true
            self.window?.isUserInteractionEnabled = false
            
            if self.currentView != nil {
                self.count = 0
                self.currentView?.dismiss()
                self.currentView = nil
                if self.complete != nil {
                    self.complete!()
                    self.complete = nil
                }
            }
        })
        
        
    }
    open func showLoading() {
        showLoading(tip: nil, sub: nil)
    }
    
    open func showLoading(tip: String?) {
        showLoading(tip: tip, sub: nil)
    }
    
    open func showLoading(tip: String?, sub: String?) {
        showLoading(tip: tip, sub: sub, cancle: nil)
        
    }
    open func showLoading(tip:String?,sub:String?,cancle:(()->())?) {
        
        count += 1
        
        OperationQueue.main.addOperation({ [unowned self] in
            self.window?.isHidden = false
            self.window?.isUserInteractionEnabled = true
            
            if self.currentView != nil {
                switch self.currentView?.type {
                case .loading:
                    self.currentView?.setTip(tip, sub: sub)
                    break
                case .message:
                    self.currentView?.toBeLoading(withTip: tip, sub: sub)
                    break
                default:
                    break
                }
            }else{
                var show = false
                if cancle != nil {
                    self.cancled = cancle
                    show = true
                }
                let view = ZSBaseContentView()
                view.start(tip: tip, sub: sub, showCancle: show)
                self.window?.addSubview(view)
                
                self.currentView = view
                if show {
                    view.button?.addTarget(self, action: #selector(self.cancleProgress(sender:)), for: .touchUpInside)
                }
            }
            
            
           
        })
    }
    @objc
    private func cancleProgress(sender:UIButton) {
        if (cancled != nil) {
            cancled!();
            cancled = nil;
        }
    }
    
    open func changeSub(_ sub: String?) {
        
        OperationQueue.main.addOperation({ [weak self] in
            self?.currentView?.subLabel?.text = sub
        })
    }
    
    
    
    
    // MARK: - *************** 提示信息 ***************
    open func show(_ msg: String?) {
        show(msg, type: .default)
    }
    
    open func showSuccess(_ msg: String?) {
        show(msg, type: .done)
    }
    
    open func showFail(_ msg: String?) {
        show(msg, type: .fail)
    }
    
    open func showWarning(_ msg: String?) {
        show(msg, type: .warning)
    }
    
    open func show(_ msg: String?, type: ZSMsgType) {
        show(msg: msg, type: type, complete: nil)
    }
    
    open func show(msg:String?,type:ZSMsgType,complete:(()->())?) {
        self.complete = complete
        count = 0
        OperationQueue.main.addOperation({ [unowned self] in
            self.window?.isHidden = false
            self.window?.isUserInteractionEnabled = false
            
            if self.currentView != nil {
                switch self.currentView?.type {
                case .loading:
                    self.currentView?.toBeMessage(msg: msg, type: type, complete: {
                        self.window?.isUserInteractionEnabled = true
                        if complete != nil {
                            complete!()
                            self.complete = nil
                        }
                    })
                    break
                case .message:
                    self.currentView?.setMsg(msg, type: type)
                    break
                default:
                    break
                }
            }else{
                let msgView = ZSBaseContentView()
                msgView.start(msg: msg, type: type)
                self.window?.addSubview(msgView)
                self.currentView = msgView
            }
            
            
            
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ZSHUDManager {
    open func showNavSuccess(_ str:String) {
        showNavInfo(str, type: .done)
    }
    func showNavInfo(_ str:String,type:ZSMsgType) {
       
        let button = UIButton.init(type: .custom)
        switch type {
        case .fail:
            button.backgroundColor = .red
        case .done:
            button.backgroundColor = ZSHEXCOLOR(0x003a6c)
            
        default:
            button.backgroundColor = .red
        }
        let navH = ZSHUD.config.navBarHeight
        button.frame = CGRect.init(x: 0, y: 0, width: self.navWindow.frame.size.width, height: navH!)
        button.setTitle(str, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.navWindow?.addSubview(button)

        //布局
//        button.removeAllAutoLayout()
//        button.addConstraint(.height, value: navH!)
//        button.addConstraint(.top, equalTo: self.navWindow, offset: 0)
//        button.addConstraint(.leading, equalTo: self.navWindow, offset: 0)
//        button.addConstraint(.trailing, equalTo: self.navWindow, offset: 0)
//        self.navBar = button
//        UIView.animate(withDuration: ZSHUD.config.animationNavTime, animations: {
//            button.layoutIfNeeded()
//        })
        navDisMiss()
        
    }
    func navDisMiss() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + ZSHUD.config.messageDelay) { [unowned self] in
//            if let constraints = self.navBar?.constraints{
//                for con in constraints {
//                    if con.firstAttribute == .height  {
//                        con.constant = 0
//                        break
//                    }
//                }
//            }
//            self.navBar?.setNeedsLayout()
            UIView.animate(withDuration: ZSHUD.config.animationNavTime, animations: {
                for view in self.navWindow.subviews {
                    view.frame.origin.y = -ZSHUD.config.navBarHeight
                }
                
            }) { [unowned self] (finshed) in
                
                for view in self.navWindow.subviews {
                    view.removeFromSuperview()
                }
                self.navBar = nil
            }
           

        }
    }
}
