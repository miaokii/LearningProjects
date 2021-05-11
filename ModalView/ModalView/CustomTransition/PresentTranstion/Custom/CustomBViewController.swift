//
//  CustomBViewController.swift
//  ModalView
//
//  Created by miaokii on 2021/2/3.
//

import UIKit

class CustomBViewController: ModalViewController {

    private var slider = UISlider.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set(tag: "B")
        view.backgroundColor = .table_bg
        nextBtn.isHidden = true
        
        /*
         带有自定义表示控制器的视图控制器默认情况下不承担对状态栏外观的控制
         （不会调用其-preferredStatusBarStyle和-prefersStatusBarHidden方法）。
         可以通过将显示的视图控制器的modalPresentationCapturesStatusBarAppearance属性的值设置为YES来覆盖此行为。
         */
        // modalPresentationCapturesStatusBarAppearance = true
        
        slider.tintColor = .theme
        view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalTo(-MKDefine.bottomSafeAreaHeight-30)
        }
        slider.addTarget(self, action: #selector(sliderChange(sender:)), for: .valueChanged)
        
        updatePreferredContentSize(with: self.traitCollection)
    }
    
    @objc private func sliderChange(sender: UISlider) {
        preferredContentSize = .init(width: view.bounds.width, height: CGFloat(sender.value))
    }
    
    private func explainUITraitCollection() {
        /// UITraitCollection是存储系统特性和UI相关配置的集合
        /// 将例如界面文字字号、主题、系统设置存储在改集合中
        /// 在traitCollectionDidChange(:)中实现配置更新后的设置
        /// 获取全局配置 ：UITraitCollection.currentTraitCollection
        let _ = UITraitCollection.current
    }
    
    /// 根据提供的traitCollection的verticalSizeClass更新接收者的preferredContentSize
    private func updatePreferredContentSize(with traitCollection: UITraitCollection) {
        let preferContentHeight = CGFloat(traitCollection.verticalSizeClass == .compact ? 270 : 420)
        preferredContentSize = CGSize.init(width: view.frame.width, height: preferContentHeight)
        slider.maximumValue = Float(preferContentHeight)
        slider.minimumValue = 220
        slider.value = slider.maximumValue
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSize(with: newCollection)
    }
}
