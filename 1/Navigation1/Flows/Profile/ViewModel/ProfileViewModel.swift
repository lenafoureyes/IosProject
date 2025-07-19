//
//  ProfileViewModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//

import UIKit
import iOSIntPackage

class ProfileViewModel {
    var user: User?
    private let imagePublisher = ImagePublisherFacade()
    
    var onImagesUpdated: (([UIImage]) -> Void)?
    var onPostsUpdated: (() -> Void)?
    private(set) var posts: [Post] = []
    
    init(user: User?) {
        self.user = user
        refreshPosts()
    }
    
    func refreshPosts() {
        posts = PostService.shared.getProfilePosts()
        onPostsUpdated?()
    }
    
    func loadProfilePosts() {
        posts = PostService.shared.getProfilePosts()
        onPostsUpdated?()
    }
    
    func subscribeForImages() {
        imagePublisher.subscribe(self)
        imagePublisher.addImagesWithTimer(time: 0.5, repeat: 20, userImages: PhotosTableViewCell.images)
    }
    
    func unsubscribeForImages() {
        imagePublisher.removeSubscription(for: self)
    }
}

extension ProfileViewModel: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        onImagesUpdated?(images)
    }
}
