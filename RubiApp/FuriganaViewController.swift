//
//  FuriganaViewController.swift
//  RubiApp
//
//  Created by 渡邊輝夢 on 2020/04/08.
//  Copyright © 2020 Terumu Watanabe. All rights reserved.
//

import UIKit

class FuriganaViewController: UIViewController {
    
    @IBOutlet weak var furiganaTableView: UITextView!
       
    var furiganaString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        furiganaTableView.layer.cornerRadius = 5
        furiganaTableView.text = furiganaString
        furiganaTableView.isEditable = false
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
