//
//  YNSearchViewController.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 11..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

public enum YNSearchContext: Int {
    case home
    case queue
    case profile
    case modal
}

open class YNSearchViewController: UIViewController, UITextFieldDelegate {
    open var delegate: YNSearchDelegate? {
        didSet {
            self.ynSearchView.delegate = delegate
        }
    }
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    open var ynSearchTextfieldView: YNSearchTextFieldView!
    open var ynSearchView: YNSearchView!
    
    open var ynSerach = YNSearch()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }

    open func ynSearchinit(context: YNSearchContext = .home) {
        var yOrigin: CGFloat = context == .home ? 70.0 : 98.0
        
        if context == .modal {
            yOrigin = 134.0
        }
        
        let ynSearchTextfieldViewOrigin: CGFloat = context == .modal ? 89.0 : 25.0
        
        self.ynSearchTextfieldView = YNSearchTextFieldView(frame: CGRect(x: 20, y: ynSearchTextfieldViewOrigin, width: width-40, height: 50))
        self.ynSearchTextfieldView.ynSearchTextField.delegate = self
        self.ynSearchTextfieldView.ynSearchTextField.addTarget(self, action: #selector(ynSearchTextfieldTextChanged(_:)), for: .editingChanged)
        self.ynSearchTextfieldView.cancelButton.addTarget(self, action: #selector(ynSearchTextfieldcancelButtonClicked), for: .touchUpInside)
        
        self.ynSearchTextfieldView.ynSearchTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        self.view.addSubview(self.ynSearchTextfieldView)
        
        self.ynSearchView = YNSearchView(frame: CGRect(x: 0, y: yOrigin, width: width, height: height-yOrigin))
        self.view.addSubview(self.ynSearchView)
    }
    
    open func setYNCategoryButtonType(type: YNCategoryButtonType) {
        self.ynSearchView.ynSearchMainView.setYNCategoryButtonType(type: .colorful)
    }
    
    open func initData(database: [Any]) {
        self.ynSearchView.ynSearchListView.initData(database: database)
    }

    
    // MARK: - YNSearchTextfield
    @objc open func ynSearchTextfieldcancelButtonClicked() {
        self.ynSearchTextfieldView.ynSearchTextField.text = ""
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.ynSearchView.ynSearchMainView.alpha = 1
            self.ynSearchTextfieldView.cancelButton.alpha = 0
            self.ynSearchView.ynSearchListView.alpha = 0
        }) { (true) in
            self.ynSearchView.ynSearchMainView.isHidden = false
            self.ynSearchView.ynSearchListView.isHidden = true
            self.ynSearchTextfieldView.cancelButton.isHidden = true
        }
    }
    @objc open func ynSearchTextfieldTextChanged(_ textField: UITextField) {
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = textField.text
    }
    
    // MARK: - UITextFieldDelegate
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if !text.isEmpty {
            self.ynSerach.appendSearchHistories(value: text)
            self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        }
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        return true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.ynSearchView.ynSearchMainView.alpha = 0
            self.ynSearchTextfieldView.cancelButton.alpha = 1
            self.ynSearchView.ynSearchListView.alpha = 1
        }) { (true) in
            self.ynSearchView.ynSearchMainView.isHidden = true
            self.ynSearchView.ynSearchListView.isHidden = false
            self.ynSearchTextfieldView.cancelButton.isHidden = false

        }
    }
}
