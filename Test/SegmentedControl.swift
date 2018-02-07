//
//  SegmentedControl.swift
//  Test
//
//  Created by Sam on 1/30/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
