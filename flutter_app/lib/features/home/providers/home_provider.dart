import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/home_repository.dart';
import '../models/home_res.dart';

final homeProvider = FutureProvider<HomeRes>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.fetchHome();
});
