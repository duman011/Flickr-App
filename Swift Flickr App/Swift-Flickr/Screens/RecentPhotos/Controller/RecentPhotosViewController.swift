//
//  RecentPhotosViewController.swift
//  Swift-Flickr
//



import UIKit

class RecentPhotosViewController: UITableViewController, UISearchResultsUpdating {
    
    private var response: PhotosResponse?
    private var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController()
        fetchRecentPhotos()
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
    
    // MARK: - Fetch Photos
    private func fetchRecentPhotos() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=df1a50b2a88aedcfebd1ed7ee14b6d89&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else {
            print("Hata Oluştu veriler Çekilemedi !!!")
            return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                self.response = response
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
    
    // MARK: - Search Photos
    private func searchPhotos(with text: String) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=df1a50b2a88aedcfebd1ed7ee14b6d89&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else {
            print("Hata Oluştu veriler Çekilemedi !!!")
            return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                self.response = response
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
    
    // MARK: - Create Search Bar
    private func searchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            searchPhotos(with: text)
        }
        if text.count < 2 {
            fetchRecentPhotos()
        }
    }
    
    // MARK: - UITableViewDataSorce && UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let photo = response?.photos?.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.ownerNameLabel.text = photo?.ownername
        cell.titleLabel.text = photo?.title
        //Fetch Image
        fetchImage(with: photo?.urlZ) { data in
            cell.photoImageView.image = UIImage(data: data)
        }
        // Fetch Buddy Icons
        if  let iconserver = photo?.iconserver,
            let iconfarm = photo?.iconfarm,
            let nsid = photo?.owner,
            NSString(string: iconserver).intValue > 0 {
            fetchImage(with: "http://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid).jpg") { data in
                cell.ownerImageView.image = UIImage(data: data)
            }
            
        }
        else {
            fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                cell.ownerImageView.image = UIImage(data: data)
            }
        }
        
        cell.titleLabel.text = photo?.title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = response?.photos?.photo?[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gidilecekVC = segue.destination as? PhotoDetailViewController {
            gidilecekVC.photo = selectedPhoto
        }
    }
    
}

