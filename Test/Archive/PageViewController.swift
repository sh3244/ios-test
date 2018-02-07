//
//  PageViewController.swift
//  Test
//
//  Created by Sam on 1/30/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import SnapKit

class PageViewController: UIPageViewController {

    let manager = SearchPageManager()
    let segmentedControl = UISegmentedControl()

    lazy var firstViewController: ViewController = {
        let vc = ViewController()
        vc.view.backgroundColor = .green
        return vc
    }()

    lazy var secondViewController: ViewController = {
        let vc = ViewController()
        vc.view.backgroundColor = .red
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        manager.controllers = [firstViewController, secondViewController]
        self.delegate = manager
        self.dataSource = manager

        setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)

        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setViewControllers([firstViewController, secondViewController], direction: .forward, animated: true, completion: nil)
    }

}

class PageManager: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var isInfinite = false
    var controllers: [UIViewController] = []

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var prev: UIViewController?
        if isInfinite {
            prev = controllers.last
        }
        for controller in controllers {
            if controller == viewController {
                return prev
            }
            prev = controller
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var prev: UIViewController?
        if isInfinite {
            prev = controllers.first
        }
        for controller in controllers.reversed() {
            if controller == viewController {
                return prev
            }
            prev = controller
        }
        return nil
    }
}
