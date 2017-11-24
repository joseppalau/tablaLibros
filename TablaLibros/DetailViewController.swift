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
    
    var numISBN: String = ""
    var tituloLibro: String = ""
    var autores: String = ""
    var imagenPortada: UIImage?
    var hayPortada: Bool?
    var hayConexion: Bool?

    var imagenPortada2: UIImage?
    var titulo2: String = ""
    var autores2: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        tituloText.text = tituloLibro
        autoresText.text = autores
        imagenView.image = imagenPortada
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if detailItem != nil {
          
                tituloText.text = titulo2
                autoresText.text = autores2
                imagenView.image = imagenPortada2
            
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

