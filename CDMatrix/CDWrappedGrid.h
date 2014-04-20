//
// Created by Carl Dong on 3/11/14.
// Copyright (c) 2014 Carl Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDWrappedGrid : NSObject <NSFastEnumeration>
{
		NSArray *_unwrappedGrid;
}

struct CDGridIndex
{
	NSUInteger row;
	NSUInteger column;
};
typedef struct CDGridIndex CDGridIndex;

struct CDGridSize
{
	NSUInteger rows;
	NSUInteger columns;
};
typedef struct CDGridSize CDGridSize;

struct CDGridRange
{
	CDGridIndex location;
	CDGridSize length;
};
typedef struct CDGridRange CDGridRange;

CDGridIndex CDMakeGridIndex(NSUInteger row, NSUInteger column);
CDGridSize CDMakeGridSize(NSUInteger rows, NSUInteger columns);
CDGridRange CDMakeGridRange(CDGridIndex location, CDGridSize length);

//the almighty unWrappedGrid - the mothership
@property (readonly) NSArray *unwrappedGrid;

//other representations
@property (readonly) NSArray *linearRepresentation;

//countSome


//querying
@property (readonly) BOOL isEmpty;
@property (readonly) BOOL isSquare;

//Creating an Array
+ (id)wrappedGrid;
+ (id)wrappedGridWithWrappedGrid:(CDWrappedGrid *)incomingWrappedGrid;
+ (id)wrappedGridWithObject:(id)incomingObject;
+ (id)wrappedGridWithUnwrappedGrid:(NSArray *)incomingUnwrappedGrid;
+ (id)wrappedGridWithLinearRepresentation:(NSArray *)incomingLinearRepresentation
                                     size:(CDGridSize)incomingGridSize;

//Initializing an Array
- (id)init;
- (id)initWithWrappedGrid:(CDWrappedGrid *)incomingWrappedGrid;
- (id)initWithObject:(id)incomingObject;
- (id)initWithUnwrappedGrid:(NSArray *)incomingUnwrappedGrid;
- (id)initWithLinearRepresentation:(NSArray *)incomingLinearRepresentation
                              size:(CDGridSize)incomingGridSize;

//querying an grid
- (BOOL)containsObject:(id)incomingObject;

@property (readonly) NSUInteger count;
@property (readonly) CDGridSize size;
@property (readonly) NSUInteger countRows;
@property (readonly) NSUInteger countColumns;
@property (readonly) id firstObject;
@property (readonly) id lastObject;
//

- (id)objectAtGridIndex:(CDGridIndex)incomingGridIndex;
- (NSEnumerator *)objectEnumerator;
- (NSEnumerator *)reverseObjectEnumerator;

- (NSArray *)rowAtIndex:(NSUInteger)incomingRowIndex;
- (NSArray *)columnAtIndex:(NSUInteger)incomingColumnIndex;

//enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
	                                count:(NSUInteger)len;

// Finding Objects in an Array
- (CDGridIndex)indexOfObject:(id)anObject;

- (CDGridIndex)indexOfObjectIdenticalTo:(id)anObject;

- (CDGridIndex)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;





// Sending Messages to Elements
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

// Comparing Matrices
- (id)firstObjectCommonWithGrid:(CDWrappedGrid *)otherGrid;
- (BOOL)isEqualToGrid:(CDWrappedGrid *)otherGrid;

// Deriving New Matrices
- (CDWrappedGrid *)wrappedGridByAddingRow:(NSArray *)incomingRowToAdd;
- (CDWrappedGrid *)wrappedGridByAddingColumn:(NSArray *)incomingColumnToAdd;
- (CDWrappedGrid *)subWrappedGridWithGridRange:(CDGridRange)incomingGridRange;


// Sorting
// Working with String Elements
// Creating a Description
// Collecting Paths
// Key-Value Observing
// Key-Value Coding


//helper methods
- (NSArray *)unwrappedGridFromLinearRepresentation:(NSArray *)incomingLinearRepresentation
                                              size:(CDGridSize)incomingGridSize;
- (BOOL)isLinearRepresentation:(NSArray *)incomingLinearRepresentation
            consistentWithSize:(CDGridSize)incomingGridSize;
- (BOOL)isValidUnwrappedGrid:(NSArray *)incomingUnwrappedGrid;

@end