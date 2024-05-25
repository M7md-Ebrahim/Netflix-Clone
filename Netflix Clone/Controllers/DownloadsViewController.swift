//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by M7md  on 14/12/2023.
//

import UIKit
class DownloadsViewController: UIViewController {
    private var movies: [MovieModel] = []
    private let downloadTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlayTableViewCell.self, forCellReuseIdentifier: PlayTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        downloadTableView.dataSource = self
        downloadTableView.delegate = self
        view.addSubview(downloadTableView)
        navigationController?.navigationBar.tintColor = .label
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchData()
        }
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame = view.bounds
    }
    private func fetchData() {
        DataPersistence.shared.fetchDownloeaded { [weak self] results in
            switch results {
            case .success(let result):
                self?.movies = result
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayTableViewCell.identifier, for: indexPath) as? PlayTableViewCell else {return UITableViewCell()}
        let cellInfo = CellInfo(titleName:(movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle) ?? "Unknown", posterURL: movies[indexPath.row].posterPath ?? "")
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataPersistence.shared.deleteMovie(movieModel: movies[indexPath.row]) { results in
                switch results {
                case .success:
                    print("Done")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
