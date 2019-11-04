//
//  SkinHistoryViewController.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 17/12/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import UIKit
import SWGOFloat

class SkinHistoryViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var inspectLinkTextField: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var skinCollectionView: UICollectionView!
    
    //MARK: - Constants and Variables
    
    var skinList: [Skin] = []
    
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
        let configuration = SWGOConfiguration(inspectLink: inspectLink)
        let requester = SWGORequester(configuration: configuration) { (skin, error) in
            guard let skin = skin else {
                self.presentErrorMessage(message: error?.message ?? ApiError.unknownError.message)
                return
            }
            DispatchQueue.main.async {
                self.appendNewSkin(skin: skin)
            }
        }
        requester.start()
    }
    
    fileprivate func appendNewSkin(skin: Skin) {
        if !self.skinList.isEmpty {
            self.skinList.reverse()
        }
        self.skinList.append(skin)
        self.skinList.reverse()
        self.skinCollectionView.reloadData()
    }
    
    fileprivate func checkPasteboard() {
        if let pasteboardSrting = UIPasteboard.general.string, pasteboardSrting.isInspectLink {
            let pasteboardAlert = UIAlertController(title: "Inspect Link Detected", message: "We detected a inspect link on your pasteboard. Would you like to use it?", preferredStyle: .alert)
            pasteboardAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.inspectLinkTextField.text = pasteboardSrting
                self.getSkinInfo()
            }))
            pasteboardAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(pasteboardAlert, animated: true, completion: nil)
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
            if let imageLink = skin.itemInfo?.imageURL, let imageURL = URL(string: imageLink) {
                cell.skinImageView.load(url: imageURL)
            }
            
            cell.styleByRarity(weapon: skin)
        }
        cell.layer.cornerRadius = 8.0
        cell.nameLabel.text = skin.itemInfo?.fullItemName
        cell.floatLabel.text = "\(skin.itemInfo?.floatValue ?? 0.0)"
        return cell
    }
}
