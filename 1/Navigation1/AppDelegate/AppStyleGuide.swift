//
//  AppStyleGuide.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.07.2025.
//

import UIKit

struct AppStyleGuide {
    // MARK: - Colors
    struct Colors {
        static let primaryBackground = UIColor(red: 0.96, green: 0.95, blue: 0.92, alpha: 1.0) // Светлый бежевый
        static let secondaryBackground = UIColor(red: 0.91, green: 0.89, blue: 0.82, alpha: 1.0) // Бежевый
        static let accentGreen = UIColor(red: 0.30, green: 0.49, blue: 0.33, alpha: 1.0) // Природный зеленый
        static let darkBrown = UIColor(red: 0.27, green: 0.21, blue: 0.16, alpha: 1.0) // Темно-коричневый
        static let lightBrown = UIColor(red: 0.69, green: 0.63, blue: 0.52, alpha: 1.0) // Светло-коричневый
        static let separator = UIColor(red: 0.80, green: 0.77, blue: 0.70, alpha: 1.0) // Разделитель
    }
    
    // MARK: - Fonts
    struct Fonts {
        static func regular(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func bold(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    // MARK: - Effects
    struct Effects {
        static func applyCardStyle(to view: UIView, cornerRadius: CGFloat = 12) {
            view.backgroundColor = Colors.secondaryBackground
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
            view.layer.borderWidth = 1
            view.layer.borderColor = Colors.separator.cgColor
        }
        
        static func applyShadow(to view: UIView) {
            view.layer.shadowColor = Colors.darkBrown.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 6
            view.layer.shadowOpacity = 0.1
        }
    }
}
