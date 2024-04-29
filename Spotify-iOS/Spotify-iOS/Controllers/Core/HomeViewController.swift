//
//  HomeViewController.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        fetchNewReleaseData()
        fetchFeaturePlaylistData()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),style: .done, target: self, action: #selector(didTabSetting))
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
    
    @objc func didTabSetting() {
        let vc = SettingsViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: false)
    }
}
