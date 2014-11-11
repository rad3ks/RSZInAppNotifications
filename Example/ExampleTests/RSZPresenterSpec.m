#import "Specta.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "RSZNotification.h"
#import "RSZPresenter.h"

#import "RSZPresenter+RSZSpecAccessors.h"
#import "UIView+RSZAssociatedViewFactory.h"

SpecBegin(RSZPresenterSpec)

describe(@"RSZPresenter", ^{
    __block UIWindow *window;

    beforeEach(^{
        window = mock([UIWindow class]);
        [RSZPresenter setPresentingWindow:window];
    });

    afterEach(^{
        window = nil;
    });

    describe(@"after setting window", ^{
        it(@"should have window", ^{
            expect([RSZPresenter window]).to.equal(window);
        });

        it(@"should have queue", ^{
            expect([RSZPresenter notificationQueue]).notTo.beNil();
        });

        describe(@"and presenting notification", ^{
            __block RSZNotification *notification;
            __block UIView *collisionBoundsView;
            __block UIDynamicAnimator *animator;

            beforeAll(^{
                notification = mock([RSZNotification class]);
                [given(notification.associatedView) willReturn:[UIView associatedView]];

                [RSZPresenter presentNotification:notification];

                collisionBoundsView = [RSZPresenter collisionBoundsView];
                animator = [RSZPresenter animator];
            });

            afterAll(^{
                notification = nil;
                collisionBoundsView = nil;
                animator = nil;
            });

            it(@"should have not nil animator", ^{
                expect([RSZPresenter animator]).willNot.beNil();
            });

            it(@"should have not nil collision bounds view", ^{
                expect(collisionBoundsView).willNot.beNil();
            });

            it(@"collision bounds view should be in view hierarchy", ^{
                expect(collisionBoundsView.superview).willNot.beNil();
            });

            describe(@"then hiding it", ^{
                beforeAll(^{
                    [Expecta setAsynchronousTestTimeout:5];
                });

                it(@"should have nil animator", ^{
                    expect(animator).will.beNil();
                });

                it(@"collision bounds view should not be in view hierarchy after 5 seconds", ^{
                    expect([RSZPresenter collisionBoundsView].superview).will.beNil();
                });
            });
        });
    });
});

SpecEnd