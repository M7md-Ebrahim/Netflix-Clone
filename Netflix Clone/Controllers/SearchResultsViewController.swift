//
//  SearchResultsViewController.swift
//  Netflix
//
//  Created by M7md  on 30/04/2024.
//

import UIKit
import SDWebImage

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTap(_ moviePreview: MoviePreview)
}
class SearchResultsViewController: UIViewController {
    weak var delegate: SearchResultsViewControllerDelegate?
    private let val = 0.0
    public var movies: [Movie] = []
    public let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumLineSpacing = 0
        let colec = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colec.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return colec
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(resultsCollectionView)
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()}
        cell.setPoster(movies[indexPath.row].posterPath ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieName = movies[indexPath.row].originalTitle ?? movies[indexPath.row].originalName, let movieOverview = movies[indexPath.row].overview else {return}
        API.shared.getMovie(movieName) { result in
            switch result {
            case .success(let youtubeItem):
                let moviePreview = MoviePreview(title: movieName, overview: movieOverview, youtubeItem: youtubeItem)
                self.delegate?.didTap(moviePreview)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
