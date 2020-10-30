class LogRecord {
  const LogRecord(this.recordid, this.description, this.alive, this.dead,
      this.sick, this.lost, this.supervisor, this.date);

  final String recordid;
  final String description;
  final String dead;
  final String alive;
  final String sick;
  final String lost;
  final String supervisor;
  final String date;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return recordid;
      case 1:
        return description;
      case 2:
        return alive;
      case 3:
        return dead;
      case 4:
        return sick;
      case 5:
        return lost;
      case 6:
        return supervisor;
      case 7:
        return date;
    }
    return '';
  }
}
