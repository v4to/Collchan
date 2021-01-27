//
//  CreatePostModalViewController.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 07.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit
import WebKit

class CreatePostModalViewController: UIViewController {
    
    var boardId: String?
    var threadId: String?
    var postToReplyId: String?
    
    var accessoryView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44.0)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
        
        
       
        
        return view
    }()
    
    lazy var toolBar: UIToolbar = {
        var toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44.0)
//        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        photoButton.image =  UIImage(systemName: "photo")!
//        let boldButtonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let italicButtonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let underlineButtonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let strikethroughButtonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let subscriptButtonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let supscriptFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let quoteButtonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

//        boldButton.image = UIImage(systemName: "bold")
        
        let photoButton = UIBarButtonItem(image: UIImage(systemName: "camera")!, style: .plain, target: nil, action: nil)
        let boldButton = UIBarButtonItem(image: UIImage(systemName: "bold")!, style: .plain, target: nil, action: nil)
        let italicButton = UIBarButtonItem(image: UIImage(systemName: "italic")!, style: .plain, target: nil, action: nil)
        let underlineButton = UIBarButtonItem(image: UIImage(systemName: "underline")!, style: .plain, target: nil, action: nil)
        let strikethroughButton = UIBarButtonItem(image: UIImage(systemName: "strikethrough")!, style: .plain, target: nil, action: nil)
        let subscriptButton = UIBarButtonItem(image: UIImage(systemName: "textformat.subscript")!, style: .plain, target: nil, action: nil)
        let supscriptButton = UIBarButtonItem(image: UIImage(systemName: "textformat.superscript")!, style: .plain, target: nil, action: nil)
        let quoteButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right")!, style: .plain, target: nil, action: nil)
        let spoilerButton = UIBarButtonItem(image: UIImage(systemName: "eye.slash")!, style: .plain, target: nil, action: nil)


//        let subscriptButton = UIBarButtonItem(image: UIImage(systemName: "textformat.subscript")!, style: .plain, target: nil, action: nil)
        
//        let quoteButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right")!, style: .plain, target: nil, action: nil)
//        let supscriptButton = UIBarButtonItem(image: UIImage(systemName: "textformat.superscript")!, style: .plain, target: nil, action: nil)

        
        
        toolBar.setItems([photoButton, flexibleSpace, boldButton, flexibleSpace, italicButton, flexibleSpace, underlineButton, flexibleSpace, strikethroughButton, flexibleSpace, subscriptButton, flexibleSpace, supscriptButton, flexibleSpace, quoteButton, flexibleSpace, spoilerButton], animated: true)
//        toolBar.setItems([flexibleSpace, photoButton, flexibleSpace, boldButton, flexibleSpace, italicButton, flexibleSpace, quoteButton, flexibleSpace, spoilerButton, flexibleSpace], animated: true)
//        toolBar.setItems([photoButton, boldButton, italicButton, quoteButton, spoilerButton], animated: true)

        toolBar.tintColor = .systemBlue
        
        let app = UIToolbarAppearance()
        app.backgroundColor = Constants.Design.Color.backgroundWithOpacity
        
        toolBar.standardAppearance = app
        
//        toolBar.backgroundColor = Constants.Design.Color.background
        return toolBar
    }()
    
    
    var postButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(postAction(_:)))
        button.isEnabled = false
        return button
    }()
    
    lazy var navigation: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationItem = UINavigationItem(title: "New Post")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction(_:)))
        navigationItem.rightBarButtonItem = postButton
        
        navigationBar.pushItem(navigationItem, animated: true)
        return navigationBar
    }()
    
    lazy var postText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isSelectable = true
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body).withSize(17.0)
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        textView.delegate = self
        textView.backgroundColor = .clear
    
        return textView
    }()
    
    
    lazy var recaptchaView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "getToken")
        contentController.add(self, name: "needToResolveCaptcha")
        contentController.add(self, name: "buttonIsClicked")
        contentController.add(self, name: "noListener")
        contentController.add(self, name: "error")

        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let postToReplyId = postToReplyId {
            postText.text = ">>\(postToReplyId)\n"
        }
        setupViews()
        setupRecpatchaView()
        // Do any additional setup after loading the view.
    }
    let publicKey = "6LdwXD4UAAAAAHxyTiwSMuge1-pf1ZiEL4qva_xu"
    // MARK: - Instance Methods
    func setupRecpatchaView() {
        recaptchaView.isHidden = true
        
        let recaptcha = Recaptcha(captchaId: publicKey)
        recaptchaView.loadHTMLString(recaptcha.htmlString, baseURL: URL(string: "https://2ch.hk/")!)
    }
    
    
    func setupViews() {
//        view.backgroundColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Design.Color.backgroundWithOpacity
        
        navigation.standardAppearance = appearance
        
        view.backgroundColor = Constants.Design.Color.background

        
        view.addSubview(navigation)
        view.addSubview(postText)
        postText.inputAccessoryView = accessoryView
        accessoryView.addSubview(toolBar)
        view.addSubview(recaptchaView)
        
        navigation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigation.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        postText.topAnchor.constraint(equalTo: navigation.bottomAnchor).isActive = true
        postText.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postText.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        postText.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        toolBar.widthAnchor.constraint(equalTo: accessoryView.widthAnchor).isActive = true
//        toolBar.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
//        toolBar.topAnchor.constraint(equalTo: accessoryView.topAnchor).isActive = true
//        toolBar.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor).isActive = true
//        accessoryView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
//        accessoryView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
//        accessoryView.leftAnchor.constraint(equalTo: postText.leftAnchor).isActive = true
//        accessoryView.rightAnchor.constraint(equalTo: postText.rightAnchor).isActive = true

        
        
        recaptchaView.topAnchor.constraint(equalTo: navigation.bottomAnchor).isActive = true
        recaptchaView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        recaptchaView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        recaptchaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupRecaptchaView() {
        
    }
    
    // MARK: - Actions
    
    @objc func cancelAction(_ sender: UIBarButtonItem) {
//        recaptchaView.evaluateJavaScript(<#T##javaScriptString: String##String#>, completionHandler: <#T##((Any?, Error?) -> Void)?##((Any?, Error?) -> Void)?##(Any?, Error?) -> Void#>)
        presentingViewController?.dismiss(animated: true)
        
//        self.recaptchaView.evaluateJavaScript("document.getElementById('b').click()", completionHandler: nil)
    }
    
    @objc func postAction(_ sender: UIBarButtonItem) {
    //        recaptchaView.evaluateJavaScript(<#T##javaScriptString: String##String#>, completionHandler: <#T##((Any?, Error?) -> Void)?##((Any?, Error?) -> Void)?##(Any?, Error?) -> Void#>)
    //        presentingViewController?.dismiss(animated: true)
            
            self.recaptchaView.evaluateJavaScript("document.getElementById('b').click()", completionHandler: nil)
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

extension CreatePostModalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            postButton.isEnabled = false
        } else {
            postButton.isEnabled = true
        }
    }
}

extension CreatePostModalViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print("url host ---- \(navigationAction.request.url)")
        decisionHandler(.allow, preferences)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print(navigationResponse.response)
//        webView.evaluateJavaScript("", completionHandler: <#T##((Any?, Error?) -> Void)?##((Any?, Error?) -> Void)?##(Any?, Error?) -> Void#>)
        decisionHandler(.allow)
    }
}

extension CreatePostModalViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        sw
        
        switch message.name {
        case "buttonIsClicked":
            print("button is clicked")
            fallthrough
        //case "noListener":
            //print("no listener")
//            fallthrough
//        case "error":
//            print("recaptcha error")
//            print("error --- \(message.body)")
//            fallthrough
        case "needToResolveCaptcha":
//            print("needToResolveCaptcha")
            print("needToResolveCaptcha --- \(message.body)")
            postText.resignFirstResponder()
            recaptchaView.isHidden = false
        case "getToken":
            recaptchaView.isHidden = true
            print(message.body)
            print(boardId)
            print(threadId)
            print("text === \(postText.text)")
            NetworkService.shared.createPostFrom(boardId: boardId!, threadId: threadId!, comment: postText.text!, googleRecaptchId: message.body as! String, captchaId: publicKey) { (result: Result<PostResponse>) in
                switch result {
                case .success(let data):
                    print("success --- \(data)")
                case .failure(let error):
                    print("error --- \(error)")
                case .empty:
                    print("empty")
                }
                self.presentingViewController?.dismiss(animated: true)
            }
        default:
            break
        }
//        print("message.name --- \(message.body)")
    }
    
    
}
