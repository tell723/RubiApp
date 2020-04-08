//
//  ViewController.swift
//  RubiApp
//
//  Created by 渡邊輝夢 on 2020/04/08.
//  Copyright © 2020 Terumu Watanabe. All rights reserved.
//

import UIKit


struct TextPostData: Codable {
    
    let app_id: String
    let sentence: String
    let output_type: String
}

struct Furigana: Codable {
    
    let converted: String
    let output_type: String
    let request_id: String
}



class ViewController: UIViewController {
    
    
    @IBOutlet weak var showFuriganaButton: UIButton!
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var furiganaString = ""
    private var selectedKana = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showFuriganaButton.layer.cornerRadius = showFuriganaButton.frame.size.height / 2
        originalTextView.layer.cornerRadius = 5
        activityIndicatorView.hidesWhenStopped = true
        selectedKana = "hiragana"
    }
    
    
    @IBAction func kanaSegmentTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedKana = "hiragana"
        case 1:
            selectedKana = "katakana"
        default:
            break
        }
    }
    
    
    
    
    @IBAction func showFuriganaButtonTapped(_ sender: Any) {
        
        if originalTextView.text == "" {
            
            showAlert(title: "テキストが空です", message: "")
            return
        }
        
        fetchFurigana()
    }
    
    
    private func fetchFurigana() {
        
        activityIndicatorView.startAnimating()
        
        let url = URL(string: "https://labs.goo.ne.jp/api/hiragana")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let textPostData = TextPostData(app_id: "c4b3aacf9a964268611b30e0144c37fc8e2916a1f7a90c3f86c7a1ed20b968a5",
                                        sentence: originalTextView.text,
                                        output_type: selectedKana)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonTextPostData = try? encoder.encode(textPostData) else {
            print("json encoding error")
            return
        }
        request.httpBody = jsonTextPostData
        
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue.main
        queue.async(group: dispatchGroup) {
            dispatchGroup.enter()
            
            let urlSession = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("error: \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode != 200  {
                    print("error")
                    print(String(data: data!, encoding: .utf8)!)
                    return
                }
                guard let data = data,
                    let jsonData = try? JSONDecoder().decode(Furigana.self, from: data) else {
                        print("json decording error")
                        return
                }
                
                print(jsonData.converted)
                self.furiganaString = jsonData.converted
                
                dispatchGroup.leave()
            }
            urlSession.resume()
        }
        
        dispatchGroup.notify(queue: queue) {
            print("fetch furigana end")
            self.activityIndicatorView.stopAnimating()
            self.performSegue(withIdentifier: "toFuriganaVC", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFuriganaVC" {
            
            let nextVC = segue.destination as! FuriganaViewController
            nextVC.furiganaString = furiganaString
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title: "OK",
                                        style: UIAlertAction.Style.default,
                                        handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }


}

