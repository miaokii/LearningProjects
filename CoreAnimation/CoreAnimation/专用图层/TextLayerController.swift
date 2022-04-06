//
//  TextLayerController.swift
//  CoreAnimation
//
//  Created by Miaokii on 2021/2/18.
//

import UIKit
import MKSwiftRes

/*
    CATextLayer以图层的形式包含了UILabel几乎所有的绘制特性，并且比UILabel渲染更快
 */

class TextLayerController: MKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        textLayerTest()
        layerLabelTest()
    }
    
    private func layerLabelTest() {
        let label = LayerLabel.init()
        label.frame = .init(x: 20, y: 300, width: view.width-40, height: 200)
        view.addSubview(label)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.text = """
随着资源枯竭和国家产业升级转型，大批年轻劳动力无法在本地找到满意的工作，只能流向经济更好、工资更高的地区。东北边境地区的生育政策相对宽松（如黑龙江省规定夫妻双方均为边境地区居民的可生育三个孩子），但生育意愿不高。究其原因，经济社会因素已成为影响生育的重要因素，特别是经济负担、婴幼儿照护和女性职业发展等方面，群众反映尤为突出，生育政策对生育行为的影响大为减弱。
"""
    }
    
    private func textLayerTest() {
        
        let textView = UIView.init(super: view,
                                   backgroundColor: .table_bg)
        textView.frame = .init(x: 20, y: 20, width: view.width-40, height: 200)
        
        let textLayer = CATextLayer.init()
        textLayer.frame = textView.bounds
        textLayer.foregroundColor = UIColor.black.cgColor
        // 对齐方式
        textLayer.alignmentMode = .justified
        // 换行
        textLayer.isWrapped = true
        textView.layer.addSublayer(textLayer)
        
        // font
        let font = UIFont.systemFont(ofSize: 15)
        // layer font
        textLayer.font = CGFont.init(font.fontName as CFString)
        textLayer.fontSize = 17
        
        let text = """
随着资源枯竭和国家产业升级转型，大批年轻劳动力无法在本地找到满意的工作，只能流向经济更好、工资更高的地区。东北边境地区的生育政策相对宽松（如黑龙江省规定夫妻双方均为边境地区居民的可生育三个孩子），但生育意愿不高。究其原因，经济社会因素已成为影响生育的重要因素，特别是经济负担、婴幼儿照护和女性职业发展等方面，群众反映尤为突出，生育政策对生育行为的影响大为减弱。
"""
        // 普通文本
        textLayer.string = text
        
        // 富文本
        let attributeText = NSMutableAttributedString.init(string: text)
        
        let normalAttribs: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.black.cgColor,
                             .font: font]
        attributeText.setAttributes(normalAttribs, range: .init(location: 0, length: text.count))
        
        let highlightAttribs: [NSAttributedString.Key: Any] = [.font: font,
                                                               .foregroundColor: UIColor.red.cgColor,
                                                               .underlineStyle: NSUnderlineStyle.single]
        attributeText.setAttributes(highlightAttribs, range: .init(location: 10, length: 5))
        textLayer.string = attributeText
        
        // 以ratina方式渲染
        textLayer.contentsScale = UIScreen.main.scale
    }
    
}

/*
 CATextLayer比UILabel有着更好的性能表现，实现一个Label
 继承UILabel，重写显示文本的方法，但是UILabel的-drawRect：
 方法任然会创建空的寄宿图，而且CALauer不支持自动缩放和布局
 所以视图大小被更改，就要手动更改子图层的边界
 
 重写layerClass方法，使得CATextLayer作为宿主图层的类型
 */
fileprivate class LayerLabel: UILabel {
    /// layerClass返回CATextLayer而不是CALayer
    /// UIView在初始化的时候会调用该方法
    /// 使用该返回类型来创建宿主图层
    override class var layerClass: AnyClass {
        return CATextLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    private var textLayer: CATextLayer {
        return layer as! CATextLayer
    }
    
    private func setup() {
        textLayer.alignmentMode = .justified
        textLayer.isWrapped = true
        textLayer.display()
    }
    
    override var text: String? {
        didSet {
            super.text = text
            textLayer.string = text
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            super.textColor = textColor
            textLayer.foregroundColor = textColor.cgColor
        }
    }
    
    override var font: UIFont! {
        didSet {
            super.font = font
            let fontNameRef = font.fontName as CFString
            textLayer.font = CGFont.init(fontNameRef)
            textLayer.fontSize = font.pointSize
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
