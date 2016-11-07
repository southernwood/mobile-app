//
//  ViewController.swift
//  Lab4
//
//  Created by Xiaoyi Xie on 10/15/16.
//  Copyright © 2016 Xiaoyi Xie. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate{

    var theData:[MovieResults] = []
    var theImageCache: [UIImage] = []
    var searchInfo: String = ""
    var movieNotFound = false
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBAction func theSearch(sender: AnyObject) {
        self.theData = []
        self.theImageCache = []
        self.searchInfo = search.text!.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        progressBarDisplayer("Searching Movie", true)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            self.fetchData(self.searchInfo)
            self.cacheImages()
            dispatch_async(dispatch_get_main_queue()){
                if (self.movieNotFound){
                    let frame = CGRect(x: 0,y: 0,width: self.theCollectionView.frame.width,height: 50)
                    let label = UILabel(frame: frame)
                    label.text = "Movie Not Found"
                    self.theCollectionView.addSubview(label)
                }
                else{
                    for view in self.theCollectionView.subviews{
                        view.removeFromSuperview()
                    }
                }
                self.theCollectionView.reloadData()
                self.messageFrame.removeFromSuperview()
            }
        }

           }
    
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
    
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        print("in did scroll")
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        let theFrame = CGRect(x:0, y:110, width:450, height: 1500)
        let scrollView = UIScrollView(frame: theFrame)
        
        scrollView.maximumZoomScale = 10.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        view.addSubview(scrollView)
        theCollectionView.frame = CGRect(x:0 ,y: 0,width: 450, height: 150*7)
        theCollectionView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(theCollectionView)
        scrollView.contentSize = theCollectionView.bounds.size
        
    
        self.theCollectionView.dataSource = self
        self.theCollectionView.delegate = self
        theCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "mycell")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(searchInfo: String){
        let json = getJSON("http://www.omdbapi.com/?s="+searchInfo+"&y=&plot=short&r=json")
        print(json)
        let json1 = getJSON("http://www.omdbapi.com/?s="+searchInfo+"&y=&plot=short&r=json&page=2")
        
        if (json["Response"] == "False"){
            self.movieNotFound = true
        }
        else {
            self.movieNotFound = false
            for movie in json["Search"].arrayValue{
                let title = movie["Title"].stringValue
                let imdbID = movie["imdbID"].stringValue
                let json2 = getJSON("http://www.omdbapi.com/?i="+imdbID)
                let rated = json2["Rated"].stringValue
                let released = json2["Released"].stringValue
                let plot = json2["Plot"].stringValue
                let url = json2["Poster"].stringValue
                
                theData.append(MovieResults(title: title, rated: rated, released: released, imageURL: url, plot: plot))
            }
            for movie in json1["Search"].arrayValue{
                let title = movie["Title"].stringValue
                let imdbID = movie["imdbID"].stringValue
                let json2 = getJSON("http://www.omdbapi.com/?i="+imdbID)
                let rated = json2["Rated"].stringValue
                let released = json2["Released"].stringValue
                let plot = json2["Plot"].stringValue
                let url = json2["Poster"].stringValue
                
                theData.append(MovieResults(title: title, rated: rated, released: released, imageURL: url, plot: plot))
            }
            print(theData)
        }
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
        for item in theData{
            
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("I have \(theData.count) in my array")
        return theData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print ("in cell for item at row \(indexPath.row) and section \(indexPath.section) ")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mycell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderWidth = 0
        let frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        let movieImage = UIImageView(frame: frame)
        movieImage.image = theImageCache[indexPath.row]
        cell.addSubview(movieImage)
        let anotherFrame = CGRect(x: 0, y: cell.frame.height-20, width: cell.frame.width, height: 20)
        let movieTitle = UILabel(frame: anotherFrame)
        movieTitle.text = theData[indexPath.row].title
        cell.addSubview(movieTitle)
        return cell

    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let movieVC = Movie(nibName: "Movie", bundle: nil)
        movieVC.name = theData[indexPath.row].title
        movieVC.image = theImageCache[indexPath.row]
        movieVC.plot = theData[indexPath.row].plot
        movieVC.score = theData[indexPath.row].rated
        movieVC.released = theData[indexPath.row].released
        print("should create a new page")
        navigationController?.pushViewController(movieVC, animated: true)
    }
    
}

