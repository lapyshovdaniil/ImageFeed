//
//  ViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 20.12.2024.
//

import UIKit
import Kingfisher


final class ImageListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    var presenter: ImageListPresenter!
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
               presenter = ImageListPresenter(view: self, imagesListService: ImagesListService.shared)
           }
           
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter.viewDidLoad()
    }
       private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.dateFormat = "dd MMMM y"
            return formatter
        }()
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == showSingleImageSegueIdentifier {
                guard
                    let viewController = segue.destination
                        as? SingleImageViewController,
                    let indexPath = sender as? IndexPath
                else {
                    assertionFailure("Invalid segue destination")
                    return
                }
                let imageURL = presenter.photos[indexPath.row].largeImageURL
                viewController.imageURL = imageURL
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
}

extension ImageListViewController: ImageListView {
    func updateTableView() {
        tableView.reloadData()
    }
    
    func updateLike(at index: Int, isLiked: Bool) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ImagesListCell {
            cell.setIsLike(isLiked: isLiked)
        }
    }
    
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showError(_ error: Error) {
        print("Ошибка: \(error)")
    }
}

extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    func tableView(
          _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
      ) {
          performSegue(
              withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        let photo = presenter.photos[indexPath.row]
        imageListCell.configure(with: photo, dateFormatter: dateFormatter)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath.row)
    }
}

extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didTapLike(at: indexPath.row)
    }
}

