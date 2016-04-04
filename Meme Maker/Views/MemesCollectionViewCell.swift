//
//  MemesCollectionViewCell.swift
//  Meme Maker
//
//  Created by Avikant Saini on 4/4/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

import UIKit
import SDWebImage

class MemesCollectionViewCell: UICollectionViewCell {
	
	var meme: XMeme? = nil {
		didSet {
			self.memeNameLabel.text = meme?.name
			self.updateImageView()
		}
	}
	
	var isListCell: Bool = true {
		didSet {
			self.setNeedsDisplay()
			self.updateImageView()
		}
	}

	@IBOutlet weak var memeImageView: UIImageView!
	@IBOutlet weak var memeNameLabel: UILabel!
//	@IBOutlet weak var memeDetailLabel: UILabel!
	
	override func drawRect(rect: CGRect) {
		
		if (isListCell) {
			let beizerPath = UIBezierPath()
			beizerPath.lineWidth = 0.5
			beizerPath.lineCapStyle = .Round
			beizerPath.moveToPoint(CGPointMake(self.bounds.height + 8, self.bounds.height - 0.5))
			beizerPath.addLineToPoint(CGPointMake(self.bounds.width, self.bounds.height - 0.5))
			UIColor.lightGrayColor().setStroke()
			beizerPath.stroke()
			
			let disclosurePath = UIBezierPath()
			disclosurePath.lineWidth = 1.0;
//			disclosurePath.lineCapStyle = .Round
//			disclosurePath.lineJoinStyle = .Round
			disclosurePath.moveToPoint(CGPointMake(self.bounds.width - 12, self.center.y - 4))
			disclosurePath.addLineToPoint(CGPointMake(self.bounds.width - 8, self.center.y))
			disclosurePath.addLineToPoint(CGPointMake(self.bounds.width - 12, self.center.y + 4))
			UIColor.lightGrayColor().setStroke()
			disclosurePath.stroke()
		}
		
	}
	
	func updateImageView() -> Void {
		let filePath = imagesPathForFileName("\(self.meme!.memeID)")
		if (NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
			if (self.isListCell) {
				self.memeImageView.image = getCircularImage(UIImage(contentsOfFile: filePath)!)
			}
			else {
				self.memeImageView.image = getSquareImage(UIImage(contentsOfFile: filePath)!)
			}
		}
		else {
			let URL = meme?.imageURL
			self.downloadImageWithURL(URL!, filePath: filePath)
		}
	}
	
	func downloadImageWithURL(URL: NSURL, filePath: String) -> Void {
		SDWebImageDownloader.sharedDownloader().downloadImageWithURL(URL, options: .ProgressiveDownload, progress: nil, completed: { (image, data, error, success) in
			if (success) {
				do {
					try data.writeToFile(filePath, options: .AtomicWrite)
				}
				catch _ {}
				dispatch_async(dispatch_get_main_queue(), {
					if (self.isListCell) {
						self.memeImageView.image = getCircularImage(image)
					}
					else {
						self.memeImageView.image = getSquareImage(image)
					}
				})
			}
		})
	}
	
}
