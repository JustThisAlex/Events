//
//  CustomElements.swift
//  Events
//
//  Created by Alexander Supe on 01.03.20.
//

import UIKit

@IBDesignable class StylizedTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    func commoninit() {
        self.borderStyle = .none
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = color
    }
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var verticalInset: CGFloat = 10
    @IBInspectable var color: UIColor? = .secondarySystemBackground { didSet { self.backgroundColor = color}}
    override func textRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: verticalInset, dy: 0) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: verticalInset, dy: 0) }
}

@IBDesignable class CustomButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    func commoninit() {
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = isPrimary ? color : .white
        self.setTitleColor(isPrimary ? (lightTextColor ? .white : .black) : color, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .medium)
    }
    @IBInspectable var fontSize: CGFloat = 20 {
        didSet { self.titleLabel?.font = .systemFont(ofSize: fontSize, weight: fontWeight) }
    }
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var isPrimary: Bool = true
    @IBInspectable var fontWeight: UIFont.Weight = .medium {
        didSet { self.titleLabel?.font = .systemFont(ofSize: fontSize, weight: fontWeight) }
    }
    @IBInspectable var lightTextColor: Bool = true
    @IBInspectable var color: UIColor? = .systemBlue { didSet { self.backgroundColor = isPrimary ? color : .white;
        self.setTitleColor(isPrimary ? (lightTextColor ? .white : .black) : color, for: .normal)}}
}

@IBDesignable class CustomSegmentedControl: UIView {
    private(set) var selectedIndex = 0
    private let buttons = [SegmentButton(), SegmentButton()
//        , SegmentButton()
    ]
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    func sharedInit() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        buttons[0].setTitle("Today", for: .normal)
        buttons[1].setTitle("Tomorrow", for: .normal)
//        buttons[2].setTitle("Pick Date", for: .normal)
        for button in buttons {
            stack.addSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
        selectButton(0)
    }
    
    func selectButton(_ index: Int) {
        for i in 0..<buttons.count {
            if i == index {
                selectedIndex = i
                buttons[i].backgroundColor = .label
                buttons[i].setTitleColor(.white, for: .normal)
            } else {
                buttons[i].backgroundColor = .systemBackground
                buttons[i].setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        for (i, button) in buttons.enumerated() {
            if button == sender {
                selectButton(i)
                NotificationCenter.default.post(name: NSNotification.Name("SegmentChanged"), object: nil, userInfo: [1:i])
            }
        }
    }
}

@IBDesignable class SegmentButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    func sharedInit() {
        layer.cornerRadius = 15
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

@IBDesignable class CustomImage: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet { self.layer.cornerRadius = self.cornerRadius } }
}

@IBDesignable class RoundedView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = self.cornerRadius
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.cornerRadius
    }
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet { self.layer.cornerRadius = self.cornerRadius } }
}

extension KeychainSwift {
    static let shared = KeychainSwift()
}
