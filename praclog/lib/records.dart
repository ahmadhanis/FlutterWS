class LogRecord {
  const LogRecord(this.recordid, this.description, this.date);

  final String recordid;
  final String description;
  final String date;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return recordid;
      case 1:
        return description;
      case 2:
        return date;
    }
    return '';
  }
}
