//
//  SavedViewController.swift
//  MakaChan
//
//  Created by Andrii Yehortsev on 22.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem.title = "Saved"
        tabBarItem.image = UIImage(named: "saved-tab-image")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
