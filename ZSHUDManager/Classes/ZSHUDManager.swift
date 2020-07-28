//
//  ZSHUDManager.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit

open class ZSHUDManager: NSObject {
    
    private var window:HUDWindow?
    private var navWindow:UIWindow!
    private var navBar:UIButton?

    private var count:Int = 0
    private weak var currentView:ZSBaseContentView?
    private var complete:(()->())?
    private var cancled:(()->())?
    
    public var config:ZSHUDConfig!
    private static var _sharedInstance: ZSHUDManager?
    
    public class func shared() -> ZSHUDManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = ZSHUDManager()
            
            return _sharedInstance!
        }
        return instance
    }
    //销毁单例对象
    public class func destroy() {
        _sharedInstance = nil
      
    }
    override private init() {
        super.init()
        self.config = ZSHUDConfig()
        //create window
        initWindow()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismiss), name: NSNotification.Name.init(kZSDismissNotification), object: nil)
    }
    private func initWindow() {
        let window = HUDWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        window.windowLevel =  UIWindow.Level.alert + 1
//        window.isUserInteractionEnabled = false
        window.rootViewController = ZSBaseProgressViewController()
        window.makeKeyAndVisible()
        self.window = window
        
//        let window2 = UIWindow(frame: UIScreen.main.bounds)
//        window2.makeKeyAndVisible()
//        window2.backgroundColor = UIColor.clear
//
//        window2.windowLevel =  UIWindow.Level.alert + 2
//        window2.isUserInteractionEnabled = false
//        window2.rootViewController = ZSBaseProgressViewController()
//        self.navWindow = window2
    }
    @objc public func dismiss() {
//        print("当前 %@ ：\(count)")
        if ZSContentViewType.loading == currentView?.type && count - 1 > 0 {
            count -= 1
            print("无需关闭, 当前 %@ ：\(count)")
            return
        }
        OperationQueue.main.addOperation({ [weak self] in
            self?.dismissView()
        })
    }
    private func dismissView(){
        if let currentV = currentView {
            count = 0
            currentV.dismiss()
            currentView = nil
            if let com = complete {
                com()
                complete = nil
            }
        }
        ZSHUDManager.destroy()
    }

    open func showLoading(_ text: String?,cancle:(()->())? = nil) {
        showLoading(main: nil, sub: text, cancle: cancle)
    }
    open func showLoading(main:String?,sub:String?,cancle:(()->())? = nil) {
        count += 1
        OperationQueue.main.addOperation({ [weak self] in
            if let currentV = self?.currentView {
                switch currentV.type {
                case .loading:
                    let show = self?.isShowCancleButton(view: currentV, cancle: cancle)
                    currentV.setTip(main, sub: sub, cancle: show ?? false)
                    break
                case .message:
                    currentV.toBeLoading(withTip: main, sub: sub)
                    break
                default:
                    break
                }
            }else{
               
                let view = ZSBaseContentView()
                let show = self?.isShowCancleButton(view: view, cancle: cancle)
                view.start(tip: main, sub: sub, showCancle: show ?? false)
                self?.window?.addSubview(view)
                self?.currentView = view
                
            }
        })
    }
    func isShowCancleButton(view:ZSBaseContentView,cancle:(()->())?) -> Bool {
        guard let can = cancle else {
            return false
        }
        cancled = can
        view.button?.addTarget(self, action: #selector(cancleProgress(sender:)), for: .touchUpInside)
        window?.showView = view
        return true
    }
    @objc
    private func cancleProgress(sender:UIButton) {
        if (cancled != nil) {
            cancled!();
            cancled = nil;
        }
        currentView?.dismiss()
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
        OperationQueue.main.addOperation({ [weak self] in
            self?.window?.isHidden = false
            self?.window?.isUserInteractionEnabled = false

            if self?.currentView != nil {
                switch self?.currentView?.type {
                case .loading:
                    self?.currentView?.toBeMessage(msg: msg, type: type, complete: {
                        self?.window?.isUserInteractionEnabled = true
                        if complete != nil {
                            complete!()
                            self?.complete = nil
                        }
                    })
                    break
                case .message:
                    self?.currentView?.setMsg(msg, type: type)
                    break
                default:
                    break
                }
            }else{
                let msgView = ZSBaseContentView()
                msgView.start(msg: msg, type: type)
                self?.window?.addSubview(msgView)
                self?.currentView = msgView
            }
        })
    }
    deinit {
        print("销毁\(self)")
        currentView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ZSHUDManager {
    open func  nav_showSuccess(_ str:String) {
        showNavInfo(str, type: .done)
    }
    open func nav_showFail(_ str:String) {
        showNavInfo(str, type: .fail)
    }
    private func showNavInfo(_ str:String,type:ZSMsgType) {

        let button = UIButton.init(type: .custom)
        switch type {
        case .fail:
            button.backgroundColor = .red
        case .done:
            button.backgroundColor = ZSHEXCOLOR(0x003a6c)

        default:
            button.backgroundColor = .red
        }
        let navH = ZSHUDManager.shared().config.navBarHeight
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + ZSHUDManager.shared().config.messageDelay) { [unowned self] in
            //            if let constraints = self.navBar?.constraints{
            //                for con in constraints {
            //                    if con.firstAttribute == .height  {
            //                        con.constant = 0
            //                        break
            //                    }
            //                }
            //            }
            //            self.navBar?.setNeedsLayout()
            UIView.animate(withDuration: ZSHUDManager.shared().config.animationNavTime, animations: {
                for view in self.navWindow.subviews {
                    view.frame.origin.y = -ZSHUDManager.shared().config.navBarHeight
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
