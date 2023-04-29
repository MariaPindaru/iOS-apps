//
//  WebViewController.swift
//  MultiScreenApp
//
//  Created by Maria Pindaru on 17.04.2023.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var member: Person!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL (string: self.member.webPageURL);
        let requestObj = URLRequest(url: url!);
        self.webView.loadRequest(requestObj);
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
