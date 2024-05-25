//
//  HomeViewController.swift
//  Netflix
//
//  Created by M7md  on 14/12/2023.
//

import UIKit
enum Sections: Int {
    case trendingMovies = 0
    case trendingTvs = 1
    case popular = 2
    case upcomingMovies = 3
    case topRated = 4
}
class HomeViewController: UIViewController {
    private var headerView: HeroHeaderView?

    private let feedTableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()

    let sectionTitles = ["Trending Movies", "Trending TVs", "Popular", "Upcoming Movies", "Top Rated"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(feedTableView)
        feedTableView.delegate = self
        feedTableView.dataSource = self
        configureNavigationBar()
        configureHeaderView()
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: 450))
        feedTableView.tableHeaderView = headerView
        navigationController?.hidesBarsOnSwipe = true
    }

    private func configureNavigationBar () {
        var netfilxLogo = UIImage(named: "logo")
        netfilxLogo = netfilxLogo?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netfilxLogo, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }

    private func configureHeaderView() {
        API.shared.getTrendingMovies(complation: { [weak self] results in
            switch results {
            case .success(let results):
                let randomMovie = results.randomElement()
                self?.headerView?.configureHeroImageView(CellInfo(titleName: "", posterURL: randomMovie?.posterPath ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath)as?CollectionTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            API.shared.getTrendingMovies(complation: { results in
                switch results {
                case .success(let results):
                    cell.configureSection(results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        case Sections.trendingTvs.rawValue:
            API.shared.getTrendingTVs(complation: { results in
                switch results {
                case .success(let results):
                    cell.configureSection(results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        case Sections.popular.rawValue:
            API.shared.getPopular(complation: { results in
                switch results {
                case .success(let results):
                    cell.configureSection(results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        case Sections.upcomingMovies.rawValue:
            API.shared.getUpcomingMovies(complation: { results in
                switch results {
                case .success(let results):
                    cell.configureSection(results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        case Sections.topRated.rawValue:
            API.shared.getTopRated(complation: { results in
                switch results {
                case .success(let results):
                    cell.configureSection(results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            headerTitle.textLabel?.frame = CGRect(x: headerTitle.bounds.origin.x + 15, y: headerTitle.bounds.origin.y, width: 100, height: headerTitle.bounds.height)
            headerTitle.textLabel?.textColor = .label
            headerTitle.textLabel?.text = headerTitle.textLabel?.text?.capitalizeFirstLetter()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollecCellDelgate {
    func didTap(_ cell: CollectionTableViewCell, moviePreview: MoviePreview) {
        DispatchQueue.main.async {[weak self] in
            let previewViewController = PreviewViewController()
            previewViewController.configure(moviePreview)
            self?.navigationController?.pushViewController(previewViewController, animated: true)
        }
    }
}
