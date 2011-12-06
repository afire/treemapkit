#import "TreemapView.h"
#import "TreemapViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TreemapViewCell

@synthesize valueLabel = _valueLabel;
@synthesize textLabel = _textLabel;
@synthesize index;
@synthesize delegate;

#pragma mark -

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 4, 20)];
        _textLabel.font = [UIFont boldSystemFontOfSize:20];
        _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_textLabel];

        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 4, 20)];
        _valueLabel.font = [UIFont boldSystemFontOfSize:20];
        _valueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _valueLabel.textAlignment = UITextAlignmentCenter;
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_valueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(0, self.frame.size.height / 2 - 10, self.frame.size.width, 20);
    self.valueLabel.frame = CGRectMake(0, self.frame.size.height / 2 + 10, self.frame.size.width, 20);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (delegate && [delegate respondsToSelector:@selector(treemapViewCell:tapped:)]) {
        [delegate treemapViewCell:self tapped:index];
    }
}

- (void)dealloc {
    [_valueLabel release];
    [_textLabel release];
    [delegate release];

    [super dealloc];
}

@end
