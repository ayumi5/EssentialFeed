//
//  ImageCommentViewController.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/08/23.
//

import UIKit
import EssentialFeed

public final class ImageCommentViewController: CellController {
    private let model: ImageCommentViewModel
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dateLabel.text = model.date
        
        return cell
    }    
}
