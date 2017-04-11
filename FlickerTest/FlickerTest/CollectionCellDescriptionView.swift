//
//  CollectionCellDescriptionView.swift
//  FlickerTest
//
//  Created by Gnani Naidu on 8/4/17.
//  Copyright © 2017 Loktra. All rights reserved.
//

import UIKit

class CollectionCellDescriptionView: UICollectionReusableView {
    
    private static let FONT_FOR_TITLE_LABEL = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    private static let FONT_FOR_SUBTITLE_LABEL = UIFont.systemFont(ofSize: UIFont.systemFontSize-4)
    private static let FONT_FOR_TAGS_LABEL = UIFont.systemFont(ofSize: UIFont.systemFontSize-2)

    private var titleLabel: UILabel?
    private var subTitleLabel: UILabel?
    private var tagsLabel: UILabel?
    private var triangularView: UIView?
    
    override func prepareForReuse() {
        titleLabel?.text = nil
        subTitleLabel?.text = nil
        tagsLabel?.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.backgroundColor = UIColor.blue
        
        titleLabel = UILabel()
        titleLabel!.textColor = UIColor.white
        titleLabel!.font = CollectionCellDescriptionView.FONT_FOR_TITLE_LABEL
        titleLabel!.lineBreakMode = .byWordWrapping
        titleLabel!.numberOfLines = 0
        self.addSubview(titleLabel!)
        
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelTopConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 8.0)
        self.addConstraint(titleLabelTopConstraint)
        
        let titleLabelLeadingConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8.0)
        self.addConstraint(titleLabelLeadingConstraint)
        
        let titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        self.addConstraint(titleLabelTrailingConstraint)
        
        subTitleLabel = UILabel()
        subTitleLabel!.textColor = UIColor.lightText
        subTitleLabel!.lineBreakMode = .byWordWrapping
        subTitleLabel!.numberOfLines = 0
        subTitleLabel!.font = CollectionCellDescriptionView.FONT_FOR_SUBTITLE_LABEL
        self.addSubview(subTitleLabel!)
        
        subTitleLabel!.translatesAutoresizingMaskIntoConstraints = false
        let subTitleLabelTopConstraint = NSLayoutConstraint(item: subTitleLabel!, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        self.addConstraint(subTitleLabelTopConstraint)
        
        let subTitleLabelLeadingConstraint = NSLayoutConstraint(item: subTitleLabel!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8.0)
        self.addConstraint(subTitleLabelLeadingConstraint)
        
        let subTitleLabelTrailingConstraint = NSLayoutConstraint(item: subTitleLabel!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        self.addConstraint(subTitleLabelTrailingConstraint)
        
        tagsLabel = UILabel()
        tagsLabel!.textColor = UIColor.white
        tagsLabel!.font = CollectionCellDescriptionView.FONT_FOR_TAGS_LABEL
        tagsLabel!.lineBreakMode = .byWordWrapping
        tagsLabel!.numberOfLines = 0
        self.addSubview(tagsLabel!)
        
        tagsLabel!.translatesAutoresizingMaskIntoConstraints = false
        let tagsLabelTopConstraint = NSLayoutConstraint(item: tagsLabel!, attribute: .top, relatedBy: .equal, toItem: subTitleLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        self.addConstraint(tagsLabelTopConstraint)
        
        let tagsLabelLeadingConstraint = NSLayoutConstraint(item: tagsLabel!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8.0)
        self.addConstraint(tagsLabelLeadingConstraint)
        
        let tagsLabelTrailingConstraint = NSLayoutConstraint(item: tagsLabel!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        self.addConstraint(tagsLabelTrailingConstraint)
    }
    
    func bindData(title: String?, author: String?, publishedOn: String?, tags: String?, rowIndex: Int) {
        
        if let titleText = title, !titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleLabel?.text = titleText
        }
        
        if author != nil, author?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, publishedOn != nil, publishedOn?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            
            var subTitleText = ""
            if let authorString = author {
                subTitleText = "By \(authorString)"
            }
            
            if let publishedOnString = publishedOn {
                subTitleText = subTitleText + "; At \(publishedOnString); "
            }
            
            subTitleLabel?.text = subTitleText
        }
        
        if let tagsText = tags, !tagsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            tagsLabel?.text = tagsText
        }
        
        var frame = CGRect.zero
        
        if (rowIndex % 2 == 0) {
            frame = CGRect(x: self.frame.width/4-5, y: -5, width: 10, height: 5)

        } else {
            frame = CGRect(x: self.frame.width/4*3-5, y: -5, width: 10, height: 5)
        }
        if let view = self.triangularView {
            view.frame = frame
        } else {
            triangularView = self.createTriangularView(frame: frame)
            triangularView!.backgroundColor = UIColor.blue
            self.addSubview(triangularView!)
        }
    }
    
    class func heightOfTheView(withWidth width: CGFloat, WithTitle title: String?, author: String?, publishedOn: String?, tags: String?) -> CGFloat {
        var height = 8.0
        if let titleText = title, !titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            height += ceil(Double(titleText.height(withConstrainedWidth: width-16, font: FONT_FOR_TITLE_LABEL)))
        }
        
        if author != nil || author?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false || publishedOn != nil || publishedOn?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            
            var subTitleText = ""
            if let authorString = author {
                subTitleText = "By \(authorString); "
            }
            
            if let publishedOnString = publishedOn {
                subTitleText = subTitleText + "At \(publishedOnString); "
            }
            
            height += 8.0
            height += ceil(Double(subTitleText.height(withConstrainedWidth: width-16, font: FONT_FOR_SUBTITLE_LABEL)))
        }
        
        if let tagsText = tags, !tagsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            height += 8.0
            height += ceil(Double(tagsText.height(withConstrainedWidth: width-16, font: FONT_FOR_TAGS_LABEL)))
        }
        height += 8.0
        return CGFloat(height)
    }
    
    func createTriangularView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width/2, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width/2, y: 0))
        path.close()
        
        let mask = CAShapeLayer()
        mask.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        mask.path = path.cgPath
        
        view.layer.mask = mask
        
        return view
    }
}

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
