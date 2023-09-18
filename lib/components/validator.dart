bool validateEmail(String input) {
  const emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  if (RegExp(emailRegex).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateServiceName(String input) {
  const serviceName = r"^[ก-๙]";
  if (RegExp(serviceName).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateRegister(String input) {
  const registerRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  if (RegExp(registerRegex).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateServicTimespend(String input) {
  const servicTimespend = r"^[\d]";
  if (RegExp(servicTimespend).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateServicPrice(String input) {
  const servicePrice = r"^[\d.]";
  if (RegExp(servicePrice).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateUserName(String input) {
  const userName = r"^[a-zA-Z0-9]";
  if (RegExp(userName).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validatePassword(String input) {
  const userName = r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`@]";
  if (RegExp(userName).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateAddress(String input) {
  const userName = r"^[ a-zA-Z0-9./ก-๙]";
  if (RegExp(userName).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validatePhoneNumber(String input) {
  const userName = r"^[0-9]{10}";
  if (RegExp(userName).hasMatch(input)) {
    return true;
  } else
    return false;
}

bool validateName(String input) {
  const userName = r"^[a-zA-Zก-๙]";
  if (RegExp(userName).hasMatch(input)) {
    return true;
  } else
    return false;
}
