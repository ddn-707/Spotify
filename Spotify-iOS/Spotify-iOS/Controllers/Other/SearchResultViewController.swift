//
//  SearchResultViewController.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import UIKit
//TODO: Build UI for search result 
class SearchResultViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(
            SearchResultDefaultTableViewCell.self,
            forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier
        )
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        tableView.isHidden = true
       return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
