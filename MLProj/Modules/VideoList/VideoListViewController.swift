//
//  VideoListViewController.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var vm: VideoListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        vm = VideoListVM(videosSource: VideoFilesSource(withFilesSourceURL: AppConstants.Video.folderUrl!))
        tableView.reloadData()
    }
    
    private func setViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath) as! VideoListTableViewCell
        cell.update(withVideo: vm.videos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.videos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
