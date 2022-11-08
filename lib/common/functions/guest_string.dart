String getGuestString(int maxAdults, int maxChildren) {
  String guestString = "";

  guestString += "$maxAdults Adult";

  if (maxAdults > 1) {
    guestString += "s";
  }
  guestString += ", $maxChildren Child";

  if (maxChildren > 1) {
    guestString += "ren";
  }

  return guestString;
}
