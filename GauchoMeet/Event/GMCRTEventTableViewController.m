/*!
 File: MyTableViewController.m
 @abstract The main table view controller of this app.
 Version: 1.6
 
 */


#import "GauchoMeet-Swift.h"
#import "GMActivityView.h"
#import "GMGlobalConstants.h"


#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kTypePickerTag              4     // view tag identifiying the type picker view
#define kDatePickerTag              5     // view tag identifiying the date picker view
#define kTitleTextFiledTag          6

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define kContentKey     @"content"

// keep track of which rows have date cells
#define kTypeRow        1
#define kDateStartRow   2
#define kDateEndRow     3


static NSString *kTitleCellID = @"titleCell";     // the cells with the event title
static NSString *kTypeCellID = @"typeCell";     // the cells with the event type
static NSString *kTypePickerCellID = @"typePickerCell"; // the cell containing the typePicker
static NSString *kDateCellID = @"timeCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePickerCell"; // the cell containing the date picker
static NSString *kLocationCellID = @"locationCell";     // the remaining cells at the end

#pragma mark -
@interface GMCRTEventTableViewController ()
/// An array that stores all input data
@property (nonatomic, strong) NSArray *dataArray;
/// Options for event types
@property (nonatomic, strong) NSArray *pickerDataArray;

/// Date formatter
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
/// Picker used for selecting event type
@property (nonatomic, strong) GMEvetnTypePickerView * TypePicker;

// keep track which indexPath points to the cell with UIDatePicker and typePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong) NSIndexPath *typePickerIndexPath;

// For Parse
@property NSString *eventTitle;
@property NSDate *eventTime;
@property NSDate *eventEndTime;
@property NSString *eventType;


@end

#pragma mark -

@implementation GMCRTEventTableViewController

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // setup our data source P.S. some are not used!
  NSMutableDictionary *titleContent = [@{ kTitleKey : @"Title" } mutableCopy];
  NSMutableDictionary *typeContent = [@{ kTitleKey : @"Type",kContentKey : @"Please Select" } mutableCopy];
  NSMutableDictionary *startContent = [@{ kTitleKey : @"Starts at",
										  kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *endContent = [@{ kTitleKey : @"Ends at(optional)",
										kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *locationContent = [@{ kTitleKey : @"Location" } mutableCopy];
  self.dataArray = @[ titleContent, typeContent, startContent, endContent, locationContent];
  
  // initialize type picker data array
  NSArray *formsDataArray = @[@"Meal", @"Study", @"Hang out"];
  NSArray *participantsDataArray = @[@"Friend", @"Stranger", @"Professor"];
  NSArray *paymentMethodsDataArray = @[@"Going Dutch", @"My treat"];
  NSArray *frequencyDataArray = @[@"One-time", @"Regular"];
  self.pickerDataArray = @[formsDataArray,participantsDataArray,paymentMethodsDataArray, frequencyDataArray];
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
  [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  
  // iOS 8 only; automaticlly configured row height
  
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  // if the local changes while in the background, we need to be notified so we can update the date
  // format in the table view cells
  //
  [[NSNotificationCenter defaultCenter] addObserver:self
										   selector:@selector(localeChanged:)
											   name:NSCurrentLocaleDidChangeNotification
											 object:nil];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
												  name:NSCurrentLocaleDidChangeNotification
												object:nil];
}

- (IBAction)unwindToCreateEvent:(UIStoryboardSegue*)sender
{
  
}


#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
  // the user changed the locale (region format) in Settings, so we are notified here to
  // update the date format in the table view cells
  //
  [self.tableView reloadData];
}


#pragma mark - Utilities

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
  BOOL hasDatePicker = NO;
  
  NSInteger targetedRow = indexPath.row;
  targetedRow++;
  
  UITableViewCell *checkDatePickerCell =
  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
  UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
  
  hasDatePicker = (checkDatePicker != nil);
  return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
  if (self.datePickerIndexPath != nil)
  {
	UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
	
	UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
	if (targetedDatePicker != nil)
	{
			// we found a UIDatePicker in this cell, so update it's date value
			//
			NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
			[targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
	  
	  // If this is the end date, set the minimum date
	  if (self.datePickerIndexPath.row - 1 == kDateEndRow) {
		targetedDatePicker.minimumDate = [itemData valueForKey:kDateKey];
	  }
	}
	
  }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
  return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
  return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
  BOOL hasDate = NO;
  
  if ((indexPath.row == kDateStartRow) ||
	  (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
  {
	hasDate = YES;
  }
  
  return hasDate;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = UITableViewAutomaticDimension;
  if ( [self indexPathHasPicker:indexPath]){
	height = 216.0;
  }
  else if ( [self indexPathHasTypePicker:indexPath]){
	height = 128;
  }
  return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger numRows = self.dataArray.count;
  if ([self hasInlineDatePicker])
  {
	// we have a date picker, so allow for it in the number of rows in this section
	
	++numRows;
  }
  if ([self hasInlineTypePicker])
  {
	// we have a type picker, so allow for it in the number of rows in this section
	++numRows;
  }
  
  return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  
  NSString *cellID = kTitleCellID;
  
  if (indexPath.row == kTypeRow)
  {
	// the indexPath is the one containing type
	cellID = kTypeCellID;
  }
  else if ([self indexPathHasTypePicker:indexPath])
  {
	cellID = kTypePickerCellID;
  }
  else if ([self indexPathHasPicker:indexPath])
  {
	// the indexPath is the one containing the inline date picker
	cellID = kDatePickerID;     // the current/opened date picker cell
  }
  else if ([self indexPathHasDate:indexPath])
  {
	// the indexPath is one that contains the date information
	cellID = kDateCellID;       // the start/end date cells
  }
  else if (indexPath.row == 4){ //?? might cause bug
	// the indexPath is the one containing type
	cellID = kLocationCellID;
  }
  
  cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  
  // if we have a date picker open whose cell is above the cell we want to update,
  // then we have one more cell than the model allows
  // for the data array
  NSInteger modelRow = indexPath.row;
  if ((self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
	  || (self.typePickerIndexPath != nil && self.typePickerIndexPath.row <= indexPath.row ))
  {
	modelRow--;
  }
  
  NSDictionary *itemData = self.dataArray[modelRow];
  
  // proceed to configure our cell
  if ([cellID isEqualToString:kDateCellID])
  {
	// we have either start or end date cells, populate their date field
	//
	cell.textLabel.text = [itemData valueForKey:kTitleKey];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
  }
  else if ([cellID isEqualToString:kLocationCellID])
  {
	// this cell is a non-date cell, just assign it's text label
	//
	cell.textLabel.text = [itemData valueForKey:kTitleKey];
	cell.detailTextLabel.text = self.eventLocation;
  }

  return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView beginUpdates];
  
  NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
  
  // check if 'indexPath' has an attached date picker below it
  if ([self hasPickerForIndexPath:indexPath])
  {
	// found a picker below it, so remove it
	[self.tableView deleteRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationFade];
  }
  else
  {
	// didn't find a picker below it, so we should insert it
	[self.tableView insertRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationFade];
  }
  
  [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // display the date picker inline with the table content
  [self.tableView beginUpdates];
  
  BOOL before = NO, before2 = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
  if ([self hasInlineDatePicker])
  {
	before = (self.datePickerIndexPath.row < indexPath.row);
  }
  if ([self hasInlineTypePicker]) {
	before2 = (self.typePickerIndexPath.row < indexPath.row);
  }
  
  BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
  
  // remove any date picker cell if it exists
  if ([self hasInlineDatePicker])
  {
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
						  withRowAnimation:UITableViewRowAnimationFade];
	self.datePickerIndexPath = nil;
  }
  if ([self hasInlineTypePicker])
  {
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.typePickerIndexPath.row inSection:0]]
						  withRowAnimation:UITableViewRowAnimationFade];
	self.typePickerIndexPath = nil;
  }
  
  
  if (!sameCellClicked)
  {
	// hide the old date picker and display the new one
	NSInteger rowToReveal = indexPath.row;
	if (before == YES) {
			rowToReveal--;
	}
	if (before2 == YES) {
			rowToReveal--;
	}
	NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
	
	[self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
	self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
  }
  
  // always deselect the row containing the start or end date
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self.tableView endUpdates];
  
  // inform our date picker of the current date to match the current cell
  [self updateDatePicker];
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  // when other cells are seleted, dimiss the keyboard and save the title
  if (cell.reuseIdentifier != kTitleCellID) {
	[self.view endEditing:YES];
	NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
	UITextField *textField = (UITextField *)[cell viewWithTag:kTitleTextFiledTag];
	[self textFieldShouldReturn:textField];
  }
  
  if (cell.reuseIdentifier == kDateCellID)
  {
	[self displayInlineDatePickerForRowAtIndexPath:indexPath];
  }
  else if (cell.reuseIdentifier == kTypeCellID)
  {
	[self displayInlineTypePickerForRowAtIndexPath:indexPath];
  }
  else
  {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
  NSIndexPath *targetedCellIndexPath = nil;
  
  
  // inline date picker: update the cell's date "above" the date picker cell
  //
  targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
  
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
  UIDatePicker *targetedDatePicker = sender;
  
  // update our data model
  NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
  [itemData setValue:targetedDatePicker.date forKey:kDateKey];
  
  // update the cell's date string
  cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
  
  // if this is the start time, change the end time accordingly
  if (self.datePickerIndexPath.row - 1 == kDateStartRow) {
	// save globally
	self.eventTime = targetedDatePicker.date;
	
	NSIndexPath *lowerCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row + 1 inSection:0];
	UITableViewCell *lowerCell = [self.tableView cellForRowAtIndexPath:lowerCellIndexPath];
	lowerCell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
	// update our data model
	NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row+1];
	[itemData setValue:targetedDatePicker.date forKey:kDateKey];
  }
  else {
	self.eventEndTime = targetedDatePicker.date;
  }
}

#pragma mark - TypePicker

// DataSource
/// Default number of components in picker veiw
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 3;
}

/// Dynamically determines the number of rows in one component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  if (self.TypePicker != nil) {
	return[self.TypePicker numberOfRowsInComponent: component];
  }
  GMEvetnTypePickerView *picker = [[GMEvetnTypePickerView alloc] init];
  return [picker numberOfRowsInComponent: component];
}

// Delegate


- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component{
  
  if ([self.TypePicker selectedRowInComponent:0] == 1) {
	// Study is selected
	if (component == 2) {
			// show another array of data
			return self.pickerDataArray[component+1][row];
	}
	return self.pickerDataArray[component][row];
  }
  else if ([self.TypePicker selectedRowInComponent:0] == 2)  {
	// hang out is selected
	return self.pickerDataArray[component][row];
  }
  return self.pickerDataArray[component][row];
}

/// @url http://blog.hawkimedia.com/2013/08/ios7-uipickerview-customization/
///
// ?? It's running more times than it needs, BUG risk
- (UIView *)pickerView:(UIPickerView *)pickerView
			viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component
		   reusingView:(UIView *)view {
  // update property
  self.TypePicker = (GMEvetnTypePickerView *)pickerView;
  
  UILabel* tView = (UILabel*)view;
  if (!tView){
	tView = [[UILabel alloc] init];
	// Setup label properties - frame, font, colors etc
	tView.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
	tView.textAlignment = NSTextAlignmentCenter;
  }
  
  if ([self.TypePicker selectedRowInComponent:0] == 1) {
	// Study is selected
	if (component == 2) {
			// show another array of data
			tView.text = self.pickerDataArray[component+1][row];
			CGFloat hue = (CGFloat) row / 10.0;
			tView.textColor = [[UIColor alloc] initWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
			return tView;
	}
	CGFloat hue = (CGFloat) row / 2.0;
	tView.textColor = [[UIColor alloc] initWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
	tView.text =  self.pickerDataArray[component][row];
	return tView;
  }
  else if ([self.TypePicker selectedRowInComponent:0] == 2)  {
	// hang out is selected
	CGFloat hue = (CGFloat) row / 3.0;
	tView.textColor = [[UIColor alloc] initWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
	tView.text = self.pickerDataArray[component][row];
	return tView;
  }
  CGFloat hue = (CGFloat) row / 4.0;
  tView.textColor = [[UIColor alloc] initWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
  tView.text = self.pickerDataArray[component][row];
  
  return tView;
}


/// Updates picker view's dimention
- (void)pickerView:(UIPickerView *)pickerView
	  didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component{
  // update picker dimension
  [self.TypePicker selectRow:row inComponent:component animated: YES ];
  
  // update data
  //
  [self updateType];
}


#pragma mark Utilities for typePicker

/*! Determines if the given indexPath has a cell below it with a GMEvetnTypePickerView.
 
 @param indexPath The indexPath to check if its cell has a GMEvetnTypePickerView below it.
 */
- (BOOL)hasTypePickerForIndexPath:(NSIndexPath *)indexPath
{
  BOOL hasTypePicker = NO;
  
  NSInteger targetedRow = indexPath.row;
  targetedRow++;
  
  UITableViewCell *checkTypePickerCell =
  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
  GMEvetnTypePickerView *checkTypePicker = (GMEvetnTypePickerView *)[checkTypePickerCell viewWithTag:kTypePickerTag];
  
  hasTypePicker = (checkTypePicker != nil);
  return hasTypePicker;
}

/*! Updates the self.TypePicker to point to the newset typePicker.
 */
- (void)updateType
{
  // update data
  //
  NSIndexPath *targetedCellIndexPath = nil;
  targetedCellIndexPath = [NSIndexPath indexPathForRow:self.typePickerIndexPath.row - 1 inSection:0];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
  
  // update the cell's date string
  //
  NSString *form = ((UILabel*)[self.TypePicker viewForRow: [self.TypePicker selectedRowInComponent:0] forComponent:0]).text;
  NSString *participant = ((UILabel*)[self.TypePicker viewForRow: [self.TypePicker selectedRowInComponent:1] forComponent:1]).text;
  NSString *other = ((UILabel*)[self.TypePicker viewForRow: [self.TypePicker selectedRowInComponent:2] forComponent:2]).text;
  NSString *connect = @"with", *comma = @",";
  NSArray *string = [NSArray arrayWithObjects:form, connect, participant, comma, other, nil];
  cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
  cell.detailTextLabel.text = [string componentsJoinedByString:@" "];
  self.eventType = [string componentsJoinedByString:@" "];
}

/*! Determines if the UITableViewController has a GMEvetnTypePickerView in any of its cells.
 */
- (BOOL)hasInlineTypePicker
{
  return (self.typePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the GMEvetnTypePickerView.
 
 @param indexPath The indexPath to check if it represents a cell with the GMEvetnTypePickerView.
 */
- (BOOL)indexPathHasTypePicker:(NSIndexPath *)indexPath
{
  return ([self hasInlineTypePicker] && self.typePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the types.
 
 @param indexPath The indexPath to check if it represents type cell.
 */
- (BOOL)indexPathHasType:(NSIndexPath *)indexPath
{
  BOOL hasType = NO;
  
  if (indexPath.row == kTypeRow)
  {
	hasType = YES;
  }
  
  return hasType;
}


/*! Adds or removes a GMEvetnTypePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the GMEvetnTypePicker.
 */
- (void)toggleTypePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView beginUpdates];
  
  NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
  
  // check if 'indexPath' has an attached Type picker below it
  if ([self hasPickerForIndexPath:indexPath])
  {
	// found a picker below it, so remove it
	[self.tableView deleteRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationFade];
  }
  else
  {
	// didn't find a picker below it, so we should insert it
	[self.tableView insertRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationFade];
  }
  
  [self.tableView endUpdates];
}

/*! Reveals the Type picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the GMEvetnTypePicker.
 */
- (void)displayInlineTypePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // display the type picker inline with the table content
  [self.tableView beginUpdates];
  
  
  BOOL sameCellClicked = (self.typePickerIndexPath.row - 1 == indexPath.row);
  
  // remove any Type picker cell if it exists
  if ([self hasInlineTypePicker])
  {
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.typePickerIndexPath.row inSection:0]]
						  withRowAnimation:UITableViewRowAnimationFade];
	self.typePickerIndexPath = nil;
  }
  if ([self hasInlineDatePicker])
  {
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
						  withRowAnimation:UITableViewRowAnimationFade];
	self.datePickerIndexPath = nil;
  }
  
  if (!sameCellClicked)
  {
	[self toggleTypePickerForSelectedIndexPath:indexPath];
	self.typePickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
  }
  
  // always deselect the row containing the Type
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self.tableView endUpdates];
  
  // inform our Type picker of the current Type to match the current cell
  [self updateType];
}

#pragma mark - Dismiss keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  self.eventTitle = textField.text;
  return YES;
}

#pragma mark - Post Button
/** Post an event created by user
 * Checks if all the fiedls are filled
 *
 * - Yes, saves in Parse; starts activity indicator; 
 *
 * - No, shows an alert window and tells user to fix the problem
 */
- (IBAction)postEvent:(UIBarButtonItem *)sender {
  PFObject *event = [PFObject objectWithClassName:@"eventDemo"];
  // Check all the required fiedls
  if (self.eventTitle != nil  && self.eventType != nil
	  && self.eventTime != nil && self.eventLocation != nil) {
	event[@"description"] = self.eventTitle;
	event[@"plannedTime"] = self.eventTime;
	if ( self.eventEndTime != nil) event[@"endTime"] = self.eventEndTime;
	event[@"type"] = self.eventType;
	event[@"location"] = self.eventLocation;
	event[@"coordinates"] = [PFGeoPoint geoPointWithLocation:self.locationCoor];
	[event setObject:[PFUser currentUser] forKey:@"host"];
	
	GMActivityView *activityView = [[GMActivityView alloc] initWithFrame:self.view.bounds];
	activityView.label.text = @"Posting your event...\nIf you have time to read this, it means your Internet connection is not good";
	activityView.label.font = [UIFont boldSystemFontOfSize:20.f];
	[activityView.activityIndicator startAnimating];
	[self.view addSubview:activityView];
	
	
	[event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (error) { // Failed to save, show an alert view with the error message
			  UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error"
																 message:@"Internet connection appears to be offline.\nPlease try again later"
																delegate:self
													   cancelButtonTitle:nil
													   otherButtonTitles:@"Ok", nil];
			  [activityView removeFromSuperview];
			  [activityView.activityIndicator stopAnimating];
			  [alertView show];
			  return;
			}
			if (succeeded) {
			  // Send notification to all relative view controllers
			  dispatch_async(dispatch_get_main_queue(),
							 ^{[[NSNotificationCenter defaultCenter] postNotificationName:GMPostEventNotification
																				   object:nil];
							 });
			  [activityView.activityIndicator stopAnimating];
			  [activityView removeFromSuperview];
			  [self performSegueWithIdentifier:@"unwindToHome" sender:@"post"];
			}
			else {
			  NSLog(@"Failed to save.");
			  [activityView.activityIndicator stopAnimating];
			}
	}];
	
  }
  else {
	NSString *error = @"Not all required fileds are filled.\nPlease fill out all fields.";
	// Show the errorString somewhere and let the user try again.
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:error preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* fixItAction = [UIAlertAction actionWithTitle:@"I'll fix it"
														  style:UIAlertActionStyleDefault
														handler:^(UIAlertAction * action) {}];
	[alert addAction:fixItAction];
	[self presentViewController:alert animated:YES completion:nil];
  }
}

@end