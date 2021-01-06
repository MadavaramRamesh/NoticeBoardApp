//
//  ViewController.swift
//  NoticeBoardApp
//
//  Created by Ramesh Madavaram on 05/01/21.
//

import UIKit

class CreateNewCardViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descTextField: UITextField!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var apartmentLabel: UILabel!
    @IBOutlet weak var apartmentTextField: UITextField!
    
    @IBOutlet weak var postButton: UIButton!
    
    var isEditVC:Bool = false
    var cardObject :[String:Any]?
    
    let editURL = "http://18.136.149.198:2020/api/noticeboards/editNoticeboardData/"
    let createURL = "http://18.136.149.198:2020/api/noticeboards/createPost"
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditVC{//Edit VC
            self.apartmentTextField.text =  cardObject?["id"] as? String
            self.descTextField.text =  cardObject?["description"] as? String
            self.statusTextField.text =  cardObject?["status"] as? String
            self.noteTextField.text =  cardObject?["note"] as? String
            self.titleTextField.text =  cardObject?["title"] as? String
            self.apartmentTextField.isEnabled = false
            self.postButton.setTitle("Save Card", for: .normal)
        }else{
            self.postButton.setTitle("Create New Card", for: .normal)
            
        }
    }
    
    @IBAction func createCard(_ sender: Any) {
        guard  titleTextField.text != "" || statusTextField.text != ""
                || titleTextField.text != "" ||  descTextField.text != "" else {
            let alert = UIAlertController(title: "Alert", message: "Please enter all the details", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.serviceCallCreateOrUpdate(isEdit: isEditVC)
    }
    
    
    func serviceCallCreateOrUpdate(isEdit:Bool){
        var parameters: [String: Any] = [:]
        if isEdit{
            parameters = ["status":statusTextField.text ?? "","title":titleTextField.text ?? "","description":descTextField.text ?? "","appartmentId":cardObject?["id"] ?? "","images":["/containers/users/download/2AYMSmuSS.png"],"postdate":"2020-12-31T16:32:00.000Z"]
        }else{
            parameters = ["status":statusTextField.text ?? "","title":titleTextField.text ?? "","description":descTextField.text ?? "","appartmentId":apartmentTextField.text ?? "","images":["/containers/users/download/2AYMSmuSS.png"],"postdate":"2020-12-31T16:32:00.000Z"]
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        let url = URL(string: isEdit == true ? editURL : createURL)!
        var request = URLRequest(url: url)
        request.httpMethod =  isEdit == true ? "PUT" : "POST"
        request.httpBody = jsonData
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if isEdit{
                print(" \n CARD EDITED  Succesfully \n")
            }else{
                print("\n ************CARD CREATED  Succesfully************** \n")
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        task.resume()
        
    }
}

