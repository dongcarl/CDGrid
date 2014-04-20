//
// Created by Carl Dong on 3/11/14.
// Copyright (c) 2014 Carl Dong. All rights reserved.
//

#import "CDWrappedGrid.h"

@implementation CDWrappedGrid

@synthesize unwrappedGrid = _unwrappedGrid;
@synthesize linearRepresentation = _linearRepresentation;

//Creating an Array

+ (id)wrappedGrid
{
	return [[self alloc]init];
}

+ (id)wrappedGridWithWrappedGrid:(CDWrappedGrid *)incomingWrappedGrid
{
	return [[self alloc] initWithWrappedGrid:incomingWrappedGrid];
}

+ (id)wrappedGridWithObject:(id)incomingObject
{
	return [[self alloc] initWithObject:incomingObject];
}

+ (id)wrappedGridWithUnwrappedGrid:(NSArray *)incomingUnwrappedGrid
{
	return [[CDWrappedGrid alloc] initWithUnwrappedGrid:incomingUnwrappedGrid];
}

+ (id)wrappedGridWithLinearRepresentation:(NSArray *)incomingLinearRepresentation
                                     size:(CDGridSize)incomingGridSize
{
	return [[CDWrappedGrid alloc] initWithLinearRepresentation:incomingLinearRepresentation size:incomingGridSize];
}

//Initializing an Array

- (id)init
{
	return [self initWithUnwrappedGrid:@[@[]]];
}

- (id)initWithWrappedGrid:(CDWrappedGrid *)incomingWrappedGrid
{
	return [self initWithUnwrappedGrid:incomingWrappedGrid.unwrappedGrid];
}

- (id)initWithObject:(id)incomingObject
{
	return [self initWithUnwrappedGrid:@[@[incomingObject]]];
}

- (id)initWithUnwrappedGrid:(NSArray *)incomingUnwrappedGrid
{
	self = [super init];
	if (self)
	{
		if ([self isValidUnwrappedGrid:incomingUnwrappedGrid])
		{
			_unwrappedGrid = incomingUnwrappedGrid;
		}
		else
		{
			NSLog(@"%@ was called with parameters that failed %@, going to return self with _unwrappedGrid unset", NSStringFromSelector(_cmd), NSStringFromSelector(@selector(isValidUnwrappedGrid:)));
		}
	}
	return self;
}

- (id)initWithLinearRepresentation:(NSArray *)incomingLinearRepresentation
                              size:(CDGridSize)incomingGridSize
{
	return [self initWithUnwrappedGrid:[self unwrappedGridFromLinearRepresentation:incomingLinearRepresentation size:incomingGridSize]];
}

//querying an grid

- (BOOL)containsObject:(id)incomingObject
{
	BOOL outgoingContainsObjectDecision = NO;
	for (NSUInteger currentRowIndex = 0; currentRowIndex < self.countRows && !outgoingContainsObjectDecision; currentRowIndex++)
	{
		if ([[_unwrappedGrid objectAtIndex:currentRowIndex] containsObject:incomingObject])
		{
			outgoingContainsObjectDecision = YES;
		}
	}
	return outgoingContainsObjectDecision;
}

- (NSUInteger)count
{
	return self.countRows * self.countColumns;
}

- (CDGridSize)size
{
	return CDMakeGridSize(self.countRows, self.countColumns);
}

- (NSUInteger)countRows
{
	return self.unwrappedGrid.count;
}

- (NSUInteger)countColumns
{
	NSUInteger outgoingCountColumns;
	if ([self isUnwrappedArrayRectangular:nil ])
	{
		outgoingCountColumns = [_unwrappedGrid.firstObject count];
	}
	else
	{
		NSLog(@"unwrappedGrid is not rectangular, going to return nil");
	}
	return outgoingCountColumns;
}

- (id)firstObject
{
	return [self.linearRepresentation firstObject];
}

- (id)lastObject
{
	return [self.linearRepresentation lastObject];
}

- (id)objectAtGridIndex:(CDGridIndex)incomingGridIndex
{
	return self.unwrappedGrid[incomingGridIndex.row][incomingGridIndex.column];
}

- (NSEnumerator *)objectEnumerator
{
	return [self.linearRepresentation objectEnumerator];
}

- (NSEnumerator *)reverseObjectEnumerator
{
	return [self.linearRepresentation reverseObjectEnumerator];
}

- (NSArray *)rowAtIndex:(NSUInteger)incomingRowIndex
{
	return [_unwrappedGrid objectAtIndex:incomingRowIndex];
}

- (NSArray *)columnAtIndex:(NSUInteger)incomingColumnIndex
{
	NSMutableArray *outgoingColumn = [NSMutableArray array];

	for (NSUInteger currentRowIndex = 0; currentRowIndex < self.countRows; currentRowIndex++)
	{
		[outgoingColumn addObject:_unwrappedGrid[currentRowIndex][incomingColumnIndex]];
	}

	return outgoingColumn;
}

//enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
	                                count:(NSUInteger)len
{
	return [self.linearRepresentation countByEnumeratingWithState:state objects:buffer count:len];
}

// Finding Objects in an Array
- (CDGridIndex)indexOfObject:(id)anObject
{
	return [self gridIndexFromLinearIndex:[self.linearRepresentation indexOfObject:anObject]];
}

- (CDGridIndex)indexOfObjectIdenticalTo:(id)anObject
{
	return [self gridIndexFromLinearIndex:[self.linearRepresentation indexOfObjectIdenticalTo:anObject]];
}

- (CDGridIndex)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
	return [self gridIndexFromLinearIndex:[self.linearRepresentation indexOfObjectPassingTest:predicate]];
}

// Sending Messages to Elements
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
	[self.linearRepresentation enumerateObjectsUsingBlock:block];
}

// Comparing Matrices
- (id)firstObjectCommonWithGrid:(CDWrappedGrid *)otherGrid
{
	return [self.linearRepresentation firstObjectCommonWithArray:otherGrid.linearRepresentation];
}

- (BOOL)isEqualToGrid:(CDWrappedGrid *)other
{
	return [self.linearRepresentation isEqualToArray:other.linearRepresentation];
}
// Deriving New Matrices

- (CDWrappedGrid *)wrappedGridByAddingRow:(NSArray *)incomingRowToAdd
{
	NSMutableArray *outgoingUnwrappedGrid = [_unwrappedGrid mutableCopy];
	if (incomingRowToAdd.count == self.countColumns)
	{
		[outgoingUnwrappedGrid addObject:incomingRowToAdd];
	}
	else
	{
		NSLog(@"%@ was called with an incomingRowToAdd that didn't have the same count: as %p's %@", NSStringFromSelector(_cmd), self, NSStringFromSelector(@selector(countColumns)));
	}
	return [[self class] wrappedGridWithUnwrappedGrid:outgoingUnwrappedGrid];
}

- (CDWrappedGrid *)wrappedGridByAddingColumn:(NSArray *)incomingColumnToAdd
{
	NSMutableArray *outgoingUnwrappedGrid = [_unwrappedGrid mutableCopy];
	if (incomingColumnToAdd.count == self.countRows)
	{
		for (NSUInteger currentRowIndex = 0; currentRowIndex < outgoingUnwrappedGrid.count; currentRowIndex++)
		{
			NSMutableArray *currentMutableRow = [[outgoingUnwrappedGrid objectAtIndex:currentRowIndex] mutableCopy];
			[currentMutableRow addObject:incomingColumnToAdd[currentRowIndex]];
			[outgoingUnwrappedGrid replaceObjectAtIndex:currentRowIndex withObject:currentMutableRow];
		}
	}
	else
	{
		NSLog(@"%@ was called with an incomingColumnToAdd that didn't have the same count: as %p's %@", NSStringFromSelector(_cmd), self, NSStringFromSelector(@selector(countRows)));
	}
	return [[self class] wrappedGridWithUnwrappedGrid:outgoingUnwrappedGrid];
}

- (CDWrappedGrid *)subWrappedGridWithGridRange:(CDGridRange)incomingGridRange
{
	NSMutableArray *outgoingUnwrappedGrid = [NSMutableArray array];
	NSRange rowRange = NSMakeRange(incomingGridRange.location.column, incomingGridRange.length.columns);
	for (NSArray *currentRow in _unwrappedGrid)
	{
		[outgoingUnwrappedGrid addObject:[currentRow subarrayWithRange:rowRange]];
	}
	return [[self class] wrappedGridWithUnwrappedGrid:outgoingUnwrappedGrid];
}


// Sorting
// Working with String Elements
// Creating a Description
// Collecting Paths
// Key-Value Observing
// Key-Value Coding

//helper methods

- (NSArray *)unwrappedGridFromLinearRepresentation:(NSArray *)incomingLinearRepresentation
                                              size:(CDGridSize)incomingGridSize
{
	NSMutableArray *outgoingUnwrappedGrid = [NSMutableArray array];
	for (NSUInteger currentRow = 0; currentRow < incomingGridSize.rows; currentRow++)
	{
		[outgoingUnwrappedGrid addObject:[incomingLinearRepresentation subarrayWithRange:NSMakeRange(currentRow*incomingGridSize.columns, incomingGridSize.columns)]];
	}
	return outgoingUnwrappedGrid;
}

- (BOOL)isLinearRepresentation:(NSArray *)incomingLinearRepresentation
            consistentWithSize:(CDGridSize)incomingGridSize
{
	return incomingLinearRepresentation.count == incomingGridSize.rows * incomingGridSize.columns;
}

- (CDGridIndex)gridIndexFromLinearIndex:(NSUInteger)incomingLinearIndex
{
	return CDMakeGridIndex(incomingLinearIndex / self.countColumns, incomingLinearIndex % self.countColumns);
}

//others
- (BOOL)isUnwrappedArrayRectangular:(NSArray *)incomingUnwrappedArray
{
	BOOL outgoingIsRectangularDecision = YES;
	NSUInteger lastNumberOfColumns = [incomingUnwrappedArray[0] count];

	for (NSUInteger currentRowIndex = 1; currentRowIndex < incomingUnwrappedArray.count && outgoingIsRectangularDecision; currentRowIndex++)
	{
		if ([incomingUnwrappedArray[currentRowIndex] count] != lastNumberOfColumns)
		{
			outgoingIsRectangularDecision = NO;
		}
	}

	return outgoingIsRectangularDecision;
}

- (BOOL)isValidUnwrappedGrid:(NSArray *)incomingUnwrappedGrid
{
	BOOL outgoingIsValidUnwrappedGridDecision = NO;
	NSUInteger lastNumberOfColumns;

	if ([incomingUnwrappedGrid.firstObject isKindOfClass:[NSArray class]])
	{
		lastNumberOfColumns = [incomingUnwrappedGrid.firstObject count];
		outgoingIsValidUnwrappedGridDecision = YES;
	}

	for (NSUInteger currentRowIndex = 0; currentRowIndex < incomingUnwrappedGrid.count && outgoingIsValidUnwrappedGridDecision; currentRowIndex++)
	{
		if (
				(![incomingUnwrappedGrid[currentRowIndex] isKindOfClass:[NSArray class]])
				|| ([incomingUnwrappedGrid[currentRowIndex] count] != lastNumberOfColumns)
				|| ([incomingUnwrappedGrid[currentRowIndex] count] == 0)
			)
		{
			outgoingIsValidUnwrappedGridDecision = NO;
		}
	}

	return outgoingIsValidUnwrappedGridDecision;
}


- (BOOL)isEmpty
{
	BOOL outgoingIsEmptyDecision = YES;
	for (NSUInteger currentRowIndex = 0; currentRowIndex < self.countRows && outgoingIsEmptyDecision; currentRowIndex++)
	{
		NSArray *currentRow = [_unwrappedGrid objectAtIndex:currentRowIndex];
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex < self.countColumns && outgoingIsEmptyDecision; currentColumnIndex++)
		{
			id currentCell = [currentRow objectAtIndex:currentColumnIndex];
			if (currentCell)
			{
				outgoingIsEmptyDecision = NO;
			}
		}
	}
	return outgoingIsEmptyDecision;
}

- (NSString *)description
{
	//initialize array with correct number of rows
	NSMutableArray *descriptionGrid = [NSMutableArray array];
	NSMutableString *outgoingDescriptionString = [NSMutableString stringWithFormat:@"%c", '\n'];

	//initialize each row with correct number of columns
	for (NSUInteger currentRowIndex = 0; currentRowIndex < self.countRows*4+1; currentRowIndex++)
	{
		[descriptionGrid addObject:[NSMutableArray array]];
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex < self.countColumns*4+1; currentColumnIndex++)
		{
			[[descriptionGrid lastObject] addObject:@" "];
		}
	}
	
	//add all the +'s!!
	for (NSUInteger currentRowIndex = 0; currentRowIndex <= self.countRows; currentRowIndex++)
	{
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex <= self.countColumns; currentColumnIndex++)
		{
			[[descriptionGrid objectAtIndex:currentRowIndex*4] replaceObjectAtIndex:currentColumnIndex*4 withObject:@"+"];
		}
	}

	//add all the -'s!!

	for (NSUInteger currentRowIndex = 0; currentRowIndex <= self.countRows; currentRowIndex++)
	{
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex < self.countColumns; currentColumnIndex++)
		{
			[[descriptionGrid objectAtIndex:currentRowIndex*4] replaceObjectAtIndex:currentColumnIndex*4+1 withObject:@"-"];
			[[descriptionGrid objectAtIndex:currentRowIndex*4] replaceObjectAtIndex:currentColumnIndex*4+2 withObject:@"-"];
			[[descriptionGrid objectAtIndex:currentRowIndex*4] replaceObjectAtIndex:currentColumnIndex*4+3 withObject:@"-"];
		}
	}

	//add all the |'s
	for (NSUInteger currentRowIndex = 0; currentRowIndex < self.countRows; currentRowIndex++)
	{
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex <= self.countColumns; currentColumnIndex++)
		{
			[[descriptionGrid objectAtIndex:currentRowIndex*4+1] replaceObjectAtIndex:currentColumnIndex*4 withObject:@"|"];
			[[descriptionGrid objectAtIndex:currentRowIndex*4+2] replaceObjectAtIndex:currentColumnIndex*4 withObject:@"|"];
			[[descriptionGrid objectAtIndex:currentRowIndex*4+3] replaceObjectAtIndex:currentColumnIndex*4 withObject:@"|"];

		}
	}

	//add all the items
	for (NSUInteger currentRowIndex = 0; currentRowIndex < self.countRows; currentRowIndex++)
	{
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex < self.countColumns; currentColumnIndex++)
		{
			[[descriptionGrid objectAtIndex:currentRowIndex*4+2] replaceObjectAtIndex:currentColumnIndex*4+2 withObject:[[[self.unwrappedGrid objectAtIndex:currentRowIndex] objectAtIndex:currentColumnIndex] description]];
		}
	}

	//make it into a string~~
	for (NSUInteger currentRowIndex = 0; currentRowIndex < descriptionGrid.count; currentRowIndex++)
	{
		for (NSUInteger currentColumnIndex = 0; currentColumnIndex < [descriptionGrid.firstObject count]; currentColumnIndex++)
		{
			NSLog(@"going to append string at row %lu out of %lu rows and column %lu out of %lu columns", (unsigned long)currentRowIndex, (
			unsigned long)descriptionGrid.count, (unsigned long)currentColumnIndex, (
					unsigned long) [descriptionGrid.firstObject count]);
			[outgoingDescriptionString appendString:[[descriptionGrid objectAtIndex:currentRowIndex] objectAtIndex:currentColumnIndex]];
		}
		[outgoingDescriptionString appendFormat:@"%c", '\n'];
	}

	return outgoingDescriptionString;
}

- (NSArray *)linearRepresentation
{
	if (!_linearRepresentation)
	{
		NSMutableArray *outgoingLinearRepresentation = [NSMutableArray array];

		for (NSArray *currentRow in self.unwrappedGrid)
		{
			[outgoingLinearRepresentation addObjectsFromArray:currentRow];
		}

		_linearRepresentation = outgoingLinearRepresentation;
	}

	return _linearRepresentation;
}

- (BOOL)isSquare
{
	return self.countColumns == self.countRows;
}

CDGridIndex CDMakeGridIndex(NSUInteger row, NSUInteger column)
{
	CDGridIndex point;
	point.row = row;
	point.column = column;
	return point;
}

CDGridSize CDMakeGridSize(NSUInteger rows, NSUInteger columns)
{
	CDGridSize size;
	size.rows = rows;
	size.columns = columns;
	return size;
}

CDGridRange CDMakeGridRange(CDGridIndex location, CDGridSize length)
{
	CDGridRange range;
	range.location = location;
	range.length = length;
	return range;
}


@end