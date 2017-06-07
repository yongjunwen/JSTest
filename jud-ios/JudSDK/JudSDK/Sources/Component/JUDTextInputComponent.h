/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"
#import "JUDTextComponentProtocol.h"
#import "JUDDatePickerManager.h"

@interface JUDTextInputComponent : JUDComponent<JUDTextComponentProtocol, UITextFieldDelegate,JUDDatePickerManagerDelegate>

@end
