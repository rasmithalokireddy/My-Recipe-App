

import UIKit
import Firebase
import AVKit
import MobileCoreServices
import AVFoundation



class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var recipeNameTxtFld: UITextField!
    @IBOutlet weak var ingregientTxtFld: UITextField!
    @IBOutlet weak var QuantityTxtFld: UITextField!
        @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet var addReceipeBtnOutlet: UIButton!
    
    @IBOutlet var cameraRecordingBtnPOutlet: UIButton!
    @IBOutlet var camImageBtnPOutlet: UIButton!
    @IBOutlet weak var tableviewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var recipeVideoView: UIImageView!
    
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var recipe = String()
    var databaseRef: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var imagePicker = UIImagePickerController()
    var imageURL = String()
    var videoURL = String()
    var videoURLPath : URL?
    var ingredientsArray = [String]()
    var quantityArray = [String]()
     var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var effectView = UIView()
    var downloadImageURL : String?
    var downloadVideoURL : String?




    @IBAction func addRecipeButnTapped(_ sender: Any) {
        
        guard recipeNameTxtFld.text?.replacingOccurrences(of: " ", with: "").count != 0  else {
            
            self.alertControllerFunction(msg:"Enter Recipe Name")
            return
        }
        guard recipeDescription.text.count != 0  else {
            self.alertControllerFunction(msg:"Enter Recipe Description")

            return
        }
        guard ingredientsArray.count != 0 else{
            self.alertControllerFunction(msg:"Enter Ingredients")
            
            return
        }
        guard recipeImageView.image != nil else{
            self.alertControllerFunction(msg:"Select Image")
            return
        }
        guard recipeVideoView.image != nil else{
            self.alertControllerFunction(msg:"Select Video")
            return
        }
        // Adding Data to Database
       activityIndicator("Uploading Image..")
        imageUploadMethod() // Adding image to firebase storage
    }
    @IBAction func addIngredientBtn(_ sender: Any) {
        guard ingregientTxtFld.text?.count != 0  else {
            self.alertControllerFunction(msg:"Enter Ingredient Name")
            return
        }
        guard QuantityTxtFld.text?.count != 0  else {
            self.alertControllerFunction(msg:"Enter Quantity")
            return
        }
        ingredientsArray.append(ingregientTxtFld.text!)
        quantityArray.append(QuantityTxtFld.text!)
        ingregientTxtFld.text = ""
        QuantityTxtFld.text = ""
        ingredientTableView.isHidden = false
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        tableviewTopConstraint.constant = CGFloat(ingredientsArray.count * 40)+40;
        ingredientTableView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Your Recipe"
        addReceipeBtnOutlet.layer.cornerRadius = 15
        let imagetapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imagetapGesture.numberOfTapsRequired = 1
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.addGestureRecognizer(imagetapGesture)
        let videotapGesture = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped))
        videotapGesture.numberOfTapsRequired = 1
        recipeVideoView.isUserInteractionEnabled = true
        recipeVideoView.addGestureRecognizer(videotapGesture)
        tableviewTopConstraint.constant = 0
        self.addDoneButtonOnKeyboard()
        ingredientTableView.isHidden = true
    }
    
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as! IngredientTableViewCell
        cell.ingredientsLbl.text = ingredientsArray[indexPath.row]
        cell.quantityLbl.text = quantityArray[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            ingredientsArray.remove(at: indexPath.row)
            quantityArray.remove(at: indexPath.row)
           tableView.reloadData()
        }
    }
    
    @objc func imageViewTapped(){
        

        
        let alertController = UIAlertController(title: "Select", message: "", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in

            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                print("Camera Available")
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.alertControllerFunction(msg:"No Camera Available")
                
            }
        }
        
        let action2 = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum;
                imagePicker.allowsEditing = false
                imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let action3 = UIAlertAction(title: "ok", style: .cancel) { (action:UIAlertAction) in
            
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func videoViewTapped(){
        

        
        let alertController = UIAlertController(title: "Select", message: "", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                print("Camera Available")
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.alertControllerFunction(msg:"No Camera Available")
            }
        }
        
        let action2 = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction) in
            print("You've pressed cancel");
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum;
                imagePicker.allowsEditing = false
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let action4 = UIAlertAction(title: "Preview", style: .default) { (action) in
           
            if let url = self.videoURLPath{
            
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            }else{
                self.alertControllerFunction(msg:  "No Video to Display")

            }
            
        }
        
        let action3 = UIAlertAction(title: "ok", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed the destructive");
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action4)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        dismiss(animated: true, completion: nil)

        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipeImageView.contentMode = .scaleAspectFit
            recipeImageView.image = pickedImage
            camImageBtnPOutlet.isHidden = true

        }
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
          videoURLPath = mediaType
            
            // Getting ThumbNail Image from video URL
            DispatchQueue.global().async {
                let asset = AVAsset(url: self.videoURLPath!)
                let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                assetImgGenerate.appliesPreferredTrackTransform = true
                let time = CMTimeMake(value: 1, timescale: 2)
                let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                if img != nil {
                    let frameImg  = UIImage(cgImage: img!)
                    DispatchQueue.main.async(execute: {
                        
                        // assign your image to UIImageView
                        self.recipeVideoView.image = frameImg
                        self.cameraRecordingBtnPOutlet.setBackgroundImage(UIImage(named: "playButton"), for: .normal)
                        
                    })
                }
            }
            

        }
    }
    

    func videoUploadMethod()
    {
        
        
        
        // Local file you want to upload
        let localFile = videoURLPath!
        
        let videoName:String = String("\(recipeNameTxtFld.text!).mov")
        //let imageName:String = String("\(recipeNameTxtFld.text!).png")

        
        let storageRef = Storage.storage().reference().child("Videos").child(recipe).child(videoName)
        
        // Upload file and metadata
        _ = storageRef.putFile(from: localFile, metadata: nil) { metadata, error in
            if let error = error
            {
                self.alertControllerFunction(msg: error as! String)

            }
        storageRef.downloadURL { (url, error) in
            self.strLabel.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
            self.effectView.removeFromSuperview()
            guard let downloadURL = url else {
                
                // Uh-oh, an error occurred!
                return
            }
            self.downloadVideoURL = downloadURL.absoluteString
            
           
            self.activityIndicator("Uploading Data ...")
            self.insertDatatoDatabase()

            print("downloadURL\(downloadURL)")
        }
        
        
        
     }
    }
    func imageUploadMethod(){
       
        let imageName:String = String("\(recipeNameTxtFld.text!).jpeg")
        
        let storageRef = Storage.storage().reference().child("Images").child(recipe).child(imageName)
            if let uploadData = recipeImageView.image!.jpegData(compressionQuality: 0.5){
            storageRef.putData(uploadData, metadata: nil
               , completion: { (metadata, error) in
                
                guard let metadata = metadata else{
                    self.alertControllerFunction(msg: error as! String)
                    return
                }
                print(metadata)

                storageRef.downloadURL(completion: { (url, error) in
                    self.strLabel.removeFromSuperview()
                    self.activityIndicator.removeFromSuperview()
                    self.effectView.removeFromSuperview()

                    if error != nil {
                        self.alertControllerFunction(msg: "Error while uploading")

                       // print(error!.localizedDescription)
                        return
                    }

                     self.videoUploadMethod()
                    if let profileImageUrl = url?.absoluteString {
                        self.downloadImageURL = profileImageUrl
                        print(profileImageUrl)

                    }
                    self.activityIndicator("Uploading Video...")
                    
                   // Adding video to firebase storage

                })
        
            })
        
        }

    }
    func insertDatatoDatabase(){
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        databaseRef = Database.database().reference()
        let path = databaseRef.child("Recipes").child(recipe).child(recipeNameTxtFld.text!)
        var ingredients = String()
        for i in 0..<ingredientsArray.count{
            ingredients.append(ingredientsArray[i])
            ingredients.append("-")
            ingredients.append(quantityArray[i])
            ingredients.append("@")
        }
        
        path.child("Ingredients").setValue(ingredients)
        path.child("Description").setValue(recipeDescription.text)
        path.child("Image URL").setValue(downloadImageURL)
        path.child("Video URL").setValue(downloadVideoURL)
         self.activityIndicator.removeFromSuperview()
        UserDefaults.standard.set("1", forKey: "DataInserted")
        let alertController = UIAlertController(title: "Alert", message: "Data Inserted", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "ok", style: .default) { (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }

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
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2-100, width: 180, height: 46)
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
    
    func alertControllerFunction(msg : String){
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)

    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.recipeNameTxtFld.inputAccessoryView = doneToolbar
        self.recipeDescription.inputAccessoryView = doneToolbar
        self.ingregientTxtFld.inputAccessoryView = doneToolbar
        self.QuantityTxtFld.inputAccessoryView = doneToolbar
        
    }
    
    @objc fileprivate func doneButtonAction() {
        self.view.endEditing(true)
    }


}
