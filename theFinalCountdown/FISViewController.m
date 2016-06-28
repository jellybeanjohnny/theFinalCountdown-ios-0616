//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;


@property (strong, nonatomic) NSTimer *countdownTimer;
@property (nonatomic) NSTimeInterval remainingSeconds;

@end

@implementation FISViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.countdownLabel.hidden = YES;
}

- (IBAction)_startButtonTapped:(id)sender
{
	NSLog(@"Start button tapped");
	[self _toggleStartCancelButtons];
	
	self.pauseButton.enabled = YES;
	self.countdownLabel.hidden = NO;
	self.datePicker.hidden = YES;
	self.remainingSeconds = self.datePicker.countDownDuration;
	[self _updateTimeLabel];
	self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_updateTimeLabel) userInfo:nil repeats:YES];
}

- (IBAction)_pauseButtonTapped:(id)sender
{
	NSLog(@"Pause button tapped");
	[self _togglePauseResumeButtons];
	[self.countdownTimer invalidate];
}

- (IBAction)_cancelButtonTapped:(id)sender
{
	NSLog(@"Cancel button tapped");
	[self _toggleStartCancelButtons];
	[self.countdownTimer invalidate];
	self.countdownLabel.hidden = YES;
	self.datePicker.hidden = NO;
	self.pauseButton.enabled = NO;
	self.pauseButton.hidden = NO;
	self.resumeButton.hidden = YES;
	self.resumeButton.enabled = NO;
	
}

- (IBAction)resume:(id)sender
{
	[self _togglePauseResumeButtons];
	self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_updateTimeLabel) userInfo:nil repeats:YES];
}

- (void)_updateTimeLabel
{
	
	// parse remaining seconds into hours minutes and seconds
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.second = self.remainingSeconds;
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	
	NSDate *date = [calendar dateFromComponents:dateComponents];
	
	NSDateComponents *resultComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
	
	NSString *hours = resultComponents.hour < 10? [NSString stringWithFormat:@"0%li", resultComponents.hour] : [NSString stringWithFormat:@"%ld", resultComponents.hour];
	NSString *minutes = resultComponents.minute < 10? [NSString stringWithFormat:@"0%li", resultComponents.minute] : [NSString stringWithFormat:@"%ld", resultComponents.minute];
	NSString *seconds = resultComponents.second < 10? [NSString stringWithFormat:@"0%li", resultComponents.second] : [NSString stringWithFormat:@"%ld", resultComponents.second];
	
	
	self.countdownLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
	
	if (self.remainingSeconds == 0) {
		[self.countdownTimer invalidate];
	}
	self.remainingSeconds--;
}

- (void)_toggleStartCancelButtons
{
	self.startButton.hidden = !self.startButton.hidden;
	self.startButton.enabled = !self.startButton.enabled;
	
	self.cancelButton.hidden = !self.cancelButton.hidden;
	self.cancelButton.enabled = !self.cancelButton.enabled;
}

- (void)_togglePauseResumeButtons
{
	self.pauseButton.hidden = !self.pauseButton.hidden;
	self.pauseButton.enabled = !self.pauseButton.enabled;
	
	self.resumeButton.hidden = !self.resumeButton.hidden;
	self.resumeButton.enabled = !self.resumeButton.enabled;
	
}



@end
