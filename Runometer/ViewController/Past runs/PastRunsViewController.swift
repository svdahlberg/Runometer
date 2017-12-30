//
//  PastRunsViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class PastRunsViewControlller: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var runs: [Run]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runs = RunService().savedRuns()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let runDetailsViewController = segue.destination as? RunDetailsViewController {
            runDetailsViewController.run = sender as? Run
        }
    }
}

extension PastRunsViewControlller: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastRunTableViewCellIdentifier", for: indexPath) as! PastRunTableViewCell
        cell.run = runs?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let run = runs?[indexPath.row] else { return }
            RunService.delete(run)
            runs = RunService().savedRuns()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let run = runs?[indexPath.row]
        performSegue(withIdentifier: "RunDetailsSegueIdentifier", sender: run)
    }
}
