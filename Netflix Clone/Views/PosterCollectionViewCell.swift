//
//  PosterCollectionViewCell.swift
//  Netflix
//
//  Created by M7md  on 27/04/2024.
//

import UIKit
import SDWebImage

class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCell"
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
    }
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    func setPoster (_  posterURL: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") else {return}
        posterImageView.sd_setImage(with: url)
    }
}
