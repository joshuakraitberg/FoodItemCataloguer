//
//  ExampleSceneBaseCD.swift
//  Purpose - Control the "next" scene in the nav Disclosure workflow
//  This is a standard view controller
//  It is within a navigation workflow, with a presenter, and a maybe a successor
//

import UIKit

// Adopt the protocols that are appropriate for this controller (detail, add, etc.)

class FoodItemScene: UIViewController {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var item: FoodItem!
    
    // MARK: - Outlets (user interface)
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var coord: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item.name
        
        name.text = item.name
        source.text = item.source
        quantity.text = "\(item.quantity) grams"
        
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        date.text = df.string(for:item.timestamp)
        
        let x = String(format: "%.4f", item.lat)
        let y = String(format: "%.4f", item.lon)
        coord.text = "Latitude: \(x), Latitude: \(y)"
    
        address.text = item.location
        photo.image = UIImage(data:item.photo!)
    }
    
    // MARK: - Actions (user interface)
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Add "if" blocks to cover all the possible segues
        // One for each workflow (navigation) or task segue
        
        // A workflow segue is managed by the current nav controller
        // A task segue goes to a scene that's managed by a NEW nav controller
        // So there's a difference in how we get a reference to the next controller
        
        // Sample workflow segue code...
        /*
        if segue.identifier == "toWorkflowScene" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is managed by the current nav controller
            let vc = segue.destination as! ExampleScene
            
            // Fetch and prepare the data to be passed on
            let selectedData = item
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData?.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        */
        
        // Sample task segue code...
        /*
        if segue.identifier == "toTaskScene" {
            
            // Your customized code goes here,
            // but here is some sample/starter code...
            
            // Get a reference to the next controller
            // Next controller is embedded in a new navigation controller
            // so we must go through it
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! ExampleDetail
            
            // Fetch and prepare the data to be passed on
            let selectedData = item
            
            // Set other properties
            vc.item = selectedData
            vc.title = selectedData?.name
            // Pass on the data model manager, if necessary
            //vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
        */
        
    }
    
}
