//
//  MasterViewController.m
//  Hackathon
//
//  Created by Andrew Kozlik on 3/28/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RWItem.h"
#import "CardCellCollectionViewCell.h"

#define BEACON_UUID @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"

#define LIMIT_FAR       -65 // you might want to change these RSSI values
#define LIMIT_NEAR      -55
#define LIMIT_IMMEDIATE -35


@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header-logo"] forBarMetrics:UIBarMetricsDefault];

    
    cards = [[NSMutableArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    pixmob = [[PIXConnectController alloc] initWithEffect:PIXConnectControlEffectPulseClose];
//    [pixmob setTargetTeam:18];

    self.proximityKitManager = [RPKManager managerWithDelegate:self];
    [self.proximityKitManager start];
    
    [pixmob clearAllDevicesInRange];
    [pixmob startScanningForAllDevicesInRange];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    
    NSUUID *dumbledoreUUID = [[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"];
    
    RWTItem *newItem2 = [[RWTItem alloc] initWithName:@"RadBeacon USB Green"
                                                uuid:uuid
                                               major:169
                                               minor:1];
    
    
    RWTItem *newItem = [[RWTItem alloc] initWithName:@"RadBeacon USB Red"
                                                uuid:uuid
                                               major:69
                                               minor:1];
    
    RWTItem *newItem3 = [[RWTItem alloc] initWithName:@"Dumbledore" uuid:dumbledoreUUID major:1 minor:1];

    [self startMonitoringItem:newItem3];
    [self startMonitoringItem:newItem2];
    [self startMonitoringItem:newItem];

    [self loadCards];
}

-(void)loadCards {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"Cards" ofType:@"plist"];
    
    NSLog(@"%@", plistPath);
    NSMutableArray *cardsData = [[NSMutableArray alloc] init];
    cardsData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSLog(@"Card Data: %@", cardsData);
}

-(void)proximityKit:(RPKManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(RPKBeaconRegion *)region {
    NSLog(@"Ranged Beacons: %@", beacons);
}

-(void)proximityKit:(RPKManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed: %@", error.localizedDescription);
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

#pragma mark - UICollectionView methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CardCellCollectionViewCell *cell = (CardCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    
    NSArray *images = @[@"BloodyMary", @"unredeemed-card", @"LadyLuck", @"unredeemed-card", @"JackTheClown", @"unredeemed-card", @"TheCake", @"unredeemed-card", @"TheDirector"];
    
    cell.cardImageView.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"CardDetailSegue" sender:self];
}

#pragma mark - Core Location
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered Region: %@", region);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        if (beacon.major.integerValue == 69) {
            [pixmob setColor:[UIColor redColor]];
            [pixmob setEffect:PIXConnectControlEffectPulseClose];
        } else if (beacon.major.integerValue == 169 || beacon.major.integerValue == 1) {
            [pixmob setColor:[UIColor greenColor]];
            [pixmob setEffect:PIXConnectControlEffectSolid];
        }
    }
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [pixmob startBroadcasting];
    NSLog(@"Broadcasting started");
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
//    [pixmob stopBroadcasting];
    NSLog(@"Stop Broadcasting");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions
-(IBAction)buttonTapped:(id)sender {

    [pixmob setColor:[UIColor redColor]];
}

-(IBAction)turnOffTapped:(id)sender {
    [pixmob setColor:[UIColor clearColor]];
}

-(IBAction)scanDevices:(id)sender {
//    [pixmob clearAllDevicesInRange];
//    [pixmob startScanningForAllDevicesInRange];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showDevices) userInfo:nil repeats:YES];
}

-(void)showDevices {
    NSLog(@"Scanning for devices");
    NSLog(@"%@", [pixmob getAllDevicesInRange]);
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
