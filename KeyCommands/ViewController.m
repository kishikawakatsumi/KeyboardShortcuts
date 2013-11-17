//
//  ViewController.m
//  KeyCommands
//
//  Created by kishikawa katsumi on 2013/11/16.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSArray *commands;

@property (nonatomic, weak) IBOutlet UIView *inputHUD;
@property (nonatomic, weak) IBOutlet UILabel *inputLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inputHUD.alpha = 0.0f;
    self.inputHUD.layer.cornerRadius = 12.0f;
    
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    NSString *characters = @"`1234567890-=qwertyuiop[]asdfghjkl;'zxcvbnm,./";
    for (NSInteger i = 0; i < characters.length; i++) {
        NSString *input = [characters substringWithRange:NSMakeRange(i, 1)];
        
        /* Caps Lock */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierAlphaShift action:@selector(handleCommand:)]];
        /* Shift */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierShift action:@selector(handleCommand:)]];
        /* Control */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierControl action:@selector(handleCommand:)]];
        /* Option */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierAlternate action:@selector(handleCommand:)]];
        /* Command */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierCommand action:@selector(handleCommand:)]];
        /* Control + Option */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierControl | UIKeyModifierAlternate action:@selector(handleCommand:)]];
        /* Control + Command */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierControl | UIKeyModifierCommand action:@selector(handleCommand:)]];
        /* Option + Command */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierAlternate | UIKeyModifierCommand action:@selector(handleCommand:)]];
        /* Control + Option + Command */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:UIKeyModifierControl | UIKeyModifierAlternate | UIKeyModifierCommand action:@selector(handleCommand:)]];
        /* No modifier */
        [commands addObject:[UIKeyCommand keyCommandWithInput:input modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    }
    /* Delete */
    [commands addObject:[UIKeyCommand keyCommandWithInput:@"\b" modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    /* Tab */
    [commands addObject:[UIKeyCommand keyCommandWithInput:@"\t" modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    /* Enter */
    [commands addObject:[UIKeyCommand keyCommandWithInput:@"\r" modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    
    /* Up */
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    /* Down */
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    /* Left */
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    /* Right */
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    /* Esc */
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputEscape modifierFlags:kNilOptions action:@selector(handleCommand:)]];
    
    self.commands = commands.copy;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (NSArray *)keyCommands
{
    return self.commands;
}

- (void)handleCommand:(UIKeyCommand *)command
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHUD) object:nil];
    [self displayHUD];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1.0];
    
    UIKeyModifierFlags modifierFlags = command.modifierFlags;
    NSString *input = command.input;
    
    NSMutableString *modifierSymbols = [[NSMutableString alloc] init];
    NSMutableString *inputCharacters = [[NSMutableString alloc] init];
    
    if ((modifierFlags & UIKeyModifierAlphaShift) == UIKeyModifierAlphaShift) {
        [modifierSymbols appendString:@"⇪"];
    }
    if ((modifierFlags & UIKeyModifierShift) == UIKeyModifierShift) {
        [modifierSymbols appendString:@"SHIFT"];
    }
    if ((modifierFlags & UIKeyModifierControl) == UIKeyModifierControl) {
        [modifierSymbols appendString:@"CTRL"];
    }
    if ((modifierFlags & UIKeyModifierAlternate) == UIKeyModifierAlternate) {
        [modifierSymbols appendString:@"⌥"];
    }
    if ((modifierFlags & UIKeyModifierCommand) == UIKeyModifierCommand) {
        [modifierSymbols appendString:@"⌘"];
    }
    
    if ([input isEqualToString:@"\b"]) {
        [inputCharacters appendFormat:@"%@", @"DEL"];
    }
    if ([input isEqualToString:@"\t"]) {
        [inputCharacters appendFormat:@"%@", @"TAB"];
    }
    if ([input isEqualToString:@"\r"]) {
        [inputCharacters appendFormat:@"%@", @"ENTER"];
    }
    if (input == UIKeyInputUpArrow) {
        [inputCharacters appendFormat:@"%@", @"↑"];
    }
    if (input == UIKeyInputDownArrow) {
        [inputCharacters appendFormat:@"%@", @"↓"];
    }
    if (input == UIKeyInputLeftArrow) {
        [inputCharacters appendFormat:@"%@", @"←"];
    }
    if (input == UIKeyInputRightArrow) {
        [inputCharacters appendFormat:@"%@", @"→"];
    }
    if (input == UIKeyInputEscape) {
        [inputCharacters appendFormat:@"%@", @"ESC"];
    }
    
    if (input.length > 0 && inputCharacters.length == 0) {
        [inputCharacters appendFormat:@"%@", input.uppercaseString];
    }
    
    if (modifierSymbols.length > 0) {
        self.inputLabel.text = [NSString stringWithFormat:@"%@ + %@", modifierSymbols, inputCharacters];
    } else {
        self.inputLabel.text = [NSString stringWithFormat:@"%@", inputCharacters];
    }
}

- (void)displayHUD
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputHUD.alpha = 1.0f;
    } completion:NULL];
}

- (void)hideHUD
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputHUD.alpha = 0.0f;
    } completion:NULL];
}

@end
