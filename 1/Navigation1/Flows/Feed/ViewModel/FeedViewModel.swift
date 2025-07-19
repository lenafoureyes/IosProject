//
//  FeedViewModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//
import UIKit

class FeedViewModel {
    var posts: [Post] = []
    var onPostsUpdated: (() -> Void)?
    
    init() {
        refreshPosts()
        // Загружаем посты из единого источника
        self.posts = PostService.shared.getFeedPosts()
    }
    
    func refreshPosts() {
            self.posts = PostService.shared.getFeedPosts()
            onPostsUpdated?()
        }
    
    func toggleFavorite(for postId: String) {
        // Обновляем в PostService
        PostService.shared.toggleFavorite(postId: postId)
        
        // Синхронизируем локальное состояние
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].isFavorite.toggle()
        }
        
        onPostsUpdated?()
    }
    
    func getFavorites() -> [Post] {
        return PostService.shared.getFavoritePosts() // Берем из единого источника
    }
    
    func updatePostFavoriteStatus(postId: String, isFavorite: Bool) {
        PostService.shared.toggleFavorite(postId: postId)
        
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].isFavorite = isFavorite
        }
    }
}
