class User {
  int id;
  String email;
  String username;
  String token;

  User(this.id, this.email, this.username, this.token);

  setId(int id) {
    this.id = id;
  }

  setEmail(String email) {
    this.email = email;
  }

  setUsername(String username) {
    this.username = username;
  }

  setToken(String token) {
    this.token = token;
  }

  getId() {
    return this.id;
  }

  getEmail() {
    return this.email;
  }

  getUsername() {
    return this.username;
  }

  getToken() {
    return this.token;
  }
}
