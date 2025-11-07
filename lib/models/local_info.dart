class UFULocalInfoModel {
/*
{
  "status": "success",
  "country": "India",
  "countryCode": "IN",
  "region": "PB",
  "regionName": "Punjab",
  "city": "Mohali",
  "zip": "160055",
  "lat": 30.674,
  "lon": 76.7249,
  "timezone": "Asia/Kolkata",
  "isp": "Hfcl Infotel LTD",
  "org": "",
  "as": "AS17917 Quadrant Televentures Limited",
  "query": "112.196.43.19"
}
*/

  String? status;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? theAs;
  String? query;

  UFULocalInfoModel({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.theAs,
    this.query,
  });

  UFULocalInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    country = json['country']?.toString();
    countryCode = json['countryCode']?.toString();
    region = json['region']?.toString();
    regionName = json['regionName']?.toString();
    city = json['city']?.toString();
    zip = json['zip']?.toString();
    lat = double.tryParse(json['lat']?.toString() ?? '');
    lon = double.tryParse(json['lon']?.toString() ?? '');
    timezone = json['timezone']?.toString();
    isp = json['isp']?.toString();
    org = json['org']?.toString();
    theAs = json['as']?.toString();
    query = json['query']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['country'] = country;
    data['countryCode'] = countryCode;
    data['region'] = region;
    data['regionName'] = regionName;
    data['city'] = city;
    data['zip'] = zip;
    data['lat'] = lat;
    data['lon'] = lon;
    data['timezone'] = timezone;
    data['isp'] = isp;
    data['org'] = org;
    data['as'] = theAs;
    data['query'] = query;
    return data;
  }
}

