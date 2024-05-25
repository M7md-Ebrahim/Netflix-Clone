//
//  HeroHeaderView.swift
//  Netflix
//
//  Created by M7md  on 18/04/2024.
//

import UIKit
import SDWebImage

class HeroHeaderView: UIView {
    private let downloadButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Download", for: .normal)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        return btn
    }()


    private let playButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Play", for: .normal)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        return btn
    }()


    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()


    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors =
        [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        return gradient
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        layer.addSublayer(gradientLayer)
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        heroImageView.frame = bounds
        gradientLayer.frame = bounds
    }
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Download Button
            downloadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            // Play Button
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    public func configureHeroImageView (_ cellInfo: CellInfo) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(cellInfo.posterURL)") else {return}
        heroImageView.sd_setImage(with: url)
    }
}
