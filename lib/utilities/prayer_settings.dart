import 'package:adhan/adhan.dart';

enum prayerTimesp {
  fajr,sunrise,duhur,asir,magrib,isha
}


Madhab madhab=Madhab.shafi;
CalculationMethod method=CalculationMethod.turkey;

setParameters(Madhab _madhab,CalculationMethod _method)
{
  madhab=_madhab;
  method=_method;
}