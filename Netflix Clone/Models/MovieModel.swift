//
//  MovieModel.swift
//  Netflix
//
//  Created by M7md  on 05/05/2024.
//

import Foundation
import RealmSwift
class MovieModel: Object {
    @Persisted var id: Int = 0
    @Persisted var mediaType: String?
    @Persisted var originalName: String?
    @Persisted var originalTitle: String?
    @Persisted var posterPath: String?
    @Persisted var overview: String?
    @Persisted var voteCount: Int = 0
    @Persisted var releaseDate: String?
    @Persisted var voteAverage: Double = 0.0
}
