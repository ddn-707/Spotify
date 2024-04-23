//
//  ProfileViewController.swift
//  Spotify-iOS
//
//  Created by DND on 12/04/2024.
//
import SDWebImage
import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
<<<<<<< Updated upstream
=======
    private func updateUI(with user: UserProfile){
        tableView.isHidden = false
        //configure the model
        models.append("Full name: \(user.display_name)")
        models.append("Email Address: \(user.email)")
        models.append("User ID: \(user.id)")
        models.append("Plan: \(user.product)")
        createTableHeader(with: "https://img.freepik.com/free-photo/beautiful-lake-landscape_23-2150725023.jpg")
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?){
        guard let urlString = string , let url = URL(string: urlString) else {
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none 
        return cell
    }
    
>>>>>>> Stashed changes
}
