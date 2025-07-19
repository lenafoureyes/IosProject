//
//  CustomButton.swift
//  Navigation1
//
//  Created by Елена Хайрова on 20.11.2024.
//

import UIKit

class CustomButton: UIButton {

    var action: (() -> Void)?

    init(title: String,
         titleColor: UIColor,
         backgroundColor: UIColor = UIColor.clear,
         frame: CGRect = .zero,
         cornerRadius: CGFloat,
         useAutoLayout: Bool,
         font: UIFont = UIFont.systemFont(ofSize: 17),
         shadowColor: CGColor = UIColor.clear.cgColor,
         shadowOffset: CGSize = .zero,
         shadowRadius: CGFloat = 0,
         shadowOpacity: Float = 0,
         masksToBounds: Bool = false
) {
        super.init(frame: frame)
        setup(title: title, titleColor: titleColor, backgroundColor: backgroundColor, cornerRadius: cornerRadius, useAutoLayout: useAutoLayout, shadowColor: shadowColor, shadowOffset: shadowOffset, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, font: font, masksToBounds: masksToBounds)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup(title: String, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat, useAutoLayout: Bool, shadowColor: CGColor, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float, font: UIFont, masksToBounds: Bool) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = useAutoLayout
        self.titleLabel?.font = font
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.masksToBounds = masksToBounds
    }
    
    @objc private func buttonTapped() {
        action?()
    }
}
