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
            }
            
            
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
            }
            
            
            let msgView = ZSBaseContentView()
            msgView.start(msg: msg, type: type)
            self.window?.addSubview(msgView)
            self.currentView = msgView
        })
    }
    
}
