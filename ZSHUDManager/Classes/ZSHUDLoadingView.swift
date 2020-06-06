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
        if (tips == nil || tips?.count == 0) {
            tips = ZSHUD.config.loadingDefaultTips
        }
       

        mainLabel?.text = tips
        subLabel?.text = sub
        setConstraint()

       creatLoadingTimer()
      
        
    }
    func creatLoadingTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: ZSHUD.config.loadingDelay, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    func setTip(_ tip: String?, sub: String?) {
        mainLabel?.text = tip
        subLabel?.text = sub
        resetConstraint()
        
        creatLoadingTimer()
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
            UIView.animate(withDuration: ZSHUD.config.animationTime, animations: {
                self.layoutIfNeeded()
            })

            creatLoadingTimer()
        }

    }
    func loadImages() -> [UIImage] {

        guard let images = ZSHUD.config.loadingImages else {
            return []
        }
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
        
        if let images = ZSHUD.config.loadingImages, images.count > 0 {
            let aniImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            aniImageView.animationImages = loadImages()
            aniImageView.animationDuration = 1
            aniImageView.animationRepeatCount = 99999
            aniImageView.startAnimating()
            return aniImageView
        } else {
            let loadingView = UIActivityIndicatorView()
            loadingView.style = .whiteLarge
            loadingView.color = ZSHUD.config.loadingColor
            loadingView.hidesWhenStopped = true
            loadingView.startAnimating()
            return loadingView
        }

    }
    


}
