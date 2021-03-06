//
//  MovieDetails.swift
//  Lab4
//
//  Created by Xiaoyi Xie on 10/19/16.
//  Copyright © 2016 Xiaoyi Xie. All rights reserved.
//

import UIKit

class MovieDetails: UIViewController {

    var name: String!
    var image: UIImage!
    var released: String!
    var plot: String!
    var score: String!
    
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theReleased: UILabel!
    @IBOutlet weak var theScore: UILabel!
    @IBOutlet weak var theName: UILabel!
    @IBOutlet weak var thePlot: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        theName.text = "Name: " + name
        theImage.image = image
        theScore.text = "Rating: " + score
        thePlot.text = "Plot: " + plot
        theReleased.text = "Released: " + released
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
