//
//  ViewController.swift
//  CoreDemoApp
//
//  Created by Pavel Kuzovlev on 19.04.2022.
//

import UIKit
import CoreData


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
        showAlert(with: "New Task", and: "What do You want to do")

    }
    
    private func fetchData() {
        let fetchRequest = TaskToDo.fetchRequest()
        do {
            tasklist =  try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save (_ taskName: String) {
        let task = TaskToDo(context: viewContext)
        task.title = taskName
        tasklist.append(task)
        
        let cellIndex = IndexPath(row: tasklist.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
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





