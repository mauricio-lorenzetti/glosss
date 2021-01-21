//
//  CustomRefreshControl.swift
//  glosss
//
//  Created by Mauricio Lorenzetti on 21/01/21.
//

import Foundation
import UIKit
import RxSwift

class CustomRefreshControl: UIControl {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "reload")
        
        imageView.image = image
        
        imageView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 18, y: 150, width: 36, height: 36)
        imageView.contentMode = .center
        
        return imageView
    }()
    
    /// The initial value must be true so that the CollectionView setup doesn't trigger an animation.
    private var isChanged = true {
        didSet {
            switch self.isChanged {
            case true:
                startLayerAnimation()
            case false:
                stopLayerAnimation()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 200))
        self.addTarget(self, action: #selector(changeState), for: .valueChanged)
        addSubview(imageView)
        
        /// Auto centralize
        autoresizingMask =  [.flexibleLeftMargin, .flexibleRightMargin]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func changeState() {
        isChanged = !isChanged
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isChanged = false
        }
    }
    
    func containingScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -80 {
            self.sendActions(for: .valueChanged)
        }
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= -100, isChanged else { return }
        scrollView.contentOffset.y = -80
    }
    
    private func startLayerAnimation() {
        imageView.isHidden = false
        imageView.rotate()
    }
    
    private func stopLayerAnimation() {
        imageView.isHidden = true
    }
}
