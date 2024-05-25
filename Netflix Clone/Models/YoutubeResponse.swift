//
//  YoutubeResponse.swift
//  Netflix
//
//  Created by M7md  on 02/05/2024.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [YouTubeItem]
}
struct YouTubeItem: Codable {
    let id: YouTubeID
}
struct YouTubeID: Codable {
    let kind, videoID: String
    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}
