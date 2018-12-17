//
//  SkinHistoryViewController.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 17/12/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import UIKit

class SkinHistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var inspectLinkTextField: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var skinCollectionView: UICollectionView!
    
    let skinModel = SkinModel()
    var skinList: [WeaponSkin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookupButton.layer.cornerRadius = 5.0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skinList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skinCell", for: indexPath) as! SkinHistoryCollectionViewCell
        let skin = skinList[indexPath.row]
        cell.nameLabel.text = skinModel.skinName(skin: skin)
        cell.floatLabek.text = "\(skin.iteminfo?.floatValue ?? 0.0)"
        cell.skinImageView.load(url: URL(string: (skin.iteminfo?.imageURL)!)!)
        //cell.layer.frame = CGRect(x: 6.0, y: CGFloat(indexPath.row) * skinCollectionView.frame.width + 20, width: skinCollectionView.frame.width - 24, height: skinCollectionView.frame.width - 24)
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.36, green:0.75, blue:0.87, alpha:1.0).cgColor
        return cell
    }

    @IBAction func lookupButtonPressed(_ sender: Any) {
        inspectLinkTextField.resignFirstResponder()
        let endpoint: String = "https://api.csgofloat.com/?url=\(inspectLinkTextField.text ?? "")"
        skinModel.getSkin(endpoint: endpoint, callback: {(skin) -> Void in
            DispatchQueue.main.async {
                if self.skinList.isEmpty == false {
                    self.skinList.reverse()
                }
                if skin.iteminfo != nil {
                    self.skinList.append(skin)
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: skin.error, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                self.skinList.reverse()
                self.skinCollectionView.reloadData()
            }
        })
    }
}
