import 'package:adhan/adhan.dart';

List<String> prayer_names = [
  "الفجر",
  "الشروق",
  "الظهر",
  "العصر",
  "المغرب",
  "العشاء"
];

//enum prayer_enum{الفجر,sunrise,duhur,asir,magrib,isha}

Madhab madhab = Madhab.shafi;
CalculationMethod method = CalculationMethod.turkey;

setParameters(Madhab _madhab, CalculationMethod _method) {
  madhab = _madhab;
  method = _method;
}
