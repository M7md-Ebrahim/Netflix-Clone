//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by M7md  on 14/12/2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    private let upcomingTableView: UITableView = {
        let table = UITableView()
        table.register(PlayTableViewCell.self, forCellReuseIdentifier: PlayTableViewCell.identifier)
        return table
    }()

    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        view.addSubview(upcomingTableView)
        getData()
        navigationController?.navigationBar.tintColor = .label
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    private func getData() {
        API.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let result):
                self?.movies = result
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayTableViewCell.identifier, for: indexPath)  as? PlayTableViewCell else {return UITableViewCell()}
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
