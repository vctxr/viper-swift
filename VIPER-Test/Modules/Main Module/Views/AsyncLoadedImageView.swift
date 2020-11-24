//
//  AsyncLoadedImageView.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

/// A shared cache to store  images
final class ImageCacher {
    
    static let shared = ImageCacher()
    
    private init() {}
    
    let imageCache = NSCache<NSString, NSData>()
}

/// A custom image view subclass to load images from cache or asynchronously
final class AsyncLoadedImageView: UIImageView {
    
    var task: URLSessionTask!
    
    /// Loads the image from cache, if doesnt exist then load image asynchronously
    /// - Parameter url: URL representing the image url
    func loadImage(from url: URL) {
        image = nil
        
        // Cancel any ongoing tasks
        if let task = task {
            task.cancel()
        }
        
        if let cachedImageData = ImageCacher.shared.imageCache.object(forKey: url.absoluteString as NSString) {
            image = UIImage(data: cachedImageData as Data)
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data, let newImage = UIImage(data: imageData), error == nil else { return }
            
            ImageCacher.shared.imageCache.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
