//
//  HomeViewController.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex,_ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        })
    )
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),style: .done, target: self, action: #selector(didTabSetting))
        configureCollectionView()
        view.addSubview(spinner)
        fetchNewReleaseData()
        fetchFeaturePlaylistData()
        fetchRecommendation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds     }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
   
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        //Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        //Vertical Group in Horizontal Group
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.0),
                heightDimension: .absolute(360)
            ),
            subitem: item,
            count: 3
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.95),
                heightDimension: .absolute(360)
            ),
            subitem: verticalGroup,
            count: 1
        )
        //Section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func fetchNewReleaseData (){
        APICaller.shared.getNewReleases { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    
    private func fetchFeaturePlaylistData() {
        APICaller.shared.getFeaturePlaylist { result in
            switch result {
            case .success(let model):
                break
            case .failure(let model):
                break
            }
        }
    }
    
    private func fetchRecommendation (){
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count <  5 {
                    if let radom = genres.randomElement() {
                        seeds.insert(radom)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
                break
            case .failure(let model):
                break
            }
        }
    }
    
    @objc func didTabSetting() {
        let vc = SettingsViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
        return cell
    }
}
