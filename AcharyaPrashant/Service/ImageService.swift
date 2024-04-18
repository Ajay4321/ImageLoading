//
//  ImageService.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 16/04/24.
//

import Foundation

final class ImageService {
    
    static let baseUrl = "https://acharyaprashant.org/api/v2"

    private enum EndPoint{
        case ImageList
        
        var path: String{
            switch self {
            case .ImageList: return "/content/misc/media-coverages?limit=100"
            }
        }
        
        var url: String {
            switch self {
            case .ImageList: return "\(baseUrl)\(path)"
            default: return ":"
            }
        }
    }
    
     func getAllImages() async throws -> [ImageResponse] {
        guard Reachability.isConnectedToNetwork(),
              let url = URL(string: EndPoint.ImageList.url) else {
                  throw CustomError.noConnection
              }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let imageList = try JSONDecoder().decode([ImageResponse].self, from: data)
                return imageList
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
