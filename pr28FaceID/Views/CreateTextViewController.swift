//
//  CreateTextViewController.swift
//  pr28FaceID
//
//  Created by Никита Попов on 29.09.23.
//

import UIKit
import CoreData

class CreateTextViewController: UIViewController {
    var delegate:AppendElementProtocol?
    var textView: UITextView!
    var netwManager = FetchData()
    private var titleNewNode = ""
    private var falseBody = ""
    private var trueBody = ""
    private var currentJoke = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        netwManager.fetchData(limit: 1) { res in
            self.currentJoke = res.joke ?? "Unknow joke"
        }
        createTextView()
        saveNodeButton()
        
        title = "Add new node"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func createTextView(){
        textView = UITextView()
        view.addSubview(textView)
        
        textView.frame = view.bounds
        
        textView.font = .systemFont(ofSize: 25)
        textView.text = ""
    }
    
    private func saveNodeButton(){
        let buttonSaveNode = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNodeAction))
        navigationItem.rightBarButtonItem = buttonSaveNode
    }
    
    //MARK: - Save new object CoreData
    private func saveData(node: NodeModel){
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        guard let ent = NSEntityDescription.entity(forEntityName: "NodeDataModel", in: context) else { return }
        
        let newNode = NodeDataModel(entity: ent, insertInto: context)
        newNode.date = node.dateString
        newNode.falseBody = node.falseBody
        newNode.trueBody  = node.trueBody
        newNode.title = node.title
        newNode.isPrivate = node.isPrivate
        
        do{
            try context.save()
            self.delegate?.updateElement(node: node, nodeData: newNode)
        }catch{
            print("не удалось сохранить заметку. \(error.localizedDescription)")
        }
    }
    
    @objc func saveNodeAction(){
        self.trueBody = self.textView.text ?? "Some text"

    
        let alertController = UIAlertController(title: "Enter title", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            let title = alertController.textFields?.first?.text ?? "xxx"
            let newNode = NodeModel(title: title, date: Date(), trueBody: self.trueBody, falseBody: self.currentJoke)
            self.saveData(node: newNode)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
        }

}
