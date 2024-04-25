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
        fetchData()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),style: .done, target: self, action: #selector(didTabSetting))
    }
    
    private func fetchData (){
        APICaller.shared.getNewReleases { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
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
