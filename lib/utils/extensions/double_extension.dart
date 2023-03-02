extension PercentageSized on double {
  double hp(double height) => (height * (this / 100));
  double wp(double width) => (width * (this / 100));
}


extension ResponsiveText on double {
  double sp(double width) => width / 100 * (this / 3);
}
