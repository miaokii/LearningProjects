//
//  SecondController.swift
//  ModalView
//
//  Created by miaokii on 2021/1/27.
//

import UIKit

class SecondController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        let cancel = UIButton.init(type: .close)
        cancel.setClosure { [unowned self] (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        var w = preferredContentSize.width
        if w == 0 { w = view.frame.width }
        view.addSubview(cancel)
        
        if modalPresentationStyle != .popover {
            cancel.frame = .init(x: w/2-20, y: 60, width: 40, height: 40)
        } else {
            let textField = UITextField.init(frame: .init(x: 20, y: 20, width: w-40, height: 40))
            textField.borderStyle = .roundedRect
            textField.backgroundColor = .black
            textField.textColor = .white
            view.addSubview(textField)
            cancel.frame = .init(x: w/2-20, y: textField.frame.maxY+40, width: 40, height: 40)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.superview?.superview?.superview?.subviews.last?.alpha = 1
        view.superview?.superview?.superview?.subviews.last?.backgroundColor = .red
    }
}
