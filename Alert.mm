#import <UIKit/UIKit.h>

// --- PHẦN 1: Định nghĩa hàm Hacker Text trước ---
// (Đặt ở trên để đoạn code bên dưới có thể gọi được)

void showHackerText() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        // Logic tìm Window an toàn cho các iOS đời mới (13+)
        if (!window) {
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }

        if (!window) return;

        // Tạo Label
        UILabel *hackerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        hackerLabel.center = window.center;
        hackerLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85]; // Đen mờ
        hackerLabel.textColor = [UIColor greenColor]; // Xanh Hacker
        hackerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16]; // Font máy đánh chữ
        hackerLabel.textAlignment = NSTextAlignmentCenter;
        hackerLabel.layer.cornerRadius = 10;
        hackerLabel.layer.borderColor = [UIColor greenColor].CGColor;
        hackerLabel.layer.borderWidth = 1.0;
        hackerLabel.clipsToBounds = YES;
        hackerLabel.text = @"";
        hackerLabel.alpha = 0;
        
        [window addSubview:hackerLabel];

        // Hiệu ứng hiện dần
        [UIView animateWithDuration:0.2 animations:^{
            hackerLabel.alpha = 1;
        }];

        // Logic gõ chữ
        NSString *message = @"Làm bởi Khổng Mạnh Yên 🪽";
        NSTimeInterval typingSpeed = 0.05;

        for (NSInteger i = 0; i < message.length; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * typingSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hackerLabel.text = [message substringToIndex:i + 1];
            });
        }

        // Tự động biến mất sau khi gõ xong + 2 giây
        NSTimeInterval totalDelay = (message.length * typingSpeed) + 2.0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(totalDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                hackerLabel.alpha = 0;
                hackerLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                [hackerLabel removeFromSuperview];
            }];
        });
    });
}

// --- PHẦN 2: Constructor hiển thị Alert ---

__attribute__((constructor))
static void showAlertAfterLaunch() {
    // Đợi 3 giây sau khi app launch
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Lấy Root View Controller để hiển thị Alert
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!rootVC) {
             // Thử tìm lại lần nữa nếu chưa có rootVC (đề phòng crash)
             for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    rootVC = ((UIWindowScene *)scene).windows.firstObject.rootViewController;
                    if (rootVC) break;
                }
            }
        }
        
        if (!rootVC) return; // Nếu vẫn không tìm thấy thì bỏ qua để tránh crash

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Khổng Mạnh Yên👑"
                                                                       message:@"Inbox thì cứ thêm vài từ *Mình sẽ trả phí* là được 😆"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // --- Nút Đóng: Đã sửa handler để gọi hàm showHackerText ---
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Đóng"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       // GỌI HÀM Ở ĐÂY
                                                       showHackerText();
                                                   }];
                                                   
        [ok setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alert addAction:ok];

        // Nút Website
        UIAlertAction *openLink = [UIAlertAction actionWithTitle:@"Website"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"https://beacons.ai/o.oyen"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }];
        [openLink setValue:[UIColor systemPinkColor] forKey:@"titleTextColor"];
        [alert addAction:openLink];

        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}

