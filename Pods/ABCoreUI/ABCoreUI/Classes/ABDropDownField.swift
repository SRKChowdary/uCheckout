//
//  ABDropDownField.swift
//  MasterApp
//
//  Created by Ganesh Reddiar on 12/18/15.
//  Copyright © 2015 Safeway. All rights reserved.
//

import UIKit

public class ABDropDownField: ABField, UITableViewDataSource, UITableViewDelegate {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    let headerHeight: CGFloat = 44.0
    
    public var dropdownValues:[String] = ["1", "2", "3", "4", "5", "6"] {
        didSet {
            textField.accessibilityTraits = dropdownValues.count > 1 ? UIAccessibilityTraits.none : UIAccessibilityTraits.staticText
        }
    }
    var tableView:UITableView = UITableView()
    var heightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var dimView:UIView = UIView()
    var selectedKey:String? {
        
        didSet {
            if let selectedKey = selectedKey, let selectedIndex = dropdownValues.index(of: selectedKey) {
                let indexPath = IndexPath(index: selectedIndex)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
            }
        }
    }
    var headerTitle:String?
    
    @IBInspectable var cellHeight:CGFloat = 44
    var cellFont = UIFont.systemFont(ofSize: 14, weight: .light)
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if dropdownValues.count > 1 {
            state = .active
        }
        return false
    }
    
    override public func resignFirstResponder() -> Bool {
        closeView(nil)
        return super.resignFirstResponder()
    }
    
    override func setupState() {
        super.setupState()
        if state == .active {
            if let window = UIApplication.shared.keyWindow {
                showInView(window)
            }
        }
    }
    
    override func setup() {
        super.setup()
        let dropDownButton = UIButton()
        //dropDownButton.setImage(#imageLiteral(resourceName: "Expand Chevron"), for: .normal)
        setupExtraButton(dropDownButton)
        textField.isAccessibilityElement = true
        extraButtonAction = { button in
            self.becomeFirstResponder()
        }
    }
    
    override func configureAccessibleElements() {
        super.configureAccessibleElements()
        extraButton?.isAccessibilityElement = false
    }
    
    func dropDownCell() -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.accessibilityTraits = UIAccessibilityTraits.button
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownValues.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dropDownCell()
        cell.textLabel?.text = dropdownValues[indexPath.row]
        cell.textLabel?.font = cellFont
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  headerTitle ?? placeholder
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
            header.textLabel?.textColor = UIColor.black
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        text = dropdownValues[indexPath.row]
        delegate?.abFieldDidEndEditing?(self)
        closeView(nil)
    }
    
    
    func setUpDropDownView () {
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.5
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.reloadData()
        
    }
    
    
    func layoutTableViewConstraintsInView (_ view:UIView) {
        tableView.snp.remakeConstraints { (make) in
            make.leftMargin.lessThanOrEqualToSuperview().offset(50)
            make.rightMargin.lessThanOrEqualToSuperview().offset(-50)
            make.width.equalTo(270)
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
            make.height.equalTo(0)
            make.height.lessThanOrEqualToSuperview().offset(-100).priority(1000)
        }
    }
    
    
    func showInView(_ view:UIView) {
        dimView.removeFromSuperview()
        guard let window = window else {
            return
        }
        dimView = UIView(frame: window.screen.bounds)
        view.addSubview(dimView)
        dimView.snp.makeConstraints { (make) in
            make.edges.equalTo(window)
        }
        setUpDropDownView()
        view.endEditing(true)
        view.addSubview(tableView)
        tableView.accessibilityViewIsModal = true
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        dimView.addGestureRecognizer(tapGestureRecognizer)
        
        delegate?.abFieldDidStartEditing?(self)
       
        self.layoutTableViewConstraintsInView(view)
        self.tableView.layoutIfNeeded()
        self.tableView.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.tableView.snp.updateConstraints({ (make) in
                make.height.equalTo(self.tableView.contentSize.height + 16)
            })
            self.tableView.layoutIfNeeded()
        })
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: tableView)
    }
    
    @objc func closeView(_ sender:AnyObject?) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.alpha = 0
            self.tableView.layoutIfNeeded()
            self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: {
            finished in
            self.delegate?.abFieldDidEndEditing?(self)
            self.tableView.snp.removeConstraints()
            self.tableView.removeFromSuperview()
            self.dimView.removeFromSuperview()
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: self.textField)
        }
        )
    }
}

