class CreateOrderResponse {
  final bool success;
  final String message;

  const CreateOrderResponse({
    required this.success,
    required this.message,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
        success: json['success'] as bool,
        message: json['message'] as String,
    );
  }
}