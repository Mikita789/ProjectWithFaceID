//
//  DetailViewController.swift
//  pr28FaceID
//
//  Created by Никита Попов on 6.10.23.
//

import UIKit
import CoreData
import LocalAuthentication


class DetailViewController: UIViewController {
    let delegate: AppendElementProtocol? = nil
    var originalFrame:CGRect!
    var infoTextView: UITextView!
    var saveButton: UIButton!
    var currentNode:NodeDataModel?
    var privateState: Bool = true
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
    let contextFaceID = LAContext()

    
    override func loadView() {
        super.loadView()
        var error:NSError?
        var errorPass: NSError?
        if contextFaceID.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            contextFaceID.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Аутентификация с помощью Face ID") { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        // Аутентификация прошла успешно
                        print("FaceID прошла успешно")
                        self.privateState = false
                        self.infoTextView.text = self.privateState ? self.currentNode?.falseBody : self.currentNode?.trueBody
                    } else {
                        // Аутентификация не удалась или была отменена пользователем
                        self.privateState = true
                    }
                }
            }
        } else {
            print("устройстов не поддерживает FaceID")
            //нужно запросить пароль от устройства
            if contextFaceID.canEvaluatePolicy(.deviceOwnerAuthentication, error: &errorPass){
                contextFaceID.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Введите пароль от устройства") { succ, error in
                    if succ{
                        DispatchQueue.main.async {
                            print("Введен правильный пароль")
                            self.privateState = false
                            self.infoTextView.text = self.privateState ? self.currentNode?.falseBody : self.currentNode?.trueBody
                        }
                    }else{
                        print("пароль введен неверно")
                        self.privateState = true
                    }
                }
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
        registerForKeyboardNotifications()

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
        infoTextView.text = self.privateState ? currentNode?.falseBody : currentNode?.trueBody
        infoTextView.isEditable = false
        infoTextView.font = .systemFont(ofSize: 25)
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
        if !self.privateState{
            self.infoTextView.isEditable = true
            self.currentEditingState.toggle()
        }
//        self.infoTextView.isEditable = true
//        self.currentEditingState.toggle()
    }
    
    private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            
            // Сохраняем исходное положение элементов
            originalFrame = saveButton.frame
            
            // Получаем высоту клавиатуры
            let keyboardHeight = keyboardFrame.height
            
            //если ищем пересечение двух UI элементов
            if saveButton.frame.intersects(keyboardFrame){
                UIView.animate(withDuration: 0.3) {
                    let buttonOffset = self.saveButton.frame.maxY - keyboardFrame.minY
                    self.saveButton.frame.origin.y = self.saveButton.frame.origin.y - buttonOffset - 20
                    //self.saveButton.frame.origin.y = -(keyboardHeight - (self.view.frame.maxY - self.saveButton.frame.maxY))
                    //keyboardHeight - (self.view.frame.maxY - self.buttonLogin.frame.maxY)
                }
            }
        }
        //когда клавиатура закрывается
        @objc private func keyboardWillHide(_ notification: Notification) {
            // Возвращаем элементы на исходное положение
            UIView.animate(withDuration: 0.3) {
                self.saveButton.frame = self.originalFrame
            }
        }


    

}
