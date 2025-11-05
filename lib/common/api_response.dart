/// 서버 응답을 위한 공통 모델
/// [T]는 'data' 필드에 들어갈 실제 데이터의 타입입니다.
class ApiResponse<T> {
  final bool success;
  final String message; // 서버가 제공하는 메시지
  final T? data; // 실제 데이터 (nullable)

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// JSON 맵으로부터 ApiResponse 객체를 생성하는 팩토리 생성자.
  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json)? fromJsonT) {
    T? data;
    if (fromJsonT != null && json['data'] != null) {
      // fromJsonT가 제공되면, 그것을 사용하여 data를 파싱
      data = fromJsonT(json['data']);
    } else {
      // fromJsonT가 없으면, data를 그대로 가져옴
      data = json['data'];
    }

    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: data,
    );
  }
}
