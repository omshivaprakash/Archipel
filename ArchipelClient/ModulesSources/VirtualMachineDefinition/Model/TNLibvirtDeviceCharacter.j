/*
 * TNLibvirtDeviceConsole.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

@import <Foundation/Foundation.j>
@import <StropheCappuccino/TNXMLNode.j>

@import "TNLibvirtBase.j"
@import "TNLibvirtDeviceCharacterSource.j"
@import "TNLibvirtDeviceCharacterTarget.j"

TNLibvirtDeviceCharacterTypePTY         = @"pty";
TNLibvirtDeviceCharacterTypeUNIX        = @"unix";
TNLibvirtDeviceCharacterTypeSPICEVMC    = @"spicevmc";


/*! @ingroup virtualmachinedefinition
    Model for device consoles
*/
@implementation TNLibvirtDeviceCharacter : TNLibvirtBase
{
    CPString                        _kind       @accessors(property=kind);

    CPString                        _type       @accessors(property=type);
    TNLibvirtDeviceCharacterSource  _source     @accessors(property=source);
    TNLibvirtDeviceCharacterTarget  _target     @accessors(property=target);
}


#pragma mark -
#pragma mark Initialization

- (TNLibvirtDeviceCharacter)initWithKind:(CPString)aKind
{
    if (self = [super init])
    {
        _kind = aKind;
    }

    return self;
}

/*! initialize the object with a given XML node
    @param aNode the node to use
*/
- (id)initWithXMLNode:(TNXMLNode)aNode
{
    if (self = [super initWithXMLNode:aNode])
    {
        if ([aNode name] != @"console" && [aNode name] != @"serial" && [aNode name] != @"channel" && [aNode name] != @"parallel")
            [CPException raise:@"XML not valid" reason:@"The TNXMLNode provided is not a valid character device"];

        _kind = [aNode name];
        _type = [aNode valueForAttribute:@"type"];

        if ([aNode containsChildrenWithName:@"source"])
            _source = [[TNLibvirtDeviceCharacterSource alloc] initWithXMLNode:[aNode firstChildWithName:@"source"]];
        if ([aNode containsChildrenWithName:@"target"])
            _target = [[TNLibvirtDeviceCharacterTarget alloc] initWithXMLNode:[aNode firstChildWithName:@"target"]];
    }

    return self;
}


#pragma mark -
#pragma mark Generation

/*! return a TNXMLNode representing the object
    @return TNXMLNode
*/
- (TNXMLNode)XMLNode
{
    if (!_type)
        [CPException raise:@"Missing console type" reason:@"console type is required"];

    var node = [TNXMLNode nodeWithName:_kind];

    if (_type)
        [node setValue:_type forAttribute:@"type"];

    if (_source)
    {
        [node addNode:[_source XMLNode]];
        [node up];
    }

    if (_target)
    {
        [node addNode:[_target XMLNode]];
        [node up];
    }

    return node;
}

@end
