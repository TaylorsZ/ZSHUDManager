//
//  ZSHUDLoadingView.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit

extension ZSBaseContentView {

    func start(tip:String?,sub:String?,showCancle:Bool) {
        self.type = .loading
        self.showCancle = showCancle
        let loadingView = self.loadingView()
        self.addSubview(loadingView)
        topView = loadingView
        var tips = tip
        if isShowkZSDefaultLoadingTip&&(tips == nil || tips?.count == 0) {
             tips = kZSDefaultLoadingTip
        }
       

        mainLabel?.text = tips
        subLabel?.text = sub
        setConstraint()

        timer = Timer(timeInterval: TimeInterval(kZSLoadingDelayTime), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        
    }
    func setTip(_ tip: String?, sub: String?) {
        mainLabel?.text = tip
        subLabel?.text = sub
        resetConstraint()
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: TimeInterval(kZSLoadingDelayTime), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    func toBeLoading(withTip tip: String?, sub: String?) {
        if type != .loading {
            self.type = .loading

            topView?.removeFromSuperview()

            //创建loading
            let loadingView = self.loadingView()
            addSubview(loadingView)

            topView = loadingView
            mainLabel?.text = tip
            subLabel?.text = sub
            setConstraint()
            topView?.layoutIfNeeded()
            UIView.animate(withDuration: TimeInterval(kZSDefaultAnimationTime), animations: {
                self.layoutIfNeeded()
            })

            timer?.invalidate()
            timer = Timer(timeInterval: TimeInterval(kZSLoadingDelayTime), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        }

    }
    func loadImages() -> [UIImage] {

        let images = ZSHUD.loadingAnimationImages
        var imagesM: [UIImage] = []
        for i in 0..<images.count {
            let imageName = "\(images[i])"
            let image = UIImage(named: imageName)
            if let image = image {
                imagesM.append(image)
            }
        }
        return imagesM
    }
    func loadingView() -> UIView{
        if ZSHUD.loadingAnimationImages.count > 0 {
            let aniImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

            aniImageView.animationImages = loadImages()
            aniImageView.animationDuration = 1
            aniImageView.animationRepeatCount = 99999
            aniImageView.startAnimating()
            return aniImageView
        } else {
            let loadingView = UIActivityIndicatorView()
            loadingView.activityIndicatorViewStyle = .whiteLarge
            loadingView.color = ZSHEXCOLOR(kZSLoadingColor)
            loadingView.hidesWhenStopped = true
            loadingView.startAnimating()
            return loadingView
        }

    }


}
