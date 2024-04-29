//
//  ViewController.swift
//  SKPhotoBrowserExample
//
//  Created by suzuki_keishi on 2015/10/06.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class FromLocalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [SKPhotoProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Static setup
//        SKPhotoBrowserOptions.displayAction = true
//        SKPhotoBrowserOptions.displayStatusbar = true
//        SKPhotoBrowserOptions.displayCounterLabel = true
//        SKPhotoBrowserOptions.displayBackAndForwardButton = true
        
        // style 1
        SKPhotoBrowserOptions.displayStatusbar = true
        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayPaginationView = false
        SKActionOptions.backgroundColor = UIColor(red: 237 / 255.0, green: 237 / 255.0, blue: 237 / 255.0, alpha: 1)
        SKActionOptions.textColor = UIColor(red: 31 / 255.0, green: 31 / 255.0, blue: 31 / 255.0, alpha: 1)
        SKActionOptions.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        SKActionOptions.textShadowColor = .clear
        SKButtonOptions.closeButtonPadding = .init(x: 5, y: 35)
        SKButtonOptions.closeButtonInsets = .zero
        SKButtonOptions.deleteButtonPadding = .init(x: 5, y: 35)
        SKButtonOptions.deleteButtonInsets = .zero
        SKCounterOptions.counterLocaton = .top
        SKCounterOptions.counterExtraMarginY = 35
        SKPhotoBrowserOptions.longPhotoWidthMatchScreen = true

        // style 2
//        SKPhotoBrowserOptions.displayStatusbar = false
//        SKPhotoBrowserOptions.displayCloseButton = false
//        SKPhotoBrowserOptions.displayAction = false
//        SKPhotoBrowserOptions.displayPaginationView = false
//        SKPhotoBrowserOptions.enableSingleTapDismiss = true
//        SKPhotoBrowserOptions.longPhotoWidthMatchScreen = true
        
        setupTestData()
        setupCollectionView()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

 // MARK: - UICollectionViewDataSource
extension FromLocalViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exampleCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.exampleImageView.image = UIImage(named: "image\((indexPath as NSIndexPath).row % 12).jpg")
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FromLocalViewController {
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.row)
        browser.delegate = self

        present(browser, animated: true, completion: {})
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 300)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 200)
        }
    }
}

// MARK: - SKPhotoBrowserDelegate

extension FromLocalViewController {
    func didShowPhotoAtIndex(_ index: Int) {
        collectionView.visibleCells.forEach({$0.isHidden = false})
        collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        collectionView.visibleCells.forEach({$0.isHidden = false})
        collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
    }
    
    func willShowActionSheet(_ photoIndex: Int) {
        // do some handle if you need
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        reload()
    }

    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        
        // style 1
        if let back = UIImage(named: "back-gray") {
            browser.updateCloseButton(back)
        }
        if let delete = UIImage(named: "delete") {
            browser.updateDeleteButton(delete)
        }
        
//        return collectionView.cellForItem(at: IndexPath(item: index, section: 0))
        return collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
    }
    
    func dismissToIndexForPhoto(_ browser: SKPhotoBrowser, index: Int) -> Int {
        0
    }
    
    func captionViewForPhotoAtIndex(index: Int) -> SKCaptionView? {
        return nil
    }
    
    func longPressAtPageIndex(_ index: Int) {
        print("long press at \(index)")
    }
}

// MARK: - private

private extension FromLocalViewController {
    func setupTestData() {
        images = createLocalPhotos()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLocalPhotos() -> [SKPhotoProtocol] {
        return (0..<12).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImage(UIImage(named: "image\(i%12).jpg")!)
//            photo.caption = caption[i%10]
            return photo
        }
    }
}

class ExampleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var exampleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exampleImageView.image = nil
//        layer.cornerRadius = 25.0
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        exampleImageView.image = nil
    }
}

var caption = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
               "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
               "It has survived not only five centuries, but also the leap into electronic typesetting",
               "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
               "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
               "It has survived not only five centuries, but also the leap into electronic typesetting",
               "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
               "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
               "It has survived not only five centuries, but also the leap into electronic typesetting",
               "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
               ]
