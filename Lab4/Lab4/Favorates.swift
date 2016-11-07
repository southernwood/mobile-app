//
//  Favorates.swift
//  Lab4
//
//  Created by Xiaoyi Xie on 10/16/16.
//  Copyright © 2016 Xiaoyi Xie. All rights reserved.
//

import UIKit

class Favorates: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    var myArray: [String] = []
    var theData:[MovieResults] = []
    var theImageCache: [UIImage] = []
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

   
    @IBOutlet weak var theTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("favorate table is shown")

        // Do any additional setup after loading the view.
        
        theTable.dataSource = self
        theTable.delegate = self
        
        if let tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("movieList"){
            myArray = tabledata as! Array<String>
        }
        else{
            print("no privous favorates")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("new favorates added")
        if let tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("movieList"){
            myArray = tabledata as! Array<String>
        }
        else{
            print("no privous favorates")
        }
        self.theTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        myCell.textLabel?.text = myArray[indexPath.row]
        return myCell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            myArray.removeAtIndex(indexPath.row)
            NSUserDefaults.standardUserDefaults().setObject(myArray, forKey: "movieList")
            self.theTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.progressBarDisplayer("Searching movie details", true)
        theData = []
        theImageCache = []
        let searchText = myArray[indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: "%20")
        self.fetchData(searchText)
        self.cacheImages()
        let movieVC = MovieDetails(nibName: "MovieDetails", bundle: nil)
        movieVC.name = theData[0].title
        movieVC.image = theImageCache[0]
        movieVC.plot = theData[0].plot
        movieVC.score = theData[0].rated
        movieVC.released = theData[0].released
        self.messageFrame.removeFromSuperview()
        navigationController?.pushViewController(movieVC, animated: true)
        print("should create a new page")
    }
    
    func fetchData(searchInfo: String){
        
        let json = getJSON("http://www.omdbapi.com/?t="+searchInfo+"&y=&plot=short&r=json")
        print(json)
        let title = json["Title"].stringValue
        let url = json["Poster"].stringValue
        let rated = json["Rated"].stringValue
        let released = json["Released"].stringValue
        let plot = json["Plot"].stringValue
        theData.append(MovieResults(title: title, rated: rated, released: released, imageURL: url, plot: plot))
        
        
    }
    
    func getJSON(url: String)-> JSON{
        if let nsurl = NSURL(string: url){
            if let data = NSData(contentsOfURL: nsurl){
                let json = JSON(data: data)
                return json
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func cacheImages(){
        for item in theData {
            
            var image = UIImage()
            let url = NSURL(string: item.imageURL)
            let data = NSData(contentsOfURL: url!)
            if (data != nil){
                image = UIImage(data: data!)!
            }
            else{
                image = UIImage.init(named: "no_image.jpg")!
            }
            theImageCache.append(image)
        }
        
    }

}
