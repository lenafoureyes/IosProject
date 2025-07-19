//
//  FavoritesViewModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 19.07.2025.
//

import UIKit

class FavoritesViewModel {
    var favoritePosts: [Post] = []
    
    func loadFavorites() {
        favoritePosts = PostService.shared.getFavoritePosts()
    }
    
    func removeFavorite(postId: String) {
        PostService.shared.toggleFavorite(postId: postId)
        loadFavorites()
    }
}
