library pure_flutter_bloc;

import 'package:equatable/equatable.dart';

abstract class BlocEquatable extends Equatable {
  @override
  String toString() {
    switch (stringify) {
      case true:
        return _mapPropsMapToString(runtimeType, propsMap);
      case false:
        return '$runtimeType';
      default:
        return EquatableConfig.stringify == true
            ? _mapPropsMapToString(runtimeType, propsMap)
            : '$runtimeType';
    }
  }

  List<Map<String, Object>> get propsMap;

  String _mapPropsMapToString(
      Type runtimeType,
      List<Map<String, Object>> propsMap,
      ) {
    String propsKeyVal = '';
    propsMap?.asMap()?.forEach((i, propMap) {
      propMap?.forEach((k, v) {
        propsKeyVal +=
        '$k: ${v?.toString()}${i == propsMap.length - 1 ? "" : ', '}';
      });
    });
    return '$runtimeType($propsKeyVal)';
  }

  List<Object> get _equatableProps {
    return (propsMap == null || propsMap.isEmpty)
        ? []
        : propsMap.map((propMap) {
      return propMap?.forEach((k, v) => v);
    }).toList();
  }

  @override
  List<Object> get props {
    return [..._equatableProps];
  }
}
