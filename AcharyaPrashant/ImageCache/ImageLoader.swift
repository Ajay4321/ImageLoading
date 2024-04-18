//
//  ImageLoader.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 17/04/24.
//

import UIKit

class ImageLoader {
    // Singleton instance
    static let shared = ImageLoader()
    
    // Memory cache
    private let memoryCache = NSCache<NSString, UIImage>()
    
    // Disk cache directory
    private let diskCacheDirectory: URL = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ImageCache")
    }()
    
    private init() {
        // Create the disk cache directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: diskCacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating disk cache directory: \(error)")
            }
        }
    }
    
    // Add image to cache
    func addImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
        
        // Save to disk asynchronously
        DispatchQueue.global().async {
            if let data = image.pngData() {
                let filePath = self.diskCacheDirectory.appendingPathComponent(key)
                let fileManager = FileManager.default

                let directory = filePath.deletingLastPathComponent()
                do {
                    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating intermediate directories: \(error)")
                }
                
                // Write the file
                do {
                    try data.write(to: filePath)
                } catch {
                    print("Error writing image to disk cache: \(error)")
                }
            }
        }
    }
    
    // Retrieve image from cache
    func image(forKey key: String) -> UIImage? {
        // Check memory cache
        if let image = memoryCache.object(forKey: key as NSString) {
            return image
        }
        
        // Check disk cache
        let filePath = diskCacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            // Add to memory cache for future access
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
    
    // Download image from URL
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if image is cached
        let cacheKey = url.absoluteString
        if let cachedImage = image(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // Download image
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Add image to cache
            self.addImage(image, forKey: cacheKey)
            
            // Return downloaded image
            completion(image)
        }.resume()
    }
}
