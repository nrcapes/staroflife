//
//
//

#import <UIKit/UIKit.h>

@class NRCPasscodeViewController;

@protocol NRCPasscodeViewControllerDelegate <NSObject>

- (void)passcodeController:(NRCPasscodeViewController *)controller passcodeEntered:(NSString *)passCode;

@end

typedef enum {
    NRCPasscodeAnimationStyleNone,
    NRCPasscodeAnimationStyleInvalid,
    NRCPasscodeAnimationStyleConfirm
} NRCPasscodeAnimationStyle;

@interface NRCPasscodeViewController : UIViewController <UITextFieldDelegate> {
    
    
    IBOutlet UIView *animationView;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *instructionLabel;
    
    IBOutlet UITextField *bulletField0;
    IBOutlet UITextField *bulletField1;
    IBOutlet UITextField *bulletField2;
    IBOutlet UITextField *bulletField3;
 
    UITextField *fakeField;
}

@property (nonatomic, assign) id <NRCPasscodeViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIView *animationView;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *instructionLabel;

@property (nonatomic, retain) IBOutlet UITextField *bulletField0;
@property (nonatomic, retain) IBOutlet UITextField *bulletField1;
@property (nonatomic, retain) IBOutlet UITextField *bulletField2;
@property (nonatomic, retain) IBOutlet UITextField *bulletField3;

- (void)resetWithAnimation:(NRCPasscodeAnimationStyle)animationStyle;

@end
