//
//  patientItem.h
//  EMSTimers
//
//  Created by Nelson Capes on 1/18/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface patientItem : NSObject
@property NSString *firstName;
@property NSString *middleName;
@property NSString *lastName;
@property NSString *fullName;
@property NSString *dateOfBirth;
@property NSString *gender;
@property NSString *streetAddress;
@property NSString *streetAddress2;
@property NSString *cityAddress;
@property NSString *stateAddress;
@property NSString *zipCode;
@property NSString *phoneNumber;
@property NSDate *contactTime;
@property NSString *venue;
@property NSString *event;
@property NSString *chiefComplaint;
@property NSString *clinicalImpression;
@property NSString *medicalHistory;
@property NSString  *currentMedications;
@property NSString *allergies;
@property NSString *mechanismOfInjury;
@property NSString *treatments;
@property NSMutableArray *assessments;
@property (nonatomic) NSString *narrative;
@property NSString *providerID;
@property (nonatomic, copy) NSString *itemKey;

@end
