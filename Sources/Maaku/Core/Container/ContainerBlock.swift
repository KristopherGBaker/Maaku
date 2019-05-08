//
//  ContainerBlock.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown container block.
public protocol ContainerBlock: Block {

    /// The block items.
    var items: [Block] { get }
}

/// Represents a markdown list.
public protocol List: ContainerBlock {

}

/// Represents an item in a markdown list.
public protocol Item: ContainerBlock {

}
