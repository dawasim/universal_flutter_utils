
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUNetworkMultiSelectParams {

  int page;
  int limit;
  String keyword;

  UFUNetworkMultiSelectParams({
    this.page = 1,
    this.limit = PaginationConstants.pageLimit,
    this.keyword = ''
  });
}