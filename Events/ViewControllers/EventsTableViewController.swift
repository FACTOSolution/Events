//
//  EventsTableViewController.swift
//  Events
//
//  Created by Orlando Amorim on 25/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import RealmSwift

class EventsTableViewController: UITableViewController {
    
    let results = try! Realm().objects(Event.self).sorted(byKeyPath: "startDate", ascending: true)
    var notificationToken: NotificationToken?
    var canLoadMore: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadEvents()
        observeNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.title = Events.localizable.tabBar.events.localized
        
        // UIRefreshControl
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(update), for: UIControlEvents.valueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: Events.localizable.tableView.pullToRefresh.localized )
        self.refreshControl = refreshControl
    }
    
    func observeNotification () {
        // Observe Results Notifications
        notificationToken = results.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: UITableViewRowAnimation.none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .fade)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    deinit {
        notificationToken?.stop()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as! EventCell
        cell.set(results[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEvent", sender: nil)
    }
    
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "ShowEvent" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! EventViewController
                controller.event = results[indexPath.row]

            }
        }
     }
 
}

extension EventsTableViewController{
    
    // MARK: - Update
    
    @objc func update(){
        print(canLoadMore)
        if canLoadMore {
            loadEvents()
        }
    }
    
    func loadEvents() {
        
        EventNetworkAdapter.getEvent(paginated: true, success: { (isLastPage) in
            self.refreshControl?.endRefreshing()
            if isLastPage {
                self.canLoadMore = false
            }
        }, error: { (error) in
            print(error)
        }) { (moyaError) in
            print(moyaError)
        }
        
    }
    
}
