//
//  UpcomingTableViewCell.swift
//  Netflix
//
//  Created by M7md  on 27/04/2024.
//

import UIKit
import SDWebImage

class PlayTableViewCell: UITableViewCell {
    static let identifier = "PlayTableViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let movieTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()

    private let playButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieTitle)
        contentView.addSubview(playButton)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Poster ImageView
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            // Movie TitleLabel
            movieTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieTitle.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            movieTitle.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),
            // Play Button
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    public func configureData (_ cellInfo: CellInfo) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(cellInfo.posterURL)") else {return}
        posterImageView.sd_setImage(with: url)
        movieTitle.text = cellInfo.titleName
    }
}
