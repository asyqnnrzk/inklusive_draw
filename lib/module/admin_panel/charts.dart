import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, int>> fetchCounts() async {
  try {
    final resourcesCountSnapshot = await FirebaseFirestore.instance
        .collection('resources')
        .get();
    final communitiesCountSnapshot = await FirebaseFirestore.instance
        .collection('communities')
        .get();

    final resourcesCount = resourcesCountSnapshot.size;
    final communitiesCount = communitiesCountSnapshot.size;

    return {
      'resources': resourcesCount,
      'communities': communitiesCount,
    };
  } catch (e) {
    print('Error fetching counts: $e');
    return {'resources': 0, 'communities': 0};
  }
}

Future<Map<DateTime, int>> fetchUserGrowthData() async {
  try {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    // Map to store the cumulative number of users per month
    Map<DateTime, int> monthlyUserCount = {};

    for (var user in usersSnapshot.docs) {
      Timestamp signUpTimestamp = user.data()['signUpDate'];
      DateTime signUpDate = signUpTimestamp.toDate();

      // Use only the year and month part
      DateTime monthKey = DateTime(signUpDate.year, signUpDate.month);

      if (monthlyUserCount.containsKey(monthKey)) {
        monthlyUserCount[monthKey] = monthlyUserCount[monthKey]! + 1;
      } else {
        monthlyUserCount[monthKey] = 1;
      }
    }

    // Sort the map by month
    final sortedMonthlyUserCount = Map.fromEntries(
      monthlyUserCount.entries.toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    // Calculate cumulative growth
    int cumulativeCount = 0;
    Map<DateTime, int> cumulativeGrowth = {};

    for (var entry in sortedMonthlyUserCount.entries) {
      cumulativeCount += entry.value;
      cumulativeGrowth[entry.key] = cumulativeCount;
    }

    return cumulativeGrowth;
  } catch (e) {
    print('Error fetching user growth data: $e');
    return {};
  }
}

Future<Map<String, dynamic>> fetchTotalUsers() async {
  try {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    final totalUsers = usersSnapshot.size;

    // Count users who registered in the last 30 days (latest users)
    final latestUsersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('signUpDate', isGreaterThanOrEqualTo: Timestamp
        .fromDate(thirtyDaysAgo))
        .get();

    final latestUsersCount = latestUsersSnapshot.size;

    // Count users who registered before the last 30 days (oldest users)
    final oldestUsersCount = totalUsers - latestUsersCount;

    // Fetch oldest and latest sign-up dates
    final oldestUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('signUpDate', descending: false)
        .limit(1)
        .get();

    final oldestSignUpDate = oldestUserSnapshot.docs.isNotEmpty
        ? (oldestUserSnapshot.docs.first['signUpDate'] as Timestamp).toDate()
        : null;

    final latestUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('signUpDate', descending: true)
        .limit(1)
        .get();

    final latestSignUpDate = latestUserSnapshot.docs.isNotEmpty
        ? (latestUserSnapshot.docs.first['signUpDate'] as Timestamp).toDate()
        : null;

    return {
      'totalUsers': totalUsers,
      'oldestUsersCount': oldestUsersCount,
      'latestUsersCount': latestUsersCount,
      'oldestSignUpDate': oldestSignUpDate,
      'latestSignUpDate': latestSignUpDate,
    };
  } catch (e) {
    print('Error fetching data: $e');
    return {
      'totalUsers': 0,
      'oldestUsersCount': 0,
      'latestUsersCount': 0,
      'oldestSignUpDate': null,
      'latestSignUpDate': null,
    };
  }
}