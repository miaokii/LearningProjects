//
//  TargetModalController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/28.
//

import Foundation
import MKSwiftRes

class PopController: MKPopViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.snp.makeConstraints { (make) in
            switch popStyle {
            case .bottom:
                make.height.equalTo(250+MKDefine.bottomSafeAreaHeight)
                make.width.equalToSuperview()
                make.bottom.equalToSuperview()
            case .left:
                make.width.equalTo(150)
                make.height.equalToSuperview()
                make.left.equalToSuperview()
            case .center:
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalToSuperview().multipliedBy(0.6)
                make.center.equalToSuperview()
            case .top:
                make.height.equalTo(250)
                make.width.equalToSuperview()
                make.top.equalToSuperview()
            case .right:
                make.width.equalTo(150)
                make.height.equalToSuperview()
                make.right.equalToSuperview()
            case .custom:
                break
            }
        }
    }
}

class CustomPopController: MKPopViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        popStyle = .custom
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        contentView.layer.cornerRadius = 10
        presentDuration = 0.5
        hideOnTapBackground = false
        
        let titleLabel = UILabel.init(super: contentView,
                                      text: "提示信息",
                                      font: .boldSystemFont(ofSize: 22))
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        let messageLabel = UILabel.init(super: contentView,
                                        text: "当前库存量不足，请减少数量或者减少单次用量",
                                        font: .systemFont(ofSize: 15),
                                        aligment: .center)
        messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        let confirmBtn = UIButton.themeBtn(super: contentView, title: "确认")
        confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(40)
            make.top.equalTo(messageLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-20)
        }
        confirmBtn.setClosure { [unowned self] (_) in
            self.hide()
        }
        
        let cancelBtn = UIButton.themeBorderBtn(super: contentView,
                                                title: "取消")
        cancelBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.width.height.top.equalTo(confirmBtn)
        }
        cancelBtn.setClosure { [unowned self] (_) in
            self.hide()
        }
    }
    
    override func beforePop() {
        super.beforePop()
        view.backgroundColor = .clear
        
        var transform = CATransform3DIdentity
        transform.m34 = -1/600
        transform = CATransform3DRotate(transform, .pi/2, 1, 0, 0)
        transform = CATransform3DTranslate(transform, 0, 0, -contentWidth/2)
        contentView.layer.transform = transform
    }
    
    override func inPoping() {
        super.inPoping()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        contentView.layer.transform = CATransform3DIdentity
    }
    
    override func inHiding() {
        super.inHiding()
        view.alpha = 0
        contentView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
    }
    
    override func endHiding() {
        super.endHiding()
        view.alpha = 1
        contentView.transform = .identity
    }
}

class DiDiLeftMenuView: MKPopViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        popStyle = .left
        view.backgroundColor = .clear
        contentView.snp.makeConstraints { (make) in
            make.height.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.setShadow(color: .gray, radius: 5, offset: .init(width: 5, height: 0), opacity: 0.2)
    }
}

class PopMessageView: MKPopViewController {

    static var share = PopMessageView.init()
    /// 消息label
    private var messageLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popStyle = .top
        view.backgroundColor = .clear
        hideOnTapBackground = false
        messageLabel = UILabel.init(super: contentView,
                                    textColor: .white, font: .systemFont(ofSize: 15))
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(MKDefine.statusBarHeight+10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
    }
    
    static func flash(waring: String) {
        share.show()
        share.contentView.backgroundColor = .orange
        share.messageLabel.text = waring
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [unowned share] in
            share.dismiss(animated: true, completion: nil)
        }
    }
    
    static func flash(error: String) {
        share.show()
        share.contentView.backgroundColor = .red
        share.messageLabel.text = error
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [unowned share] in
            share.dismiss(animated: true, completion: nil)
        }
    }
    
    static func flash(success: String) {
        share.show()
        share.contentView.backgroundColor = .green
        share.messageLabel.text = success
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [unowned share] in
            share.dismiss(animated: true, completion: nil)
        }
    }
}

/// 科室选择
class PartPickerController: MKPickerController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "选择科室"
        
        options = [["儿科", "内科", "神经科", "骨科", "外科", "放射科", "妇科"]]
        values = ["内科"]
    }
}

/// 日期选择
class DatePickerController: MKPopViewController{
    
    var dateClosure:((Date)->Void)?
    var datePickerMode: UIDatePicker.Mode = .date
    /// 显示时间选择
    private let datePicker = UIDatePicker.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popStyle = .bottom
        hideOnTapBackground = false
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3).priority(.low)
            make.left.right.equalToSuperview()
        }
        
        let cancelBtn = UIButton.init(super: contentView,
                                      title: "取消",
                                      titleColor: .text_l3,
                                      font: .systemFont(ofSize: 15))
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
        }
        
        cancelBtn.setClosure { [unowned self] (_) in
            self.hide()
        }
        
        let confirmBtn = UIButton.init(super: contentView,
                                      title: "确认",
                                      titleColor: .text_l1,
                                      font: .systemFont(ofSize: 15))
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
        
        confirmBtn.setClosure { [unowned self] (_) in
            self.hide {
                self.dateClosure?(datePicker.date)
            }
        }
        
        let topLine = UIView.init(super: contentView,
                                  backgroundColor: .table_bg)
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(cancelBtn.snp.bottom).offset(15)
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
        
        datePicker.datePickerMode = datePickerMode
        datePicker.tintColor = .theme
        datePicker.maximumDate = Date()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = .current
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-MKDefine.bottomSafeAreaHeight-15)
            make.top.equalTo(topLine.snp.bottom).offset(15)
        }
    }
    
    @objc private func confirmAction() {
        hide { [unowned self] in
            self.dateClosure?(self.datePicker.date)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.round(corners: [.topLeft, .topRight], radius: 8)
    }
}
