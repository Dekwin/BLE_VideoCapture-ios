//
//  VideoListViewController.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import UIKit

class VideoListViewController: BaseViewController {
    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteClosure = {[weak self] (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            self?.vm.removeVideo(atIndex: indexPath.row, callback: { (error) in
                if error == nil {
                    self?.removeRow(at: indexPath)
                } else {
                    self?.tableView.reloadData()
                }
            })
        }
        
        let exportClosure = { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            print("Export button pressed")
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: deleteClosure)
        let exportAction = UITableViewRowAction(style: .normal, title: "Export", handler: exportClosure)
        
        return [deleteAction, exportAction]
    }
    
    private func removeRow(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
}
