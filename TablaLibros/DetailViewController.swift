//
//  DetailViewController.swift
//  TablaLibros
//
//  Created by Administrador on 6/11/17.
//  Copyright © 2017 palauturf. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tituloText: UITextField!
    @IBOutlet weak var autoresText: UITextField!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var labelConexion: UILabel!
    
    var numISBN: String = ""
    var tituloLibro: String = ""
    var autores: String = ""
    var imagenPortada: UIImage?
    var hayConexion = true

   
    
    override func viewWillAppear(_ animated: Bool) {
        
        tituloText.text = tituloLibro
        autoresText.text = autores
        imagenView.image = imagenPortada
        
        if hayConexion == false {
            
            labelConexion.text = "No hay Conexion"
            labelConexion.backgroundColor = UIColor(red: 170/255, green: 39/255, blue: 59/255, alpha: 1)
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if detailItem != nil {
          
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

