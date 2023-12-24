//
//  CacheService.swift
//  WhispR
//
//  Created by Amish on 03/08/2023.
//

import Foundation
import SwiftUI

class CacheService {
    static let shared = CacheService()
    private var imageCache: [String: Image] = [:]
    
    // This returns the image
    func getImage(forKey: String) -> Image? {
        return imageCache[forKey]
    }
    
    // This saves the image
    func setImage(image: Image, forKey: String) {
        imageCache[forKey] = image
    }
}
