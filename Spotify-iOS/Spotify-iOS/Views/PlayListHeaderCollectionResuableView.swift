//
//  PlayListHeaderCollectionResuableView.swift
//  Spotify-iOS
//
//  Created by DND on 03/06/2024.
//

import Foundation
import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate : PlaylistHeaderCollectionReusableViewDelegate?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let descriptionLable: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let ownerLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    // Button for playlist
    private let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLable)
        addSubview(ownerLabel)
        addSubview(playButton)
        playButton.addTarget(
            self,
            action: #selector(didTapPlayAll),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //TODO: Handle button play
    @objc private func didTapPlayAll(){
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/2
        imageView.frame = CGRect(
            x: (width - imageSize)/2,
            y: 20,
            width: imageSize,
            height: imageSize
        )
        nameLabel.frame = CGRect(x: 10,  y: imageView.bottom, width: width - 20, height: 44)
        descriptionLable.frame =  CGRect( x: 10, y: nameLabel.bottom, width: width - 20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLable.bottom, width: width - 20, height: 44)
        playButton.frame = CGRect(x: width - 80, y: width - 80, width: 60, height: 60)
    }
    
    func configure(with model: PlaylistHeaderViewModel){
        nameLabel.text = model.name
        descriptionLable.text = model.description
        ownerLabel.text = model.ownerName
        imageView.sd_setImage(
            with: model.artworkURL,
            placeholderImage: UIImage(systemName: "photo"),
            completed: nil
        )
    }
}
