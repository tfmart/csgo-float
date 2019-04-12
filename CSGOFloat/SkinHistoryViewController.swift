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
        //skinCollectionView.setCollectionViewLayout(AddCellAnimation(), animated: false)
        lookupButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let pasteboardSrting = UIPasteboard.general.string {
            if (pasteboardSrting.hasPrefix("steam://rungame/730/")) {
                let pasteboardAlert = UIAlertController(title: "Inspect Link Detected", message: "We detected a inspect link on your copyboard. Would you like to use it?", preferredStyle: .alert)
                pasteboardAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.inspectLinkTextField.text = UIPasteboard.general.string
                    self.lookupSkin()
                }))
                pasteboardAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(pasteboardAlert, animated: true, completion: nil)
            }
        }
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
        cell.tag = indexPath.row
        if(cell.tag == indexPath.row) {
            cell.skinImageView.load(url: URL(string: (skin.iteminfo?.imageURL)!)!)
            cell.styleByRarity(weapon: skin)
        }
        cell.layer.cornerRadius = 8.0
        cell.nameLabel.text = skinModel.skinName(skin: skin)
        cell.floatLabel.text = "\(skin.iteminfo?.floatValue ?? 0.0)"
        return cell
    }

    fileprivate func lookupSkin() {
        let endpoint: String = "https://api.csgofloat.com/?url=\(inspectLinkTextField.text ?? "")"
        skinModel.getSkin(endpoint: endpoint, callback: {(skin) -> Void in
            DispatchQueue.main.async {
                if self.skinList.isEmpty == false {
                    self.skinList.reverse()
                }
                if skin.iteminfo != nil {
                    self.skinList.append(skin)
                    self.skinList.reverse()
                    self.skinCollectionView.reloadData()
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: skin.error, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func lookupButtonPressed(_ sender: Any) {
        inspectLinkTextField.resignFirstResponder()
        lookupSkin()
    }
}
