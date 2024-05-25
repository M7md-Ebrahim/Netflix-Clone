//
//  SearchViewController.swift
//  Netflix
//
//  Created by M7md  on 14/12/2023.
//

import UIKit

class SearchViewController: UIViewController {
    private let discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlayTableViewCell.self, forCellReuseIdentifier: PlayTableViewCell.identifier)
        return tableView
    }()
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search for a Movie or a Tv show"
        search.searchBar.searchBarStyle = .minimal
        return search
    }()
    private var movies: [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTableView)
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        searchController.searchResultsUpdater = self
        getData()
    }
    private func getData() {
        API.shared.getDiscover(complation: { [weak self] results in
            switch results {
            case .success(let result):
                self?.movies = result
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayTableViewCell.identifier, for: indexPath) as? PlayTableViewCell else {return UITableViewCell()}
        let cellInfo = CellInfo(titleName: (movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle) ?? "Unknown", posterURL: movies[indexPath.row].posterPath ?? "")
        cell.configureData(cellInfo)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieName = movies[indexPath.row].originalTitle ?? movies[indexPath.row].originalName, let movieOverview = movies[indexPath.row].overview else {return}
        API.shared.getMovie(movieName) { result in
            switch result {
            case .success(let youtubeItem):
                DispatchQueue.main.async {[weak self] in
                    let moviePreview = MoviePreview(title: movieName, overview: movieOverview, youtubeItem: youtubeItem)
                    let previewViewController = PreviewViewController()
                    previewViewController.configure(moviePreview)
                    self?.navigationController?.pushViewController(previewViewController, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultController = searchController.searchResultsController as? SearchResultsViewController
        else {return}
        if query.trimmingCharacters(in: .whitespaces).count < 3 {
            DispatchQueue.main.async {
                resultController.movies.removeAll()
                resultController.resultsCollectionView.reloadData()
            }
        } else {
            API.shared.getQuery(query, complation: { results in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let result):
                        resultController.movies = result
                        resultController.resultsCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            )
        }
        resultController.delegate = self
    }
    func didTap(_ moviePreview: MoviePreview) {
        DispatchQueue.main.async {[weak self] in
            let previewViewController = PreviewViewController()
            previewViewController.configure(moviePreview)
            self?.navigationController?.pushViewController(previewViewController, animated: true)
        }
    }
}
