//
//  DataPersistence.swift
//  Netflix
//
//  Created by M7md  on 05/05/2024.
//

import Foundation
import RealmSwift

enum DatabasError: Error {
    case failedToSaveData
    case failedToFetchData
    case failedToDeleteData
}
class DataPersistence {
    static let shared = DataPersistence()

    func downloadMovie(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        let movieModel = MovieModel()
        movieModel.id = movie.id
        movieModel.mediaType = movie.mediaType
        movieModel.originalName = movie.originalName
        movieModel.originalTitle = movie.originalTitle
        movieModel.posterPath = movie.posterPath
        movieModel.overview = movie.overview
        movieModel.voteCount = movie.voteCount
        movieModel.releaseDate = movie.releaseDate
        movieModel.voteAverage = movie.voteAverage
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(movieModel)
            }
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }

    func fetchDownloeaded(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        do {
            let realm = try Realm()
            let movieModel = realm.objects(MovieModel.self)
            completion(.success(Array(movieModel)))
        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }

    func deleteMovie(movieModel: MovieModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(movieModel)
            }
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
    }
}
