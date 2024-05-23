//
//  SearchResultDefaultTableViewCell.swift
//  Spotify-iOS
//
//  Created by DND on 20/05/2024.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    //Identifier
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        iconImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagaSize = contentView.height - 10
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imagaSize,
            height: imagaSize
        )
        iconImageView.layer.cornerRadius = imagaSize/2
        iconImageView.layer.masksToBounds = true
        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: contentView.height
        )
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel){
        label.text = viewModel.title
        iconImageView.sd_setImage(
            with: viewModel.imageURL,
            placeholderImage: UIImage(systemName: "person"),
            completed: nil
        )
    }
}
