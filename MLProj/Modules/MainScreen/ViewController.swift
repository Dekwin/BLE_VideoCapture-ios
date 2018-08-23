//
//  ViewController.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/3/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: BaseViewController {
    @IBOutlet weak var actionsTableView: UITableView!
    
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var bleSwitcher: UISwitch!
    let vm = MainVM.configuredVM()
    
    @IBAction func bleSwitcherSwitched(_ sender: UISwitch) {
        if sender.isOn {
            vm.enableBLE()
        } else {
            vm.disableBLE()
            setError(text: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionsTableView.dataSource = self
        vm.delegate = self
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.bleActionsLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCellIdentifier", for: indexPath) as! ActionTableViewCell
        cell.update(withAction: vm.bleActionsLog[indexPath.row])
        return cell
    }
    
    
}

extension ViewController: BLEConfiguratorView {
    
    func didRecieve(requestAction: BLERequestAction) {
        actionsTableView.reloadData()
    }
    
    var bleIsEnabled: Bool {
        get {
            return bleSwitcher.isOn
        }
        set {
            bleSwitcher.setOn(newValue, animated: true)
        }
    }
    
    func recordingDidStart(withError error: Error?) {
        setError(text: error?.localizedDescription)
    }
    
    func recordingDidStop() {
        setError(text: nil)
    }
    
    func bleState(isPoweredOn: Bool) {
        bleSwitcher.isEnabled = isPoweredOn
        if !isPoweredOn {
            setError(text: "Please, power on BT")
        }
    }
    
    private func setError(text: String?) {
        DispatchQueue.main.async {
        if let text = text {
            self.errorButton.setTitle(text, for: .normal)
            self.errorButton.isHidden = false
        }else {
            self.errorButton.isHidden = true
        }
        }
    }
    
}


