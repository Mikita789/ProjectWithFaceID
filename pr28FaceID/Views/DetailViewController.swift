//
//  DetailViewController.swift
//  pr28FaceID
//
//  Created by Никита Попов on 6.10.23.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    let delegate: AppendElementProtocol? = nil
    var infoTextView: UITextView!
    var saveButton: UIButton!
    var currentNode:NodeDataModel?
    var currentEditingState = false{
        didSet{
            if currentEditingState == false{
                //скрыть кнопку
                UIView.animate(withDuration: 0.5) {
                    self.saveButton.alpha = 0

                } completion: { fin in
                    if fin{
                        self.saveButton.isHidden = true
                    }
                }
                self.infoTextView.isEditable = false
            }else{
                //открыть кнопку
                self.saveButton.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.saveButton.alpha = 1
                }
                self.infoTextView.isEditable = true
                self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        createInfoLabel()
        createButtonNavBar()
        createSaveButton()
        buttonView()

    }
    
    private func createInfoLabel(){
        infoTextView = UITextView()
        view.addSubview(infoTextView)
        
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            infoTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            infoTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        infoTextView.text = currentNode?.trueBody
        infoTextView.isEditable = false 
    }
    
    private func createButtonNavBar(){
        let buttonEdit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonAction))
        navigationItem.rightBarButtonItem = buttonEdit
    }
    
    private func createSaveButton(){
        saveButton = UIButton()
        view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: 5),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(buttonSaveAction), for: .touchUpInside)
        saveButton.isHidden = self.currentEditingState ? false : true
        saveButton.alpha = 0
    }
    
    private func buttonView(){
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2
        self.saveButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
    }
    
    private func saveNewNode(newBody: String){
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let req:NSFetchRequest<NodeDataModel> = NodeDataModel.fetchRequest()
        
        guard let items = try? context.fetch(req) else { return }
        for item in items{
            if item.id == self.currentNode?.id{
                item.trueBody = newBody
            }
        }
        
        do{
            try context.save()
            delegate?.fetchData()
        }catch{
            print("не удалось сохранить изменения. \(error.localizedDescription)")
        }

    }
    
    @objc func buttonSaveAction(){
        guard let trueBody = self.infoTextView.text else { return }
        self.currentNode?.trueBody = trueBody
        saveNewNode(newBody: trueBody)
        navigationController?.popViewController(animated: true)
        //save new information
    }
    
    @objc func editButtonAction(){
        self.infoTextView.isEditable = true
        self.currentEditingState.toggle()
    }
    

}
