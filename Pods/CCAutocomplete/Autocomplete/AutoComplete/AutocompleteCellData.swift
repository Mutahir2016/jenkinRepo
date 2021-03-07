//
//  AutocompleteCellData.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/12/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

public protocol AutocompletableOption {
    var cityId: String { get }
    var text: String { get }
}

open class AutocompleteCellData: AutocompletableOption {
    fileprivate let _text: String
    fileprivate let _cityId: String
    
    open var text: String { get { return _text } }
    open var cityId: String { return _cityId }
    public let image: UIImage?

    public init(cityId: String, text: String, image: UIImage?) {
        self._text = text
        self._cityId = cityId
        self.image = image
    }
}
