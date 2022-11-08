String getUserInitials(String name, String email) {
  if (name.isNotEmpty) {
    return name[0].toUpperCase();
  } else if (email.isNotEmpty) {
    return email[0].toUpperCase();
  }
  return "NA";
}
