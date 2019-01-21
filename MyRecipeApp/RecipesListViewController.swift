

import UIKit
import Firebase


class RecipesListViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var recipe = String()
    var databaseRef: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var recipeList = [String]()
    var recipeImages = [String]()
    var recipesDictionary = [DataSnapshot]()
    var strLabel = UILabel()
    var effectView = UIView()
     var activityIndicator = UIActivityIndicatorView()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var recipeName = recipe
        recipeName.append(" List")
        UserDefaults.standard.set("0", forKey: "DataInserted")

        self.navigationItem.title = recipeName
        let button1 = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addRecipe))
        
        self.navigationItem.rightBarButtonItem  = button1
        activityIndicator("Getting Data....")
        databaseRef = Database.database().reference()
        let path = databaseRef.child("Recipes").child(recipe)
        
        path.observeSingleEvent(of: .value, with: { (snap : DataSnapshot)  in
            
            for user_child in (snap.children) {
                
                let user_snap = user_child as! DataSnapshot
                self.recipesDictionary.append(user_snap)
                print(user_snap.key)
                
                if self.recipeList.contains(user_snap.key){
                    
                }else{
                    
                    self.recipeList.append(user_snap.key)
                    let dict = user_snap.value as! [String: String?]
                    let imageURLValue = dict["Image URL"] as? String
                    self.recipeImages.append(imageURLValue!)
                    // Video URL, Image URL, Description, Ingredients
                }
            }
            
            self.activityIndicator.removeFromSuperview()
            self.effectView.removeFromSuperview()
            if self.recipeList.count > 0{
                self.recipesCollectionView.delegate = self
                self.recipesCollectionView.dataSource = self
                self.recipesCollectionView.reloadData()
            }else{
                let textLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 100, y: self.view.frame.midY - 100 , width: 200, height: 50))
                textLabel.text = "No Recipies Available"
                textLabel.textAlignment = .center
                textLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
                textLabel.textColor = UIColor.white
                textLabel.backgroundColor = UIColor(red: 252/256, green: 178/256, blue: 82/256, alpha: 1)
                textLabel.layer.cornerRadius = 5
                self.view.addSubview(textLabel)
            }
            
            
        }) { (err: Error) in
            
            self.alertControllerFunction(msg: "Error Occur While Retrievig Data")
            print("\(err.localizedDescription)")
            
        }
        
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Getting Data from Database
        
       
        let value = UserDefaults.standard.value(forKey: "DataInserted") as! String
        if  value == "1"{
            UserDefaults.standard.set("0", forKey: "DataInserted")
            activityIndicator("Getting Data....")
            databaseRef = Database.database().reference()
            let path = databaseRef.child("Recipes").child(recipe)
        
        path.observeSingleEvent(of: .value, with: { (snap : DataSnapshot)  in
            
            for user_child in (snap.children) {
                
                let user_snap = user_child as! DataSnapshot
                self.recipesDictionary.append(user_snap)
                print(user_snap.key)
                
                if self.recipeList.contains(user_snap.key){
                    
                }else{
                
                self.recipeList.append(user_snap.key)
                let dict = user_snap.value as! [String: String?]
                let imageURLValue = dict["Image URL"] as? String
                self.recipeImages.append(imageURLValue!)
                // Video URL, Image URL, Description, Ingredients
                }
            }
            
            self.activityIndicator.removeFromSuperview()
            self.effectView.removeFromSuperview()
            if self.recipeList.count > 0{
                self.recipesCollectionView.delegate = self
                self.recipesCollectionView.dataSource = self
                self.recipesCollectionView.reloadData()
            }else{
                let textLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 100, y: self.view.frame.midY - 100 , width: 200, height: 50))
                textLabel.text = "No Recipies Available"
                textLabel.textAlignment = .center
                textLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
                textLabel.textColor = UIColor.white
                textLabel.backgroundColor = UIColor(red: 252/256, green: 178/256, blue: 82/256, alpha: 1)
                textLabel.layer.cornerRadius = 5
                self.view.addSubview(textLabel)
            }
            
            
        }) { (err: Error) in
            
            self.alertControllerFunction(msg: "Error Occur While Retrievig Data")
            print("\(err.localizedDescription)")
            
        }
        }

    }
    
    @objc func addRecipe(){
        
        let addRecipeController = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipeViewController") as! AddRecipeViewController
        addRecipeController.recipe = recipe
        self.navigationController?.pushViewController(addRecipeController, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesListCollectionViewCell", for: indexPath) as! RecipesListCollectionViewCell
        let recipeImageURL = recipeImages[indexPath.row]
        
        cell.recipeImageVIew.image = UIImage(named: recipe)
        cell.recipeImageVIew.layer.cornerRadius = 10
        cell.recipeName.layer.cornerRadius = 10
        print(recipeImageURL)
        
        let storageRef = Storage.storage().reference(forURL: recipeImageURL)
        storageRef.getData(maxSize: (1 * 4000 * 4000)) { (data, error) in
            if let _error = error{
                print(_error)
            } else {
                if let _data  = data {
                    
                    cell.recipeImageVIew.image = UIImage(data: _data)
                    
                }
            }
        }
        cell.recipeName.text = recipeList[indexPath.row]
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // RecipeDetailViewController
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        
        controller.recipeDetails = recipesDictionary[indexPath.row].value as! [String : String]
        controller.recipeName = recipeList[indexPath.row]

        self.navigationController?.pushViewController(controller, animated: true)
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recipesCollectionView.frame.width / 3-5 , height: (recipesCollectionView.frame.height / 4)-10)
        
    }
    
    func alertControllerFunction(msg : String){
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        strLabel.textColor = UIColor.white
        
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2-100 , width: 180, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        effectView.backgroundColor = UIColor(red: 252/256, green: 178/256, blue: 82/256, alpha: 1)
        self.view.addSubview(effectView)
    }

    


}
