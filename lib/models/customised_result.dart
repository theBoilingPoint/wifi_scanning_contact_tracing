class CustomisedResult {
  double filterPercentage;
  double similarityThreshold;
  bool prediction;
  bool truth;

  CustomisedResult(this.filterPercentage, this.similarityThreshold, this.prediction, this.truth);

  Map<String, dynamic> toMap() =>
      {
        "filterPercentage": filterPercentage,
        "similarityThreshold": similarityThreshold,
        "prediction": prediction,
        "truth": truth,
      };

  static CustomisedResult fromMap(Map<String, dynamic> map) {
    return CustomisedResult(
        map['filterPercentage'],
        map['similarityThreshold'],
        map['prediction'],
        map['truth'],
    );
  }
}