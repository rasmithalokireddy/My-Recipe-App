
import UIKit
import AVKit
import MobileCoreServices
import AVFoundation

class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var videoView: UIView!
    
    var recipeDetails = [String: String]()
    var recipeName = String()
    var ingredientsArray = [String]()
    var quantityArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = recipeName
        
        
        print(recipeDetails)
        let videoURL = recipeDetails["Video URL"]!

        guard let movieURL = URL(string: videoURL)
            else { return }
        let player = AVPlayer(url: movieURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerViewController.view.frame = videoView.bounds
        
        
        self.addChild(playerViewController)
       
        videoView.addSubview(playerViewController.view)
         playerViewController.player!.play()
        
        var ingredientsString = recipeDetails["Ingredients"]
        ingredientsString?.removeLast()
        let stringArray = ingredientsString!.components(separatedBy: "@")
        for str in stringArray{
            let strArray = str.components(separatedBy: "-")
            ingredientsArray.append(strArray[0])
            quantityArray.append(strArray[1])
        }
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.reloadData()
        tableviewHeightConstraint.constant = CGFloat(40 * ingredientsArray.count)+40
        descriptionTextView.text = recipeDetails["Description"]
    descriptionTextView.scrollRangeToVisible(NSMakeRange(descriptionTextView.text.count, 0))
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailTableViewCell", for: indexPath) as! RecipeDetailTableViewCell
        cell.selectionStyle = .none
        cell.ingredientsLbl.text = ingredientsArray[indexPath.row]
        cell.quantityLbl.text = quantityArray[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    
}



