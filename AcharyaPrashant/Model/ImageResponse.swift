//
//  ImageResponse.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 16/04/24.
//

import Foundation


struct Images: Codable {
    let data: [ImageResponse]
}
// MARK: - WelcomeElement
struct ImageResponse: Codable {
    let id, title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

// MARK: - BackupDetails
struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Int
}

