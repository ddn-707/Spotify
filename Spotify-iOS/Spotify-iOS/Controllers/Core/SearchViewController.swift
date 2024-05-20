//
//  SearchViewController.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import UIKit

class SearchViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: UIViewController())
        searchController.searchBar.placeholder = "Songs, Artists, Albums, Podcasts"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                // Have Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                //Add padding to item
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 2,
                    leading: 7,
                    bottom: 2,
                    trailing: 7
                )
                //Group
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)
                    ),
                    subitem: item,
                    count: 2
                )
                group.contentInsets = NSDirectionalEdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 10,
                    trailing: 0
                )
                return NSCollectionLayoutSection(group: group)
            }
        )
    )
    // Create array categories
    private var categories = [Category]()
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        view.backgroundColor = .systemBackground
        
        //Add searchResultsUpdater to searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        //collectionView
        view.addSubview(collectionView)
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.sync {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension SearchViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        let viewModel = CategoryCollectionViewCellViewModel(
            title: category.name,
            artworkURL: URL(string: category.icons.first?.url ?? "")
        )
        cell.configure(with: viewModel)
        return cell
    }
}
