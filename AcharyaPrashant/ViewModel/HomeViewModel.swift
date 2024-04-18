//
//  HomeViewModel.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 18/04/24.
//

import Foundation

final class HomeViewModel {
    private var imageList: [ImageResponse] = []
    private let imageService: ImageService
    
    init(imageService: ImageService = ImageService()) {
        self.imageService = imageService
    }
    
    func loadData(completion: @escaping (Result<[ImageResponse], Error>) -> Void) {
        Task {
            do {
                let images = try await imageService.getAllImages()
                self.imageList = images
                completion(.success(images))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getImageCount() -> Int {
        return imageList.count
    }
    
    func getImage(at index: Int) -> ImageResponse {
        return imageList[index]
    }
}
