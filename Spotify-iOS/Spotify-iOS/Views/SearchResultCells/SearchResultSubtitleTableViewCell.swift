//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify-iOS
//
//  Created by DND on 20/05/2024.
//

import UIKit

class SearchResultSubtitleTableViewCell: UITableViewCell {
    //identifier
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        
        let labelHeight = contentView.height/2
        let labelCoordinateX = iconImageView.right + 10
        let labelWidth = contentView.width - iconImageView.right - 15
        label.frame = CGRect(
            x: labelCoordinateX,
            y: 0,
            width: labelWidth ,
            height: labelHeight
        )
        subtitleLabel.frame = CGRect(
            x: labelCoordinateX,
            y: label.bottom,
            width: labelWidth,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel){
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(
            with: viewModel.imageURL,
            placeholderImage: UIImage(systemName: "person"),
            completed: nil
        )
    }
}
