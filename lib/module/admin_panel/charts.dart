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
