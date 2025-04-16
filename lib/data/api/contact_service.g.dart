// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ContactService implements ContactService {
  _ContactService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://ms.itmd-b1.com:5123/';
  }

  final Dio _dio;

  String? baseUrl;


  @override
  Future<List<Contact>> fetchContact(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Contact>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/Contacts',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Contact> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Contact.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object {
      rethrow;
    }
    return _value;
  }

  @override
  Future<Contact> createContact(
    String token,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String address,
    bool isFavorite,
    String status,
    File? image,
    String? emailTwo,
    String? mobileNumber,
    String? addressTwo,
    int? companyId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry('firstName', firstName));
    _data.fields.add(MapEntry('lastName', lastName));
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('phoneNumber', phoneNumber));
    _data.fields.add(MapEntry('address', address));
    _data.fields.add(MapEntry('isFavorite', isFavorite.toString()));
    _data.fields.add(MapEntry('status', status));
    if (image != null) {
      _data.files.add(
        MapEntry(
          'ImageUploadFile',
          MultipartFile.fromFileSync(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (emailTwo != null) {
      _data.fields.add(MapEntry('emailTwo', emailTwo));
    }
    if (mobileNumber != null) {
      _data.fields.add(MapEntry('mobileNumber', mobileNumber));
    }
    if (addressTwo != null) {
      _data.fields.add(MapEntry('addressTwo', addressTwo));
    }
    if (companyId != null) {
      _data.fields.add(MapEntry('companyId', companyId.toString()));
    }
    final _options = _setStreamType<Contact>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'multipart/form-data',
      )
          .compose(
            _dio.options,
            'api/Contacts',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Contact _value;
    try {
      _value = Contact.fromJson(_result.data!);
    } on Object{
      rethrow;
    }
    return _value;
  }

  @override
  Future<Contact> updateContact(
    String token,
    int id,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String address,
    bool isFavorite,
    String status,
    File? image,
    String? emailTwo,
    String? mobileNumber,
    String? addressTwo,
    int? companyId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry('firstName', firstName));
    _data.fields.add(MapEntry('lastName', lastName));
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('phoneNumber', phoneNumber));
    _data.fields.add(MapEntry('address', address));
    _data.fields.add(MapEntry('isFavorite', isFavorite.toString()));
    _data.fields.add(MapEntry('status', status));
    if (image != null) {
      _data.files.add(
        MapEntry(
          'ImageUploadFile',
          MultipartFile.fromFileSync(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (emailTwo != null) {
      _data.fields.add(MapEntry('emailTwo', emailTwo));
    }
    if (mobileNumber != null) {
      _data.fields.add(MapEntry('mobileNumber', mobileNumber));
    }
    if (addressTwo != null) {
      _data.fields.add(MapEntry('addressTwo', addressTwo));
    }
    if (companyId != null) {
      _data.fields.add(MapEntry('companyId', companyId.toString()));
    }
    final _options = _setStreamType<Contact>(
      Options(
        method: 'PUT',
        headers: _headers,
        extra: _extra,
        contentType: 'multipart/form-data',
      )
          .compose(
            _dio.options,
            'api/Contacts/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Contact _value;
    try {
      _value = Contact.fromJson(_result.data!);
    } on Object {
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> deleteOneContact(String token, int id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/Contacts/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> deleteContact(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/Contacts',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> sendEmail(String token, EmailModel model) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(model.toJson());
    final _options = _setStreamType<void>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/Contacts/send-email',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<String> getImageUrl(String token, int id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<String>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/Contacts/${id}/image-url',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object {
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> toggleFavorite(String token, int id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'api/Contacts/toggle-favorite/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
