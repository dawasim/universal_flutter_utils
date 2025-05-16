
class FileUploadStatus {

  static const String pending = 'pending';
  static const String uploading = 'uploading';
  static const String paused = 'paused';
  static const String uploaded = 'uploaded';

}

class FileUploadType {

  static const String companyFiles = 'companyFiles';
  static const String measurements = 'measurements';
  static const String estimations = 'estimations';
  static const String photosAndDocs = 'photosAndDocs';
  static const String materialList = 'materialList';
  static const String formProposals = 'proposals';
  static const String workOrder = 'workOrder';
  static const String instantPhoto = 'instantPhoto';
  static const String attachment = 'attachment';
  static const String dropBoxList = 'dropBoxList';
  static const String companyCam = 'companyCam';
  static const String template = 'template';
  static const String xactimate = 'xactimate';
  static const String srsOrder = 'srsOrder'; 

}

class FileUploadSupportedFiles {

  static List<String> extensions = [
    "jpg",
    "jpeg",
    "png",
    "pdf",
    "doc",
    "docx",
    "csv",
    "xlsx",
    "xls",
    "ppt",
    "pptx",
    "txt",
    "zip",
    "rar",
    "eml",
    "ai",
    "psd",
    "ve",
    "eps",
    "dxf",
    "skp",
    "ac5",
    "ac6",
    "xlsm",
    "sdr",
    "json",
    "xml",
    "pages",
    "numbers",
    "dwg",
    "esx",
    "sfz",
  ];

}

class SrsSupportedFiles {

  static List<String> extensions = [
    "jpg",
    "jpeg",
    "png",
    "pdf",
  ];
}