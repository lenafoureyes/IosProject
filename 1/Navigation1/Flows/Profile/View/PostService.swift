//
//  PostService.swift
//  Navigation1
//
//  Created by Елена Хайрова on 19.07.2025.
//

import UIKit

class PostService {
    static let shared = PostService()
    
    private var allPosts: [Post] = []
    
    private init() {
        self.allPosts = loadInitialData()
        loadSavedData()
    }
    
    private func loadInitialData() -> [Post] {
        let feedPosts = Post.mockData.map { post in
            var modifiedPost = post
            modifiedPost.postType = .feed
            return modifiedPost
        }
        
        let profilePosts = [
            Post(
                id: "14",
                author: "Meow_Master",
                text: "Walking my man",
                imageName: "selfie1",
                isFavorite: false,
                date: Date(),
                postType: .profile
            ),
            Post(
                id: "15",
                author: "Meow_Master",
                text: "with the brothers in the area",
                imageName: "selfie2",
                isFavorite: false,
                date: Date(),
                postType: .profile
            ),
            Post(
                id: "16",
                author: "Meow_Master",
                text: "With my girlfriend",
                imageName: "selfie3",
                isFavorite: false,
                date: Date(),
                postType: .profile
            ),
            Post(
                id: "17",
                author: "Meow_Master",
                text: "My brother and I are going to drink",
                imageName: "selfie4",
                isFavorite: false,
                date: Date(),
                postType: .profile
            )
        ]
        
        return feedPosts + profilePosts
    }
    
    private func saveData() {
        let postsData = allPosts.map { post in
            var postTypeString: String
            switch post.postType {
            case .feed: postTypeString = "feed"
            case .profile: postTypeString = "profile"
            case .both: postTypeString = "both"
            }
            
            return [
                "id": post.id,
                "author": post.author,
                "text": post.text,
                "imageName": post.imageName ?? "",
                "isFavorite": post.isFavorite,
                "date": post.date.timeIntervalSince1970,
                "postType": postTypeString
            ] as [String: Any]
        }
        UserDefaults.standard.set(postsData, forKey: "savedPosts")
        NotificationCenter.default.post(name: NSNotification.Name("PostsUpdated"), object: nil)
    }
    
    private func loadSavedData() {
        guard let savedPosts = UserDefaults.standard.array(forKey: "savedPosts") as? [[String: Any]] else { return }
        
        for dict in savedPosts {
            guard let id = dict["id"] as? String,
                  let author = dict["author"] as? String,
                  let text = dict["text"] as? String,
                  let isFavorite = dict["isFavorite"] as? Bool,
                  let timeInterval = dict["date"] as? TimeInterval else {
                continue
            }
            
            let imageName = dict["imageName"] as? String
            let date = Date(timeIntervalSince1970: timeInterval)
            let postTypeString = dict["postType"] as? String
            let postType: Post.PostType
            
            switch postTypeString {
            case "feed": postType = .feed
            case "profile": postType = .profile
            case "both": postType = .both
            default: postType = .both
            }
            
            if !allPosts.contains(where: { $0.id == id }) {
                let newPost = Post(
                    id: id,
                    author: author,
                    text: text,
                    imageName: imageName,
                    isFavorite: isFavorite,
                    date: date,
                    postType: postType
                )
                allPosts.insert(newPost, at: 0)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func getFeedPosts() -> [Post] {
        return allPosts.filter { $0.postType == .feed || $0.postType == .both }
    }

    func getProfilePosts() -> [Post] {
        return allPosts.filter { $0.postType == .profile || $0.postType == .both }
    }
    
    func addPost(_ post: Post) {
        var newPost = post
        newPost.postType = .both
        allPosts.insert(newPost, at: 0)
        saveData()
    }
    
    func toggleFavorite(postId: String) {
        if let index = allPosts.firstIndex(where: { $0.id == postId }) {
            allPosts[index].isFavorite.toggle()
            saveData()
        }
    }

    func getFavoritePosts() -> [Post] {
        return allPosts.filter { $0.isFavorite }
    }
    
    func isFavorite(postId: String) -> Bool {
        return allPosts.first(where: { $0.id == postId })?.isFavorite ?? false
    }
    
    func getImage(for post: Post) -> UIImage? {
        guard let imageName = post.imageName else { return nil }
        
        // Сначала пробуем загрузить из Assets
        if let image = UIImage(named: imageName) {
            return image
        }
        
        // Если нет в Assets, пробуем загрузить из Documents
        let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    func saveImage(_ image: UIImage, name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return false }
        let fileURL = FileManager.getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print(NSLocalizedString("faled.save.img", comment: "") + "\(error)")
            return false
        }
    }
    
    func loadImage(name: String) -> UIImage? {
        // Сначала пробуем загрузить из Assets
        if let image = UIImage(named: name) {
            return image
        }
        
        // Если нет в Assets, пробуем загрузить из Documents
        let fileURL = FileManager.getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func deletePost(postId: String) {
        if let index = allPosts.firstIndex(where: { $0.id == postId }) {
            if let imageName = allPosts[index].imageName {
                // Удаляем только если изображение было сохранено в Documents
                let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
                if FileManager.default.fileExists(atPath: imagePath.path) {
                    try? FileManager.default.removeItem(at: imagePath)
                }
            }
            allPosts.remove(at: index)
            saveData()
        }
    }
}
