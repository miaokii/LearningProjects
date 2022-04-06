//
//  SpringListView.swift
//  CoreAnimation
//
//  Created by miaokii on 2021/2/24.
//

import UIKit
import MiaoKiit

class SpringListView: DynamicView {
    
    private var collectionView: UICollectionView!
    private var layout = SpringCollectionLayout.init()
    private var sources = [ChatModel]()
    
    override func setup() {
        
        boxView.removeFromSuperview()
        backgroundColor = .view_l1
        
        sources = makeListSource()
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .view_l1
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.register(cellType: SpringChatCell.self)
        
        let controlView = UIView.init(super: self,
                                      backgroundColor: UIColor.view_l1.withAlphaComponent(0.8))
        controlView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(MKDefine.bottomSafeAreaHeight+100)
        }
        
        let dampingLabel = UILabel.init(super: controlView)
        dampingLabel.tag = 10
        
        dampingLabel.text = "damping:\(String.number(for: layout.damping))"
        dampingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(40)
        }
        
        let frequencyLabel = UILabel.init(super: controlView)
        frequencyLabel.tag = 20
        frequencyLabel.text = "frequency:\(String.number(for: layout.frequency))"
        frequencyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dampingLabel)
            make.top.equalTo(dampingLabel.snp.bottom).offset(10)
        }
        
        let factorLabel = UILabel.init(super: controlView)
        factorLabel.tag = 30
        factorLabel.text = "factor:\(String.number(for: layout.resistanceFactor))"
        factorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(frequencyLabel)
            make.top.equalTo(frequencyLabel.snp.bottom).offset(10)
        }
        
        let dampingSlider = UISlider.init()
        dampingSlider.tag = 1
        dampingSlider.maximumValue = 1
        dampingSlider.minimumValue = 0
        dampingSlider.value = Float(layout.damping)
        dampingSlider.addTarget(self, action: #selector(update(slider:)), for: .valueChanged)
        controlView.addSubview(dampingSlider)
        dampingSlider.snp.makeConstraints { (make) in
            make.left.equalTo(180)
            make.right.equalTo(-50)
            make.centerY.equalTo(dampingLabel)
        }
        
        let frequencySlider = UISlider.init()
        frequencySlider.tag = 2
        frequencySlider.maximumValue = 1
        frequencySlider.minimumValue = 0
        frequencySlider.value = Float(layout.frequency)
        frequencySlider.addTarget(self, action: #selector(update(slider:)), for: .valueChanged)
        controlView.addSubview(frequencySlider)
        frequencySlider.snp.makeConstraints { (make) in
            make.left.right.equalTo(dampingSlider)
            make.centerY.equalTo(frequencyLabel)
        }
        
        let factorSlider = UISlider.init()
        factorSlider.tag = 3
        factorSlider.maximumValue = 1000
        factorSlider.minimumValue = 100
        factorSlider.value = Float(layout.resistanceFactor)
        factorSlider.addTarget(self, action: #selector(update(slider:)), for: .valueChanged)
        controlView.addSubview(factorSlider)
        factorSlider.snp.makeConstraints { (make) in
            make.left.right.equalTo(dampingSlider)
            make.centerY.equalTo(factorLabel)
        }
    }
    
    @objc private func update(slider: UISlider) {
        let label = slider.superview?.viewWithTag(slider.tag*10) as! UILabel
        if slider.tag == 1 {
            layout.damping = CGFloat(slider.value)
            label.text = "damping:\(String.number(for: layout.damping))"
        } else if slider.tag == 2 {
            layout.frequency = CGFloat(slider.value)
            label.text = "frequency:\(String.number(for: layout.frequency))"
        } else {
            layout.resistanceFactor = CGFloat(slider.value)
            label.text = "factor:\(String.number(for: layout.resistanceFactor))"
        }
    }
}

extension SpringListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: SpringChatCell.self, at: indexPath)
        cell.set(chat: sources[indexPath.row])
        return cell
    }
}

extension SpringListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SpringChatCell.cellSizeFor(chat: sources[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - layout
fileprivate class SpringCollectionLayout: UICollectionViewFlowLayout {
    private var animator: UIDynamicAnimator!
    
    var resistanceFactor: CGFloat = 500
    var damping: CGFloat = 0.5 {
        didSet {
            guard damping >= 0, damping != oldValue else {
                return
            }
            for spring in animator.behaviors as! [UIAttachmentBehavior] {
                spring.damping = damping
            }
        }
    }
    var frequency: CGFloat = 0.8 {
        didSet {
            guard frequency >= 0, oldValue != frequency else {
                return
            }
            for spring in animator.behaviors as! [UIAttachmentBehavior] {
                spring.frequency = frequency
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
        guard animator == nil else {
            return
        }
        animator = UIDynamicAnimator.init(collectionViewLayout: self)
        let contentSize = collectionViewContentSize
        
        guard let items = super.layoutAttributesForElements(in: .init(origin: .zero, size: contentSize)) else {
            return
        }
        
        for item in items {
            let spring = UIAttachmentBehavior.init(item: item, attachedToAnchor: item.center)
            spring.length = 0
            // 阻尼
            spring.damping = damping
            // 频率
            spring.frequency = frequency
            animator.addBehavior(spring)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCell(at: indexPath)
    }
    
    /*
     每次layout的bounds发生变化的时候，collectionView都会询问这个方法是否需要为这个新的边界和更新layout。一般情况下只要layout没有根据边界不同而发生变化的话，这个方法直接不做处理地返回NO，表示保持现在的layout即可，而每次bounds改变时这个方法都会被调用的特点正好可以满足我们更新锚点的需求，因此我们可以在这里面完成锚点的更新
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let scrollView = collectionView else {
            return false
        }
        // 滑动的距离
        let scrolLDelta = newBounds.origin.y - scrollView.bounds.origin.y
        // 触摸点坐标
        let touchLocation = scrollView.panGestureRecognizer.location(in: scrollView)
        
        for spring in (animator.behaviors as! [UIAttachmentBehavior]){
            // 锚点
            let anchorPoint = spring.anchorPoint
            // 锚点与触摸点的距离
            let distanceFromTouch = CGFloat(fabsf(Float(touchLocation.y-anchorPoint.y)))
            // 系数
            let scrollResistance = distanceFromTouch/resistanceFactor
            
            if let item = spring.items.first {
                var center = item.center
                
                center.y += scrolLDelta > 0 ? min(scrolLDelta, scrolLDelta * CGFloat(scrollResistance))
                    : max(scrolLDelta, scrolLDelta*CGFloat(scrollResistance))
                item.center = center
                animator.updateItem(usingCurrentState: item)
            }
        }
        
        return false
    }
}

fileprivate class SpringChatCell: UICollectionViewCell {
    
    private var messageLabel: UILabel!
    private var messageBubbleView: UIImageView!
    private static var maxWidth = MKDefine.screenWidth * 0.7
    private static let lineSep: CGFloat = 5

    static func cellSizeFor(chat: ChatModel) -> CGSize {
        if chat.sepLine {
            return .init(width: MKDefine.screenWidth, height: 10)
        }
        let chatSize = size(for: chat)
        return .init(width: MKDefine.screenWidth, height: chatSize.height+2*lineSep+2)
    }
    
    static private func size(for chat: ChatModel) -> CGSize {
        return attributeMessage(for: chat).boundingRect(with: .init(width: maxWidth, height: .infinity), options: .usesLineFragmentOrigin, context: nil).size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        messageBubbleView = UIImageView.init(super: contentView, cornerRadius: 10)
        messageLabel = UILabel.init(super: messageBubbleView,
                                    numLines: 0)
        messageLabel.backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(chat: ChatModel) {
        messageBubbleView.isHidden = chat.sepLine
        guard let sender = chat.sender else {
            return
        }
        let chatSize = Self.size(for: chat)
        let chatWidth = chatSize.width + 20
        
        if sender {
            messageBubbleView.backgroundColor = .init(0x0074FE)
            messageBubbleView.frame = .init(x: MKDefine.screenWidth-chatWidth-10, y: 1, width: chatWidth, height: Self.cellSizeFor(chat: chat).height-2)
        } else {
            messageBubbleView.backgroundColor = .view_l2
            messageBubbleView.frame = .init(x: 10, y: 1, width: chatWidth, height: Self.cellSizeFor(chat: chat).height-2)
        }
        
        messageLabel.attributedText = Self.attributeMessage(for: chat)
        messageLabel.frame = .init(origin: .init(x: 10, y: Self.lineSep), size: chatSize)
    }
    
    private static func attributeMessage(for chat: ChatModel) -> NSMutableAttributedString {
        let attributeMessage = NSMutableAttributedString.init()
        attributeMessage.append(.init(string: chat.message, attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                                         .foregroundColor: chat.sender! ? UIColor.white : UIColor.text_l1]))
        return attributeMessage
    }
}

fileprivate struct ChatModel {
    var sepLine = false
    var sender: Bool? = nil
    var message = ""
}
fileprivate func makeListSource() -> [ChatModel] {
    var chats = [ChatModel]()
    (0..<50).forEach { (i) in
        let sender = arc4random_uniform(2) == 0
        let charCount = Int(arc4random_uniform(30))+1
        let message1 = Array.init(repeating: "哼", count: charCount).joined()
        let message2 = Array.init(repeating: "哈", count: charCount).joined()
        
        var model = ChatModel()
        model.sender = sender
        model.message = sender ? message1 : message2
        
//        if i > 0 {
//            // 相邻两条消息发送者不是同一个人，插入一条空白
//            let lastSender = chats[i-1].sender
//            if lastSender != nil, sender != lastSender {
//                let lineModel = ChatModel.init(sepLine: true)
//                chats.append(lineModel)
//            }
//        }
        chats.append(model)
    }
    return chats
}
