//
//  ViewController.swift
//  Tapptic
//
//  Created by Lilian on 23/01/2019.
//  Copyright © 2019 Lilian. All rights reserved.
//

import UIKit

// MARK : We define here a protocol in order to communicate the selected row to the detailed scene. -
protocol ObjectSelectionDelegate: class {
    func objectSelected(_ newObject: ObjectModel)
}

class MasterViewController: UIViewController, UISplitViewControllerDelegate {
    
    // MARK : IB and UI -
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    
    // MARK : DATA IN -
    var objectList: [ObjectModel] = []
    
    // MARK : Handling delegate protocol :
    var delegate: ObjectSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tapptic"
        self.getObjectList()
        guard let splitViewController = splitViewController else { return }
        // This next line ensure that the first scene is the list.
        splitViewController.delegate = self
        if UIApplication.shared.statusBarOrientation.isPortrait {
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                // Ensure displaying only the list
                splitViewController.minimumPrimaryColumnWidth = splitViewController.view.bounds.size.width
                splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
                splitViewController.preferredDisplayMode = .primaryOverlay
            default:
                // Ensure displaying all scenes when rotating
                splitViewController.preferredDisplayMode = .automatic
            }
        } else {
            splitViewController.preferredDisplayMode = .automatic
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let splitViewController = splitViewController else { return }
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if UIDevice.current.orientation.isPortrait {
                splitViewController.minimumPrimaryColumnWidth = splitViewController.view.bounds.size.width
                splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width
                splitViewController.preferredDisplayMode = .primaryOverlay
            } else {
                splitViewController.maximumPrimaryColumnWidth = splitViewController.view.bounds.size.width/2
                splitViewController.minimumPrimaryColumnWidth = splitViewController.view.bounds.size.width/2
                splitViewController.preferredPrimaryColumnWidthFraction = 0.5
                splitViewController.preferredDisplayMode = .automatic
            }
        default:
            splitViewController.preferredDisplayMode = .automatic
        }
    }
    
    
    // MARK : API REQUEST -
    func getObjectList() {
        loaderActivityIndicator.startAnimating()
        URLSession.shared.requestObjectList { [weak self] (result) in
            guard let me = self else { return }
            switch result {
            case .success(let objectListFromWS):
                me.objectList = objectListFromWS
                DispatchQueue.main.async {
                    me.tableView.reloadData()
                    me.loaderActivityIndicator.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: error.domain, message: "Voulez-vous réessayer ?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ré essayez", style: .default, handler: { (_) in
                        me.getObjectList()
                    }))
                    alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
                    me.loaderActivityIndicator.stopAnimating()
                    me.present(alert, animated: true)
                }
            }
        }
    }
    
    // Ensure that the first scene seen 
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let detailedViewController = delegate as? DetailedViewController, detailedViewController.object != nil {
            return false
        }
        return true
    }
}

// MARK : TABLE VIEW -
extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! TableViewCell
        cell.fillWith(object: objectList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        let currentCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        currentCell.setSelectedStyle()
        let selectedObject = objectList[indexPath.row]
        delegate.objectSelected(selectedObject)
        // Opening the view when the cell is selected :
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if UIDevice.current.orientation.isPortrait {
                splitViewController?.preferredDisplayMode = .primaryHidden
            } else {
                splitViewController?.preferredDisplayMode = .automatic
            }
            showDetailViewController()
        default:
            showDetailViewController()
        }
    }
    
    func showDetailViewController() {
        if let detailedViewController = delegate as? DetailedViewController,
            let detailedNavigationController = detailedViewController.navigationController {
            splitViewController?.showDetailViewController(detailedNavigationController, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let currentCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        currentCell.setTouchedStyle()
        return indexPath
    }
}


