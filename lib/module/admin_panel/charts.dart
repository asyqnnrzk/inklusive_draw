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
        .where('isDeleted', isEqualTo: false)
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

    // Create an ordered map for all months of the year up to the current month
    DateTime now = DateTime.now();
    Map<DateTime, int> sortedMonthlyUserCount = {};
    for (int month = 1; month <= now.month; month++) {
      DateTime monthKey = DateTime(now.year, month);
      sortedMonthlyUserCount[monthKey] =
          monthlyUserCount[monthKey] ?? 0; // Fill empty months with 0
    }

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

// not used
Future<Map<String, dynamic>> fetchTotalUsers() async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('isDeleted', isEqualTo: false)
      .get();

  int oldestUsersCount = 0;
  int latestUsersCount = 0;
  DateTime? oldestSignUpDate;
  DateTime? latestSignUpDate;

  final DateTime now = DateTime.now();
  final DateTime latestCutoff = DateTime(now.year, now.month, 1).
  subtract(const Duration(days: 30));

  for (var doc in snapshot.docs) {
    final Timestamp signUpTimestamp = doc['signUpDate'];
    final DateTime signUpDate = signUpTimestamp.toDate();

    if (signUpDate.isBefore(latestCutoff)) {
      oldestUsersCount++;
      if (oldestSignUpDate == null || signUpDate.isBefore(oldestSignUpDate)) {
        oldestSignUpDate = signUpDate;
      }
    } else {
      latestUsersCount++;
      if (latestSignUpDate == null || signUpDate.isAfter(latestSignUpDate)) {
        latestSignUpDate = signUpDate;
      }
    }
  }

  return {
    'oldestUsersCount': oldestUsersCount,
    'latestUsersCount': latestUsersCount,
    'oldestSignUpDate': oldestSignUpDate,
    'latestSignUpDate': latestSignUpDate,
  };
}

Future<Map<String, dynamic>> fetchActiveInactiveUsers() async {
  DateTime now = DateTime.now();
  DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));

  QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

  int activeUsersCount = 0;
  int inactiveUsersCount = 0;

  for (var doc in usersSnapshot.docs) {
    bool isDeleted = doc.get('isDeleted') ?? false;
    if (!isDeleted) {
      Timestamp? lastLoginTimestamp = doc.get('lastLoggedIn');
      if (lastLoginTimestamp != null) {
        DateTime lastLoggedIn = lastLoginTimestamp.toDate();
        if (lastLoggedIn.isAfter(thirtyDaysAgo)) {
          activeUsersCount++;
        } else {
          inactiveUsersCount++;
        }
      } else {
        inactiveUsersCount++; // Consider users with no login date as inactive
      }
    }
  }

  return {
    'activeUsersCount': activeUsersCount,
    'inactiveUsersCount': inactiveUsersCount,
  };
}