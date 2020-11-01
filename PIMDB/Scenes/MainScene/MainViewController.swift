//
//  ViewController.swift
//  AliveCorAssignment
//
//  Created by abhinay varma on 30/10/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    let mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewModel.delegate = self
        mainViewModel.getMovies()
        setupTableView()
    }

    private func setupTableView() {
        mainTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        mainViewModel.reloadDataOnRefresh()
    }
    
    @IBAction func onClickFav(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavViewController") as? FavViewController
        self.navigationController?.pushViewController(vc!,animated:true)
    }
    
}

extension MainViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell
        let model = mainViewModel.models[indexPath.row]
        cell?.updateCell(model)
        cell?.favClicked = {
            self.mainViewModel.updateFav(model)
        }
        if indexPath.row == mainViewModel.models.count - 1 && mainViewModel.currentPage < mainViewModel.totalPages {
            mainViewModel.currentPage += 1
            mainViewModel.getMovies()
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 60.0))
        view.backgroundColor = UIColor(displayP3Red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        let titleLabel = UILabel(frame: CGRect(x: 16.0, y: 5.0, width: view.frame.size.width, height: 50.0))
        titleLabel.textAlignment = .left
        titleLabel.text = "Most Popular Movies"
        titleLabel.font = UIFont(name: "", size: 40.0)
        titleLabel.textColor = UIColor.white
        view.addSubview(titleLabel)
        return view
    }
    
    
    
}

extension MainViewController:UIUpdateDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}
