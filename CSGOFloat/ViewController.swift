//
//  ViewController.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 07/11/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var inspectLinkTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var floatLabel: UILabel!
    @IBOutlet weak var lookupButton: UIButton!
    
    let skinModel = SkinModel()
    var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        floatLabel.text = ""
        lookupButton.layer.cornerRadius = 5.0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func getFloatButtonPressed(_ sender: Any) {
        inspectLinkTextField.resignFirstResponder()
        let endpoint: String = "https://api.csgofloat.com/?url=\(inspectLinkTextField.text ?? "")"
        skinModel.getSkin(endpoint: endpoint, callback: {(skin) -> Void in
            DispatchQueue.main.async {
                if skin.iteminfo != nil {
                    self.nameLabel.text = self.skinModel.skinName(skin: skin)
                    self.floatLabel.text = "\(skin.iteminfo?.floatValue ?? 0.0)"
                    self.imageView.load(url: URL(string: (skin.iteminfo?.imageURL)!)!)
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: skin.error, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        })
    }
}
