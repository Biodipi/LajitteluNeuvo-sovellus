class FeedbackModel {
  final double functinality;
  final double utility;
  final String feedback;
  final String timestamp;
  final String deviceId;

  const FeedbackModel(this.functinality, this.utility, this.feedback,
      this.timestamp, this.deviceId);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "functionality": functinality,
      "utility": utility,
      "timestamp": timestamp,
      "feedback": feedback,
      "deviceId": deviceId,
    };

    return map;
  }
}
