//
//  CardViewController.swift
//  NoticeBoardApp
//
//  Created by Ramesh Madavaram on 05/01/21.
//

import UIKit

class CardViewController: UIViewController {
    @IBOutlet weak var tableview :UITableView!
    var cardViewArray  = [[String:Any]]()
    let getNoticeBoardListURL = "http://18.136.149.198:2020/api/noticeboards?filter[include]=userData&filter[order]=postdate%20DESC"
    let deleteCardURL = "http://18.136.149.198:2020/api/noticeboards"
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "CardTableViewCell")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        self.tableview.addSubview(refreshControl)
        self.serviceCallToGetNoticeBoard()
    }
    
    @objc func refresh(_ refreshControl:UIRefreshControl) {
        self.serviceCallToGetNoticeBoard()
    }
    func serviceCallToGetNoticeBoard() {
        guard let url = URL(string: getNoticeBoardListURL) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [[String: Any]] {
                print(responseJSON)
                self.cardViewArray = responseJSON
                DispatchQueue.main.async {
                                    self.tableview.reloadData()

                }
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                print("CARDCOUNT:::",self.cardViewArray.count)
            }
        }.resume()
    }
    
    func servicelToDeleteCard(id:String){
        let  urlStr = self.deleteCardURL + "/" + "\(id)"
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
        }.resume()
    }
    
    @IBAction func addNewCard(_ sender: Any) {
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewCardViewController") as! CreateNewCardViewController
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    @IBAction func guideButtonAction(_ sender: Any) {
        let guideVC = self.storyboard?.instantiateViewController(withIdentifier: "GuideViewController") as! GuideViewController
        self.navigationController?.pushViewController(guideVC, animated: true)
        
    }
    

}

extension CardViewController:UITableViewDelegate,UITableViewDataSource{
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MMM-dd"
            return  dateFormatter.string(from: date!)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardViewArray.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell") as! CardTableViewCell
        let card = cardViewArray[indexPath.section]
        cell.nameLabel.text = card["title"] as? String
        cell.descriptionLabel.text = card["description"] as? String
        cell.idLabel.text = card["id"] as? String
        cell.editButton.tag = indexPath.section
        cell.editButton.addTarget(self, action: #selector(editCardAction), for: .touchUpInside)
       let date = self.convertDateFormater(card["postdate"] as! String )
        cell.dateLabel.text = date
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let card = cardViewArray[indexPath.section]
            self.servicelToDeleteCard(id: card["id"] as! String )
            self.cardViewArray.remove(at: indexPath.section)
            self.tableview.reloadData()
        }
    }
    @objc func editCardAction(sender: UIButton) {
        print("On CLick EDIT PRESSED")
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewCardViewController") as! CreateNewCardViewController
        createVC.isEditVC = true
        createVC.cardObject = self.cardViewArray[sender.tag]
        self.navigationController?.pushViewController(createVC, animated: true)
    }
}

