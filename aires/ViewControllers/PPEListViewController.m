//
//  PPEListViewController.h
//  aires
//
//  Created by Gautham on 01/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "PPEListViewController.h"
#import "SampleProtectionEquipment.h"

@interface NSArray (SSArrayOfArrays)
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NSArray (SSArrayOfArrays)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

@end

@interface NSMutableArray (SSArrayOfArrays)
// If idx is beyond the bounds of the reciever, this method automatically extends the reciever to fit with empty subarrays.
- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx;
@end

@implementation NSMutableArray (SSArrayOfArrays)

- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx
{
    while ([self count] <= idx) {
        [self addObject:[NSMutableArray array]];
    }
    
    [[self objectAtIndex:idx] addObject:anObject];
}

@end


@implementation PPEListViewController
@synthesize listContent, filteredListContent, sectionedListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (void)setListContent:(NSArray *)inListContent
{
    if (listContent == inListContent) {
        return;
    }
    listContent = inListContent ;
    
    NSMutableArray *sections = [NSMutableArray array];
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    for (SampleProtectionEquipment *equip in listContent) {
        NSInteger section = [collation sectionForObject:equip collationStringSelector:@selector(sampleProtectionEquipment_Name)];
        [sections addObject:equip toSubarrayAtIndex:section];
    }
    
    NSInteger section = 0;
    for (section = 0; section < [sections count]; section++) {
        NSArray *sortedSubarray = [collation sortedArrayFromArray:[sections objectAtIndex:section]
                                          collationStringSelector:@selector(sampleProtectionEquipment_Name)];
        [sections replaceObjectAtIndex:section withObject:sortedSubarray];
    }
    sectionedListContent = sections;
}

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
    [self.searchDisplayController setDelegate:self];
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
    [_ppeTableView reloadData];
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_navbar_nor.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_doneButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"btn_navbar_pressed.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_doneButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    bgimage = [UIImage imageNamed:@"navbar_back_nor.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_backButton setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"navbar_back_pressed.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    [_backButton setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    _titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17.0f];
    _backButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    _doneButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];

}


- (void)viewDidUnload
{
	// Save the state of the search UI so that it can be restored if the view is re-created.
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredListContent = nil;
}


-(IBAction)backButtonPressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(ppeListBackPressed)])
    {
        [_delegate ppeListBackPressed];
    }
}

-(IBAction)doneButtonPressed:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(selectedPPE:)])
    {
        [_delegate selectedPPE:_selectedContent];
    }
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return [self.sectionedListContent count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [[self.sectionedListContent objectAtIndex:section] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] ;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	SampleProtectionEquipment *equip = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        equip = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        equip = [self.sectionedListContent objectAtIndexPath:indexPath];
    }
	
    cell.textLabel.text = equip.sampleProtectionEquipment_Name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for(SampleProtectionEquipment *equip1 in self.selectedContent)
    {
        if([equip.sampleProtectionEquipment_Name isEqualToString:equip1.sampleProtectionEquipment_Name])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SampleProtectionEquipment *equip = [self.sectionedListContent objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for(SampleProtectionEquipment *equip1 in _selectedContent)
        {
            if([equip.sampleProtectionEquipment_Name isEqualToString:equip1.sampleProtectionEquipment_Name])
            {
                [_selectedContent removeObject:equip1];
                break;
            }
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedContent addObject:equip];
    }
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    for (NSArray *section in self.sectionedListContent) {
        for (SampleProtectionEquipment *equip in section)
        {
            NSComparisonResult result = [equip.sampleProtectionEquipment_Name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [self.filteredListContent addObject:equip];
            }
        }
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[self.sectionedListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

@end
