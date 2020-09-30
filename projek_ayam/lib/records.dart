class LogRecord {
  const LogRecord(this.recordid, this.description, this.date, this.dead,
      this.alive, this.supervisor);

  final String recordid;
  final String description;
  final String dead;
  final String alive;
  final String supervisor;
  final String date;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return recordid;
      case 1:
        return description;
      case 2:
        return date;
      case 3:
        return dead;
      case 4:
        return alive;
      case 5:
        return supervisor;
    }
    return '';
  }
}
