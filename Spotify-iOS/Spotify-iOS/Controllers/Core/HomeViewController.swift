//
//  HomeViewController.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import UIKit

enum BrowserSectionType {
    case newRelease(viewModels:[NewReleaseCellViewModel])
    case featurePlaylist(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendTrack(viewModels: [RecommendedTrackCellViewModel])
    //Adding computed properties to associate Titles
    var title: String{
        switch self{
        case .newRelease:
            return "Newly Released Albums"
        case .featurePlaylist:
            return "Featured Playlists"
        case .recommendTrack:
            return "Recommended Tracks"
        }
    }
}

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
    
    private var sections = [BrowserSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName:  "gear"),style: .done, target: self, action: #selector(didTabSetting))
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds     }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
        )
        collectionView.register(
            NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier
        )
        collectionView.register(
            FeaturePlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier
        )
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        
        var newRelease: NewReleasesResponse?
        var featurePlaylist: FeaturePlaylistReponse?
        var recommendation: RecommendationsResponse?
        
        //New release
        APICaller.shared.getNewReleases { newReleaseResult in
            defer {
                group.leave()
            }
            switch newReleaseResult {
            case .success(let model):
                newRelease = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Feature Playlist
        APICaller.shared.getFeaturePlaylist { featurePlaylistResult in
            defer {
                group.leave()
            }
            switch featurePlaylistResult {
            case .success(let model):
                featurePlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Recommed track
        APICaller.shared.getRecommendedGenres { RecommendedGenresResult in
            switch RecommendedGenresResult {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count <  5 {
                    if let radom = genres.randomElement() {
                        seeds.insert(radom)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { recommendationResult in
                    defer {
                        group.leave()
                    }
                    switch recommendationResult {
                    case .success(let model):
                        recommendation = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        group.notify(queue: .main) {
            guard let newAlbum = newRelease?.albums.items,
            let playlists = featurePlaylist?.playlists.items,
            let tracks = recommendation?.tracks else {
                fatalError("Model are nil")
            }
            self.configureModels(
                newAlbums: newAlbum,
                playlists: playlists,
                tracks: tracks
            )
        }
        
    }
    
    private func configureModels (newAlbums: [Album],playlists: [Playlist], tracks: [AudioTrack]) {
        //Configure Models
        sections.append(
            .newRelease(
                viewModels: newAlbums.compactMap(
                    {
                        return NewReleaseCellViewModel(
                            name: $0.name,
                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                            numberOfTracks: $0.total_tracks,
                            artistName: $0.artists.first?.name ?? "-"
                        )
                    }
                )
            )
        )
        
        sections.append(
            .featurePlaylist(
                viewModels: playlists.compactMap(
                    {
                        return FeaturedPlaylistCellViewModel(
                            name: $0.name,
                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                            creatorName: $0.owner.display_name
                        )
                    }
                )
            )
        )
        sections.append(
            .recommendTrack(
                viewModels: tracks.compactMap(
                    {
                        return RecommendedTrackCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "_",
                            artworkURL:URL(string:$0.album.images.first?.url ?? "")
                        )
                    }
                )
            )
        )
        
        collectionView.reloadData()
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
        let type = sections[section]
        switch type {
        case.newRelease(let viewModels):
            return viewModels.count
        case .featurePlaylist(let viewModels):
            return viewModels.count
        case .recommendTrack(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case.newRelease(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featurePlaylist(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturePlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .recommendTrack(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionViewCell()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        switch section {
        case 0:
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
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.95),
                    heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            )
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementaryViews
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1:
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
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 2
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.95),
                    heightDimension: .absolute(360)
                ),
                subitem: verticalGroup,
                count: 2
            )
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementaryViews
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 2:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Vertical Group in Horizontal Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Vertical Group in Horizontal Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 1
            )
            //Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
       
    }
}
