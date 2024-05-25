//
//  CollecCell.swift
//  Netflix
//
//  Created by M7md  on 18/12/2023.
//

import UIKit
import RealmSwift

protocol CollecCellDelgate: AnyObject {
    func didTap(_ cell: CollectionTableViewCell, moviePreview: MoviePreview)
}

class CollectionTableViewCell: UITableViewCell {
    static let identifier = "CollectionTableViewCell"

    weak var delegate: CollecCellDelgate?
    private var movies: [Movie] = []
    private let movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return collection
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(movieCollectionView)
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        movieCollectionView.frame = contentView.bounds
    }
    public func configureSection (_ movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {[weak self] in
            self?.movieCollectionView.reloadData()
        }
    }
    private func download(_ indexPath: IndexPath) {
        DataPersistence.shared.downloadMovie(movie: movies[indexPath.row]) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("Added"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell
        else {return UICollectionViewCell()}
        guard let val = movies[indexPath.row].posterPath else {return UICollectionViewCell()}
        cell.setPoster(val)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieName = movies[indexPath.row].originalTitle ?? movies[indexPath.row].originalName, let movieOverview = movies[indexPath.row].overview else {return}
        API.shared.getMovie(movieName) { result in
            switch result {
            case .success(let youtubeItem):
                self.delegate?.didTap(self, moviePreview: MoviePreview(title: movieName, overview: movieOverview, youtubeItem: youtubeItem))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            let downloadAction = UIAction(title: "Add To Watchlist", image: UIImage(systemName: "stopwatch")) { _ in
                self?.download(indexPath)
            }
            return UIMenu(children: [downloadAction])
        })
    }
}
