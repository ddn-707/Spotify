//
//  FeaturePlaylistCollectionViewCell.swift
//  Spotify-iOS
//
//  Created by DND on 02/05/2024.
//

import SDWebImage
import UIKit

class FeaturePlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturePlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLable: UILabel = {
       let nameLable = UILabel()
        nameLable.font = .systemFont(ofSize: 18, weight: .thin)
        nameLable.textAlignment = .center
        nameLable.numberOfLines = 0
        return nameLable
    }()
    
    private let creatorNameLable: UILabel = {
       let creatorLable = UILabel()
        creatorLable.font = .systemFont(ofSize: 15, weight: .thin)
        creatorLable.textAlignment = .center
        creatorLable.numberOfLines = 0
        return creatorLable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLable)
        contentView.addSubview(creatorNameLable)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistNameLable.frame = CGRect(x: 3, y: contentView.height - 30, width: contentView.width - 6, height: 30)
        creatorNameLable.frame = CGRect(x: 3, y: contentView.height - 60, width: contentView.width - 6, height: 30)
        let imageSize = contentView.height - 70
        playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize)/2, y: 3, width: imageSize, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistCoverImageView.image = nil
        playlistNameLable.text = nil
        creatorNameLable.text = nil
    }
    
    func configure (with viewModel : FeaturedPlaylistCellViewModel){
        playlistNameLable.text = viewModel.name
        creatorNameLable.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
}
