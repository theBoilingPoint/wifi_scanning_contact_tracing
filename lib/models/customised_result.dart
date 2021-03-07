class CustomisedResult {
  double filterPercentage;
  double similarityThreshold;
  double similarity;
  bool prediction;
  bool truth;

  CustomisedResult(this.filterPercentage, this.similarityThreshold,this.similarity,
      this.prediction, this.truth);

  Map<String, dynamic> toMap() => {
        "filterPercentage": filterPercentage,
        "similarityThreshold": similarityThreshold,
        "similarity": similarity,
        "prediction": prediction,
        "truth": truth,
      };

  static CustomisedResult fromMap(Map<String, dynamic> map) {
    return CustomisedResult(
      map['filterPercentage'],
      map['similarityThreshold'],
      map['similarity'],
      map['prediction'],
      map['truth'],
    );
  }
}
