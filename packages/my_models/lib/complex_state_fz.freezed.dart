// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complex_state_fz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ComplexState {
  String get var1 => throw _privateConstructorUsedError;
  double get var2 => throw _privateConstructorUsedError;
  bool get var3 => throw _privateConstructorUsedError;
  int get var4 => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ComplexStateCopyWith<ComplexState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComplexStateCopyWith<$Res> {
  factory $ComplexStateCopyWith(
          ComplexState value, $Res Function(ComplexState) then) =
      _$ComplexStateCopyWithImpl<$Res, ComplexState>;
  @useResult
  $Res call({String var1, double var2, bool var3, int var4});
}

/// @nodoc
class _$ComplexStateCopyWithImpl<$Res, $Val extends ComplexState>
    implements $ComplexStateCopyWith<$Res> {
  _$ComplexStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? var1 = null,
    Object? var2 = null,
    Object? var3 = null,
    Object? var4 = null,
  }) {
    return _then(_value.copyWith(
      var1: null == var1
          ? _value.var1
          : var1 // ignore: cast_nullable_to_non_nullable
              as String,
      var2: null == var2
          ? _value.var2
          : var2 // ignore: cast_nullable_to_non_nullable
              as double,
      var3: null == var3
          ? _value.var3
          : var3 // ignore: cast_nullable_to_non_nullable
              as bool,
      var4: null == var4
          ? _value.var4
          : var4 // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ComplexStateCopyWith<$Res>
    implements $ComplexStateCopyWith<$Res> {
  factory _$$_ComplexStateCopyWith(
          _$_ComplexState value, $Res Function(_$_ComplexState) then) =
      __$$_ComplexStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String var1, double var2, bool var3, int var4});
}

/// @nodoc
class __$$_ComplexStateCopyWithImpl<$Res>
    extends _$ComplexStateCopyWithImpl<$Res, _$_ComplexState>
    implements _$$_ComplexStateCopyWith<$Res> {
  __$$_ComplexStateCopyWithImpl(
      _$_ComplexState _value, $Res Function(_$_ComplexState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? var1 = null,
    Object? var2 = null,
    Object? var3 = null,
    Object? var4 = null,
  }) {
    return _then(_$_ComplexState(
      var1: null == var1
          ? _value.var1
          : var1 // ignore: cast_nullable_to_non_nullable
              as String,
      var2: null == var2
          ? _value.var2
          : var2 // ignore: cast_nullable_to_non_nullable
              as double,
      var3: null == var3
          ? _value.var3
          : var3 // ignore: cast_nullable_to_non_nullable
              as bool,
      var4: null == var4
          ? _value.var4
          : var4 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_ComplexState extends _ComplexState {
  const _$_ComplexState(
      {required this.var1,
      required this.var2,
      required this.var3,
      required this.var4})
      : super._();

  @override
  final String var1;
  @override
  final double var2;
  @override
  final bool var3;
  @override
  final int var4;

  @override
  String toString() {
    return 'ComplexState(var1: $var1, var2: $var2, var3: $var3, var4: $var4)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ComplexState &&
            (identical(other.var1, var1) || other.var1 == var1) &&
            (identical(other.var2, var2) || other.var2 == var2) &&
            (identical(other.var3, var3) || other.var3 == var3) &&
            (identical(other.var4, var4) || other.var4 == var4));
  }

  @override
  int get hashCode => Object.hash(runtimeType, var1, var2, var3, var4);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ComplexStateCopyWith<_$_ComplexState> get copyWith =>
      __$$_ComplexStateCopyWithImpl<_$_ComplexState>(this, _$identity);
}

abstract class _ComplexState extends ComplexState {
  const factory _ComplexState(
      {required final String var1,
      required final double var2,
      required final bool var3,
      required final int var4}) = _$_ComplexState;
  const _ComplexState._() : super._();

  @override
  String get var1;
  @override
  double get var2;
  @override
  bool get var3;
  @override
  int get var4;
  @override
  @JsonKey(ignore: true)
  _$$_ComplexStateCopyWith<_$_ComplexState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$JsonForMqtt {
  String get deviceId => throw _privateConstructorUsedError;
  set deviceId(String value) => throw _privateConstructorUsedError;
  Map<String, dynamic> get teleJsonMap => throw _privateConstructorUsedError;
  set teleJsonMap(Map<String, dynamic> value) =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get listOtherJsonMap =>
      throw _privateConstructorUsedError;
  set listOtherJsonMap(List<Map<String, dynamic>> value) =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get listCmdJsonMap =>
      throw _privateConstructorUsedError;
  set listCmdJsonMap(List<Map<String, dynamic>> value) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JsonForMqttCopyWith<JsonForMqtt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsonForMqttCopyWith<$Res> {
  factory $JsonForMqttCopyWith(
          JsonForMqtt value, $Res Function(JsonForMqtt) then) =
      _$JsonForMqttCopyWithImpl<$Res, JsonForMqtt>;
  @useResult
  $Res call(
      {String deviceId,
      Map<String, dynamic> teleJsonMap,
      List<Map<String, dynamic>> listOtherJsonMap,
      List<Map<String, dynamic>> listCmdJsonMap});
}

/// @nodoc
class _$JsonForMqttCopyWithImpl<$Res, $Val extends JsonForMqtt>
    implements $JsonForMqttCopyWith<$Res> {
  _$JsonForMqttCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? teleJsonMap = null,
    Object? listOtherJsonMap = null,
    Object? listCmdJsonMap = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      teleJsonMap: null == teleJsonMap
          ? _value.teleJsonMap
          : teleJsonMap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      listOtherJsonMap: null == listOtherJsonMap
          ? _value.listOtherJsonMap
          : listOtherJsonMap // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      listCmdJsonMap: null == listCmdJsonMap
          ? _value.listCmdJsonMap
          : listCmdJsonMap // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JsonForMqttCopyWith<$Res>
    implements $JsonForMqttCopyWith<$Res> {
  factory _$$_JsonForMqttCopyWith(
          _$_JsonForMqtt value, $Res Function(_$_JsonForMqtt) then) =
      __$$_JsonForMqttCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      Map<String, dynamic> teleJsonMap,
      List<Map<String, dynamic>> listOtherJsonMap,
      List<Map<String, dynamic>> listCmdJsonMap});
}

/// @nodoc
class __$$_JsonForMqttCopyWithImpl<$Res>
    extends _$JsonForMqttCopyWithImpl<$Res, _$_JsonForMqtt>
    implements _$$_JsonForMqttCopyWith<$Res> {
  __$$_JsonForMqttCopyWithImpl(
      _$_JsonForMqtt _value, $Res Function(_$_JsonForMqtt) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? teleJsonMap = null,
    Object? listOtherJsonMap = null,
    Object? listCmdJsonMap = null,
  }) {
    return _then(_$_JsonForMqtt(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      teleJsonMap: null == teleJsonMap
          ? _value.teleJsonMap
          : teleJsonMap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      listOtherJsonMap: null == listOtherJsonMap
          ? _value.listOtherJsonMap
          : listOtherJsonMap // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      listCmdJsonMap: null == listCmdJsonMap
          ? _value.listCmdJsonMap
          : listCmdJsonMap // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc

class _$_JsonForMqtt extends _JsonForMqtt {
  _$_JsonForMqtt(
      {required this.deviceId,
      required this.teleJsonMap,
      required this.listOtherJsonMap,
      required this.listCmdJsonMap})
      : super._();

  @override
  String deviceId;
  @override
  Map<String, dynamic> teleJsonMap;
  @override
  List<Map<String, dynamic>> listOtherJsonMap;
  @override
  List<Map<String, dynamic>> listCmdJsonMap;

  @override
  String toString() {
    return 'JsonForMqtt(deviceId: $deviceId, teleJsonMap: $teleJsonMap, listOtherJsonMap: $listOtherJsonMap, listCmdJsonMap: $listCmdJsonMap)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JsonForMqttCopyWith<_$_JsonForMqtt> get copyWith =>
      __$$_JsonForMqttCopyWithImpl<_$_JsonForMqtt>(this, _$identity);
}

abstract class _JsonForMqtt extends JsonForMqtt {
  factory _JsonForMqtt(
      {required String deviceId,
      required Map<String, dynamic> teleJsonMap,
      required List<Map<String, dynamic>> listOtherJsonMap,
      required List<Map<String, dynamic>> listCmdJsonMap}) = _$_JsonForMqtt;
  _JsonForMqtt._() : super._();

  @override
  String get deviceId;
  set deviceId(String value);
  @override
  Map<String, dynamic> get teleJsonMap;
  set teleJsonMap(Map<String, dynamic> value);
  @override
  List<Map<String, dynamic>> get listOtherJsonMap;
  set listOtherJsonMap(List<Map<String, dynamic>> value);
  @override
  List<Map<String, dynamic>> get listCmdJsonMap;
  set listCmdJsonMap(List<Map<String, dynamic>> value);
  @override
  @JsonKey(ignore: true)
  _$$_JsonForMqttCopyWith<_$_JsonForMqtt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ThermostatAway {
  int get temperature => throw _privateConstructorUsedError;
  int get humidity => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ThermostatAwayCopyWith<ThermostatAway> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThermostatAwayCopyWith<$Res> {
  factory $ThermostatAwayCopyWith(
          ThermostatAway value, $Res Function(ThermostatAway) then) =
      _$ThermostatAwayCopyWithImpl<$Res, ThermostatAway>;
  @useResult
  $Res call({int temperature, int humidity, String? name});
}

/// @nodoc
class _$ThermostatAwayCopyWithImpl<$Res, $Val extends ThermostatAway>
    implements $ThermostatAwayCopyWith<$Res> {
  _$ThermostatAwayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as int,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ThermostatAwayCopyWith<$Res>
    implements $ThermostatAwayCopyWith<$Res> {
  factory _$$_ThermostatAwayCopyWith(
          _$_ThermostatAway value, $Res Function(_$_ThermostatAway) then) =
      __$$_ThermostatAwayCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int temperature, int humidity, String? name});
}

/// @nodoc
class __$$_ThermostatAwayCopyWithImpl<$Res>
    extends _$ThermostatAwayCopyWithImpl<$Res, _$_ThermostatAway>
    implements _$$_ThermostatAwayCopyWith<$Res> {
  __$$_ThermostatAwayCopyWithImpl(
      _$_ThermostatAway _value, $Res Function(_$_ThermostatAway) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? name = freezed,
  }) {
    return _then(_$_ThermostatAway(
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as int,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ThermostatAway implements _ThermostatAway {
  _$_ThermostatAway(
      {required this.temperature, required this.humidity, this.name});

  @override
  final int temperature;
  @override
  final int humidity;
  @override
  final String? name;

  @override
  String toString() {
    return 'ThermostatAway(temperature: $temperature, humidity: $humidity, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ThermostatAway &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, temperature, humidity, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ThermostatAwayCopyWith<_$_ThermostatAway> get copyWith =>
      __$$_ThermostatAwayCopyWithImpl<_$_ThermostatAway>(this, _$identity);
}

abstract class _ThermostatAway implements ThermostatAway {
  factory _ThermostatAway(
      {required final int temperature,
      required final int humidity,
      final String? name}) = _$_ThermostatAway;

  @override
  int get temperature;
  @override
  int get humidity;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$_ThermostatAwayCopyWith<_$_ThermostatAway> get copyWith =>
      throw _privateConstructorUsedError;
}
