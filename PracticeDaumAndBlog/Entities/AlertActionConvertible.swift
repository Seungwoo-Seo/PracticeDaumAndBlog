//
//  AlertActionConvertible.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import UIKit

protocol AlertActionConvertible {
    var title: String {get}
    var style: UIAlertAction.Style {get}
}
