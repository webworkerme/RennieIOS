//
//  SuggestionView.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 10/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit


class SuggestionView: UIView {

    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_suggestion: UITextView!
    
    
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    
    var delegate : SendEmailDelegate!
    
    @IBAction func btn_submit(_ sender: UIButton) {
        
        self.delegate.sendEmail(email: self.txt_email.text!, suggestion: self.txt_suggestion.text!)
        
    }

    @IBAction func btn_cancel(_ sender: Any) {
        
        self.removeFromSuperview()
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.txt_email.layer.borderColor = UIColor.white.cgColor
        self.txt_email.layer.borderWidth = 1
        self.txt_suggestion.layer.borderColor = UIColor.white.cgColor
        self.txt_suggestion.layer.borderWidth = 1
        self.btn_cancel.layer.borderColor = UIColor.white.cgColor
        self.btn_cancel.layer.borderWidth = 1
        self.btn_submit.layer.borderColor = UIColor.white.cgColor
        self.btn_submit.layer.borderWidth = 1
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
        
    }
    
    
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    
}
