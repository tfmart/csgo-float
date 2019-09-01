//
//  SkinHistoryViewController.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 17/12/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import UIKit

class SkinHistoryViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var inspectLinkTextField: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var skinCollectionView: UICollectionView!
    
    //MARK: - Constants and Variables
    
    let skinController = SkinController()
    var skinList: [WeaponSkin] = []
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookupButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPasteboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func presentErrorMessage(message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func getSkinInfo() {
        guard let inspectLink = inspectLinkTextField.text else {
            presentErrorMessage(message: "Invalid inspect link")
            return
        }
        skinController.fetchSkin(inspectLink: inspectLink) { (skin) in
            guard skin.iteminfo != nil else {
                if let error = skin.error {
                    self.presentErrorMessage(message: error)
                } else {
                    self.presentErrorMessage(message: "Failed to fetch skin information. Please try again")
                }
                return
            }
            DispatchQueue.main.async {
                self.appendNewSkin(skin: skin)
            }
        }
    }
    
    fileprivate func appendNewSkin(skin: WeaponSkin) {
        if !self.skinList.isEmpty {
            self.skinList.reverse()
        }
        self.skinList.append(skin)
        self.skinList.reverse()
        self.skinCollectionView.reloadData()
    }
    
    fileprivate func checkPasteboard() {
        if let pasteboardSrting = UIPasteboard.general.string {
            if (pasteboardSrting.hasPrefix("steam://rungame/730/")) {
                let pasteboardAlert = UIAlertController(title: "Inspect Link Detected", message: "We detected a inspect link on your copyboard. Would you like to use it?", preferredStyle: .alert)
                pasteboardAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.inspectLinkTextField.text = UIPasteboard.general.string
                    self.getSkinInfo()
                }))
                pasteboardAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(pasteboardAlert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - @IBActions
    
    @IBAction func lookupButtonPressed(_ sender: Any) {
        inspectLinkTextField.resignFirstResponder()
        getSkinInfo()
    }
}

//MARK: - UICollectionView Delegate and Data Source

extension SkinHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        cell.nameLabel.text = skinController.setSkinName(skin: skin)
        cell.floatLabel.text = "\(skin.iteminfo?.floatValue ?? 0.0)"
        return cell
    }
}
