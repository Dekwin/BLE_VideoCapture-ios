//
//  BaseViewController.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/23/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let item: UIBarButtonItem = UIBarButtonItem(title: "hjvg", style: UIBarButtonItemStyle.done, target: self, action: nil)
        navigationItem.rightBarButtonItem = item
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}