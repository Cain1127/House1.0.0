
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

///
extern NSString *kReachabilityChangedNotification;

/**
 *  @author yangshengmeng, 15-01-19 10:01:39
 *
 *  @brief  判断当前网络是否可用，返回当前的网络类型
 *
 *  @since  1.0.0
 */
@interface QSNetworkingStatus : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

/*!
 * Checks whether a local WiFi connection is available.
 */
+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

/**
 *  @author yangshengmeng, 15-01-20 10:01:30
 *
 *  @brief  返回当前网络类型
 *
 *  @return 返回当前网络类型
 *
 *  @since  1.0.0
 */
- (NETWORK_STATUS)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end


