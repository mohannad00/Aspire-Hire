class Resume {
  final String? secureUrl;
  final String? publicId;

  Resume({this.secureUrl, this.publicId});

  factory Resume.fromJson(Map<String, dynamic> json) => Resume(
    secureUrl: json['secure_url'] as String?,
    publicId: json['public_id'] as String?,
  );

  Map<String, dynamic> toJson() => {
    if (secureUrl != null) 'secure_url': secureUrl,
    if (publicId != null) 'public_id': publicId,
  };
}
