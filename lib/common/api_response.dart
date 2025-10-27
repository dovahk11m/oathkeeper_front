/// 서버 응답을 위한 공통 모델
/// [T]는 'data' 필드에 들어갈 실제 데이터의 타입입니다.
class ApiResponse<T> {
  final int status; // HTTP 상태 코드가 아닌, 서버가 정의한 비즈니스 상태 코드
  final String message; // 서버가 제공하는 메시지
  final T? data; // 실제 데이터 (nullable)

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  /// JSON 맵으로부터 ApiResponse 객체를 생성하는 팩토리 생성자.
  /// [json]은 API 응답으로 받은 전체 JSON 맵입니다.
  /// [fromJsonT]는 'data' 필드를 특정 타입 [T]로 변환하는 함수입니다.
  /// 예를 들어, T가 User 모델이라면, (json) => User.fromJson(json) 과 같은 함수가 전달됩니다.
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json)? fromJsonT) {
    // 'data' 필드가 존재하고, 변환 함수(fromJsonT)가 제공되었을 때만 데이터 변환을 시도합니다.
    T? data;
    if (fromJsonT != null && json['data'] != null) {
      data = fromJsonT(json['data']);
    }

    return ApiResponse<T>(
      status: json['status'] as int,
      message: json['message'] as String,
      data: data,
    );
  }
}
