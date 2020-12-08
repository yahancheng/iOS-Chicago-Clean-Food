//
//  WalkThroughViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/29.
//

import UIKit

class WalkThroughViewController: UIViewController, WalkThroughPageViewControllerDelegate {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton!
    
    var walkThroughPageViewController: WalkThroughPageViewController?
    
    
    // button action
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkThrough")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkThroughPageViewController?.currentIndex {
            switch index {
            case 0...2:
                walkThroughPageViewController?.forwardPage()
                
            case 3:
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
        
        updateUI()
    }
    
    //mark: view controller life cycle
    func updateUI() {
        if let index = walkThroughPageViewController?.currentIndex {
            switch index {
            case 0...2:
                nextButton.setTitle("Next", for: .normal)
                skipButton.isHidden = false
            case 3:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkThrough")
                nextButton.setTitle("Explore", for: .normal)
                skipButton.isHidden = true
            default:
                break
            }
            pageControl.currentPage = index
        }
    }
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkThroughPageViewController {
            walkThroughPageViewController = pageViewController
            walkThroughPageViewController?.walkThroughDelegate = self
        }
    }


}
