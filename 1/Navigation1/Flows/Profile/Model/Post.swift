//
//  Post.swift
//  Navigation1
//
//  Created by Елена Хайрова on 02.08.2024.
//

import Foundation

// Post.swift
struct Post {
    let id: String
    let author: String
    let text: String
    let imageName: String?
    var isFavorite: Bool
    let date: Date
    var postType: PostType 
        
    enum PostType {
        case feed
        case profile
        case both  // Для постов, которые должны быть везде
    }
}
