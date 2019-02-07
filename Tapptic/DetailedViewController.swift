//
//  DetailedViewController.swift
//  Tapptic
//
//  Created by Lilian on 23/01/2019.
//  Copyright © 2019 Lilian. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    // MARK UI :
    @IBOutlet private weak var detailedImageView: UIImageView!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK DATA INPUT + refreshing UI each time it's been updated :
    var object: ObjectModel? {
        didSet {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let splitViewController = splitViewController else { return }
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if UIDevice.current.orientation.isPortrait {
                splitViewController.minimumPrimaryColumnWidth = splitViewController.view.bounds.size.width
                splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
                splitViewController.preferredDisplayMode = .primaryHidden
            } else {
                splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width/2
                splitViewController.minimumPrimaryColumnWidth = splitViewController.view.bounds.size.width/2
                splitViewController.preferredDisplayMode = .allVisible
            }
        default:
            splitViewController.preferredDisplayMode = .automatic
        }
    }
    
    func refreshUI() {
        guard let name = object?.name else { return }
        if #available(iOS 9.0, *) {
            loadViewIfNeeded()
        }
        requestText(name)
    }

    func requestText(_ name: String) {
        loaderActivityIndicator.startAnimating()
        URLSession.shared.requestDetailText(name: name, completion: { [weak self] (result) in
            guard let me = self else {
                self?.loaderActivityIndicator.stopAnimating()
                return
            }
            switch result {
            case .success(let object):
                DispatchQueue.main.async {
                    if let image = object.image {
                        me.detailedImageView?.sd_setImage(with: URL(string: image), completed: nil)
                    }
                    me.textLabel.text = object.text
                    me.loaderActivityIndicator.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: error.domain, message: "Voulez-vous réessayer ?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ré essayez", style: .default, handler: { (_) in
                        me.requestText(name)
                    }))
                    alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
                    me.loaderActivityIndicator.stopAnimating()
                    me.present(alert, animated: true)
                }
            }
        })
    }
}

// MARK : Extension handling the communication of the object data flow between Master and Detailed scenes -
extension DetailedViewController: ObjectSelectionDelegate {
    
    func objectSelected(_ newObject: ObjectModel) {
        object = newObject
    }
    
}
