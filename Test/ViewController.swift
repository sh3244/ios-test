//
//  ViewController.swift
//  Test
//
//  Created by Sam on 1/30/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import SnapKit
import Dwifft

class TestCell: UICollectionViewCell {

    var imageView = UIImageView()
    var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(label)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        bringSubview(toFront: label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}

class ViewController: UIViewController {

    var diffCalculator: CollectionViewDiffCalculator<String, Book>?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(TestCell.self, forCellWithReuseIdentifier: "testCell")
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.dataSource = self
        collectionView.delegate = self

        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl

        return collectionView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        return control
    }()

    var pager = Pager()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(collectionView.snp.width)
            make.centerY.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        load()
    }

    func load() {
        fetchBooks { (books) in
            var manyBooks = books
            manyBooks.append(contentsOf: books)
            manyBooks.append(contentsOf: books)
            manyBooks.append(contentsOf: books)
            manyBooks.append(contentsOf: books)
            manyBooks.append(contentsOf: books)
            self.diffCalculator?.sectionedValues = SectionedValues([("", manyBooks)])
            self.refreshControl.endRefreshing()
        }
    }

    @objc func refreshTriggered() {
        self.load()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let testCell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as? TestCell else {
            return TestCell()
        }

        guard let item = diffCalculator?.value(atIndexPath: indexPath) else {
            return testCell
        }
        testCell.label.text = item.title
        return testCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let calc = diffCalculator else { return 0 }
        return calc.numberOfObjects(inSection: section)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let calc = diffCalculator else { return 0 }
        return calc.numberOfSections()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - 1)/2
        return CGSize(width: size, height: size)
    }
}

