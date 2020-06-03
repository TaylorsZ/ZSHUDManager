//
//  UIVIew+AutoLayout.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit

extension UIView {
    func addConstraint(_ attribute: NSLayoutConstraint.Attribute, value: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value))
    }

    func addConstraint(_ attribute: NSLayoutConstraint.Attribute, greatOrLess rela: NSLayoutConstraint.Relation, value: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: rela, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value))
    }
    func addConstraint(_ attribute: NSLayoutConstraint.Attribute, equalTo to: UIView?, offset: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: to, attribute: attribute, multiplier: 1.0, constant: offset))
    }

    func addConstraint(_ attribute: NSLayoutConstraint.Attribute, equalTo to: UIView?, multiplier: CGFloat) {
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: to, attribute: attribute, multiplier: multiplier, constant: 0))
    }
    func addConstraint(_ attribute: NSLayoutConstraint.Attribute, equalTo to: UIView?, fromConstraint fromAttribute: NSLayoutConstraint.Attribute, offset: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: to, attribute: fromAttribute, multiplier: 1.0, constant: offset))
    }

    func removeAutoLayout(_ constraint: NSLayoutConstraint?) {
        
        guard let constraints = superview?.constraints  else {
            return
        }
        for con in constraints {
            if con.isEqual(constraint) {
                superview?.removeConstraint(con)
            }
        }
    }
    func removeAllAutoLayout() {
        for con in constraints {
            removeConstraint(con)
        }
    }


}
