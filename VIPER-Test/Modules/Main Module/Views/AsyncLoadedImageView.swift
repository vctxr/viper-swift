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
    
    let imageCache = NSCache<AnyObject, AnyObject>()
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
        
        if let cachedImage = ImageCacher.shared.imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = cachedImage
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data), error == nil else { return }
            
            ImageCacher.shared.imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
