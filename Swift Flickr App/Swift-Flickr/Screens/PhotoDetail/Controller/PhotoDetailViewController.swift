//
//  PhotoDetailViewController.swift
//  Swift-Flickr
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var photo: Photo?
    
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerImageView1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Creat ImageView CornerRadius
        ownerImageView1.layer.cornerRadius = 24.0
        
        // MARK: - Creat Photos Detail Fetch Data
        ownerNameLabel.text = photo?.ownername
        fetchImage(with: photo?.urlZ) { data in
            self.imageViewPhoto.image = UIImage(data: data)
        }
        
        if  let iconserver = photo?.iconserver,
            let iconfarm = photo?.iconfarm,
            let nsid = photo?.owner,
            NSString(string: iconserver).intValue > 0 {
            fetchImage(with: "http://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid).jpg") { data in
                self.ownerImageView1.image = UIImage(data: data)
            }
            
        }
        else {
            fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                self.imageViewPhoto.image = UIImage(data: data)
            }
        }
        
        title = photo?.title
        
        if ((photo?.description?.content) != nil) {
            descriptionLabel.text = photo?.description?.content
        }
        else {
            descriptionLabel.text = "Failed to get description"
            
        }
    }
    
    // MARK: - Fetch Image
    private func fetchImage(with url : String?, competion: @escaping (Data) -> Void) {
        if let urlString = url, let url = URL(string: urlString)  {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        competion(data)
                    }
                    
                }
            }.resume()
        }
    }
    
}
