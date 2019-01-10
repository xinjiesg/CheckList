//
//  ViewController.swift
//  Checklist
//
//  Created by xin jie on 16/12/18.
//  Copyright © 2018 xinjie. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = todoList.todos[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            configureCheckmark(for: cell, with:item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        //let indexPaths = [indexPath]
        //tableView.deleteRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let label  = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmark = cell.viewWithTag(1001) as? UILabel else {
            return
        }
        if item.checked {
            checkmark.text = "√"
        } else {
            checkmark.text = ""
        }
        item.toggleChecked()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let ItemDetailViewController = segue.destination as? ItemDetailViewController {
                ItemDetailViewController.delegate = self
                ItemDetailViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue" {
            if let ItemDetailViewController = segue.destination as? ItemDetailViewController{
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell){
                    let item = todoList.todos[indexPath.row]
                    ItemDetailViewController.itemToEdit = item
                    ItemDetailViewController.delegate = self
                }
            }
        }
    }

}


extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todos.count - 1 // todolist ald include new item, need to find previoud rowIndex
        let indexpath = IndexPath(row:rowIndex, section: 0)
        let indexPaths = [indexpath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}


