//
//  SearchPlaceController.m
//  PlatiDo
//
//  Created by Valera Voroshilov on 19.08.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//


#import "SearchPlaceController.h"
#import "RegistarationAPI.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>


@interface SearchPlaceController ()

@property (nonatomic, weak)   IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak)   IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *placePredictions;
@property (nonatomic, strong) NSTimer *searchPredictionsPlacesTimer;
@property (nonatomic, assign) BOOL isPredictionRequest;
@property (nonatomic, strong) MBProgressHUD *progressIndicator;

@end


@implementation SearchPlaceController

#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // progressIndicator.indicatorColor = [UIColor colorWithHex:0xffc966];
    [self.view addSubview:self.progressIndicator];
    [self.progressIndicator hide:NO];
    
    self.searchBar.showsCancelButton = YES;
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
}



#pragma mark main marker



#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placePredictions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSDictionary* predictionUncknown = (NSDictionary*) self.placePredictions[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[predictionUncknown valueForKey:@"typeShort"], [predictionUncknown valueForKey:@"name"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _searchBar.text = cell.textLabel.text;
  
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self hideMe];
}



#pragma mark - User Location Manager


- (void)passRequestSearchPredictionsFor:(NSString*)searchText{

    [self.tableView reloadData];
    [self.progressIndicator show:YES];
    self.isPredictionRequest = YES;
    
    
    [RegistarationAPI getStreetsAutoComplete:searchText ComBlock:^(NSArray *objects, NSError *error) {
        [self.progressIndicator hide:NO];
        self.isPredictionRequest = NO;
        self.placePredictions = objects;
        [self.tableView reloadData];
    }];
}

- (void)passTimerRequestSearchPredictions:(NSTimer *)timer{
    if (self.isPredictionRequest ) return;
    NSString *searchText = timer.userInfo [@"textSearch"];
    [timer invalidate];
    [self passRequestSearchPredictionsFor:searchText];
}

- (void)searchPredictionErrorHandler{

}

- (void)hideMe{
    [self dismissViewControllerAnimated:YES completion:^{
         NSString *result = _searchBar.text ;
        _searchBar.text = @"";
        self.complitationBlock(result);
    }];
}

#pragma mark - search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self hideMe];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchPredictionsPlacesTimer invalidate];
    
    if (nil == searchText || ([searchText length]<3)) {
        self.placePredictions = nil;
        [self.tableView reloadData];
        return;
    }
    
    self.searchPredictionsPlacesTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(passTimerRequestSearchPredictions:) userInfo:@{@"textSearch":searchText} repeats:NO];
}


- (void)hideSearchResults{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.placePredictions = nil;
}



@end
