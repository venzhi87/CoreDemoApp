//
//  ViewController.swift
//  CoreDemoApp
//
//  Created by Pavel Kuzovlev on 19.04.2022.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var tasklist: [TaskToDo] = []
    private let cellID = "task"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
        fetchData()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/25,
            alpha: 194/253
        )
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }

    
    @objc private func addNewTask() {
        let taskVC = TaskViewController()
        taskVC.delegate = self
        present(taskVC, animated: true)
    }
    private func fetchData() {
        let fetchRequest = TaskToDo.fetchRequest()
        do {
            tasklist =  try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
}

extension TaskListViewController :TaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
    
    
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasklist.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasklist[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}





