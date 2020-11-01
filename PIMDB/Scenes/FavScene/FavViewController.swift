//
//  FavViewController.swift
//  PIMDB
//
//  Created by abhinay varma on 01/11/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class FavViewController: UIViewController {
    @IBOutlet weak var favViewController: UITableView!
    var viewModel = FavViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.getFavMovies()
        favViewController.reloadData()
    }

    private func setupTableView() {
        favViewController.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        favViewController.dataSource = self
        favViewController.delegate = self
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FavViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell
        let model = viewModel.movies[indexPath.row]
        cell?.updateCell(model)
        cell?.bookmarkIcon.isHidden = true
//        cell?.favClicked = {
//            self.mainViewModel.updateFav(model)
//        }
        
        return cell ?? UITableViewCell()
    }
    
}
