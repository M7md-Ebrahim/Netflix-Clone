//
//  PreviewViewController.swift
//  Netflix
//
//  Created by M7md  on 02/05/2024.
//

import UIKit
import WebKit
class PreviewViewController: UIViewController {
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let overviewleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let downloadButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.setImage(UIImage(systemName: "arrowshape.down.fill"), for: .normal)
        btn.tintColor = .label
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewleLabel)
        view.addSubview(downloadButton)
        applyConstraints()
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // webview
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),

            // title label
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // overview label
            overviewleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // download button
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewleLabel.bottomAnchor, constant: 25),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    func configure(_  moviePreview: MoviePreview) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(moviePreview.youtubeItem.id.videoID)") else {return}
        webView.load(URLRequest(url: url))
        titleLabel.text = moviePreview.title
        overviewleLabel.text = moviePreview.overview
    }
}
