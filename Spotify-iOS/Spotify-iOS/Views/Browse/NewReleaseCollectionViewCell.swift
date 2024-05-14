//
//  NewReleaseCollectionViewCell.swift
//  Spotify-iOS
//
//  Created by DND on 02/05/2024.
//

import Foundation
import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 22, weight: .semibold)
        return lable
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 18, weight: .semibold)
        return lable
    }()
    
    private let artistNameLabel: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 18, weight: .semibold)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        let albumLableSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 10,
                height: contentView.height - imageSize - 10
            )
        )
        let albumLableHeight = min(50, albumLableSize.height)

        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
//        albumNameLabel.backgroundColor = .red
//        artistNameLabel.backgroundColor = .blue
//        numberOfTracksLabel.backgroundColor = .purple
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            width: albumLableSize.width,
            height: albumLableHeight
        )
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumNameLabel.bottom ,
            width: contentView.width - albumCoverImageView.right - 5,
            height: albumLableHeight
        )
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: artistNameLabel.bottom ,
            width: numberOfTracksLabel.width,
            height: albumLableHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        albumCoverImageView.image = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
    }
    
    func configure(with viewModel: NewReleaseCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks:\(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
