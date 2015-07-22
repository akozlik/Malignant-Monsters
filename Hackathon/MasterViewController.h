//
//  MasterViewController.h
//  Hackathon
//
//  Created by Andrew Kozlik on 3/28/15.
//  Copyright (c) 2015 Andrew Kozlik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PixmobConnect-Public/PIXConnectController.h"
#import "PixmobConnect-Public/PIXConnectControlParameters.h"
#import <ProximityKit/ProximityKit.h>

@import CoreLocation;

@interface MasterViewController : UIViewController <CLLocationManagerDelegate, RPKManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    PIXConnectController * pixmob;
    IBOutlet UIButton *button;
    NSMutableArray *cards;
}

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) RPKManager *proximityKitManager;

@property IBOutlet UICollectionView *collectionView;


-(IBAction)buttonTapped:(id)sender;
-(IBAction)turnOffTapped:(id)sender;

@end

