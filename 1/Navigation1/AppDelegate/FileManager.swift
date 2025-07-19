//
//  FileManager.swift
//  Navigation1
//
//  Created by Елена Хайрова on 19.07.2025.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
