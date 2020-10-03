//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {

    var selectedSnap: Snap?
    var selectedTime: Int?
    var inputArray = [KingfisherSource]()
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // delaem gorizontalnoe prolistuwanie image ispolzuja - pod 'ImageSlideshow', '~> 1.8.3' & pod "ImageSlideshow/Kingfisher"

        if let snap = selectedSnap {
            
            timeLabel.text = "Time Left: \(snap.timeLeft)"

                   
            for imageUrl in snap.imageUrl {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            let imageStideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageStideShow.backgroundColor = UIColor.white
            
            // indicator kotoruj pokazuwaet gde mu nachodimsia w nastoas4ee wrwmia pri ispolzowanii slider Images
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageStideShow.pageIndicator = pageIndicator
            
            imageStideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageStideShow.setImageInputs(inputArray)
            
            self.view.addSubview(imageStideShow)
            // ispravliaem oshubky pri kotoroj label okazalsia na zadnem plane i ego ne widno pri gorizontalnoj prokrytke image
            self.view.bringSubviewToFront(timeLabel)
        }
    }
}
