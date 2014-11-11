#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"

#import "RSZNotification.h"
#import "RSZPresenter.h"

#import "RSZNotification+RSZSpecAccessors.h"
#import "UIView+RSZAssociatedViewFactory.h"

SpecBegin(RSZNotificationSpec)

describe(@"RSZNotification", ^{
    __block RSZNotification *notification;
    __block UIView *associatedView;
    __block RSZNotification *blockArgumentNotification;
    __block BOOL blockInvoked;

    beforeAll(^{
        associatedView = [UIView associatedView];
        notification = [RSZNotification notificationWithAssociatedView:associatedView onTapBlock:^(RSZNotification *notification) {
            blockArgumentNotification = notification;
            blockInvoked = YES;
        }];
    });

    afterAll(^{
        associatedView = nil;
        notification = nil;
    });

    describe(@"after initialization", ^{
        it(@"should have associated view", ^{
            expect(notification.associatedView).to.equal(associatedView);
        });

        it(@"should have onTapBlock", ^{
            expect([notification valueForKeyPath:@"onTapBlock"]).notTo.beNil();
        });
    });

    describe(@"after presenting", ^{

        beforeEach(^{
            [RSZPresenter presentNotification:notification];
            [Expecta setAsynchronousTestTimeout:2];
        });

        it(@"should being presented", ^{
            expect(notification.isBeingPresented).will.equal(YES);
        });

        describe(@"and being tapped", ^{
            beforeAll(^{
                [notification associatedViewTapped:nil];
            });

            it(@"onTapBlock should be invoked", ^{
                expect(blockInvoked).to.equal(YES);
            });

            it(@"correct notification should be passed to onTapBlock", ^{
                expect(blockArgumentNotification).to.equal(notification);
            });
        });
    });
});

SpecEnd