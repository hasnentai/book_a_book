class UserModal {
  String token;
  String userEmail;
  String userNiceName;
  String userDisplayName;

  UserModal(
      {this.token, this.userDisplayName, this.userEmail, this.userNiceName});

  factory UserModal.formJson(Map<String, dynamic> jsonData) {
    return UserModal(
        token: jsonData['token'],
        userEmail: jsonData['user_email'],
        userNiceName: jsonData['user_nicename'],
        userDisplayName: jsonData['user_display_name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNiceName;
    data['user_display_name'] = this.userDisplayName;
    return data;
  }
}
