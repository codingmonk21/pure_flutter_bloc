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

  Map<String, Object> get propsMap;

  String _mapPropsMapToString(
    final Type runtimeType,
    final Map<String, Object> propsMap,
  ) {
    String propsKeyVal = '';
    propsMap?.forEach((k, v) {
      if (v is List) {
        propsKeyVal += '$k: ${v?.length}, ';
      } else if (v is Set) {
        propsKeyVal += '$k: ${v?.length}, ';
      } else if (v is Map) {
        propsKeyVal += '$k: ${v?.length}, ';
      } else if (v is Iterable) {
        propsKeyVal += '$k: ${v?.length}, ';
      } else {
        propsKeyVal += '$k: ${v?.toString()}, ';
      }
    });
    propsKeyVal = propsKeyVal.trim();
    if (propsKeyVal.endsWith(',')) {
      propsKeyVal = propsKeyVal.substring(0, propsKeyVal.length - 1);
    }

    return '$runtimeType($propsKeyVal)';
  }

  List<Object> get _equatableProps {
    var props = [];
    if (propsMap == null || propsMap.isEmpty) {
      return props;
    } else {
      propsMap?.forEach((k, v) => props.add(v));
      return props;
    }
  }

  @override
  List<Object> get props {
    return [..._equatableProps];
  }
}
