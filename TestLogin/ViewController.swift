//
//  ViewController.swift
//  TestLogin
//
//  Created by Ing. Enrique Ugalde on 01/07/16.
//  Copyright © 2016 Ing. Enrique Ugalde. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tf_Email.delegate = self
        self.tf_Password.delegate = self
//      GESTURE FOR DISMISSKEYBOARD WHEN END EDITTING USING TAPGESTURE
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        if prefs.stringForKey("tf_EmailText") != "" {
            tf_Email.text = prefs.stringForKey("tf_EmailText")
        }

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ingresar(sender: AnyObject) {
        if (tf_Email.text! != ""){
            if (tf_Password.text!.characters.count > 6){
                        accesar()
            }else {
                wrong("Verifica tu email o password")
            }
        } else {
            wrong("Ingresa un Email")
        }
    }

    @IBAction func crearCuenta(sender: AnyObject) {
        if (tf_Email.text! != ""){
            if (tf_Password.text!.characters.count > 6){
                FIRAuth.auth()?.createUserWithEmail(tf_Email.text!, password: tf_Password.text!, completion: {
                    user, error in
                    if (error != nil){
                        //account created or something wrong
                        self.wrong("Este usuario ya existe, intenta con otro")
                    } else {
                        print("Se creó el usuario")
                        self.accesar()
                    }
                })

            } else {
                wrong("Ingresa un Password mayor a 6 caracteres")
            }
        } else {
            wrong("Ingresa un Email")
        }
    }
    
    func accesar(){
        FIRAuth.auth()?.signInWithEmail(tf_Email.text!, password: tf_Password.text!, completion: {
            user, error in
            if (error != nil){
            //password or email incorrect
                print("mail/pass incorrect")
                self.wrong("Verifica tu email o password")
            } else {
                print("You´re in!")
                self.prefs.setValue(self.tf_Email.text!, forKey: "tf_EmailText")
                self.tf_Password.text = ""
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("View1") as UIViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        })
    }
    
    func wrong(mensaje: String){
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

