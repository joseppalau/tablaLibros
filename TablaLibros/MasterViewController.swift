//
//  MasterViewController.swift
//  TablaLibros
//
//  Created by Administrador on 6/11/17.
//  Copyright © 2017 palauturf. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil


    @IBOutlet weak var vistaISBN: UITextField!
    
    var numISBN: String = ""
    var tituloLibro: String = ""
    var autores:String = ""
    var imagenPortada: UIImage? = nil
    var hayPortada: Bool = false
    var hayConexion: Bool = false
    
    var tituloCeldasArray = [String?]()
    
    var codigosISBNArrays = [String?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        self.title = "Tabla de Libros"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
    
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        vistaISBN.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func buscarISBN(_ sender: Any) {
        
        self.numISBN = vistaISBN.text!
        Asincrono(codigoISBN: self.numISBN)
        vistaISBN.text = "número ISBN"
        vistaISBN.isHidden = true
        codigosISBNArrays.append(numISBN)
        tituloCeldasArray.append(tituloLibro)
        
        
        let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Event(context: context)
        newEvent.accessibilityValue = self.tituloLibro
        
    
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    func insertNewObject(_ sender: Any) {
        
        vistaISBN.isHidden = false
        
        // If appropriate, configure the new managed object.
        
        tituloLibro = ""
        autores = ""
        imagenPortada = nil
        
        //Save the context.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "showDetail" {
            
            let sigVista = segue.destination as! DetailViewController
            sigVista.numISBN = self.numISBN
            sigVista.tituloLibro = self.tituloLibro
            sigVista.autores = self.autores
            sigVista.imagenPortada = self.imagenPortada
            sigVista.hayPortada = self.hayPortada
            sigVista.hayConexion = self.hayConexion
            
        }
        
        if segue.identifier == "showDetail" {
           
            tituloLibro = ""
            autores = ""
            imagenPortada = nil
            
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
               
                Asincrono(codigoISBN: codigosISBNArrays[indexPath.row]!)
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.tituloLibro = self.tituloLibro
                controller.autores = self.autores
                controller.imagenPortada = self.imagenPortada
                
            }
            
          }
    
        }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
    
        cell.textLabel!.text = event.accessibilityValue
        
    }
    
    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            
                if codigosISBNArrays.count != 0 {
                    
                    codigosISBNArrays.remove(at: (indexPath?.row)!)
            }
            
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
        
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

    
    func Asincrono(codigoISBN:String) {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(codigoISBN)"
        let url: NSURL? = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOf: url! as URL)
        
        if datos != nil {
            
            do {
                let json = try JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let dic1 = json as! NSDictionary
                let dic2 = dic1["ISBN:\(codigoISBN)"] as! NSDictionary
                self.tituloLibro = dic2["title"] as! NSString as String
                let dic3 = dic2["authors"] as! NSArray
                
                var autor: String = ""
                
                for i in 0..<dic3.count {
                    
                    let dic = dic3[i] as! NSDictionary
                    autor = dic["name"] as! NSString as String
                    self.autores += "\(autor) "
                }
                
                if dic2["cover"] != nil {
                    
                    self.hayPortada = true
                    let dic4 = dic2["cover"] as! NSDictionary
                    let dic5 = dic4["large"] as! NSString as String
                    
                    let url = NSURL(string: dic5)
                    
                    
                    let datos2: NSData? = NSData(contentsOf: url! as URL)
                    
                    if datos2 != nil {
                    let imagen = UIImage(data: datos2! as Data)
                    self.imagenPortada = imagen
                    }
                    
                }
                else {
                    
                    self.hayPortada = false
                   
                }
                
                self.hayConexion = true
                }
        
                catch {
                
                }
        
            }
            
        else {
                
            self.hayConexion = false
                
        }
    }
    
}
    
    
    // "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(self.numISBN.text!)"
    


