//
//  Model.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//

import Foundation


extension Post {
    static var mockData: [Post] {
        [
            Post(id: "1", author: "Анна", text: "Сегодня прекрасный день для прогулки в парке!",
                 imageName: "park", isFavorite: false, date: Date(), postType: .feed),
            Post(id: "2", author: "Максим", text: "Попробовал новый рецепт пасты - получилось вкусно!",
                 imageName: "pasta", isFavorite: false, date: Date().addingTimeInterval(-3600), postType: .feed),
            Post(id: "3", author: "София", text: "Мои впечатления от нового фильма...",
                 imageName: "film", isFavorite: false, date: Date().addingTimeInterval(-7200), postType: .feed),
            Post(id: "4", author: "Иван", text: "Только что закончил марафон! Лучшее чувство в мире.",
                 imageName: "marathon", isFavorite: false, date: Date().addingTimeInterval(-10800), postType: .feed),
            Post(id: "5", author: "Елена", text: "Открыла для себя новый кофейный магазин - их латте просто божественный!",
                 imageName: "coffee", isFavorite: false, date: Date().addingTimeInterval(-14400), postType: .feed),
            Post(id: "6", author: "Дмитрий", text: "Поделюсь фотографией с нашего вчерашнего похода в горы.",
                 imageName: "mountain", isFavorite: false, date: Date().addingTimeInterval(-18000), postType: .feed),
            Post(id: "7", author: "Ольга", text: "Прочитала потрясающую книгу 'Тень ветра' - всем рекомендую!",
                 imageName: "book", isFavorite: false, date: Date().addingTimeInterval(-21600), postType: .feed),
            Post(id: "8", author: "Алексей", text: "Мой новый проект наконец-то запущен! Кто хочет посмотреть?",
                 imageName: "project", isFavorite: false, date: Date().addingTimeInterval(-25200), postType: .feed),
            Post(id: "9", author: "Мария", text: "Утро начинается с хорошей музыки и чашки горячего чая.",
                 imageName: "morning", isFavorite: false, date: Date().addingTimeInterval(-28800), postType: .feed),
            Post(id: "10", author: "Сергей", text: "Первый снег в этом году! Дети в восторге.",
                 imageName: "snow", isFavorite: false, date: Date().addingTimeInterval(-32400), postType: .feed),
            Post(id: "11", author: "Алиса", text: "Нашла старые фотографии из путешествия в Италию. Ностальгия...",
                 imageName: "italy", isFavorite: false, date: Date().addingTimeInterval(-36000), postType: .feed),
            Post(id: "12", author: "Павел", text: "Сегодня научился готовить суши дома. Получилось не идеально, но вкусно!",
                 imageName: "sushi", isFavorite: false, date: Date().addingTimeInterval(-39600), postType: .feed),
            Post(id: "13", author: "Татьяна", text: "Мой сад наконец-то начал цвести. Весна пришла!",
                 imageName: "garden", isFavorite: false, date: Date().addingTimeInterval(-43200), postType: .feed)
        ]
    }
}
