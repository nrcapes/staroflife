//
//  patientItem.m
//  EMSTimers
//
//  Created by Nelson Capes on 1/18/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This class's encodeWithCoder method is called when the application enters background and archives the patient bibliographic data and the patient's assessments.  The classes initWithCoder method is called when the application becomes active and unarchives the patient bibliographic data and assessments.
#import "patientItem.h"

@implementation patientItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _firstName = [aDecoder decodeObjectForKey:@"firstName"];
        _middleName = [aDecoder decodeObjectForKey:@"middleName"];
        _lastName = [aDecoder decodeObjectForKey:@"lastName"];
        _fullName = [aDecoder decodeObjectForKey:@"fullName"];
        _dateOfBirth = [aDecoder decodeObjectForKey:@"dateOfBirth"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _streetAddress = [aDecoder decodeObjectForKey:@"streetAddress"];
        _streetAddress2 = [aDecoder decodeObjectForKey:@"streetAddress2"];
        _cityAddress = [aDecoder decodeObjectForKey:@"cityAddress"];
        _stateAddress = [aDecoder decodeObjectForKey:@"stateAddress"];
        _zipCode = [aDecoder decodeObjectForKey:@"zipCode"];
        _phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        _venue = [aDecoder decodeObjectForKey:@"venue"];
        _event = [aDecoder decodeObjectForKey:@"event"];
        _contactTime = [aDecoder decodeObjectForKey:@"contactTime"];
        _assessments = [aDecoder decodeObjectForKey:@"assessments"];
        _narrative = [aDecoder decodeObjectForKey:@"narrative"];
        _providerID = [aDecoder decodeObjectForKey:@"providerID"];
        if(!_itemKey){
            NSUUID *uuid = [[NSUUID alloc]init];
            NSString *key = [uuid UUIDString];
            _itemKey = key;}
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.middleName forKey:@"middleName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.dateOfBirth forKey:@"dateOfBirth"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.streetAddress forKey:@"streetAddress"];
    [aCoder encodeObject:self.streetAddress2 forKey:@"streetAddress2"];
    [aCoder encodeObject:self.cityAddress forKey:@"cityAddress"];
    [aCoder encodeObject:self.stateAddress forKey:@"stateAddress"];
    [aCoder encodeObject:self.zipCode forKey:@"zipCode"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.venue forKey:@"venue"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:self.contactTime forKey:@"contactTime"];
    [aCoder encodeObject:self.assessments forKey:@"assessments"];
    [aCoder encodeObject:self.narrative forKey:@"narrative"];
    [aCoder encodeObject:self.providerID forKey:@"providerID"];
}


@end
