//
//  ViewController.swift
//  pr28FaceID
//
//  Created by Никита Попов on 29.09.23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var table:UITableView!
    var tableCellID = "cellPrototype"
    var nodesArr:[NodeModel] = []
    var nodeData:[NodeDataModel] = []
    var appendNodeViewController = CreateTextViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nodes"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchData()
        createTableView()
        table.reloadData()
        createNavBarButtons()
        appendNodeViewController.delegate = self
        
    }
    
    private func createTableView(){
        table = UITableView()
        view.addSubview(table)
        table.frame = view.bounds
        table.register(TableViewCell.self, forCellReuseIdentifier: tableCellID)
        table.delegate = self
        table.dataSource = self
        
    }
    
    internal func fetchData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let req:NSFetchRequest<NodeDataModel> = NodeDataModel.fetchRequest()
        
        do{
            nodeData = try context.fetch(req)
        }catch{
            print("не удалось выгрузить данные. \(error.localizedDescription)")
        }
    }
    
    private func deleteItem(node: NodeDataModel, ind: Int){
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let req:NSFetchRequest<NodeDataModel> = NodeDataModel.fetchRequest()
        
        do{
            let items = try context.fetch(req)
            for item in items{
                if item.id == node.id{
                    context.delete(item)
                }
            }
            try context.save()
            self.nodeData.remove(at: ind)
            table.reloadData()
        }catch{
            fatalError("не удалось получить данный")
        }
    }
    
    private func createNavBarButtons(){
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = buttonAdd
    }
    
    @objc func addButtonAction(){
        navigationController?.pushViewController(self.appendNodeViewController, animated: true)
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.nodeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: self.tableCellID, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.setData(node: nodeData[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("delete \(indexPath.row)")
            deleteItem(node: nodeData[indexPath.row], ind: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.currentNode = self.nodeData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: AppendElementProtocol{
    func updeteData() {
        table.reloadData()
    }
    
    func updateElement(node: NodeModel, nodeData: NodeDataModel) {
        self.nodesArr.append(node)
        self.nodeData.append(nodeData)
        self.table.reloadData()
    }
}
